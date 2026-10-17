import 'package:flutter/material.dart';
import 'package:rim_coffee/app/route_names.dart';
import 'package:rim_coffee/app/theme.dart';
import 'package:rim_coffee/core/widgets/widgets.dart';

/// 4 · Acceso (beneficiario). La cuenta la da el negocio: no hay registro abierto.
class AccesoScreen extends StatefulWidget {
  const AccesoScreen({super.key});

  @override
  State<AccesoScreen> createState() => _AccesoScreenState();
}

class _AccesoScreenState extends State<AccesoScreen> {
  final TextEditingController _usuario =
      TextEditingController(text: 'admin@rimcoffee.mx');
  final TextEditingController _clave = TextEditingController(text: 'demo1234');

  @override
  void dispose() {
    _usuario.dispose();
    _clave.dispose();
    super.dispose();
  }

  void _entrar() {
    if (_usuario.text.trim().isEmpty || _clave.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa usuario y contraseña')),
      );
      return;
    }
    Navigator.of(context).pushNamedAndRemoveUntil(
      Routes.admin,
      ModalRoute.withName(Routes.launcher),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: rcAppBar(title: 'Rim Coffee', showBack: true),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 68,
                    height: 68,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.ink, width: 1.8),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'RC',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Acceso de beneficiario',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 24),
                RcTextField(
                  label: 'Usuario',
                  controller: _usuario,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 14),
                RcTextField(
                  label: 'Contraseña',
                  controller: _clave,
                  obscure: true,
                ),
                const SizedBox(height: 22),
                RcButton(label: 'Iniciar sesión', onPressed: _entrar),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed(Routes.recuperar),
                  style: TextButton.styleFrom(foregroundColor: AppColors.soft),
                  child: const Text(
                    '¿Olvidaste tu contraseña?',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
