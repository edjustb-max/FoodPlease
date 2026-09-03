from django.shortcuts import get_object_or_404, redirect, render
from django.views.decorators.http import require_http_methods

from .models import Pedido


def formato_clp(valor):
    valor = int(valor)
    return f"${valor:,}".replace(",", ".")


def pedido_lista(request):
    pedidos = (
        Pedido.objects
        .prefetch_related("detalles__producto")
        .all()
    )

    for pedido in pedidos:
        pedido.total_formateado = formato_clp(pedido.total)

        pedido.cantidad_productos = sum(
            detalle.cantidad
            for detalle in pedido.detalles.all()
        )

    contexto = {
        "pedidos": pedidos,
        "cantidad_pedidos": pedidos.count(),
    }

    return render(
        request,
        "menu/pedido_lista.html",
        contexto,
    )


@require_http_methods(["GET", "POST"])
def pedido_detalle(request, pedido_id):
    pedido = get_object_or_404(
        Pedido.objects.prefetch_related(
            "detalles__producto"
        ),
        pk=pedido_id,
    )

    if request.method == "POST":
        nuevo_estado = request.POST.get("estado")

        estados_validos = [
            valor
            for valor, etiqueta
            in Pedido.Estado.choices
        ]

        if nuevo_estado in estados_validos:
            pedido.estado = nuevo_estado
            pedido.save(
                update_fields=["estado"]
            )

        return redirect(
            "menu:pedido_detalle",
            pedido_id=pedido.id,
        )

    pedido.subtotal_formateado = formato_clp(
        pedido.subtotal
    )

    pedido.costo_envio_formateado = formato_clp(
        pedido.costo_envio
    )

    pedido.descuento_formateado = formato_clp(
        pedido.descuento
    )

    pedido.total_formateado = formato_clp(
        pedido.total
    )

    for detalle in pedido.detalles.all():
        detalle.precio_unitario_formateado = (
            formato_clp(detalle.precio_unitario)
        )

        detalle.subtotal_formateado = formato_clp(
            detalle.subtotal
        )

    contexto = {
        "pedido": pedido,
        "estados": Pedido.Estado.choices,
    }

    return render(
        request,
        "menu/pedido_detalle.html",
        contexto,
    )