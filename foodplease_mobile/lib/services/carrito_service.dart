import '../models/item_carrito.dart';
import '../models/producto.dart';

class CarritoService {
  static final List<ItemCarrito> _items = [];

  static List<ItemCarrito> get items => _items;

  static void agregarProducto(Producto producto) {
    final index = _items.indexWhere(
      (item) => item.producto.id == producto.id,
    );

    if (index >= 0) {
      _items[index].cantidad++;
    } else {
      _items.add(
        ItemCarrito(producto: producto),
      );
    }
  }

  static void aumentarCantidad(ItemCarrito item) {
    if (item.cantidad < item.producto.stock) {
      item.cantidad++;
    }
  }

  static void disminuirCantidad(ItemCarrito item) {
    if (item.cantidad > 1) {
      item.cantidad--;
    } else {
      _items.remove(item);
    }
  }

  static void eliminarProducto(ItemCarrito item) {
    _items.remove(item);
  }

  static int get total {
    return _items.fold(
      0,
      (suma, item) => suma + item.subtotal,
    );
  }
}