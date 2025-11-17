import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Center(
                child: Text(
                  'Controle de Abastecimento',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.directions_car),
              title: const Text('Meus Veículos'),
              onTap: () => Navigator.pushReplacementNamed(context, '/veiculos'),
            ),
            ListTile(
              leading: const Icon(Icons.local_gas_station),
              title: const Text('Registrar Abastecimento'),
              onTap: () => Navigator.pushReplacementNamed(
                context,
                '/abastecimentos/novo',
              ),
            ),
            ListTile(
              leading: const Icon(Icons.history),
              title: const Text('Histórico de Abastecimentos'),
              onTap: () =>
                  Navigator.pushReplacementNamed(context, '/abastecimentos'),
            ),
            ListTile(
              leading: const Icon(Icons.insights),
              title: const Text('Gráficos'),
              onTap: () => Navigator.pushReplacementNamed(context, '/graficos'),
            ),

            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Sobre o aplicativo'),
              onTap: () => Navigator.pushNamed(context, '/sobre'),
            ),

            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sair'),
              onTap: () async {
                await context.read<AuthService>().signOut();
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (_) => false,
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
