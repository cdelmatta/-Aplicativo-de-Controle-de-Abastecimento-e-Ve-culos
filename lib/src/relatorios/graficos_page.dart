import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../widgets/app_drawer.dart';

class GraficosPage extends StatelessWidget {
  const GraficosPage({super.key});

  Future<Map<String, double>> _custoPorVeiculo() async {
    final abs = await FS.abastecimentosCol().get();
    final vei = await FS.veiculosCol().get();
    final nomes = {for (var d in vei.docs) d.id: (d.data()['modelo'] ?? d.id)};

    final mapa = <String, double>{};
    for (final d in abs.docs) {
      final vId = d.data()['veiculoId'] as String? ?? '';
      final nome = nomes[vId] ?? vId;
      final valor = (d.data()['valorPago'] as num?)?.toDouble() ?? 0;
      mapa[nome] = (mapa[nome] ?? 0) + valor;
    }
    return mapa;
  }

  @override
  Widget build(BuildContext context) {
    const darkBlue = Color(0xFF00008B); // azul escuro

    return Scaffold(
      appBar: AppBar(title: const Text('Gráfico de Custos')),
      drawer: const AppDrawer(),
      body: FutureBuilder<Map<String, double>>(
        future: _custoPorVeiculo(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snap.data!;
          if (data.isEmpty) {
            return const Center(child: Text('Sem dados para o gráfico.'));
          }

          final entries = data.entries.toList();

          return Padding(
            padding: const EdgeInsets.all(16),
            child: BarChart(
              BarChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  getDrawingHorizontalLine: (value) =>
                      FlLine(color: Colors.black.withOpacity(.1), strokeWidth: 1),
                  getDrawingVerticalLine: (value) =>
                      FlLine(color: Colors.black.withOpacity(.08), strokeWidth: 1),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.black.withOpacity(.25)),
                ),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (x, meta) {
                        final i = x.toInt();
                        if (i < 0 || i >= entries.length) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(
                            entries[i].key,
                            style: const TextStyle(fontSize: 10),
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: List.generate(entries.length, (i) {
                  return BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: entries[i].value,
                        color: darkBlue,        
                        width: 26,                     
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  );
                }),
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipPadding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 8),
                    tooltipMargin: 8,
                    tooltipRoundedRadius: 8,
                    tooltipBorder: BorderSide(color: Colors.black.withOpacity(.4)),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final nome = entries[group.x.toInt()].key;
                      final valor = rod.toY;
                      return BarTooltipItem(
                        '$nome\nR\$ ${valor.toStringAsFixed(2)}',
                        const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
