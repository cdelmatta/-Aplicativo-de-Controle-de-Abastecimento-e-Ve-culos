import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../services/firestore_service.dart';

class NovoAbastecimentoPage extends StatefulWidget {
  const NovoAbastecimentoPage({super.key});
  @override
  State<NovoAbastecimentoPage> createState() => _NovoAbastecimentoPageState();
}

class _NovoAbastecimentoPageState extends State<NovoAbastecimentoPage> {
  final formKey = GlobalKey<FormState>();
  final litros = TextEditingController();
  final valor = TextEditingController();
  final km = TextEditingController();
  final obs = TextEditingController();

  String tipo = 'Gasolina';
  String? veiculoId;

  @override
  void dispose() {
    litros.dispose();
    valor.dispose();
    km.dispose();
    obs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: const Text('Registrar Abastecimento'),
        leading: Navigator.of(context).canPop()
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              )
            : null,
        actions: [
          IconButton(
            tooltip: 'Cadastrar veículo',
            onPressed: () => Navigator.pushNamed(context, '/veiculos/novo'),
            icon: const Icon(Icons.directions_car),
          ),
        ],
      ),
      body: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
        future: FS.veiculosCol().get(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final veiculos = snap.data!.docs;

          if (veiculos.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Cadastre um veículo primeiro.'),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    icon: const Icon(Icons.add),
                    onPressed: () => Navigator.pushNamed(context, '/veiculos/novo'),
                    label: const Text('Cadastrar veículo'),
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      } else {
                        Navigator.of(context).pushReplacementNamed('/abastecimentos');
                      }
                    },
                    label: const Text('Voltar'),
                  ),
                ],
              ),
            );
          }

          veiculoId ??= veiculos.first.id;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: veiculoId,
                    items: veiculos
                        .map((d) => DropdownMenuItem(
                              value: d.id,
                              child: Text(d.data()['modelo'] ?? d.id),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => veiculoId = v),
                    decoration: const InputDecoration(labelText: 'Veículo'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: litros,
                    decoration: const InputDecoration(labelText: 'Quantidade (L)'),
                    keyboardType: TextInputType.number,
                    validator: (v) =>
                        (v == null || double.tryParse(v) == null) ? 'Valor inválido' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: valor,
                    decoration: const InputDecoration(labelText: 'Valor pago (R\$)'),
                    keyboardType: TextInputType.number,
                    validator: (v) =>
                        (v == null || double.tryParse(v) == null) ? 'Valor inválido' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: km,
                    decoration: const InputDecoration(labelText: 'Quilometragem'),
                    keyboardType: TextInputType.number,
                    validator: (v) =>
                        (v == null || int.tryParse(v) == null) ? 'Valor inválido' : null,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: tipo,
                    items: const [
                      DropdownMenuItem(value: 'Gasolina', child: Text('Gasolina')),
                      DropdownMenuItem(value: 'Etanol', child: Text('Etanol')),
                      DropdownMenuItem(value: 'Diesel', child: Text('Diesel')),
                      DropdownMenuItem(value: 'GNV', child: Text('GNV')),
                    ],
                    onChanged: (v) => setState(() => tipo = v ?? 'Gasolina'),
                    decoration: const InputDecoration(labelText: 'Tipo de Combustível'),
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: obs,
                    decoration: const InputDecoration(labelText: 'Observação (opcional)'),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () async {
                        if (!formKey.currentState!.validate() || veiculoId == null) return;

                        try {
                          final qnt = double.parse(litros.text);
                          final val = double.parse(valor.text);
                          final quil = int.parse(km.text);
                          final consumo = qnt > 0 ? quil / qnt : null;

                          await FS.abastecimentosCol().add({
                            'data': DateTime.now(),
                            'quantidadeLitros': qnt,
                            'valorPago': val,
                            'quilometragem': quil,
                            'tipoCombustivel': tipo,
                            'veiculoId': veiculoId,
                            'observacao':
                                obs.text.trim().isEmpty ? null : obs.text.trim(),
                            'consumo': consumo,
                          });

                          if (!mounted) return;
                          // No Web pode não haver histórico de navegação
                          Navigator.pushReplacementNamed(
                              context, '/abastecimentos');
                        } catch (e) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Erro ao salvar: $e')),
                          );
                        }
                      },
                      child: const Text('Salvar'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
