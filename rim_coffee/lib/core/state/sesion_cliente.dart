import 'carrito_controller.dart';

/// Sesión temporal del cliente: solo recuerda la mesa y su pedido actual.
/// No hay cuenta ni login (decisión de diseño del proyecto).
class SesionCliente {
  SesionCliente._();

  static final SesionCliente instance = SesionCliente._();

  int mesa = 4;
  String? pedidoActualId;

  /// Se llama al escanear el QR: empieza una sesión limpia para esa mesa.
  void iniciar(int numeroMesa) {
    mesa = numeroMesa;
    pedidoActualId = null;
    CarritoController.instance.vaciar();
  }
}
