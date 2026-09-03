import 'package:flutter/material.dart';

import '../models/producto.dart';
import '../services/carrito_service.dart';
import '../services/pedido_service.dart';
import '../widgets/app_bottom_nav.dart';
import 'carrito_screen.dart';
import 'locales_screen.dart';
import 'seguimiento_screen.dart';

class DetalleProductoScreen extends StatefulWidget {
  final Producto producto;

  const DetalleProductoScreen({
    super.key,
    required this.producto,
  });

  @override
  State<DetalleProductoScreen> createState() =>
      _DetalleProductoScreenState();
}

class _DetalleProductoScreenState
    extends State<DetalleProductoScreen> {
  static const Color naranja = Color(0xFFFF8A16);
  static const Color verde = Color(0xFF31A636);
  static const Color crema = Color(0xFFFFFBF3);

  int cantidad = 1;

  final TextEditingController instruccionesController =
      TextEditingController();

  Producto get producto => widget.producto;

  @override
  void dispose() {
    instruccionesController.dispose();
    super.dispose();
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

  String formatoPrecio(int valor) {
    return valor.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+$)'),
      (match) => '${match[1]}.',
    );
  }

  void disminuirCantidad() {
    if (cantidad > 1) {
      setState(() {
        cantidad--;
      });
    }
  }

  void aumentarCantidad() {
    if (cantidad < producto.stock) {
      setState(() {
        cantidad++;
      });
    }
  }

  void agregarAlCarrito() {
    for (int i = 0; i < cantidad; i++) {
      CarritoService.agregarProducto(producto);
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CarritoScreen(),
      ),
    );
  }

  void abrirInicio() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LocalesScreen(),
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

  void abrirCarrito() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CarritoScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: crema,

      body: Stack(
        children: [
          // Fondo orgánico superior izquierdo
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

          // Fondo orgánico superior derecho
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
                            color: naranja,
                            size: 22,
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

                // NOMBRE PRODUCTO
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: Text(
                    producto.nombre,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                      color: verde,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // CONTENIDO
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      24,
                      0,
                      24,
                      12,
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        // FOTO GRANDE
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(10),
                          child: Image.asset(
                            obtenerImagenProducto(
                              producto.nombre,
                            ),
                            width: double.infinity,
                            height: 205,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (
                                  context,
                                  error,
                                  stackTrace,
                                ) {
                              return Container(
                                width: double.infinity,
                                height: 205,
                                color:
                                    Colors.grey.shade200,
                                child: const Icon(
                                  Icons
                                      .image_not_supported,
                                  size: 50,
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 15),

                        // PRECIO
                        Text(
                          '\$ ${formatoPrecio(producto.precio)}',
                          style: const TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF302018),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // DESCRIPCIÓN
                        Text(
                          producto.descripcion,
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.35,
                            color: Color(0xFF555555),
                          ),
                        ),

                        const SizedBox(height: 14),

                        // INSTRUCCIONES
                        const Center(
                          child: Text(
                            'Agregar instrucciones',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  FontWeight.bold,
                              color: verde,
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),

                        TextField(
                          controller:
                              instruccionesController,
                          maxLines: 2,
                          decoration: InputDecoration(
                            hintText:
                                'Ejemplo: Sin aderezos, vegetales extra, etc.',
                            hintStyle:
                                const TextStyle(
                              fontSize: 12,
                              color:
                                  Color(0xFFAAAAAA),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding:
                                const EdgeInsets.all(
                              12,
                            ),
                            border:
                                OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                10,
                              ),
                              borderSide:
                                  const BorderSide(
                                color:
                                    Color(0xFFD5D5D5),
                              ),
                            ),
                            enabledBorder:
                                OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                10,
                              ),
                              borderSide:
                                  const BorderSide(
                                color:
                                    Color(0xFFD5D5D5),
                              ),
                            ),
                            focusedBorder:
                                OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                10,
                              ),
                              borderSide:
                                  const BorderSide(
                                color: naranja,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 13),

                        // CANTIDAD
                        Row(
                          children: [
                            _BotonCantidad(
                              icono: Icons.remove,
                              onPressed:
                                  disminuirCantidad,
                            ),

                            const SizedBox(width: 14),

                            Text(
                              '$cantidad',
                              style:
                                  const TextStyle(
                                fontSize: 18,
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            const SizedBox(width: 14),

                            _BotonCantidad(
                              icono: Icons.add,
                              onPressed:
                                  aumentarCantidad,
                            ),

                            const Spacer(),

                            if (!producto.disponible)
                              const Text(
                                'No disponible',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // BOTÓN PRINCIPAL
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: FilledButton(
                            onPressed:
                                producto.disponible
                                    ? agregarAlCarrito
                                    : null,
                            style:
                                FilledButton.styleFrom(
                              backgroundColor:
                                  naranja,
                              disabledBackgroundColor:
                                  Colors.grey.shade300,
                              foregroundColor:
                                  Colors.white,
                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                  8,
                                ),
                              ),
                            ),
                            child: Text(
                              producto.disponible
                                  ? 'Agregar al carrito'
                                  : 'No disponible',
                              style:
                                  const TextStyle(
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
        onCarrito: abrirCarrito,
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
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 35,
        height: 35,
        decoration: const BoxDecoration(
          color: naranja,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icono,
          color: Colors.white,
          size: 22,
        ),
      ),
    );
  }
}