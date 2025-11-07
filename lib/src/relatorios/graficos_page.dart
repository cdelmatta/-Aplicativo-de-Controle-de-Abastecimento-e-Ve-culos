import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../widgets/app_drawer.dart';

class GraficosPage extends StatelessWidget {
  const GraficosPage({super.key});

  Future<Map<String, double>> _custoPorVeiculo() async {
    final abs = await FS.abastecimentosCol().get();
    final vei = await FS.veiculosCol().get();
    final nomes = {for (var d in vei.docs) d.id : (d.data()['modelo'] ?? d.id)};
    final mapa = <String,double>{};
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
    return Scaffold(
      appBar: AppBar(title: const Text('Gráfico de Custos')),
      drawer: const AppDrawer(),
      body: FutureBuilder<Map<String,double>>(
        future: _custoPorVeiculo(),
        builder: (context, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final data = snap.data!;
          if (data.isEmpty) return const Center(child: Text('Sem dados para o gráfico.'));
          final entries = data.entries.toList();
          return Padding(
            padding: const EdgeInsets.all(16),
            child: BarChart(
              BarChartData(
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (x, meta) {
                        final i = x.toInt();
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(entries[i].key, style: const TextStyle(fontSize: 10)),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: List.generate(entries.length, (i) {
                  return BarChartGroupData(
                    x: i,
                    barRods: [BarChartRodData(toY: entries[i].value)],
                  );
                }),
              ),
            ),
          );
        },
      ),
    );
  }
}
