import 'package:flutter/material.dart';
import 'package:rim_coffee/app/theme.dart';
import 'package:rim_coffee/core/models/pedido.dart';

enum ChipTone { filled, outline, soft, accent }

/// Etiqueta redondeada de estado (Nuevo, Pendiente, En preparación…).
class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.label, this.tone = ChipTone.outline});

  /// Chip correspondiente al estado de un pedido.
  factory StatusChip.deEstado(Pedido pedido) {
    if (pedido.estado == EstadoPedido.pendiente && pedido.nuevo) {
      return const StatusChip(label: 'Nuevo', tone: ChipTone.filled);
    }
    switch (pedido.estado) {
      case EstadoPedido.pendiente:
        return const StatusChip(label: 'Pendiente', tone: ChipTone.outline);
      case EstadoPedido.enPreparacion:
        return const StatusChip(label: 'En preparación', tone: ChipTone.soft);
      case EstadoPedido.listo:
        return const StatusChip(label: 'Listo', tone: ChipTone.accent);
      case EstadoPedido.entregado:
        return const StatusChip(label: 'Entregado', tone: ChipTone.soft);
    }
  }

  final String label;
  final ChipTone tone;

  @override
  Widget build(BuildContext context) {
    Color fondo;
    Color borde;
    Color texto;
    switch (tone) {
      case ChipTone.filled:
        fondo = AppColors.ink;
        borde = AppColors.ink;
        texto = Colors.white;
        break;
      case ChipTone.accent:
        fondo = AppColors.accent;
        borde = AppColors.accent;
        texto = Colors.white;
        break;
      case ChipTone.soft:
        fondo = AppColors.fill;
        borde = AppColors.soft;
        texto = AppColors.ink;
        break;
      case ChipTone.outline:
        fondo = Colors.white;
        borde = AppColors.ink;
        texto = AppColors.ink;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: fondo,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borde, width: 1.3),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: texto),
      ),
    );
  }
}
