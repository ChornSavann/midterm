import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _user = TextEditingController(text: 'emilys'); // demo account
  final _pass = TextEditingController(text: 'emilyspass');
  final c = Get.find<AuthController>();

  @override
  void dispose() {
    _user.dispose();
    _pass.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) c.login(_user.text.trim(), _pass.text);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: cs.primaryContainer,
                  child: Icon(Icons.lock_outline, size: 40, color: cs.primary),
                ),
                const SizedBox(height: 16),
                Text('Welcome back', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 4),
                const Text('Sign in to continue'),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _user,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(labelText: 'Username', prefixIcon: Icon(Icons.person_outline)),
                  validator: (v) => (v == null || v.trim().isEmpty) ? 'Username is required' : null,
                ),
                const SizedBox(height: 16),
                Obx(() => TextFormField(
                      controller: _pass,
                      obscureText: c.obscure.value,
                      onFieldSubmitted: (_) => _submit(),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.key_outlined),
                        suffixIcon: IconButton(
                          icon: Icon(c.obscure.value ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => c.obscure.toggle(),
                        ),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Password is required';
                        if (v.length < 6) return 'At least 6 characters';
                        return null;
                      },
                    )),
                const SizedBox(height: 24),
                Obx(() => SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: FilledButton(
                        onPressed: c.isLoading.value ? null : _submit,
                        child: c.isLoading.value
                            ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Text('Login'),
                      ),
                    )),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
