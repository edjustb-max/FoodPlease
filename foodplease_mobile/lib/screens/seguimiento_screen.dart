import 'dart:async';

import 'package:flutter/material.dart';

import '../services/api_service.dart';
import '../widgets/app_bottom_nav.dart';
import 'carrito_screen.dart';
import 'detalle_pedido_screen.dart';
import 'locales_screen.dart';

class SeguimientoScreen extends StatefulWidget {
  final int pedidoId;
  final String direccion;
  final String metodoPago;
  final int descuento;
  final String numeroPedido;

  const SeguimientoScreen({
    super.key,
    required this.pedidoId,
    required this.direccion,
    required this.metodoPago,
    required this.numeroPedido,
    this.descuento = 0,
  });

  @override
  State<SeguimientoScreen> createState() =>
      _SeguimientoScreenState();
}

class _SeguimientoScreenState extends State<SeguimientoScreen> {
  static const Color naranja = Color(0xFFFF8A16);
  static const Color verde = Color(0xFF31A636);
  static const Color crema = Color(0xFFFFFBF3);

  Map<String, dynamic>? pedido;

  bool cargando = true;
  String? error;

  Timer? timer;

  @override
  void initState() {
    super.initState();

    cargarPedido();

    timer = Timer.periodic(
      const Duration(seconds: 5),
      (_) {
        cargarPedido(
          mostrarCarga: false,
        );
      },
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> cargarPedido({
    bool mostrarCarga = true,
  }) async {
    if (mostrarCarga && mounted) {
      setState(() {
        cargando = true;
        error = null;
      });
    }

    try {
      final respuesta =
          await ApiService.obtenerPedido(
        widget.pedidoId,
      );

      if (!mounted) return;

      setState(() {
        pedido = respuesta;
        cargando = false;
        error = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        cargando = false;
        error =
            'No se pudo actualizar el estado del pedido.';
      });
    }
  }

  String get estado {
    return pedido?['estado'] as String? ??
        'confirmado';
  }

  String get estadoTexto {
    return pedido?['estado_texto'] as String? ??
        'Pedido confirmado';
  }

  String get direccionActual {
    return pedido?['direccion'] as String? ??
        widget.direccion;
  }

  String get metodoPagoActual {
    return pedido?['metodo_pago'] as String? ??
        widget.metodoPago;
  }

  int get descuentoActual {
    return pedido?['descuento'] as int? ??
        widget.descuento;
  }

  bool estadoActivo(
    String estadoObjetivo,
  ) {
    const orden = {
      'confirmado': 0,
      'preparacion': 1,
      'en_camino': 2,
      'entregado': 3,
    };

    final actual = orden[estado] ?? 0;
    final objetivo =
        orden[estadoObjetivo] ?? 0;

    return actual >= objetivo;
  }

  String get tituloPrincipal {
    switch (estado) {
      case 'preparacion':
        return '¡Tu pedido está en preparación!';

      case 'en_camino':
        return '¡Tu pedido va en camino!';

      case 'entregado':
        return '¡Pedido entregado!';

      default:
        return '¡Pedido confirmado!';
    }
  }

  String get subtituloPrincipal {
    switch (estado) {
      case 'preparacion':
        return 'El local está preparando tu pedido.';

      case 'en_camino':
        return 'Tu pedido está siendo trasladado.';

      case 'entregado':
        return 'Tu pedido fue entregado correctamente.';

      default:
        return 'Tu pedido fue recibido correctamente.';
    }
  }

  IconData get iconoPrincipal {
    switch (estado) {
      case 'preparacion':
        return Icons.restaurant;

      case 'en_camino':
        return Icons.delivery_dining;

      case 'entregado':
        return Icons.home;

      default:
        return Icons.check_circle;
    }
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

  void abrirCarrito() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            const CarritoScreen(),
      ),
    );
  }

  void abrirDetalle() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            DetallePedidoScreen(
          pedidoId: widget.pedidoId,
          direccion: direccionActual,
          metodoPago: metodoPagoActual,
          descuento: descuentoActual,
          numeroPedido:
              widget.numeroPedido,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: crema,

      body: Stack(
        children: [
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
                  height: 62,
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
                            size: 21,
                          ),
                        ),
                      ),

