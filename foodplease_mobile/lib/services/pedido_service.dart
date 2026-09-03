class PedidoService {
  static int? _pedidoId;
  static String? _numeroPedido;
  static String? _direccion;
  static String? _metodoPago;
  static int _descuento = 0;

  static int? get pedidoId => _pedidoId;

  static String? get numeroPedido => _numeroPedido;

  static String? get direccion => _direccion;

  static String? get metodoPago => _metodoPago;

  static int get descuento => _descuento;

  static bool get tienePedidoActual {
    return _pedidoId != null &&
        _numeroPedido != null &&
        _direccion != null &&
        _metodoPago != null;
  }

  static void guardarPedido({
    required int pedidoId,
    required String numeroPedido,
    required String direccion,
    required String metodoPago,
    required int descuento,
  }) {
    _pedidoId = pedidoId;
    _numeroPedido = numeroPedido;
    _direccion = direccion;
    _metodoPago = metodoPago;
    _descuento = descuento;
  }

  static void limpiarPedido() {
    _pedidoId = null;
    _numeroPedido = null;
    _direccion = null;
    _metodoPago = null;
    _descuento = 0;
  }
}