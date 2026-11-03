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
    if (_formKey.currentState!.validate()) {
      c.login(_user.text.trim(), _pass.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo / Icon Container with soft shadow
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: cs.primaryContainer.withOpacity(0.4),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: cs.primary.withOpacity(0.1),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(Icons.lock_person_rounded, size: 50, color: cs.primary),
                  ),
                  const SizedBox(height: 24),

                  // Title & Subtitle
                  Text(
                    'Welcome Back',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Sign in to continue to your dashboard',
                    style: TextStyle(fontSize: 14, color: cs.onSurfaceVariant),
                  ),
                  const SizedBox(height: 36),

                  // Username TextField
                  TextFormField(
                    controller: _user,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      hintText: 'Enter your username',
                      prefixIcon: Icon(Icons.person_outline, color: cs.primary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: cs.outline.withOpacity(0.5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: cs.primary, width: 2),
                      ),
                      filled: true,
                      fillColor: cs.surfaceContainerHighest.withOpacity(0.3),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Username is required' : null,
                  ),
                  const SizedBox(height: 18),

                  // Password TextField with Obscure & Toggle
                  Obx(() => TextFormField(
                    controller: _pass,
                    obscureText: c.obscure.value,
                    onFieldSubmitted: (_) => _submit(),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      prefixIcon: Icon(Icons.key_outlined, color: cs.primary),
                      suffixIcon: IconButton(
                        icon: Icon(
                          c.obscure.value ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: cs.onSurfaceVariant,
                        ),
                        onPressed: () => c.obscure.toggle(),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: cs.outline.withOpacity(0.5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: cs.primary, width: 2),
                      ),
                      filled: true,
                      fillColor: cs.surfaceContainerHighest.withOpacity(0.3),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Password is required';
                      if (v.length < 6) return 'At least 6 characters required';
                      return null;
                    },
                  )),
                  const SizedBox(height: 30),

                  // Login Button with Loading State
                  Obx(() => SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 2,
                      ),
                      onPressed: c.isLoading.value ? null : _submit,
                      child: c.isLoading.value
                          ? SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: cs.onPrimary,
                        ),
                      )
                          : const Text(
                        'Login',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}