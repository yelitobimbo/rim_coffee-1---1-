import 'package:flutter/foundation.dart';
import 'package:rim_coffee/core/models/producto.dart';

/// Catálogo de productos compartido: lo edita el beneficiario y lo ve el cliente.
class ProductosController extends ChangeNotifier {
  ProductosController._();

  static final ProductosController instance = ProductosController._();

  int _contador = 100;

  final List<Producto> _items = [
    Producto(
      id: 'f1',
      nombre: 'Frappé de chocolate',
      descripcion: 'Café helado, chocolate artesanal y crema batida.',
      precio: 65,
      categoria: Categoria.frias,
    ),
    Producto(
      id: 'f2',
      nombre: 'Latte frío de vainilla',
      descripcion: 'Espresso, leche fría y jarabe de vainilla.',
      precio: 58,
      categoria: Categoria.frias,
    ),
    Producto(
      id: 'f3',
      nombre: 'Cold brew',
      descripcion: 'Café de extracción en frío, 12 horas de reposo.',
      precio: 52,
      categoria: Categoria.frias,
    ),
    Producto(
      id: 'f4',
      nombre: 'Té helado de limón',
      descripcion: 'Té negro, limón fresco y un toque de miel.',
      precio: 38,
      categoria: Categoria.frias,
    ),
    Producto(
      id: 'c1',
      nombre: 'Americano 12 oz',
      descripcion: 'Espresso con agua caliente.',
      precio: 45,
      categoria: Categoria.calientes,
    ),
    Producto(
      id: 'c2',
      nombre: 'Latte de vainilla',
      descripcion: 'Espresso, leche vaporizada y vainilla.',
      precio: 58,
      categoria: Categoria.calientes,
    ),
    Producto(
      id: 'c3',
      nombre: 'Capuchino',
      descripcion: 'Espresso doble con espuma de leche.',
      precio: 55,
      categoria: Categoria.calientes,
    ),
    Producto(
      id: 'c4',
      nombre: 'Chocolate caliente',
      descripcion: 'Chocolate de metate con leche entera.',
      precio: 50,
      categoria: Categoria.calientes,
    ),
    Producto(
      id: 'p1',
      nombre: 'Pay de queso',
      descripcion: 'Rebanada de pay de queso con zarzamora.',
      precio: 65,
      categoria: Categoria.postres,
    ),
    Producto(
      id: 'p2',
      nombre: 'Brownie',
      descripcion: 'Brownie tibio con nuez.',
      precio: 48,
      categoria: Categoria.postres,
    ),
    Producto(
      id: 'p3',
      nombre: 'Galleta de avena',
      descripcion: 'Galleta artesanal de avena y pasas.',
      precio: 28,
      categoria: Categoria.postres,
    ),
  ];

  List<Producto> get todos => List.unmodifiable(_items);

  List<Producto> porCategoria(Categoria categoria) {
    return _items.where((p) => p.categoria == categoria).toList();
  }

  List<Producto> buscar(String texto) {
    final t = texto.trim().toLowerCase();
    return _items.where((p) => p.nombre.toLowerCase().contains(t)).toList();
  }

  void agregar({
    required String nombre,
    required String descripcion,
    required double precio,
    required Categoria categoria,
  }) {
    _contador++;
    _items.add(
      Producto(
        id: 'n$_contador',
        nombre: nombre,
        descripcion: descripcion,
        precio: precio,
        categoria: categoria,
      ),
    );
    notifyListeners();
  }

  void actualizar(
    Producto producto, {
    required String nombre,
    required String descripcion,
    required double precio,
    required Categoria categoria,
  }) {
    producto
      ..nombre = nombre
      ..descripcion = descripcion
      ..precio = precio
      ..categoria = categoria;
    notifyListeners();
  }

  void eliminar(Producto producto) {
    _items.remove(producto);
    notifyListeners();
  }
}
