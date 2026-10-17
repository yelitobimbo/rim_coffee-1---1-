/// Nombres de ruta de toda la app, en un solo lugar.
class Routes {
  Routes._();

  // Demostración
  static const String launcher = '/';

  // Cliente (menú web por QR)
  static const String bienvenida = '/bienvenida';
  static const String cliente = '/cliente';
  static const String producto = '/cliente/producto';
  static const String estado = '/cliente/estado';

  // Administrador / beneficiario
  static const String acceso = '/admin/acceso';
  static const String recuperar = '/admin/recuperar';
  static const String admin = '/admin';
  static const String pedidoDetalle = '/admin/pedido';
  static const String pedidoEstado = '/admin/pedido/estado';
  static const String codigosQr = '/admin/codigos-qr';
}
