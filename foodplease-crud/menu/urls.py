from django.urls import path

from . import api_views, pedido_views, views


app_name = "menu"

urlpatterns = [
    path(
        "",
        views.producto_lista,
        name="producto_lista",
    ),
    path(
        "productos/nuevo/",
        views.producto_crear,
        name="producto_crear",
    ),
    path(
        "productos/<int:producto_id>/editar/",
        views.producto_editar,
        name="producto_editar",
    ),
    path(
        "productos/<int:producto_id>/eliminar/",
        views.producto_eliminar,
        name="producto_eliminar",
    ),

    path(
    "pedidos/",
    pedido_views.pedido_lista,
    name="pedido_lista",
    ),

    path(
    "pedidos/<int:pedido_id>/",
    pedido_views.pedido_detalle,
    name="pedido_detalle",
   ),

    # API para la aplicación Flutter
    path(
        "api/productos/",
        api_views.productos_api,
        name="productos_api",
    ),

    # Pedidos 
    path(
    "api/pedidos/",
    api_views.crear_pedido_api,
    name="crear_pedido_api",
    ),

    path(
    "api/pedidos/<int:pedido_id>/",
    api_views.obtener_pedido_api,
    name="obtener_pedido_api",
    ),


]