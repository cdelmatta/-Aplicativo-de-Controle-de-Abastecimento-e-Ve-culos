import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _loading = false;
  bool _obscure1 = true, _obscure2 = true;

  static const _bg = Color(0xFFB0C4DE); 
  static const _actionBlue = Color(0xFF0044CC); 

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email.text.trim(),
        password: _password.text.trim(),
      );
      if (mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message ?? 'Falha no cadastro')));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar')),
      body: Stack(
        children: [
          const Positioned.fill(child: ColoredBox(color: _bg)),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextFormField(
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(labelText: 'E-mail'),
                            validator: (v) =>
                                (v == null || !v.contains('@')) ? 'Informe um e-mail válido' : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _password,
                            obscureText: _obscure1,
                            decoration: InputDecoration(
                              labelText: 'Senha',
                              suffixIcon: IconButton(
                                onPressed: () => setState(() => _obscure1 = !_obscure1),
                                icon: Icon(_obscure1 ? Icons.visibility : Icons.visibility_off),
                              ),
                            ),
                            validator: (v) =>
                                (v == null || v.length < 6) ? 'Mínimo de 6 caracteres' : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _confirm,
                            obscureText: _obscure2,
                            decoration: InputDecoration(
                              labelText: 'Confirmar senha',
                              suffixIcon: IconButton(
                                onPressed: () => setState(() => _obscure2 = !_obscure2),
                                icon: Icon(_obscure2 ? Icons.visibility : Icons.visibility_off),
                              ),
                            ),
                            validator: (v) =>
                                (v != _password.text) ? 'As senhas não coincidem' : null,
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _actionBlue,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: _loading ? null : _register,
                              child: _loading
                                  ? const SizedBox(
                                      height: 20, width: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                    )
                                  : const Text('Cadastrar'),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextButton(
                            style: TextButton.styleFrom(foregroundColor: _actionBlue),
                            onPressed: _loading ? null : () => Navigator.pop(context),
                            child: const Text('Já tem conta? Entrar'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
