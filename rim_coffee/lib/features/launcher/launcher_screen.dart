import 'package:flutter/material.dart';
import 'package:rim_coffee/app/route_names.dart';
import 'package:rim_coffee/app/theme.dart';

/// Pantalla SOLO de demostración: permite elegir qué perfil simular.
/// En el producto real son dos aplicaciones separadas (menú web por QR para
/// el cliente y app móvil para el beneficiario), así que no forma parte
/// de las 16 pantallas del anexo.
class LauncherScreen extends StatelessWidget {
  const LauncherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    width: 72,
                    height: 72,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.ink, width: 2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Text(
                      'RC',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Rim Coffee',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Prototipo de interfaz · modo demostración',
                    style: TextStyle(fontSize: 13, color: AppColors.soft),
                  ),
                  const SizedBox(height: 32),
                  _PerfilCard(
                    icono: Icons.qr_code_scanner,
                    titulo: 'Soy cliente',
                    detalle:
                        'Simula escanear el QR de la mesa 4 y pedir desde el menú web.',
                    onTap: () => Navigator.of(context)
                        .pushNamed(Routes.bienvenida, arguments: 4),
                  ),
                  const SizedBox(height: 12),
                  _PerfilCard(
                    icono: Icons.storefront_outlined,
                    titulo: 'Soy el beneficiario',
                    detalle:
                        'Entra a la app de gestión: pedidos, productos, reportes y QR.',
                    onTap: () => Navigator.of(context).pushNamed(Routes.acceso),
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    'Esta pantalla solo existe para la demostración. En el '
                    'sistema real, el cliente entra escaneando el QR de su '
                    'mesa y el beneficiario usa su propia app.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11.5, color: AppColors.soft),
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

class _PerfilCard extends StatelessWidget {
  const _PerfilCard({
    required this.icono,
    required this.titulo,
    required this.detalle,
    required this.onTap,
  });

  final IconData icono;
  final String titulo;
  final String detalle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.ink, width: 1.6),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icono, size: 30),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    detalle,
                    style: const TextStyle(fontSize: 12.5, color: AppColors.soft),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
