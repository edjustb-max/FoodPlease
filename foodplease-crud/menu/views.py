from django.contrib import messages
from django.shortcuts import get_object_or_404, redirect, render
from django.views.decorators.http import require_http_methods

from .forms import ProductoForm
from .models import Producto


def producto_lista(request):
    productos = Producto.objects.all()

    contexto = {
        "productos": productos,
    }

    return render(request, "menu/producto_lista.html", contexto)


@require_http_methods(["GET", "POST"])
def producto_crear(request):
    if request.method == "POST":
        formulario = ProductoForm(request.POST)

        if formulario.is_valid():
            producto = formulario.save()

            messages.success(
                request,
                f'El producto "{producto.nombre}" fue registrado correctamente.',
            )

            return redirect("menu:producto_lista")
    else:
        formulario = ProductoForm()

    contexto = {
        "formulario": formulario,
        "titulo": "Registrar producto",
        "texto_boton": "Guardar producto",
    }

    return render(request, "menu/producto_formulario.html", contexto)


@require_http_methods(["GET", "POST"])
def producto_editar(request, producto_id):
    producto = get_object_or_404(Producto, id=producto_id)

    if request.method == "POST":
        formulario = ProductoForm(
            request.POST,
            instance=producto,
        )

        if formulario.is_valid():
            producto = formulario.save()

            messages.success(
                request,
                f'El producto "{producto.nombre}" fue actualizado correctamente.',
            )

            return redirect("menu:producto_lista")
    else:
        formulario = ProductoForm(instance=producto)

    contexto = {
        "formulario": formulario,
        "producto": producto,
        "titulo": "Editar producto",
        "texto_boton": "Guardar cambios",
    }

    return render(request, "menu/producto_formulario.html", contexto)


@require_http_methods(["GET", "POST"])
def producto_eliminar(request, producto_id):
    producto = get_object_or_404(Producto, id=producto_id)

    if request.method == "POST":
        nombre_producto = producto.nombre
        producto.delete()

        messages.success(
            request,
            f'El producto "{nombre_producto}" fue eliminado correctamente.',
        )

        return redirect("menu:producto_lista")

    contexto = {
        "producto": producto,
    }

    return render(request, "menu/producto_confirmar_eliminacion.html", contexto)