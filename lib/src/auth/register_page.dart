import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final email = TextEditingController();
  final senha = TextEditingController();
  final confirma = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String? error;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    if (context.watch<AuthService>().isLoggedIn) {
      Future.microtask(() => Navigator.pushReplacementNamed(context, '/home'));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Criar conta')),
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
                TextFormField(
                  controller: confirma,
                  decoration: const InputDecoration(labelText: 'Confirmar senha'),
                  obscureText: true,
                  validator: (v) => (v!=senha.text) ? 'Senhas não conferem' : null,
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
                        await context.read<AuthService>().register(email.text.trim(), senha.text);
                      } catch (e) {
                        setState(()=>error='Falha ao criar: $e');
                      } finally {
                        setState(()=>loading=false);
                      }
                    },
                    child: Text(loading ? 'Criando...' : 'Cadastrar'),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
                  child: const Text('Já tem conta? Entrar'),
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
