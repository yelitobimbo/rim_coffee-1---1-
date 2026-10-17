enum EstadoPedido { pendiente, enPreparacion, listo, entregado }

extension EstadoPedidoX on EstadoPedido {
  String get etiqueta {
    switch (this) {
      case EstadoPedido.pendiente:
        return 'Pendiente';
      case EstadoPedido.enPreparacion:
        return 'En preparación';
      case EstadoPedido.listo:
        return 'Listo';
      case EstadoPedido.entregado:
        return 'Entregado';
    }
  }

  /// Siguiente estado del flujo, o null si ya es el último.
  EstadoPedido? get siguiente {
    final i = EstadoPedido.values.indexOf(this);
    if (i + 1 < EstadoPedido.values.length) {
      return EstadoPedido.values[i + 1];
    }
    return null;
  }

  /// Texto del botón que lleva al siguiente estado.
  String get accionSiguiente {
    switch (this) {
      case EstadoPedido.pendiente:
        return 'Iniciar preparación';
      case EstadoPedido.enPreparacion:
        return 'Marcar como listo';
      case EstadoPedido.listo:
        return 'Marcar como entregado';
      case EstadoPedido.entregado:
        return 'Pedido entregado';
    }
  }
}

/// Línea de un pedido ya enviado (tabla `detalle_pedido`).
class PedidoItem {
  const PedidoItem(this.nombre, this.cantidad, this.subtotal);

  final String nombre;
  final int cantidad;
  final double subtotal;
}

/// Pedido recibido por el beneficiario (tabla `pedido`).
class Pedido {
  Pedido({
    required this.id,
    required this.numero,
    required this.mesa,
    required this.cliente,
    required this.hora,
    required this.items,
    this.notas = '',
    this.estado = EstadoPedido.pendiente,
    this.nuevo = true,
  });

  final String id;
  final int numero;
  final int mesa;
  final String cliente;
  final String hora;
  final List<PedidoItem> items;
  final String notas;
  EstadoPedido estado;

  /// Verdadero hasta que el beneficiario abre el pedido por primera vez.
  bool nuevo;

  double get total {
    var suma = 0.0;
    for (final item in items) {
      suma += item.subtotal;
    }
    return suma;
  }
}
