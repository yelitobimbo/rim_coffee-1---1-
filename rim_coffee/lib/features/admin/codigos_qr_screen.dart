import 'package:flutter/material.dart';
import 'package:rim_coffee/app/route_names.dart';
import 'package:rim_coffee/app/theme.dart';
import 'package:rim_coffee/core/widgets/widgets.dart';
import 'package:rim_coffee/features/admin/widgets/admin_bottom_bar.dart';

/// 15 · Códigos QR por mesa (administrador): de aquí salen los QR que el
/// cliente escanea. "Simular escaneo" abre la bienvenida del cliente (14).
class CodigosQrScreen extends StatefulWidget {
  const CodigosQrScreen({super.key});

  @override
  State<CodigosQrScreen> createState() => _CodigosQrScreenState();
}

class _CodigosQrScreenState extends State<CodigosQrScreen> {
  final List<int> _mesas = [1, 2, 3, 4, 5];

  void _verQr(int mesa) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: Text('QR · Mesa $mesa'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FakeQr(seed: mesa, size: 200),
            const SizedBox(height: 12),
            const Text(
              'Al escanearlo, el cliente entra directo al menú de esta mesa.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.5, color: AppColors.soft),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cerrar'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pushNamed(Routes.bienvenida, arguments: mesa);
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.ink),
            child: const Text('Simular escaneo'),
          ),
        ],
      ),
    );
  }

  void _descargar(int mesa) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('QR de la mesa $mesa guardado (simulado)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: rcAppBar(title: 'Códigos QR', showBack: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Descarga o imprime el QR de cada mesa',
            style: TextStyle(fontSize: 12.5, color: AppColors.soft),
          ),
          const SizedBox(height: 12),
          for (final mesa in _mesas)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.ink, width: 1.4),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => _verQr(mesa),
                      child: FakeQr(seed: mesa, size: 52),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        'Mesa $mesa',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => _descargar(mesa),
                      icon: const Icon(Icons.download_outlined, size: 16),
                      label: const Text('Descargar'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.ink,
                        side: const BorderSide(color: AppColors.ink, width: 1.3),
                        textStyle: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 4),
          RcButton(
            label: '+ Agregar mesa',
            filled: false,
            muted: true,
            onPressed: () => setState(() => _mesas.add(_mesas.length + 1)),
          ),
        ],
      ),
      bottomNavigationBar: const AdminBottomBar(index: 3),
    );
  }
}
