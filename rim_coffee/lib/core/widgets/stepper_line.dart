import 'package:flutter/material.dart';
import 'package:rim_coffee/app/theme.dart';

class StepData {
  const StepData({
    required this.label,
    this.trailing,
    this.done = false,
    this.current = false,
  });

  final String label;
  final String? trailing;
  final bool done;
  final bool current;
}

/// Línea de tiempo vertical con círculos numerados.
/// [boxed] dibuja cada paso dentro de una caja (pantalla "Avanzar estado").
class VerticalStepper extends StatelessWidget {
  const VerticalStepper({super.key, required this.steps, this.boxed = false});

  final List<StepData> steps;
  final bool boxed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < steps.length; i++) _fila(i),
      ],
    );
  }

  Widget _fila(int i) {
    final paso = steps[i];
    final ultimo = i == steps.length - 1;
    final activo = paso.done || paso.current;
    final siguienteActivo =
        !ultimo && (steps[i + 1].done || steps[i + 1].current);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 38,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: boxed ? 5 : 0),
                  child: _Dot(numero: i + 1, lleno: activo),
                ),
                if (!ultimo)
                  Expanded(
                    child: Center(
                      child: Container(
                        width: 1.8,
                        color: siguienteActivo ? AppColors.ink : AppColors.line,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: ultimo ? 0 : 18),
              child: boxed ? _caja(paso, activo) : _simple(paso, activo),
            ),
          ),
        ],
      ),
    );
  }

  Widget _simple(StepData paso, bool activo) {
    return SizedBox(
      height: 24,
      child: Row(
        children: [
          Expanded(
            child: Text(
              paso.label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: paso.current ? FontWeight.w800 : FontWeight.w500,
                color: activo ? AppColors.ink : AppColors.soft,
              ),
            ),
          ),
          if (paso.trailing != null)
            Text(
              paso.trailing!,
              style: const TextStyle(fontSize: 11.5, color: AppColors.soft),
            ),
        ],
      ),
    );
  }

  Widget _caja(StepData paso, bool activo) {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        border: Border.all(
          color: activo ? AppColors.ink : AppColors.soft,
          width: activo ? 1.5 : 1.2,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        paso.label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: paso.current ? FontWeight.w800 : FontWeight.w500,
          color: activo ? AppColors.ink : AppColors.soft,
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.numero, required this.lleno});

  final int numero;
  final bool lleno;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: lleno ? AppColors.ink : Colors.white,
        border: Border.all(
          color: lleno ? AppColors.ink : AppColors.soft,
          width: 1.6,
        ),
      ),
      child: Text(
        '$numero',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: lleno ? Colors.white : AppColors.soft,
        ),
      ),
    );
  }
}
