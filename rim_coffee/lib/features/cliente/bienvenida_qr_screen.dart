import 'package:flutter/material.dart';
import 'package:rim_coffee/app/route_names.dart';
import 'package:rim_coffee/app/theme.dart';
import 'package:rim_coffee/core/state/sesion_cliente.dart';
import 'package:rim_coffee/core/widgets/widgets.dart';

/// 14 · Bienvenida QR (cliente). Primera pantalla del flujo del cliente:
/// confirma la mesa detectada y aclara que no hace falta cuenta.
class BienvenidaQrScreen extends StatelessWidget {
  const BienvenidaQrScreen({super.key, required this.mesa});

  final int mesa;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: rcAppBar(title: 'Rim Coffee', showBack: false),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.ink, width: 1.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: FakeQr(seed: mesa, size: 120),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    '¡Bienvenido a Rim Coffee!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Detectamos tu mesa automáticamente',
                    style: TextStyle(fontSize: 13.5, color: AppColors.soft),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 160,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.ink, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'MESA $mesa',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'No necesitas crear una cuenta',
                    style: TextStyle(fontSize: 12.5, color: AppColors.soft),
                  ),
                  const SizedBox(height: 28),
                  RcButton(
                    label: 'Ver el menú',
                    onPressed: () {
                      SesionCliente.instance.iniciar(mesa);
                      Navigator.of(context).pushReplacementNamed(
                        Routes.cliente,
                        arguments: 0,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
