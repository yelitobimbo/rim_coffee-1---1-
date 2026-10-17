import 'package:flutter/material.dart';
import 'package:rim_coffee/app/theme.dart';
import 'package:rim_coffee/core/widgets/widgets.dart';

/// 16 · Olvidé mi contraseña (beneficiario). Dos estados: formulario y
/// confirmación de envío del enlace.
class RecuperarContrasenaScreen extends StatefulWidget {
  const RecuperarContrasenaScreen({super.key});

  @override
  State<RecuperarContrasenaScreen> createState() =>
      _RecuperarContrasenaScreenState();
}

class _RecuperarContrasenaScreenState extends State<RecuperarContrasenaScreen> {
  final TextEditingController _correo =
      TextEditingController(text: 'admin@rimcoffee.mx');
  bool _enviado = false;
  String? _error;

  @override
  void dispose() {
    _correo.dispose();
    super.dispose();
  }

  void _enviar() {
    final correo = _correo.text.trim();
    if (!correo.contains('@') || !correo.contains('.')) {
      setState(() => _error = 'Escribe un correo válido');
      return;
    }
    setState(() {
      _error = null;
      _enviado = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: rcAppBar(title: 'Recuperar contraseña', showBack: true),
      body: _enviado ? _buildConfirmacion(context) : _buildFormulario(),
    );
  }

  Widget _buildFormulario() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 8),
        Center(
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.ink, width: 1.8),
            ),
            child: const Icon(Icons.lock_reset, size: 34),
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          '¿Olvidaste tu contraseña?',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        const Text(
          'Ingresa el correo de tu cuenta de beneficiario y te enviaremos un '
          'enlace para crear una nueva contraseña.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 13, color: AppColors.soft),
        ),
        const SizedBox(height: 24),
        RcTextField(
          label: 'Correo',
          controller: _correo,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: const Icon(Icons.mail_outline, color: AppColors.soft),
        ),
        if (_error != null) ...[
          const SizedBox(height: 6),
          Text(
            _error!,
            style: const TextStyle(fontSize: 12, color: AppColors.accent),
          ),
        ],
        const SizedBox(height: 20),
        RcButton(label: 'Enviar enlace', onPressed: _enviar),
      ],
    );
  }

  Widget _buildConfirmacion(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 24),
        Center(
          child: Container(
            width: 76,
            height: 76,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.ink,
            ),
            child: const Icon(
              Icons.mark_email_read_outlined,
              size: 36,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 18),
        const Text(
          'Revisa tu correo',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        Text(
          'Enviamos un enlace a ${_correo.text.trim()}.\n'
          'Si no lo ves, revisa tu carpeta de spam.',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 13, color: AppColors.soft),
        ),
        const SizedBox(height: 28),
        RcButton(
          label: 'Volver al acceso',
          onPressed: () => Navigator.of(context).pop(),
        ),
        const SizedBox(height: 10),
        RcButton(
          label: 'Reenviar enlace',
          filled: false,
          muted: true,
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Enlace reenviado')),
          ),
        ),
      ],
    );
  }
}
