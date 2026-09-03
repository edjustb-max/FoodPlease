import 'package:flutter/material.dart';

import '../models/producto.dart';
import '../services/api_service.dart';
import '../services/pedido_service.dart';
import '../widgets/app_bottom_nav.dart';
import 'carrito_screen.dart';
import 'detalle_producto_screen.dart';
import 'locales_screen.dart';
import 'seguimiento_screen.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  late Future<List<Producto>> productos;

  final TextEditingController buscadorController =
      TextEditingController();

  String categoriaSeleccionada = 'Todos';

  final List<String> categorias = [
    'Todos',
    'Destacados',
    'Entradas',
    'Platos',
    'Bebidas',
  ];

  @override
  void initState() {
    super.initState();
    productos = ApiService.obtenerProductos();
  }

  String obtenerImagenProducto(String nombre) {
    switch (nombre.toLowerCase()) {
      case 'ensalada cesar':
        return 'assets/images/ensalada_cesar.png';

      case 'bowl mediterráneo':
      case 'bowl mediterraneo':
        return 'assets/images/bowl_mediterraneo.png';

      case 'salmón al horno':
      case 'salmon al horno':
        return 'assets/images/salmon_horno.png';

      case 'ensalada griega':
        return 'assets/images/ensalada_griega.png';

      case 'jugo natural':
        return 'assets/images/jugo_natural.png';

      default:
        return 'assets/images/logo_foodplease.png';
    }
  }

  List<Producto> filtrarProductos(
    List<Producto> lista,
  ) {
    final textoBusqueda =
        buscadorController.text.toLowerCase();

    return lista.where((producto) {
      final coincideBusqueda =
          producto.nombre
                  .toLowerCase()
                  .contains(textoBusqueda) ||
              producto.descripcion
                  .toLowerCase()
                  .contains(textoBusqueda);

      bool coincideCategoria = true;

      if (categoriaSeleccionada == 'Bebidas') {
        coincideCategoria =
            producto.categoria.toLowerCase() ==
                'bebida';
      } else if (categoriaSeleccionada ==
          'Entradas') {
        coincideCategoria =
            producto.categoria.toLowerCase() ==
                'acompañamiento';
      } else if (categoriaSeleccionada ==
          'Platos') {
        coincideCategoria =
            producto.categoria.toLowerCase() ==
                    'hamburguesa' ||
                producto.categoria
                        .toLowerCase() ==
                    'pizza' ||
                producto.categoria
                        .toLowerCase() ==
                    'completo' ||
                producto.categoria
                        .toLowerCase() ==
                    'postre' ||
                producto.categoria
                        .toLowerCase() ==
                    'otro';
      } else if (categoriaSeleccionada ==
          'Destacados') {
        coincideCategoria = true;
      }

      return coincideBusqueda &&
          coincideCategoria;
    }).toList();
  }

  Widget construirBotonCategoria(
    String categoria,
  ) {
    final seleccionada =
        categoriaSeleccionada == categoria;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 3,
        ),
        child: SizedBox(
          height: 31,
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                categoriaSeleccionada =
                    categoria;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(6),
              ),
            ),
            child: Text(
              categoria,
              style: TextStyle(
                fontSize: 10,
                fontWeight: seleccionada
                    ? FontWeight.bold
                    : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget construirTarjetaProducto(
    Producto producto,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                DetalleProductoScreen(
              producto: producto,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(
          bottom: 8,
        ),
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.92),
          borderRadius:
              BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color:
                  Colors.black.withOpacity(
                0.08,
              ),
              blurRadius: 6,
              offset:
                  const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(10),
              child: Image.asset(
                obtenerImagenProducto(
                  producto.nombre,
                ),
                width: 72,
                height: 72,
                fit: BoxFit.cover,
                errorBuilder: (
                  context,
                  error,
                  stackTrace,
                ) {
                  return Container(
                    width: 72,
                    height: 72,
                    color:
                        Colors.grey.shade200,
                    child: const Icon(
                      Icons.image_not_supported,
                    ),
                  );
                },
              ),
            ),

            const SizedBox(width: 11),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    producto.nombre,
                    style:
                        const TextStyle(
                      fontSize: 15.5,
                      fontWeight:
                          FontWeight.bold,
                      color: Color(
                        0xFF3A2A24,
                      ),
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    producto.descripcion,
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.5,
                      height: 1.22,
                      color:
                          Colors.grey.shade700,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    '\$ ${producto.precio}',
                    style:
                        const TextStyle(
                      fontSize: 16.5,
                      fontWeight:
                          FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 7),

            InkWell(
              onTap: producto.disponible
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              DetalleProductoScreen(
                            producto:
                                producto,
                          ),
                        ),
                      );
                    }
                  : null,
              borderRadius:
                  BorderRadius.circular(30),
              child: Container(
                width: 33,
                height: 33,
                decoration:
                    BoxDecoration(
                  color:
                      producto.disponible
                          ? Colors.orange
                          : Colors
                              .grey
                              .shade300,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add,
                  size: 22,
                  color:
                      producto.disponible
                          ? Colors.white
                          : Colors
                              .grey
                              .shade600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void abrirInicio() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const LocalesScreen(),
      ),
      (route) => route.isFirst,
    );
  }

  void abrirPedidos() {
    if (!PedidoService.tienePedidoActual) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Aún no tienes un pedido activo.',
          ),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            SeguimientoScreen(
          pedidoId:
              PedidoService.pedidoId!,
          numeroPedido:
              PedidoService.numeroPedido!,
          direccion:
              PedidoService.direccion!,
          metodoPago:
              PedidoService.metodoPago!,
          descuento:
              PedidoService.descuento,
        ),
      ),
    );
  }

  void abrirCarrito() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const CarritoScreen(),
      ),
    );
  }

  @override
  void dispose() {
    buscadorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF7F3EA),

      body: Stack(
        children: [
          Positioned(
            top: -40,
            left: -50,
            child: Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                color: const Color(
                  0xFFDDE3CB,
                ),
                borderRadius:
                    BorderRadius.circular(
                  100,
                ),
              ),
            ),
          ),

          Positioned(
            top: 40,
            right: -70,
            child: Container(
              width: 210,
              height: 210,
              decoration: BoxDecoration(
                color: const Color(
                  0xFFF4E4D8,
                ),
                borderRadius:
                    BorderRadius.circular(
                  120,
                ),
              ),
            ),
          ),

          Positioned(
            bottom: -70,
            right: -30,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                color: const Color(
                  0xFFDDE3CB,
                ),
                borderRadius:
                    BorderRadius.circular(
                  100,
                ),
              ),
            ),
          ),

          SafeArea(
            child: FutureBuilder<
                List<Producto>>(
              future: productos,
              builder:
                  (context, snapshot) {
                if (snapshot
                        .connectionState ==
                    ConnectionState
                        .waiting) {
                  return const Center(
                    child:
                        CircularProgressIndicator(
                      color:
                          Colors.orange,
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return const Center(
                    child: Text(
                      'No se pudieron cargar los productos.',
                    ),
                  );
                }

                final lista =
                    snapshot.data ?? [];

                final productosFiltrados =
                    filtrarProductos(lista);

                return Padding(
                  padding:
                      const EdgeInsets
                          .symmetric(
                    horizontal: 18,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 7,
                      ),

                      Center(
                        child: Image.asset(
                          'assets/images/logo_foodplease.png',
                          height: 65,
                        ),
                      ),

                      const SizedBox(
                        height: 3,
                      ),

                      const Text(
                        'Menú',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight:
                              FontWeight.bold,
                          color:
                              Colors.green,
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      Row(
                        children:
                            categorias
                                .map(
                                  (
                                    categoria,
                                  ) =>
                                      construirBotonCategoria(
                                    categoria,
                                  ),
                                )
                                .toList(),
                      ),

                      const SizedBox(
                        height: 9,
                      ),

                      Container(
                        height: 44,
                        padding:
                            const EdgeInsets
                                .symmetric(
                          horizontal: 12,
                        ),
                        decoration:
                            BoxDecoration(
                          color:
                              Colors.white,
                          borderRadius:
                              BorderRadius
                                  .circular(
                            14,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors
                                  .black
                                  .withOpacity(
                                0.08,
                              ),
                              blurRadius:
                                  6,
                              offset:
                                  const Offset(
                                0,
                                3,
                              ),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.search,
                              color:
                                  Colors.black54,
                            ),

                            const SizedBox(
                              width: 8,
                            ),

                            Expanded(
                              child: TextField(
                                controller:
                                    buscadorController,
                                onChanged: (_) {
                                  setState(
                                    () {},
                                  );
                                },
                                decoration:
                                    const InputDecoration(
                                  hintText:
                                      'Buscar producto',
                                  border:
                                      InputBorder.none,
                                ),
                              ),
                            ),

                            const Icon(
                              Icons.tune,
                              color:
                                  Colors.black54,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      Expanded(
                        child:
                            productosFiltrados
                                    .isEmpty
                                ? const Center(
                                    child:
                                        Text(
                                      'No hay productos disponibles.',
                                    ),
                                  )
                                : ListView
                                    .builder(
                                    padding:
                                        const EdgeInsets
                                            .only(
                                      bottom: 6,
                                    ),
                                    itemCount:
                                        productosFiltrados
                                            .length,
                                    itemBuilder:
                                        (
                                          context,
                                          index,
                                        ) {
                                      return construirTarjetaProducto(
                                        productosFiltrados[
                                            index],
                                      );
                                    },
                                  ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),

      bottomNavigationBar: AppBottomNav(
        activa: SeccionBottom.inicio,
        onInicio: abrirInicio,
        onPedidos: abrirPedidos,
        onCarrito: abrirCarrito,
      ),
    );
  }
}