import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../widgets/app_drawer.dart';
import 'abastecimento_model.dart';

class AbastecimentoPage extends StatelessWidget {
  const AbastecimentoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Histórico de Abastecimentos')),
      drawer: const AppDrawer(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/abastecimentos/novo'),
        label: const Text('Registrar'),
        icon: const Icon(Icons.local_gas_station),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FS.abastecimentosCol().orderBy('data', descending: true).snapshots(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snap.data?.docs ?? [];
          if (docs.isEmpty) return const Center(child: Text('Sem registros'));
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (ctx, i) {
              final a = Abastecimento.fromMap(docs[i].id, docs[i].data());
              return Card(
                child: ListTile(
                  title: Text('${a.tipoCombustivel} • ${a.quantidadeLitros.toStringAsFixed(2)} L'),
                  subtitle: Text(
                    '${a.data.toLocal().toString().substring(0,16)} | Km: ${a.quilometragem} | R\$ ${a.valorPago.toStringAsFixed(2)}'
                    '${a.consumo!=null ? ' | Consumo: ${a.consumo!.toStringAsFixed(2)} km/L' : ''}'
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => FS.abastecimentosCol().doc(a.id).delete(),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
