import 'dart:async';

import 'package:flutter/material.dart';

import '../services/api_service.dart';

class DetallePedidoScreen extends StatefulWidget {
  final int pedidoId;
  final String direccion;
  final String metodoPago;
  final int descuento;
  final String numeroPedido;

  const DetallePedidoScreen({
    super.key,
    required this.pedidoId,
    required this.direccion,
    required this.metodoPago,
    required this.descuento,
    required this.numeroPedido,
  });

  @override
  State<DetallePedidoScreen> createState() =>
      _DetallePedidoScreenState();
}

class _DetallePedidoScreenState
    extends State<DetallePedidoScreen> {
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

    // Actualiza automáticamente el detalle
    // si cambia el estado desde la plataforma web.
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
            'No se pudo obtener el detalle del pedido.';
      });
    }
  }

  int convertirEntero(dynamic valor) {
    if (valor is int) {
      return valor;
    }

    return int.tryParse(
          valor?.toString() ?? '0',
        ) ??
        0;
  }

  String formatoPrecio(int valor) {
    return valor.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+$)'),
      (match) => '${match[1]}.',
    );
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

  String get numeroPedidoActual {
    return pedido?['numero'] as String? ??
        widget.numeroPedido;
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

  int get subtotal {
    return convertirEntero(
      pedido?['subtotal'],
    );
  }

  int get costoEnvio {
    return convertirEntero(
      pedido?['costo_envio'],
    );
  }

  int get descuentoActual {
    return convertirEntero(
      pedido?['descuento'],
    );
  }

  int get total {
    return convertirEntero(
      pedido?['total'],
    );
  }

  List<Map<String, dynamic>> get items {
    final datos = pedido?['items'];

    if (datos is! List) {
      return [];
    }

    return datos
        .map(
          (item) => Map<String, dynamic>.from(
            item as Map,
          ),
        )
        .toList();
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
                SizedBox(
                  width: double.infinity,
                  height: 65,
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
                        width: 120,
                        height: 62,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ),

                const Text(
                  'Detalle del pedido',
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
                      : error != null &&
                              pedido == null
                          ? Center(
                              child: Padding(
                                padding:
                                    const EdgeInsets.all(
                                  30,
                                ),
                                child: Column(
                                  mainAxisSize:
                                      MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons
                                          .error_outline,
                                      color: naranja,
                                      size: 46,
                                    ),

                                    const SizedBox(
                                      height: 10,
                                    ),

                                    Text(
                                      error!,
                                      textAlign:
                                          TextAlign.center,
                                    ),

                                    const SizedBox(
                                      height: 12,
                                    ),

                                    FilledButton(
                                      onPressed:
                                          cargarPedido,
                                      style:
                                          FilledButton
                                              .styleFrom(
                                        backgroundColor:
                                            naranja,
                                      ),
                                      child:
                                          const Text(
                                        'Reintentar',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : SingleChildScrollView(
                              padding:
                                  const EdgeInsets
                                      .fromLTRB(
                                22,
                                0,
                                22,
                                15,
                              ),
                              child: Column(
                                children: [
                                  // DATOS PRINCIPALES
                                  Container(
                                    width:
                                        double.infinity,
                                    padding:
                                        const EdgeInsets
                                            .all(13),
                                    decoration:
                                        BoxDecoration(
                                      color:
                                          Colors.white,
                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                        15,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                      children: [
                                        Text(
                                          'Pedido: $numeroPedidoActual',
                                          style:
                                              const TextStyle(
                                            fontSize: 14,
                                            fontWeight:
                                                FontWeight
                                                    .bold,
                                          ),
                                        ),

                                        const SizedBox(
                                          height: 5,
                                        ),

                                        Text(
                                          'Estado: $estadoTexto',
                                          style:
                                              const TextStyle(
                                            fontSize: 13,
                                            color: verde,
                                            fontWeight:
                                                FontWeight
                                                    .w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 12,
                                  ),

                                  const Align(
                                    alignment: Alignment
                                        .centerLeft,
                                    child: Text(
                                      'Productos',
                                      style:
                                          TextStyle(
                                        fontSize: 16,
                                        fontWeight:
                                            FontWeight
                                                .bold,
                                        color: verde,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 7,
                                  ),

                                  // PRODUCTOS REALES DEL PEDIDO
                                  ...items.map(
                                    (item) {
                                      final nombre =
                                          item['nombre']
                                                  as String? ??
                                              'Producto';

                                      final cantidad =
                                          convertirEntero(
                                        item[
                                            'cantidad'],
                                      );

                                      final subtotalItem =
                                          convertirEntero(
                                        item[
                                            'subtotal'],
                                      );

                                      return _ProductoPedido(
                                        nombre:
                                            nombre,
                                        cantidad:
                                            cantidad,
                                        imagen:
                                            obtenerImagenProducto(
                                          nombre,
                                        ),
                                        precio:
                                            '\$ ${formatoPrecio(subtotalItem)}',
                                      );
                                    },
                                  ),

                                  const SizedBox(
                                    height: 10,
                                  ),

                                  // RESUMEN REAL DEL PEDIDO
                                  Container(
                                    padding:
                                        const EdgeInsets
                                            .all(13),
                                    decoration:
                                        BoxDecoration(
                                      color:
                                          Colors.white,
                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                        15,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        _FilaResumen(
                                          titulo:
                                              'Subtotal',
                                          valor:
                                              '\$ ${formatoPrecio(subtotal)}',
                                        ),

                                        const Divider(),

                                        _FilaResumen(
                                          titulo:
                                              'Costo de envío',
                                          valor:
                                              '\$ ${formatoPrecio(costoEnvio)}',
                                        ),

                                        const Divider(),

                                        _FilaResumen(
                                          titulo:
                                              'Descuento',
                                          valor:
                                              descuentoActual >
                                                      0
                                                  ? '- \$ ${formatoPrecio(descuentoActual)}'
                                                  : '\$ 0',
                                        ),

                                        const Divider(),

                                        _FilaResumen(
                                          titulo:
                                              'Total',
                                          valor:
                                              '\$ ${formatoPrecio(total)}',
                                          destacado:
                                              true,
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(
                                    height: 12,
                                  ),

                                  // ENTREGA Y PAGO REALES
                                  Container(
                                    width:
                                        double.infinity,
                                    padding:
                                        const EdgeInsets
                                            .all(13),
                                    decoration:
                                        BoxDecoration(
                                      color:
                                          Colors.white,
                                      borderRadius:
                                          BorderRadius
                                              .circular(
                                        15,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                      children: [
                                        const Text(
                                          'Entrega',
                                          style:
                                              TextStyle(
                                            color:
                                                verde,
                                            fontWeight:
                                                FontWeight
                                                    .bold,
                                          ),
                                        ),

                                        const SizedBox(
                                          height: 4,
                                        ),

                                        Text(
                                          direccionActual,
                                        ),

                                        const Divider(),

                                        const Text(
                                          'Método de pago',
                                          style:
                                              TextStyle(
                                            color:
                                                verde,
                                            fontWeight:
                                                FontWeight
                                                    .bold,
                                          ),
                                        ),

                                        const SizedBox(
                                          height: 4,
                                        ),

                                        Text(
                                          metodoPagoActual,
                                        ),
                                      ],
                                    ),
                                  ),

                                  if (error !=
                                      null) ...[
                                    const SizedBox(
                                      height: 8,
                                    ),

                                    Text(
                                      error!,
                                      textAlign:
                                          TextAlign
                                              .center,
                                      style:
                                          const TextStyle(
                                        fontSize: 11,
                                        color:
                                            Colors.red,
                                      ),
                                    ),
                                  ],

                                  const SizedBox(
                                    height: 15,
                                  ),

                                  SizedBox(
                                    width:
                                        double.infinity,
                                    height: 48,
                                    child:
                                        FilledButton(
                                      onPressed: () {
                                        Navigator.pop(
                                          context,
                                        );
                                      },
                                      style:
                                          FilledButton
                                              .styleFrom(
                                        backgroundColor:
                                            naranja,
                                        foregroundColor:
                                            Colors.white,
                                      ),
                                      child:
                                          const Text(
                                        'Volver al seguimiento',
                                        style:
                                            TextStyle(
                                          fontWeight:
                                              FontWeight
                                                  .bold,
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
    );
  }
}

class _ProductoPedido extends StatelessWidget {
  final String nombre;
  final int cantidad;
  final String imagen;
  final String precio;

  const _ProductoPedido({
    required this.nombre,
    required this.cantidad,
    required this.imagen,
    required this.precio,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 7,
      ),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius:
                BorderRadius.circular(8),
            child: Image.asset(
              imagen,
              width: 58,
              height: 58,
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
                  nombre,
                  style:
                      const TextStyle(
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  'Cantidad: $cantidad',
                  style:
                      const TextStyle(
                    fontSize: 12,
                    color:
                        Color(0xFF777777),
                  ),
                ),
              ],
            ),
          ),

          Text(
            precio,
            style:
                const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
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
            fontWeight: destacado
                ? FontWeight.bold
                : FontWeight.w500,
          ),
        ),

        Text(
          valor,
          style: TextStyle(
            fontWeight:
                FontWeight.bold,
            fontSize:
                destacado ? 15 : 13,
          ),
        ),
      ],
    );
  }
}