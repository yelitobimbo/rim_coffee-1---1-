import 'package:flutter/material.dart';
import 'package:rim_coffee/app/route_names.dart';
import 'package:rim_coffee/app/theme.dart';
import 'package:rim_coffee/core/widgets/widgets.dart';

/// 13 · Perfil (administrador): datos del negocio, acceso a los códigos QR
/// y cierre de sesión. Es el único perfil del sistema porque el cliente
/// no tiene cuenta.
class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final TextEditingController _negocio = TextEditingController(text: 'Rim Coffee');
  final TextEditingController _correo =
      TextEditingController(text: 'admin@rimcoffee.mx');
  final TextEditingController _telefono =
      TextEditingController(text: '477 123 4567');
  final TextEditingController _horario =
      TextEditingController(text: 'Lun–Dom · 8:00–21:00');
  bool _editando = false;

  @override
  void dispose() {
    _negocio.dispose();
    _correo.dispose();
    _telefono.dispose();
    _horario.dispose();
    super.dispose();
  }

  void _alternarEdicion() {
    if (_editando) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Información actualizada')),
      );
    }
    setState(() => _editando = !_editando);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: rcAppBar(title: 'Perfil'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 4),
          Center(
            child: Container(
              width: 76,
              height: 76,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.ink, width: 2),
              ),
              child: const Text(
                'RC',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              _negocio.text,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
          ),
          Center(
            child: Text(
              _correo.text,
              style: const TextStyle(fontSize: 12.5, color: AppColors.soft),
            ),
          ),
          const SizedBox(height: 20),
          RcTextField(
            label: 'Nombre del negocio',
            controller: _negocio,
            enabled: _editando,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          RcTextField(
            label: 'Correo de contacto',
            controller: _correo,
            enabled: _editando,
            keyboardType: TextInputType.emailAddress,
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          RcTextField(
            label: 'Teléfono',
            controller: _telefono,
            enabled: _editando,
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 12),
          RcTextField(
            label: 'Horario',
            controller: _horario,
            enabled: _editando,
          ),
          const SizedBox(height: 18),
          RcButton(
            label: _editando ? 'Guardar cambios' : 'Editar información',
            filled: _editando,
            onPressed: _alternarEdicion,
          ),
          const SizedBox(height: 18),
          InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: () => Navigator.of(context).pushNamed(Routes.codigosQr),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.ink, width: 1.4),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Row(
                children: [
                  Icon(Icons.qr_code_2, size: 26),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Códigos QR por mesa',
                      style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800),
                    ),
                  ),
                  Icon(Icons.chevron_right),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          RcButton(
            label: 'Cerrar sesión',
            filled: false,
            muted: true,
            onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
              Routes.acceso,
              ModalRoute.withName(Routes.launcher),
            ),
          ),
        ],
      ),
    );
  }
}
