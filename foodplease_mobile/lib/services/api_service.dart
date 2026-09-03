import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/producto.dart';

class ApiService {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8000',
  );

  // OBTENER PRODUCTOS
  static Future<List<Producto>> obtenerProductos() async {
    final url = Uri.parse(
      '$baseUrl/api/productos/',
    );

    final respuesta = await http.get(url);

    if (respuesta.statusCode == 200) {
      final List<dynamic> datos = jsonDecode(
        utf8.decode(respuesta.bodyBytes),
      );

      return datos
          .map(
            (producto) => Producto.fromJson(producto),
          )
          .toList();
    }

    throw Exception(
      'Error al obtener productos: ${respuesta.statusCode}',
    );
  }

  // CREAR PEDIDO
  static Future<Map<String, dynamic>> crearPedido({
    required String direccion,
    required String metodoPago,
    required String codigoCupon,
    required List<Map<String, dynamic>> items,
  }) async {
    final url = Uri.parse(
      '$baseUrl/api/pedidos/',
    );

    final cuerpo = {
      'direccion': direccion,
      'metodo_pago': metodoPago,
      'codigo_cupon': codigoCupon,
      'items': items,
    };

    final respuesta = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(cuerpo),
    );

    final Map<String, dynamic> datos = jsonDecode(
      utf8.decode(respuesta.bodyBytes),
    );

    if (respuesta.statusCode == 201) {
      return datos;
    }

    throw Exception(
      datos['error'] ?? 'No se pudo crear el pedido.',
    );
  }

  // OBTENER UN PEDIDO Y SU ESTADO REAL
  static Future<Map<String, dynamic>> obtenerPedido(
    int pedidoId,
  ) async {
    final url = Uri.parse(
      '$baseUrl/api/pedidos/$pedidoId/',
    );

    final respuesta = await http.get(url);

    final Map<String, dynamic> datos = jsonDecode(
      utf8.decode(respuesta.bodyBytes),
    );

    if (respuesta.statusCode == 200) {
      return datos;
    }

    throw Exception(
      datos['error'] ?? 'No se pudo obtener el pedido.',
    );
  }
}