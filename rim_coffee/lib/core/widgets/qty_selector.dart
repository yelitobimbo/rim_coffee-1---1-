import 'package:flutter/material.dart';
import 'package:rim_coffee/app/theme.dart';

/// Selector de cantidad:  [–]  2  [+]
class QtySelector extends StatelessWidget {
  const QtySelector({
    super.key,
    required this.value,
    required this.onAdd,
    required this.onRemove,
  });

  final int value;
  final VoidCallback onAdd;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _QtyButton(icon: Icons.remove, onTap: onRemove),
        SizedBox(
          width: 32,
          child: Center(
            child: Text(
              '$value',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
            ),
          ),
        ),
        _QtyButton(icon: Icons.add, onTap: onAdd),
      ],
    );
  }
}

class _QtyButton extends StatelessWidget {
  const _QtyButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.ink, width: 1.4),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(icon, size: 17),
      ),
    );
  }
}
