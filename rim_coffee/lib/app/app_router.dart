import 'package:flutter/material.dart';
import 'package:rim_coffee/app/route_args.dart';
import 'package:rim_coffee/app/route_names.dart';
import 'package:rim_coffee/features/admin/acceso_screen.dart';
import 'package:rim_coffee/features/admin/admin_shell.dart';
import 'package:rim_coffee/features/admin/avanzar_estado_screen.dart';
import 'package:rim_coffee/features/admin/codigos_qr_screen.dart';
import 'package:rim_coffee/features/admin/detalle_cobro_screen.dart';
import 'package:rim_coffee/features/admin/recuperar_contrasena_screen.dart';
import 'package:rim_coffee/features/cliente/bienvenida_qr_screen.dart';
import 'package:rim_coffee/features/cliente/cliente_shell.dart';
import 'package:rim_coffee/features/cliente/detalle_producto_screen.dart';
import 'package:rim_coffee/features/cliente/estado_pedido_screen.dart';
import 'package:rim_coffee/features/launcher/launcher_screen.dart';

/// Router central: traduce el nombre de ruta a la pantalla correspondiente.
class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final Widget page;

    switch (settings.name) {
      case Routes.bienvenida:
        page = BienvenidaQrScreen(mesa: (settings.arguments as int?) ?? 4);
        break;
      case Routes.cliente:
        page = ClienteShell(initialIndex: (settings.arguments as int?) ?? 0);
        break;
      case Routes.producto:
        page = DetalleProductoScreen(
          args: settings.arguments as DetalleProductoArgs,
        );
        break;
      case Routes.estado:
        page = const EstadoPedidoScreen();
        break;
      case Routes.acceso:
        page = const AccesoScreen();
        break;
      case Routes.recuperar:
        page = const RecuperarContrasenaScreen();
        break;
      case Routes.admin:
        page = AdminShell(initialIndex: (settings.arguments as int?) ?? 0);
        break;
      case Routes.pedidoDetalle:
        page = DetalleCobroScreen(pedidoId: settings.arguments as String);
        break;
      case Routes.pedidoEstado:
        page = AvanzarEstadoScreen(pedidoId: settings.arguments as String);
        break;
      case Routes.codigosQr:
        page = const CodigosQrScreen();
        break;
      case Routes.launcher:
      default:
        page = const LauncherScreen();
    }

    return MaterialPageRoute<void>(settings: settings, builder: (_) => page);
  }
}
