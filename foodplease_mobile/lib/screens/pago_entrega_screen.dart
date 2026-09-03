import 'package:flutter/material.dart';

import '../services/api_service.dart';
import '../services/carrito_service.dart';
import '../services/pedido_service.dart';
import '../widgets/app_bottom_nav.dart';
import 'locales_screen.dart';
import 'seguimiento_screen.dart';

class PagoEntregaScreen extends StatefulWidget {
  const PagoEntregaScreen({super.key});

  @override
  State<PagoEntregaScreen> createState() =>
      _PagoEntregaScreenState();
}

class _PagoEntregaScreenState
    extends State<PagoEntregaScreen> {
  static const Color naranja = Color(0xFFFF8A16);
  static const Color verde = Color(0xFF31A636);
  static const Color crema = Color(0xFFFFFBF3);

  static const int costoEnvio = 2990;

  final TextEditingController direccionController =
      TextEditingController();

  final TextEditingController cuponController =
      TextEditingController();

  String metodoPago = 'Tarjeta';

  int descuento = 0;
  bool cuponAplicado = false;
  bool procesandoPedido = false;

  int get subtotal => CarritoService.total;

  int get totalFinal =>
      subtotal + costoEnvio - descuento;

  @override
  void dispose() {
    direccionController.dispose();
    cuponController.dispose();
    super.dispose();
  }

  String formatoPrecio(int valor) {
    return valor.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+$)'),
      (match) => '${match[1]}.',
    );
  }

  void aplicarCupon() {
    final codigo =
        cuponController.text.trim().toUpperCase();

    if (codigo == 'FOOD10') {
      setState(() {
        descuento = (subtotal * 0.10).round();
        cuponAplicado = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Cupón FOOD10 aplicado: 10% de descuento.',
          ),
        ),
      );
    } else {
      setState(() {
        descuento = 0;
        cuponAplicado = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'El código ingresado no es válido.',
          ),
        ),
      );
    }
  }

  Future<void> confirmarPedido() async {
    final direccion =
        direccionController.text.trim();

    if (direccion.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Ingresa una dirección de entrega.',
          ),
        ),
      );
      return;
    }

    if (CarritoService.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'El carrito está vacío.',
          ),
        ),
      );
      return;
    }

    setState(() {
      procesandoPedido = true;
    });

    try {
      final items = CarritoService.items
          .map(
            (item) => {
              'producto_id': item.producto.id,
              'cantidad': item.cantidad,
            },
          )
          .toList();

      final respuesta =
          await ApiService.crearPedido(
        direccion: direccion,
        metodoPago: metodoPago,
        codigoCupon:
            cuponController.text.trim(),
        items: items,
      );

      if (!mounted) return;

      final descuentoReal =
          respuesta['descuento'] as int? ?? 0;

      final numeroPedido =
          respuesta['numero'] as String? ??
              'FP-00000';

      final pedidoId =
          respuesta['pedido_id'] as int;

      PedidoService.guardarPedido(
        pedidoId: pedidoId,
        numeroPedido: numeroPedido,
        direccion: direccion,
        metodoPago: metodoPago,
        descuento: descuentoReal,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Pedido ${respuesta['numero']} guardado correctamente.',
          ),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              SeguimientoScreen(
            pedidoId: pedidoId,
            direccion: direccion,
            metodoPago: metodoPago,
            descuento: descuentoReal,
            numeroPedido: numeroPedido,
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error
                .toString()
                .replaceFirst(
                  'Exception: ',
                  '',
                ),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          procesandoPedido = false;
        });
      }
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
        builder: (context) =>
            SeguimientoScreen(
          pedidoId: PedidoService.pedidoId!,
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

  void volverCarrito() {
    Navigator.pop(context);
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
                          decoration:
                              const BoxDecoration(
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
                  'Pago y entrega',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: verde,
                  ),
                ),

                const SizedBox(height: 8),

                Expanded(
                  child: SingleChildScrollView(
                    padding:
                        const EdgeInsets.fromLTRB(
                      22,
                      0,
                      22,
                      15,
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const _TituloSeccion(
                          icono:
                              Icons.location_on_outlined,
                          texto:
                              'Dirección de entrega',
                        ),

                        const SizedBox(height: 6),

                        Container(
                          padding:
                              const EdgeInsets.all(
                            12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(
                              14,
                            ),
                          ),
                          child: TextField(
                            controller:
                                direccionController,
                            decoration:
                                const InputDecoration(
                              hintText:
                                  'Ej: Avenida Siempreviva 742',
                              prefixIcon: Icon(
                                Icons.home_outlined,
                                color: verde,
                              ),
                              filled: false,
                              border:
                                  InputBorder.none,
                              enabledBorder:
                                  InputBorder.none,
                              focusedBorder:
                                  InputBorder.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 13),

                        const _TituloSeccion(
                          icono:
                              Icons.credit_card_outlined,
                          texto: 'Método de pago',
                        ),

                        const SizedBox(height: 6),

                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(
                              14,
                            ),
                          ),
                          child: Column(
                            children: [
                              RadioListTile<String>(
                                value: 'Tarjeta',
                                groupValue:
                                    metodoPago,
                                activeColor:
                                    naranja,
                                dense: true,
                                title:
                                    const Text(
                                  'Tarjeta terminada en ••••79',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight:
                                        FontWeight
                                            .w600,
                                  ),
                                ),
                                secondary:
                                    const Icon(
                                  Icons.credit_card,
                                  color: naranja,
                                ),
                                onChanged:
                                    (value) {
                                  setState(() {
                                    metodoPago =
                                        value!;
                                  });
                                },
                              ),

                              const Divider(
                                height: 1,
                              ),

                              RadioListTile<String>(
                                value: 'Efectivo',
                                groupValue:
                                    metodoPago,
                                activeColor:
                                    naranja,
                                dense: true,
                                title:
                                    const Text(
                                  'Efectivo',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight:
                                        FontWeight
                                            .w600,
                                  ),
                                ),
                                secondary:
                                    const Icon(
                                  Icons
                                      .payments_outlined,
                                  color: verde,
                                ),
                                onChanged:
                                    (value) {
                                  setState(() {
                                    metodoPago =
                                        value!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 13),

                        const _TituloSeccion(
                          icono:
                              Icons.discount_outlined,
                          texto:
                              'Código de descuento',
                        ),

                        const SizedBox(height: 6),

                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 45,
                                decoration:
                                    BoxDecoration(
                                  color:
                                      Colors.white,
                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    12,
                                  ),
                                  border:
                                      Border.all(
                                    color:
                                        const Color(
                                      0xFFD4D4D4,
                                    ),
                                  ),
                                ),
                                child: TextField(
                                  controller:
                                      cuponController,
                                  decoration:
                                      const InputDecoration(
                                    hintText:
                                        'Ingresa tu cupón',
                                    filled: false,
                                    border:
                                        InputBorder
                                            .none,
                                    enabledBorder:
                                        InputBorder
                                            .none,
                                    focusedBorder:
                                        InputBorder
                                            .none,
                                    contentPadding:
                                        EdgeInsets
                                            .symmetric(
                                      horizontal:
                                          12,
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 8),

                            SizedBox(
                              height: 45,
                              child: FilledButton(
                                onPressed:
                                    aplicarCupon,
                                style:
                                    FilledButton
                                        .styleFrom(
                                  backgroundColor:
                                      naranja,
                                ),
                                child:
                                    const Text(
                                  'Aplicar',
                                ),
                              ),
                            ),
                          ],
                        ),

                        if (cuponAplicado)
                          const Padding(
                            padding:
                                EdgeInsets.only(
                              top: 5,
                            ),
                            child: Text(
                              'Cupón FOOD10 aplicado',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight:
                                    FontWeight.bold,
                                color: verde,
                              ),
                            ),
                          ),

                        const SizedBox(height: 13),

                        const _TituloSeccion(
                          icono:
                              Icons.receipt_long_outlined,
                          texto:
                              'Resumen del pedido',
                        ),

                        const SizedBox(height: 6),

                        Container(
                          width: double.infinity,
                          padding:
                              const EdgeInsets.all(
                            13,
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
                              _FilaResumen(
                                titulo: 'Productos',
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
                                    descuento > 0
                                        ? '- \$ ${formatoPrecio(descuento)}'
                                        : '\$ 0',
                              ),

                              const Divider(),

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
                            onPressed:
                                procesandoPedido
                                    ? null
                                    : confirmarPedido,
                            style:
                                FilledButton.styleFrom(
                              backgroundColor:
                                  naranja,
                              disabledBackgroundColor:
                                  Colors
                                      .orange.shade200,
                            ),
                            child:
                                procesandoPedido
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child:
                                            CircularProgressIndicator(
                                          strokeWidth:
                                              2,
                                          color: Colors
                                              .white,
                                        ),
                                      )
                                    : const Text(
                                        'Pagar y confirmar pedido',
                                        style:
                                            TextStyle(
                                          fontSize:
                                              15,
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

      bottomNavigationBar: AppBottomNav(
        activa: SeccionBottom.carrito,
        onInicio: abrirInicio,
        onPedidos: abrirPedidos,
        onCarrito: volverCarrito,
      ),
    );
  }
}

class _TituloSeccion extends StatelessWidget {
  final IconData icono;
  final String texto;

  const _TituloSeccion({
    required this.icono,
    required this.texto,
  });

  @override
  Widget build(BuildContext context) {
    const verde = Color(0xFF31A636);

    return Row(
      children: [
        Icon(
          icono,
          size: 18,
          color: verde,
        ),
        const SizedBox(width: 5),
        Text(
          texto,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: verde,
          ),
        ),
      ],
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
            fontWeight: FontWeight.bold,
            fontSize:
                destacado ? 15 : 13,
          ),
        ),
      ],
    );
  }
}