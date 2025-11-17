import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const String imgPath = 'assets/images/sobre_foto.jpg';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sobre o aplicativo')),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Título pedido
            Text(
              'Leia abaixo para as informações do aplicativo',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),

            // Foto
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: 4 / 3,
                child: Image.asset(
                  imgPath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: Colors.black12,
                    alignment: Alignment.center,
                    child: const Text('Imagem não encontrada em assets/images/sobre_foto.jpg'),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Descrição geral
            Text(
              'O Controle de Abastecimento e Veículos foi desenvolvido para registrar e analisar os custos de abastecimentos, '
              'facilitando o controle financeiro e o acompanhamento de consumo por veículo.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),

            // Seções explicativas
            _Section(
              icon: Icons.directions_car,
              title: 'Meus Veículos',
              text:
                  'Cadastre e gerencie os veículos. Cada abastecimento é vinculado a um veículo, permitindo somatórios e métricas por modelo.',
            ),
            _Section(
              icon: Icons.local_gas_station,
              title: 'Registrar Abastecimento',
              text:
                  'Lance data, litros, valor pago, quilometragem, tipo de combustível e observações. O app calcula o consumo estimado (km/L).',
            ),
            _Section(
              icon: Icons.history,
              title: 'Histórico de Abastecimentos',
              text:
                  'Lista todos os lançamentos em ordem cronológica, com opção de exclusão. Útil para auditoria rápida dos gastos.',
            ),
            _Section(
              icon: Icons.show_chart,
              title: 'Gráficos',
              text:
                  'Visualização dos custos consolidados por veículo, ajudando a identificar qual tem maior impacto no orçamento.',
            ),
            _Section(
              icon: Icons.account_circle_outlined,
              title: 'Conta / Sair',
              text:
                  'Área de autenticação. Assegura que seus dados fiquem associados ao seu usuário.',
            ),

            const SizedBox(height: 8),
            Text(
              'Dica: mantenha os registros sempre atualizados para que as métricas e gráficos reflitam a realidade de consumo.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;
  const _Section({required this.icon, required this.title, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(text),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
