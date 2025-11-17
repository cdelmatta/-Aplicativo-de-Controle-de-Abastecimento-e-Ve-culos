import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'services/auth_service.dart';
import 'auth/login_page.dart';
import 'auth/register_page.dart';
import 'home/home_page.dart';
import 'veiculos/veiculo_page.dart';
import 'abastecimentos/abastecimento_page.dart';
import 'relatorios/graficos_page.dart';
import 'abastecimentos/novo_abastecimento_page.dart';
import 'veiculos/novo_veiculo_page.dart';
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Controle de Abastecimento',
        theme: AppTheme.light(),
        themeMode: ThemeMode.light,
        initialRoute: '/login',
        routes: {
          '/login': (_) => const LoginPage(),
          '/register': (_) => const RegisterPage(),
          '/home': (_) => const HomePage(),
          '/veiculos': (_) => const VeiculoPage(),
          '/veiculos/novo': (_) => const NovoVeiculoPage(),
          '/abastecimentos': (_) => const AbastecimentoPage(),
          '/graficos': (_) => const GraficosPage(),
          '/abastecimentos/novo': (_) => const NovoAbastecimentoPage(),
          
        },
      ),
    );
  }
}
