import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class NovoAbastecimentoPage extends StatefulWidget {
  const NovoAbastecimentoPage({super.key});
  @override
  State<NovoAbastecimentoPage> createState() => _NovoAbastecimentoPageState();
}

class _NovoAbastecimentoPageState extends State<NovoAbastecimentoPage> {
  final formKey = GlobalKey<FormState>();
  DateTime data = DateTime.now();
  final litros = TextEditingController();
  final valor = TextEditingController();
  final km = TextEditingController();
  String tipo = 'Gasolina';
  String? veiculoId;
  final obs = TextEditingController();

  @override
  void initState() {
    super.initState();
    veiculoId = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Abastecimento')),
      body: FutureBuilder<QuerySnapshot<Map<String,dynamic>>>(
        future: FS.veiculosCol().get(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final veiculos = snap.data!.docs;
          if (veiculos.isEmpty) {
            return const Center(child: Text('Cadastre um veículo primeiro.'));
          }
          veiculoId ??= veiculos.first.id;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: Column(children: [
                DropdownButtonFormField<String>(
                  value: veiculoId,
                  items: veiculos.map((d) =>
                    DropdownMenuItem(value: d.id, child: Text(d.data()['modelo'] ?? d.id))
                  ).toList(),
                  onChanged: (v)=> setState(()=> veiculoId = v),
                  decoration: const InputDecoration(labelText: 'Veículo'),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: litros,
                  decoration: const InputDecoration(labelText: 'Quantidade (L)'),
                  keyboardType: TextInputType.number,
                  validator: (v)=> (v==null || double.tryParse(v)==null)?'Valor inválido':null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: valor,
                  decoration: const InputDecoration(labelText: 'Valor pago (R\$)'),
                  keyboardType: TextInputType.number,
                  validator: (v)=> (v==null || double.tryParse(v)==null)?'Valor inválido':null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: km,
                  decoration: const InputDecoration(labelText: 'Quilometragem'),
                  keyboardType: TextInputType.number,
                  validator: (v)=> (v==null || int.tryParse(v)==null)?'Valor inválido':null,
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
                  onChanged: (v)=> setState(()=> tipo = v ?? 'Gasolina'),
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
                      if(!formKey.currentState!.validate() || veiculoId==null) return;
                      final qnt = double.parse(litros.text);
                      final val = double.parse(valor.text);
                      final quil = int.parse(km.text);
                      // Consumo estimado: (quilometragem / litros). Ajuste se quiser calcular diferença entre abastecimentos.
                      final consumo = qnt > 0 ? quil / qnt : null;

                      await FS.abastecimentosCol().add({
                        'data': DateTime.now().toIso8601String(),
                        'quantidadeLitros': qnt,
                        'valorPago': val,
                        'quilometragem': quil,
                        'tipoCombustivel': tipo,
                        'veiculoId': veiculoId,
                        'observacao': obs.text.trim().isEmpty ? null : obs.text.trim(),
                        'consumo': consumo,
                      });
                      if (mounted) Navigator.pop(context);
                    },
                    child: const Text('Salvar'),
                  ),
                ),
              ]),
            ),
          );
        },
      ),
    );
  }
}
