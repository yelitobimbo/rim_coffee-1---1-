import 'package:flutter/material.dart';
import 'package:rim_coffee/app/theme.dart';

class BottomItem {
  const BottomItem(this.label, this.icon);

  final String label;
  final IconData icon;
}

/// Barra inferior con borde superior de 2 px y pestaña activa en gris.
class AppBottomBar extends StatelessWidget {
  const AppBottomBar({
    super.key,
    required this.items,
    required this.index,
    required this.onTap,
  });

  final List<BottomItem> items;
  final int index;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.ink, width: 2)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 58,
          child: Row(
            children: [
              for (var i = 0; i < items.length; i++)
                Expanded(
                  child: InkWell(
                    onTap: () => onTap(i),
                    child: Container(
                      decoration: BoxDecoration(
                        color: i == index ? AppColors.fill : Colors.white,
                        border: i > 0
                            ? const Border(
                                left: BorderSide(color: AppColors.line),
                              )
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            items[i].icon,
                            size: 22,
                            color: i == index ? AppColors.ink : AppColors.soft,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            items[i].label,
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight:
                                  i == index ? FontWeight.w800 : FontWeight.w500,
                              color:
                                  i == index ? AppColors.ink : AppColors.soft,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
