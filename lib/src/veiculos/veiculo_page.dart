import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import 'veiculo_model.dart';
import '../widgets/app_drawer.dart';

class VeiculoPage extends StatelessWidget {
  const VeiculoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meus Veículos')),
      drawer: const AppDrawer(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/veiculos/novo'),
        label: const Text('Novo veículo'),
        icon: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FS.veiculosCol().orderBy('modelo').snapshots(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snap.data?.docs ?? [];
          if (docs.isEmpty) return const Center(child: Text('Nenhum veículo'));
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (ctx, i) {
              final v = Veiculo.fromMap(docs[i].id, docs[i].data());
              return Card(
                child: ListTile(
                  title: Text('${v.modelo} • ${v.marca}'),
                  subtitle: Text('${v.placa}  |  ${v.ano}  |  ${v.tipoCombustivel}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => FS.veiculosCol().doc(v.id).delete(),
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
