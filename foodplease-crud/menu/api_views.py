import json
from decimal import Decimal

from django.db import transaction
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.views.decorators.http import (
    require_GET,
    require_http_methods,
)

from .models import DetallePedido, Pedido, Producto


@require_GET
def productos_api(request):
    productos = Producto.objects.all()

    datos = []

    for producto in productos:
        datos.append({
            "id": producto.id,
            "codigo": producto.codigo,
            "nombre": producto.nombre,
            "descripcion": producto.descripcion,
            "categoria": producto.get_categoria_display(),
            "precio": int(producto.precio),
            "stock": producto.stock,
            "disponible": producto.disponible,
        })

    return JsonResponse(
        datos,
        safe=False,
    )


@csrf_exempt
@require_http_methods(["POST"])
def crear_pedido_api(request):
    try:
        datos = json.loads(request.body)

        direccion = datos.get(
            "direccion",
            "",
        ).strip()

        metodo_pago = datos.get(
            "metodo_pago",
            "",
        ).strip()

        codigo_cupon = datos.get(
            "codigo_cupon",
            "",
        ).strip().upper()

        items = datos.get(
            "items",
            [],
        )

        if not direccion:
            return JsonResponse(
                {
                    "ok": False,
                    "error": "La dirección es obligatoria.",
                },
                status=400,
            )

        if metodo_pago not in [
            "Tarjeta",
            "Efectivo",
        ]:
            return JsonResponse(
                {
                    "ok": False,
                    "error": "Método de pago no válido.",
                },
                status=400,
            )

        if not items:
            return JsonResponse(
                {
                    "ok": False,
                    "error": "El pedido no contiene productos.",
                },
                status=400,
            )

        cantidades = {}

        for item in items:
            producto_id = item.get(
                "producto_id"
            )

            cantidad = item.get(
                "cantidad"
            )

            try:
                producto_id = int(
                    producto_id
                )

                cantidad = int(
                    cantidad
                )

            except (
                TypeError,
                ValueError,
            ):
                return JsonResponse(
                    {
                        "ok": False,
                        "error": (
                            "Producto o cantidad "
                            "no válida."
                        ),
                    },
                    status=400,
                )

            if cantidad <= 0:
                return JsonResponse(
                    {
                        "ok": False,
                        "error": (
                            "La cantidad debe ser "
                            "mayor a cero."
                        ),
                    },
                    status=400,
                )

            cantidades[producto_id] = (
                cantidades.get(
                    producto_id,
                    0,
                )
                + cantidad
            )

        with transaction.atomic():
            productos_pedido = []

            subtotal = Decimal("0")

            for (
                producto_id,
                cantidad,
            ) in cantidades.items():

                try:
                    producto = (
                        Producto.objects
                        .select_for_update()
                        .get(
                            pk=producto_id
                        )
                    )

                except Producto.DoesNotExist:
                    return JsonResponse(
                        {
                            "ok": False,
                            "error": (
                                f"El producto "
                                f"{producto_id} "
                                "no existe."
                            ),
                        },
                        status=404,
                    )

                if producto.stock < cantidad:
                    return JsonResponse(
                        {
                            "ok": False,
                            "error": (
                                "No hay stock "
                                "suficiente de "
                                f"{producto.nombre}. "
                                "Stock disponible: "
                                f"{producto.stock}."
                            ),
                        },
                        status=400,
                    )

                subtotal_producto = (
                    producto.precio
                    * cantidad
                )

                subtotal += (
                    subtotal_producto
                )

                productos_pedido.append({
                    "producto": producto,
                    "cantidad": cantidad,
                })

            descuento = Decimal("0")

            if codigo_cupon == "FOOD10":
                descuento = (
                    subtotal
                    * Decimal("0.10")
                ).quantize(
                    Decimal("1")
                )

            costo_envio = Decimal(
                "2990"
            )

            total = (
                subtotal
                + costo_envio
                - descuento
            )

            pedido = Pedido.objects.create(
                direccion=direccion,
                metodo_pago=metodo_pago,
                subtotal=subtotal,
                costo_envio=costo_envio,
                descuento=descuento,
                total=total,
                estado=Pedido.Estado.CONFIRMADO,
            )

            respuesta_items = []

            for item in productos_pedido:
                producto = item[
                    "producto"
                ]

                cantidad = item[
                    "cantidad"
                ]

                DetallePedido.objects.create(
                    pedido=pedido,
                    producto=producto,
                    cantidad=cantidad,
                    precio_unitario=producto.precio,
                )

                producto.stock -= cantidad
                producto.save()

                respuesta_items.append({
                    "producto_id":
                        producto.id,
                    "nombre":
                        producto.nombre,
                    "cantidad":
                        cantidad,
                    "stock_restante":
                        producto.stock,
                    "disponible":
                        producto.disponible,
                })

        return JsonResponse(
            {
                "ok": True,
                "pedido_id": pedido.id,
                "numero": pedido.numero,
                "estado": pedido.estado,
                "estado_texto":
                    pedido.get_estado_display(),
                "subtotal":
                    int(pedido.subtotal),
                "costo_envio":
                    int(pedido.costo_envio),
                "descuento":
                    int(pedido.descuento),
                "total":
                    int(pedido.total),
                "items":
                    respuesta_items,
            },
            status=201,
        )

    except json.JSONDecodeError:
        return JsonResponse(
            {
                "ok": False,
                "error": "JSON no válido.",
            },
            status=400,
        )

    except Exception as error:
        return JsonResponse(
            {
                "ok": False,
                "error": str(error),
            },
            status=500,
        )


@require_GET
def obtener_pedido_api(
    request,
    pedido_id,
):
    try:
        pedido = (
            Pedido.objects
            .prefetch_related(
                "detalles__producto"
            )
            .get(
                pk=pedido_id
            )
        )

    except Pedido.DoesNotExist:
        return JsonResponse(
            {
                "ok": False,
                "error": (
                    "El pedido no existe."
                ),
            },
            status=404,
        )

    items = []

    for detalle in pedido.detalles.all():
        items.append({
            "producto_id":
                detalle.producto.id,
            "codigo":
                detalle.producto.codigo,
            "nombre":
                detalle.producto.nombre,
            "cantidad":
                detalle.cantidad,
            "precio_unitario":
                int(
                    detalle.precio_unitario
                ),
            "subtotal":
                int(
                    detalle.subtotal
                ),
        })

    return JsonResponse(
        {
            "ok": True,
            "pedido_id":
                pedido.id,
            "numero":
                pedido.numero,
            "direccion":
                pedido.direccion,
            "metodo_pago":
                pedido.metodo_pago,
            "estado":
                pedido.estado,
            "estado_texto":
                pedido.get_estado_display(),
            "subtotal":
                int(pedido.subtotal),
            "costo_envio":
                int(pedido.costo_envio),
            "descuento":
                int(pedido.descuento),
            "total":
                int(pedido.total),
            "fecha_creacion":
                pedido.fecha_creacion.isoformat(),
            "items":
                items,
        }
    )