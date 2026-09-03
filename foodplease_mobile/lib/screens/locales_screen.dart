import 'package:flutter/material.dart';

import '../services/pedido_service.dart';
import '../widgets/app_bottom_nav.dart';
import 'carrito_screen.dart';
import 'menu_screen.dart';
import 'seguimiento_screen.dart';

class LocalesScreen extends StatelessWidget {
  const LocalesScreen({super.key});

  static const Color naranja = Color(0xFFFF8A16);
  static const Color verde = Color(0xFF31A636);
  static const Color crema = Color(0xFFFFFBF3);

  void abrirMenu(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MenuScreen(),
      ),
    );
  }

  void abrirPedidos(BuildContext context) {
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

  void abrirCarrito(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CarritoScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locales = [
      const _LocalData(
        nombre: 'Sabor Natural',
        categoria: 'Cocina Saludable',
        imagen: 'assets/images/local_sabor_natural.png',
        rating: '4.7',
        tiempo: '30 - 40 min',
        favorito: true,
      ),
      const _LocalData(
        nombre: 'La Tradición',
        categoria: 'Cocina Chilena',
        imagen: 'assets/images/local_tradicion.png',
        rating: '4.5',
        tiempo: '20 - 30 min',
        favorito: false,
      ),
      const _LocalData(
        nombre: 'Don Cangrejo',
        categoria: 'Hamburguesas',
        imagen: 'assets/images/local_don_cangrejo.png',
        rating: '4.2',
        tiempo: '15 - 25 min',
        favorito: false,
      ),
      const _LocalData(
        nombre: 'El Oso',
        categoria: 'Pizzas',
        imagen: 'assets/images/local_el_oso.png',
        rating: '4.6',
        tiempo: '35 - 45 min',
        favorito: true,
      ),
      const _LocalData(
        nombre: 'Yoshi',
        categoria: 'Pastas Italianas',
        imagen: 'assets/images/local_yoshi.png',
        rating: '4.8',
        tiempo: '10 - 20 min',
        favorito: false,
      ),
    ];

    return Scaffold(
      backgroundColor: crema,

      body: Stack(
        children: [
          // Forma decorativa superior izquierda
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

          // Forma decorativa superior derecha
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

          // Forma decorativa inferior derecha
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
                const SizedBox(height: 6),

                // LOGO
                Image.asset(
                  'assets/images/logo_foodplease.png',
                  width: 160,
                  height: 85,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 2),

                const Text(
                  'Locales Disponibles',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: verde,
                  ),
                ),

                const SizedBox(height: 3),

                const Text(
                  'Elige tú local favorito',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF444444),
                  ),
                ),

                const SizedBox(height: 8),

                // BUSCADOR
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                  ),
                  child: Container(
                    height: 43,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: const Color(0xFFBDBDBD),
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x16000000),
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Buscar local',
                        hintStyle: TextStyle(
                          fontSize: 14,
                          color: Color(0xFFAAAAAA),
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.black87,
                        ),
                        suffixIcon: Icon(
                          Icons.tune,
                          color: Colors.black87,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 11,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 7),

                // LISTA DE LOCALES
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      0,
                      20,
                      12,
                    ),
                    itemCount: locales.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 9),
                    itemBuilder: (context, index) {
                      final local = locales[index];

                      return _LocalCard(
                        local: local,
                        onTap: () {
                          abrirMenu(context);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      bottomNavigationBar: AppBottomNav(
        activa: SeccionBottom.inicio,

        // Ya estamos en Inicio.
        onInicio: () {},

        onPedidos: () {
          abrirPedidos(context);
        },

        onCarrito: () {
          abrirCarrito(context);
        },
      ),
    );
  }
}

// DATOS DE CADA LOCAL
class _LocalData {
  final String nombre;
  final String categoria;
  final String imagen;
  final String rating;
  final String tiempo;
  final bool favorito;

  const _LocalData({
    required this.nombre,
    required this.categoria,
    required this.imagen,
    required this.rating,
    required this.tiempo,
    required this.favorito,
  });
}

// TARJETA DE LOCAL
class _LocalCard extends StatelessWidget {
  final _LocalData local;
  final VoidCallback onTap;

  const _LocalCard({
    required this.local,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const naranja = Color(0xFFFF8A16);

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          height: 90,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0x10000000),
                blurRadius: 3,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // FOTO
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  local.imagen,
                  width: 82,
                  height: 74,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(width: 12),

              // INFORMACIÓN
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      local.nombre,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF302018),
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      local.categoria,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF666666),
                      ),
                    ),

                    const SizedBox(height: 5),

                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: naranja,
                          size: 16,
                        ),

                        const SizedBox(width: 3),

                        Text(
                          local.rating,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF555555),
                          ),
                        ),

                        const SizedBox(width: 7),

                        Icon(
                          local.favorito
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 15,
                          color: local.favorito
                              ? naranja
                              : const Color(0xFFD1D1C8),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // TIEMPO
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 5,
                    bottom: 5,
                  ),
                  child: Text(
                    local.tiempo,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF555555),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}