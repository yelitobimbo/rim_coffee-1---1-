import 'package:flutter/foundation.dart';
import 'package:rim_coffee/core/models/linea_carrito.dart';
import 'package:rim_coffee/core/models/pedido.dart';
import 'package:rim_coffee/core/utils/formato.dart';

/// Pedidos recibidos. Es el "observable" del patrón Observer del documento:
/// cuando el estado cambia, las pantallas del cliente y del beneficiario
/// se actualizan solas.
class PedidosController extends ChangeNotifier {
  PedidosController._() {
    _pedidos.addAll([
      Pedido(
        id: 'p128',
        numero: 128,
        mesa: 4,
        cliente: 'Alexandra Camacho',
        hora: '10:15',
        notas: 'Sin azúcar en el americano',
        items: const [
          PedidoItem('Frappé de chocolate', 2, 130),
          PedidoItem('Americano 12 oz', 1, 45),
          PedidoItem('Pay de queso', 1, 65),
        ],
      ),
      Pedido(
        id: 'p129',
        numero: 129,
        mesa: 7,
        cliente: 'Juan Pérez',
        hora: '10:12',
        nuevo: false,
        items: const [PedidoItem('Capuchino', 2, 110)],
      ),
      Pedido(
        id: 'p127',
        numero: 127,
        mesa: 2,
        cliente: '—',
        hora: '10:05',
        nuevo: false,
        estado: EstadoPedido.enPreparacion,
        items: const [PedidoItem('Pay de queso', 1, 65)],
      ),
    ]);
  }

  static final PedidosController instance = PedidosController._();

  final List<Pedido> _pedidos = [];
  int _siguienteNumero = 130;

  /// Evita repetir la notificación simulada de "pedido nuevo".
  bool yaSimulo = false;

  List<Pedido> get todos => List.unmodifiable(_pedidos);

  int get totalPendientes =>
      _pedidos.where((p) => p.estado == EstadoPedido.pendiente).length;

  Pedido? porId(String? id) {
    if (id == null) {
      return null;
    }
    for (final p in _pedidos) {
      if (p.id == id) {
        return p;
      }
    }
    return null;
  }

  /// Convierte el carrito del cliente en un pedido para el beneficiario.
  Pedido crearDesdeCarrito({
    required int mesa,
    required String cliente,
    required String notas,
    required List<LineaCarrito> lineas,
  }) {
    final numero = _siguienteNumero++;
    final pedido = Pedido(
      id: 'p$numero',
      numero: numero,
      mesa: mesa,
      cliente: cliente,
      hora: horaActual(),
      notas: notas,
      items: lineas
          .map((l) => PedidoItem(l.nombreConDetalle, l.cantidad, l.subtotal))
          .toList(),
    );
    _pedidos.insert(0, pedido);
    notifyListeners();
    return pedido;
  }

  void avanzar(String id) {
    final pedido = porId(id);
    if (pedido == null) {
      return;
    }
    final siguiente = pedido.estado.siguiente;
    if (siguiente != null) {
      pedido.estado = siguiente;
      pedido.nuevo = false;
      notifyListeners();
    }
  }

  void marcarVisto(String id) {
    final pedido = porId(id);
    if (pedido != null && pedido.nuevo) {
      pedido.nuevo = false;
      notifyListeners();
    }
  }

  /// Simula la llegada de un pedido desde otra mesa.
  Pedido simularPedidoEntrante() {
    yaSimulo = true;
    final numero = _siguienteNumero++;
    final pedido = Pedido(
      id: 'p$numero',
      numero: numero,
      mesa: 5,
      cliente: 'Luis Hernández',
      hora: horaActual(),
      items: const [
        PedidoItem('Capuchino', 1, 55),
        PedidoItem('Brownie', 1, 48),
      ],
    );
    _pedidos.insert(0, pedido);
    notifyListeners();
    return pedido;
  }
}
