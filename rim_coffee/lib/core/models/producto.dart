enum Categoria { frias, calientes, postres }

extension CategoriaX on Categoria {
  String get nombre {
    switch (this) {
      case Categoria.frias:
        return 'Frías';
      case Categoria.calientes:
        return 'Calientes';
      case Categoria.postres:
        return 'Postres';
    }
  }
}

/// Producto del menú (tabla `producto` del modelo entidad-relación).
class Producto {
  Producto({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.categoria,
  });

  final String id;
  String nombre;
  String descripcion;
  double precio;
  Categoria categoria;

  /// Los postres no tienen tamaños.
  bool get tieneTamano => categoria != Categoria.postres;
}
