import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final senha = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool loading = false;
  String? error;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthService>();
    if (auth.isLoggedIn) {
      Future.microtask(() => Navigator.pushReplacementNamed(context, '/home'));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Entrar')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                TextFormField(
                  controller: email,
                  decoration: const InputDecoration(labelText: 'E-mail'),
                  validator: (v) => (v==null || !v.contains('@')) ? 'E-mail inválido' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: senha,
                  decoration: const InputDecoration(labelText: 'Senha'),
                  obscureText: true,
                  validator: (v) => (v==null || v.length<6) ? 'Mínimo 6 caracteres' : null,
                ),
                const SizedBox(height: 12),
                if (error != null) Text(error!, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: loading ? null : () async {
                      if (!formKey.currentState!.validate()) return;
                      setState(()=>loading=true);
                      try {
                        await context.read<AuthService>().signIn(email.text.trim(), senha.text);
                      } catch (e) {
                        setState(()=>error='Falha ao entrar: $e');
                      } finally {
                        setState(()=>loading=false);
                      }
                    },
                    child: Text(loading ? 'Entrando...' : 'Entrar'),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/register'),
                  child: const Text('Não tem conta? Cadastre-se'),
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
