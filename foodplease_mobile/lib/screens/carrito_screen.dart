import 'package:flutter/material.dart';

import '../models/item_carrito.dart';
import '../services/carrito_service.dart';
import '../services/pedido_service.dart';
import '../widgets/app_bottom_nav.dart';
import 'locales_screen.dart';
import 'pago_entrega_screen.dart';
import 'seguimiento_screen.dart';

class CarritoScreen extends StatefulWidget {
  const CarritoScreen({super.key});

  @override
  State<CarritoScreen> createState() =>
      _CarritoScreenState();
}

class _CarritoScreenState extends State<CarritoScreen> {
  static const Color naranja = Color(0xFFFF8A16);
  static const Color verde = Color(0xFF31A636);
  static const Color crema = Color(0xFFFFFBF3);

  static const int costoEnvio = 2990;

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

  String formatoPrecio(int valor) {
    return valor.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+$)'),
      (match) => '${match[1]}.',
    );
  }

  void disminuir(ItemCarrito item) {
    setState(() {
      CarritoService.disminuirCantidad(item);
    });
  }

  void aumentar(ItemCarrito item) {
    setState(() {
      CarritoService.aumentarCantidad(item);
    });
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
      ScaffoldMessenger.of(context).showSnackBar(
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
        builder: (context) => SeguimientoScreen(
          pedidoId: PedidoService.pedidoId!,
          numeroPedido: PedidoService.numeroPedido!,
          direccion: PedidoService.direccion!,
          metodoPago: PedidoService.metodoPago!,
          descuento: PedidoService.descuento,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = CarritoService.items;
    final subtotal = CarritoService.total;

    final totalFinal =
        items.isEmpty ? 0 : subtotal + costoEnvio;

    return Scaffold(
      backgroundColor: crema,

      body: Stack(
        children: [
          // Fondo superior izquierdo
          Positioned(
            top: -100,
            left: -120,
            child: Container(
              width: 280,
              height: 300,
              decoration: const BoxDecoration(
                color: Color(0xFFE9EBD9),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Fondo superior derecho
          Positioned(
            top: 80,
            right: -130,
            child: Container(
              width: 280,
              height: 300,
              decoration: const BoxDecoration(
                color: Color(0xFFFFEFE1),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Fondo inferior
          Positioned(
            bottom: -110,
            right: -130,
            child: Container(
              width: 300,
              height: 300,
              decoration: const BoxDecoration(
                color: Color(0xFFE8EAD7),
                shape: BoxShape.circle,
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // ENCABEZADO
                SizedBox(
                  width: double.infinity,
                  height: 72,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        left: 10,
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios_new,
                            size: 22,
                            color: naranja,
                          ),
                        ),
                      ),

                      Image.asset(
                        'assets/images/logo_foodplease.png',
                        width: 125,
                        height: 70,
                        fit: BoxFit.contain,
                      ),

                      Positioned(
                        right: 18,
                        child: Container(
                          width: 34,
                          height: 34,
                          decoration: const BoxDecoration(
                            color: naranja,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.menu,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Text(
                  'Carrito',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: verde,
                  ),
                ),

                const SizedBox(height: 10),

                Expanded(
                  child: items.isEmpty
                      ? const Center(
                          child: Text(
                            'Tu carrito está vacío.',
                            style: TextStyle(
                              fontSize: 17,
                              color: Color(0xFF666666),
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          padding:
                              const EdgeInsets.fromLTRB(
                            22,
                            0,
                            22,
                            14,
                          ),
                          child: Column(
                            children: [
                              ...items.map(
                                (item) =>
                                    _construirProducto(
                                  item,
                                ),
                              ),

                              const SizedBox(height: 9),

                              const Text(
                                'Resumen del pedido',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight:
                                      FontWeight.bold,
                                  color: verde,
                                ),
                              ),

                              const SizedBox(height: 9),

                              Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.all(
                                  14,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white
                                      .withOpacity(0.95),
                                  borderRadius:
                                      BorderRadius.circular(
                                    16,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    _FilaResumen(
                                      titulo: 'Subtotal',
                                      valor:
                                          '\$ ${formatoPrecio(subtotal)}',
                                    ),

                                    const Divider(
                                      height: 20,
                                    ),

                                    _FilaResumen(
                                      titulo:
                                          'Costo de envío',
                                      valor:
                                          '\$ ${formatoPrecio(costoEnvio)}',
                                    ),

                                    const Divider(
                                      height: 20,
                                    ),

                                    _FilaResumen(
                                      titulo: 'Total',
                                      valor:
                                          '\$ ${formatoPrecio(totalFinal)}',
                                      destacado: true,
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 14),

                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: FilledButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) =>
                                                const PagoEntregaScreen(),
                                      ),
                                    );
                                  },
                                  style:
                                      FilledButton.styleFrom(
                                    backgroundColor:
                                        naranja,
                                    foregroundColor:
                                        Colors.white,
                                    shape:
                                        RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius
                                              .circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    'Confirmar pedido',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),

      bottomNavigationBar: AppBottomNav(
        activa: SeccionBottom.carrito,
        onInicio: abrirInicio,
        onPedidos: abrirPedidos,

        // Ya estamos en Carrito.
        onCarrito: () {},
      ),
    );
  }

  Widget _construirProducto(
    ItemCarrito item,
  ) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 8,
      ),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        borderRadius:
            BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius:
                BorderRadius.circular(8),
            child: Image.asset(
              obtenerImagenProducto(
                item.producto.nombre,
              ),
              width: 66,
              height: 66,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  item.producto.nombre,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight:
                        FontWeight.bold,
                    color:
                        Color(0xFF302018),
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  '\$ ${formatoPrecio(item.producto.precio)}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight:
                        FontWeight.bold,
                    color:
                        Color(0xFF302018),
                  ),
                ),
              ],
            ),
          ),

          _BotonCantidad(
            icono: Icons.remove,
            onPressed: () {
              disminuir(item);
            },
          ),

          const SizedBox(width: 8),

          Text(
            '${item.cantidad}',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(width: 8),

          _BotonCantidad(
            icono: Icons.add,
            onPressed: () {
              aumentar(item);
            },
          ),
        ],
      ),
    );
  }
}

class _BotonCantidad extends StatelessWidget {
  final IconData icono;
  final VoidCallback onPressed;

  const _BotonCantidad({
    required this.icono,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    const naranja = Color(0xFFFF8A16);

    return InkWell(
      onTap: onPressed,
      borderRadius:
          BorderRadius.circular(30),
      child: Container(
        width: 25,
        height: 25,
        decoration: const BoxDecoration(
          color: naranja,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icono,
          size: 17,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _FilaResumen extends StatelessWidget {
  final String titulo;
  final String valor;
  final bool destacado;

  const _FilaResumen({
    required this.titulo,
    required this.valor,
    this.destacado = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        Text(
          titulo,
          style: TextStyle(
            fontSize:
                destacado ? 15 : 13,
            fontWeight: destacado
                ? FontWeight.bold
                : FontWeight.w500,
          ),
        ),

        Text(
          valor,
          style: TextStyle(
            fontSize:
                destacado ? 16 : 13,
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ],
    );
  }
}