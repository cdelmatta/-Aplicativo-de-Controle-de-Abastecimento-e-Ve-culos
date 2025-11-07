import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class NovoVeiculoPage extends StatefulWidget {
  const NovoVeiculoPage({super.key});
  @override
  State<NovoVeiculoPage> createState() => _NovoVeiculoPageState();
}

class _NovoVeiculoPageState extends State<NovoVeiculoPage> {
  final formKey = GlobalKey<FormState>();
  final modelo = TextEditingController();
  final marca = TextEditingController();
  final placa = TextEditingController();
  final ano = TextEditingController();
  String tipo = 'Gasolina';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Novo Veículo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(children: [
            TextFormField(controller: modelo, decoration: const InputDecoration(labelText: 'Modelo'), validator: (v)=>v==null||v.isEmpty?'Obrigatório':null),
            const SizedBox(height: 12),
            TextFormField(controller: marca, decoration: const InputDecoration(labelText: 'Marca'), validator: (v)=>v==null||v.isEmpty?'Obrigatório':null),
            const SizedBox(height: 12),
            TextFormField(controller: placa, decoration: const InputDecoration(labelText: 'Placa'), validator: (v)=>v==null||v.isEmpty?'Obrigatório':null),
            const SizedBox(height: 12),
            TextFormField(controller: ano, decoration: const InputDecoration(labelText: 'Ano'), keyboardType: TextInputType.number, validator: (v)=>v==null||int.tryParse(v)==null?'Ano inválido':null),
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
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () async {
                  if(!formKey.currentState!.validate()) return;
                  await FS.veiculosCol().add({
                    'modelo': modelo.text.trim(),
                    'marca': marca.text.trim(),
                    'placa': placa.text.trim(),
                    'ano': int.parse(ano.text),
                    'tipoCombustivel': tipo,
                  });
                  if (mounted) Navigator.pop(context);
                },
                child: const Text('Salvar'),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
