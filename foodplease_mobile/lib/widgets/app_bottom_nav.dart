import 'package:flutter/material.dart';

enum SeccionBottom {
  inicio,
  pedidos,
  carrito,
  perfil,
}

class AppBottomNav extends StatelessWidget {
  final SeccionBottom activa;

  final VoidCallback onInicio;
  final VoidCallback onPedidos;
  final VoidCallback onCarrito;
  final VoidCallback? onPerfil;

  const AppBottomNav({
    super.key,
    required this.activa,
    required this.onInicio,
    required this.onPedidos,
    required this.onCarrito,
    this.onPerfil,
  });

  static const Color naranja = Color(0xFFFF8A16);
  static const Color crema = Color(0xFFFFFBF3);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: const BoxDecoration(
        color: crema,
        boxShadow: [
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceAround,
          children: [
            _BottomItem(
              icono: Icons.home_outlined,
              texto: 'Inicio',
              activo:
                  activa == SeccionBottom.inicio,
              onTap: onInicio,
            ),

            _BottomItem(
              icono:
                  Icons.receipt_long_outlined,
              texto: 'Pedidos',
              activo:
                  activa == SeccionBottom.pedidos,
              onTap: onPedidos,
            ),

            _BottomItem(
              icono:
                  Icons.shopping_cart_outlined,
              texto: 'Carrito',
              activo:
                  activa == SeccionBottom.carrito,
              onTap: onCarrito,
            ),

            _BottomItem(
              icono: Icons.person_outline,
              texto: 'Perfil',
              activo:
                  activa == SeccionBottom.perfil,
              onTap: onPerfil,
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomItem extends StatelessWidget {
  final IconData icono;
  final String texto;
  final bool activo;
  final VoidCallback? onTap;

  const _BottomItem({
    required this.icono,
    required this.texto,
    required this.activo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const naranja = Color(0xFFFF8A16);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        width: 70,
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Icon(
              icono,
              size: 27,
              color: activo
                  ? naranja
                  : const Color(
                      0xFF555555,
                    ),
            ),

            const SizedBox(height: 2),

            Text(
              texto,
              style: TextStyle(
                fontSize: 11,
                color: activo
                    ? naranja
                    : const Color(
                        0xFF333333,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}