                      Image.asset(
                        'assets/images/logo_foodplease.png',
                        width: 115,
                        height: 60,
                        fit: BoxFit.contain,
                      ),

                      Positioned(
                        right: 18,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration:
                              const BoxDecoration(
                            color: naranja,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.menu,
                            color: Colors.white,
                            size: 19,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Text(
                  'Seguimiento del pedido',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: verde,
                  ),
                ),

                const SizedBox(height: 8),

                Expanded(
                  child: cargando
                      ? const Center(
                          child:
                              CircularProgressIndicator(
                            color: naranja,
                          ),
                        )
                      : SingleChildScrollView(
                          padding:
                              const EdgeInsets.fromLTRB(
                            22,
                            0,
                            22,
                            10,
                          ),
                          child: Column(
                            children: [
                              // ESTADO PRINCIPAL
                              Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(
                                    16,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      iconoPrincipal,
                                      color: verde,
                                      size: 52,
                                    ),

                                    const SizedBox(
                                      height: 5,
                                    ),

                                    Text(
                                      tituloPrincipal,
                                      textAlign:
                                          TextAlign.center,
                                      style:
                                          const TextStyle(
                                        fontSize: 19,
                                        fontWeight:
                                            FontWeight.bold,
                                        color: Color(
                                          0xFF302018,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 2,
                                    ),

                                    Text(
                                      subtituloPrincipal,
                                      textAlign:
                                          TextAlign.center,
                                      style:
                                          const TextStyle(
                                        fontSize: 12,
                                        color: Color(
                                          0xFF777777,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 11),

                              // ESTADO
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                children: [
                                  const Text(
                                    'Estado del pedido',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight:
                                          FontWeight.bold,
                                      color: verde,
                                    ),
                                  ),

                                  Text(
                                    estadoTexto,
                                    style:
                                        const TextStyle(
                                      fontSize: 11,
                                      color: verde,
                                      fontWeight:
                                          FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 6),

                              // PROGRESO
                              Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.symmetric(
                                  horizontal: 13,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(
                                    16,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    _EstadoPedido(
                                      icono: Icons.check,
                                      titulo:
                                          'Pedido recibido',
                                      descripcion:
                                          'Pedido confirmado.',
                                      activo:
                                          estadoActivo(
                                        'confirmado',
                                      ),
                                    ),

                                    const _LineaEstado(),

                                    _EstadoPedido(
                                      icono:
                                          Icons.restaurant,
                                      titulo:
                                          'Preparando tu pedido',
                                      descripcion:
                                          'El local está preparando tu pedido.',
                                      activo:
                                          estadoActivo(
                                        'preparacion',
                                      ),
                                    ),

                                    const _LineaEstado(),

                                    _EstadoPedido(
                                      icono: Icons
                                          .delivery_dining,
                                      titulo: 'En camino',
                                      descripcion:
                                          'Un repartidor llevará tu pedido.',
                                      activo:
                                          estadoActivo(
                                        'en_camino',
                                      ),
                                    ),

                                    const _LineaEstado(),

                                    _EstadoPedido(
                                      icono: Icons.home,
                                      titulo: 'Entregado',
                                      descripcion:
                                          'Pedido entregado al cliente.',
                                      activo:
                                          estadoActivo(
                                        'entregado',
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 9),

                              // ENTREGA Y PAGO
                              Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.all(
                                  12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(
                                    16,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                  children: [
                                    const Row(
                                      children: [
                                        Icon(
                                          Icons
                                              .location_on_outlined,
                                          size: 17,
                                          color: verde,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          'Entrega',
                                          style:
                                              TextStyle(
                                            fontSize: 13,
                                            fontWeight:
                                                FontWeight
                                                    .bold,
                                            color: verde,
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(
                                      height: 4,
                                    ),

                                    Text(
                                      direccionActual,
                                      style:
                                          const TextStyle(
                                        fontSize: 12,
                                        color: Color(
                                          0xFF444444,
                                        ),
                                      ),
                                    ),

                                    const Divider(
                                      height: 14,
                                    ),

                                    const Row(
                                      children: [
                                        Icon(
                                          Icons
                                              .credit_card_outlined,
                                          size: 17,
                                          color: verde,
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          'Método de pago',
                                          style:
                                              TextStyle(
                                            fontSize: 13,
                                            fontWeight:
                                                FontWeight
                                                    .bold,
                                            color: verde,
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(
                                      height: 4,
                                    ),

                                    Text(
                                      metodoPagoActual,
                                      style:
                                          const TextStyle(
                                        fontSize: 12,
                                        color: Color(
                                          0xFF444444,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 10),

                              // NÚMERO DEL PEDIDO
                              Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.circular(
                                    12,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons
                                          .receipt_long_outlined,
                                      size: 18,
                                      color: verde,
                                    ),

                                    const SizedBox(width: 7),

                                    const Text(
                                      'Pedido',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight:
                                            FontWeight.bold,
                                        color: verde,
                                      ),
                                    ),

                                    const Spacer(),

                                    Text(
                                      widget.numeroPedido,
                                      style:
                                          const TextStyle(
                                        fontSize: 13,
                                        fontWeight:
                                            FontWeight.bold,
                                        color: Color(
                                          0xFF302018,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              if (error != null) ...[
                                const SizedBox(
                                  height: 7,
                                ),
                                Text(
                                  error!,
                                  textAlign:
                                      TextAlign.center,
                                  style:
                                      const TextStyle(
                                    fontSize: 11,
                                    color: Colors.red,
                                  ),
                                ),
                              ],

                              const SizedBox(height: 12),

                              // VER DETALLES
                              SizedBox(
                                width: double.infinity,
                                height: 43,
                                child: OutlinedButton(
                                  onPressed:
                                      abrirDetalle,
                                  style: OutlinedButton
                                      .styleFrom(
                                    foregroundColor:
                                        naranja,
                                    backgroundColor:
                                        Colors.white,
                                    side:
                                        const BorderSide(
                                      color: naranja,
                                    ),
                                    shape:
                                        RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius
                                              .circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    'Ver detalles del pedido',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 10),

                              // VOLVER AL INICIO
                              SizedBox(
                                width: double.infinity,
                                height: 44,
                                child: FilledButton(
                                  onPressed: abrirInicio,
                                  style:
                                      FilledButton
                                          .styleFrom(
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
                                    'Volver al inicio',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 4),
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
        activa: SeccionBottom.pedidos,
        onInicio: abrirInicio,
        onPedidos: () {},
        onCarrito: abrirCarrito,
      ),
    );
  }
}

class _EstadoPedido extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String descripcion;
  final bool activo;

  const _EstadoPedido({
    required this.icono,
    required this.titulo,
    required this.descripcion,
    required this.activo,
  });

  @override
  Widget build(BuildContext context) {
    const naranja = Color(0xFFFF8A16);

    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: activo
                ? naranja
                : const Color(0xFFF0F0F0),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icono,
            size: 18,
            color: activo
                ? Colors.white
                : const Color(0xFFAAAAAA),
          ),
        ),

        const SizedBox(width: 9),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                titulo,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: activo
                      ? const Color(
                          0xFF302018,
                        )
                      : const Color(
                          0xFF999999,
                        ),
                ),
              ),

              const SizedBox(height: 1),

              Text(
                descripcion,
                style: TextStyle(
                  fontSize: 10,
                  color: activo
                      ? const Color(
                          0xFF666666,
                        )
                      : const Color(
                          0xFFAAAAAA,
                        ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LineaEstado extends StatelessWidget {
  const _LineaEstado();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 9,
      margin: const EdgeInsets.only(
        left: 15,
      ),
      alignment: Alignment.centerLeft,
      child: Container(
        width: 2,
        height: 9,
        color: const Color(
          0xFFDDDDDD,
        ),
      ),
    );
  }
}