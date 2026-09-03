import 'package:flutter/material.dart';

import 'locales_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final usuarioController = TextEditingController();
  final claveController = TextEditingController();

  @override
  void dispose() {
    usuarioController.dispose();
    claveController.dispose();
    super.dispose();
  }

  void ingresar() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LocalesScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const naranja = Color(0xFFFF8A16);
    const verde = Color(0xFF31A636);
    const crema = Color(0xFFFFFBF3);
    const beigeCampo = Color(0xFFF4F1E7);

    return Scaffold(
      backgroundColor: crema,
      body: Stack(
        children: [
          // Decoración superior izquierda
          Positioned(
            top: -90,
            left: -110,
            child: Container(
              width: 260,
              height: 300,
              decoration: const BoxDecoration(
                color: Color(0xFFE9EBD9),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Decoración superior derecha
          Positioned(
            top: 40,
            right: -120,
            child: Container(
              width: 250,
              height: 280,
              decoration: const BoxDecoration(
                color: Color(0xFFFFF0E2),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Decoración inferior izquierda
          Positioned(
            bottom: -120,
            left: -120,
            child: Container(
              width: 300,
              height: 300,
              decoration: const BoxDecoration(
                color: Color(0xFFFFF0E2),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Decoración inferior derecha
          Positioned(
            bottom: -100,
            right: -130,
            child: Container(
              width: 310,
              height: 310,
              decoration: const BoxDecoration(
                color: Color(0xFFE9EBD9),
                shape: BoxShape.circle,
              ),
            ),
          ),

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 38,
                        vertical: 20,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 12),

                          // LOGO REAL
                          Image.asset(
                            'assets/images/logo_foodplease.png',
                            width: 190,
                            height: 115,
                            fit: BoxFit.contain,
                          ),

                          const SizedBox(height: 12),

                          const Text(
                            '¡Bienvenido!',
                            style: TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.bold,
                              color: verde,
                            ),
                          ),

                          const SizedBox(height: 5),

                          const Text(
                            'Inicia sesión para continuar',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF383838),
                            ),
                          ),

                          const SizedBox(height: 33),

                          // USUARIO
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'USUARIO',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                                color: Color(0xFF555555),
                              ),
                            ),
                          ),

                          const SizedBox(height: 7),

                          TextField(
                            controller: usuarioController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: 'usuario@correo.com',
                              hintStyle: const TextStyle(
                                color: Color(0xFF777777),
                              ),
                              prefixIcon: const Icon(
                                Icons.person_outline,
                                color: Color(0xFF8ED9A2),
                              ),
                              filled: true,
                              fillColor: beigeCampo,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(17),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(17),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(17),
                                borderSide: const BorderSide(
                                  color: verde,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 14),

                          // CONTRASEÑA
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'CONTRASEÑA',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                                color: Color(0xFF555555),
                              ),
                            ),
                          ),

                          const SizedBox(height: 7),

                          TextField(
                            controller: claveController,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: '******',
                              hintStyle: const TextStyle(
                                color: Color(0xFF777777),
                              ),
                              prefixIcon: const Icon(
                                Icons.visibility_outlined,
                                color: Color(0xFF8ED9A2),
                              ),
                              filled: true,
                              fillColor: beigeCampo,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(17),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(17),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(17),
                                borderSide: const BorderSide(
                                  color: verde,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          TextButton(
                            onPressed: () {},
                            child: const Text(
                              '¿Olvidaste tu contraseña?',
                              style: TextStyle(
                                color: verde,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: FilledButton(
                              onPressed: ingresar,
                              style: FilledButton.styleFrom(
                                backgroundColor: naranja,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Iniciar sesión',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 19),

                          const Text(
                            '¿No tienes cuenta?',
                            style: TextStyle(
                              fontSize: 14,
                              color: verde,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 2),

                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: const Size(0, 25),
                            ),
                            child: const Text(
                              'Crear cuenta',
                              style: TextStyle(
                                color: Color(0xFFFF5D42),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          // MOTO REAL
                          Image.asset(
                            'assets/images/moto_delivery.png',
                            width: 145,
                            height: 120,
                            fit: BoxFit.contain,
                          ),

                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}