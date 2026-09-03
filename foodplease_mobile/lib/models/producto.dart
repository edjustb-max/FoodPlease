class Producto {
  final int id;
  final String codigo;
  final String nombre;
  final String descripcion;
  final String categoria;
  final int precio;
  final int stock;
  final bool disponible;

  Producto({
    required this.id,
    required this.codigo,
    required this.nombre,
    required this.descripcion,
    required this.categoria,
    required this.precio,
    required this.stock,
    required this.disponible,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      id: json['id'],
      codigo: json['codigo'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      categoria: json['categoria'],
      precio: json['precio'],
      stock: json['stock'],
      disponible: json['disponible'],
    );
  }
}