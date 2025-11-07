import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(title: const Text('Início')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FlutterLogo(size: 96),
            const SizedBox(height: 16),
            Text('Bem-vindo!', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            const Text('Use o menu lateral para navegar.'),
          ],
        ),
      ),
    );
  }
}
