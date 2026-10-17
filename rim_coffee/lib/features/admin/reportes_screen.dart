import 'package:flutter/material.dart';
import 'package:rim_coffee/app/theme.dart';
import 'package:rim_coffee/core/utils/formato.dart';
import 'package:rim_coffee/core/widgets/widgets.dart';

class _Reporte {
  const _Reporte({
    required this.titulo,
    required this.total,
    required this.etiquetas,
    required this.valores,
    required this.masVendido,
    required this.unidades,
    required this.periodo,
  });

  final String titulo;
  final double total;
  final List<String> etiquetas;
  final List<double> valores;
  final String masVendido;
  final int unidades;
  final String periodo;
}

const List<_Reporte> _reportes = [
  _Reporte(
    titulo: 'Ventas de hoy',
    total: 1240,
    etiquetas: ['9h', '11h', '13h', '15h', '17h', '19h', '21h'],
    valores: [8, 15, 22, 30, 18, 12, 6],
    masVendido: 'Frappé de chocolate',
    unidades: 9,
    periodo: 'hoy',
  ),
  _Reporte(
    titulo: 'Ventas de la semana',
    total: 4180,
    etiquetas: ['L', 'M', 'M', 'J', 'V', 'S', 'D'],
    valores: [40, 70, 55, 90, 60, 100, 45],
    masVendido: 'Frappé de chocolate',
    unidades: 38,
    periodo: 'esta semana',
  ),
  _Reporte(
    titulo: 'Ventas del mes',
    total: 17650,
    etiquetas: ['S1', 'S2', 'S3', 'S4'],
    valores: [3900, 4300, 4600, 4850],
    masVendido: 'Frappé de chocolate',
    unidades: 152,
    periodo: 'este mes',
  ),
];

/// 9 · Reportes de ventas (beneficiario): por día, semana o mes,
/// con el producto más vendido.
class ReportesScreen extends StatefulWidget {
  const ReportesScreen({super.key});

  @override
  State<ReportesScreen> createState() => _ReportesScreenState();
}

class _ReportesScreenState extends State<ReportesScreen> {
  int _rango = 1;

  @override
  Widget build(BuildContext context) {
    final reporte = _reportes[_rango];
    final maximo = reporte.valores.reduce((a, b) => a > b ? a : b);

    return Scaffold(
      appBar: rcAppBar(title: 'Reportes'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SegmentedTabs(
            labels: const ['Día', 'Semana', 'Mes'],
            selected: _rango,
            onChanged: (i) => setState(() => _rango = i),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.ink, width: 1.5),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reporte.titulo,
                  style: const TextStyle(fontSize: 12.5, color: AppColors.soft),
                ),
                const SizedBox(height: 4),
                Text(
                  money(reporte.total),
                  style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Container(
            height: 176,
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.ink, width: 1.4),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var i = 0; i < reporte.valores.length; i++)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 24,
                        height: 120 * (reporte.valores[i] / maximo),
                        decoration: BoxDecoration(
                          color: AppColors.ink,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        reporte.etiquetas[i],
                        style: const TextStyle(fontSize: 10.5, color: AppColors.soft),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          DashedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Producto más vendido',
                  style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    const ImagePlaceholder(width: 52, height: 52),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            reporte.masVendido,
                            style: const TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${reporte.unidades} vendidos ${reporte.periodo}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.soft,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
