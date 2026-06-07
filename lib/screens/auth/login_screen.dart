// lib/screens/auth/login_screen.dart
// Tela de Login com validação de formulário

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../controllers/app_controller.dart';
import '../../theme/app_theme.dart';
import '../../widgets/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _senhaCtrl = TextEditingController();
  bool _verSenha = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _senhaCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthController>();
    final sucesso = await auth.login(_emailCtrl.text.trim(), _senhaCtrl.text);

    if (!mounted) return;

    if (sucesso) {
      // Vai para seleção de área na primeira vez
      context.go('/selecao-area');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao conectar. Verifique email e senha.'),
          backgroundColor: AppTheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),

                // ── Logo e título ──────────────────────────────────────────
                Center(
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: AppTheme.primary,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                    child: const Icon(Icons.location_city,
                        size: 40, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Cidade Inteligente',
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: AppTheme.primary,
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Sua voz na cidade',
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // ── Formulário ─────────────────────────────────────────────
                AppTextField(
                  label: 'E-mail',
                  hint: 'seu@email.com',
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(Icons.email_outlined),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Informe o e-mail';
                    if (!v.contains('@')) return 'E-mail inválido';
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                AppTextField(
                  label: 'Senha',
                  controller: _senhaCtrl,
                  obscureText: !_verSenha,
                  prefixIcon: const Icon(Icons.lock_outlined),
                  suffixIcon: IconButton(
                    icon: Icon(
                        _verSenha ? Icons.visibility_off : Icons.visibility),
                    onPressed: () =>
                        setState(() => _verSenha = !_verSenha),
                  ),
                  validator: (v) {
                    if (v == null || v.length < 6) {
                      return 'Senha deve ter ao menos 6 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text('Esqueci minha senha'),
                  ),
                ),
                const SizedBox(height: 16),

                // ── Botão entrar ───────────────────────────────────────────
                LoadingButton(
                  label: 'Entrar',
                  onPressed: _login,
                  isLoading: auth.isLoading,
                  icon: Icons.login,
                ),
                const SizedBox(height: 24),

                // ── Divider ────────────────────────────────────────────────
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('ou',
                          style: theme.textTheme.bodySmall),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 24),

                // ── Cadastrar-se ───────────────────────────────────────────
                OutlinedButton.icon(
                  onPressed: () => context.push('/cadastro'),
                  icon: const Icon(Icons.person_add_outlined),
                  label: const Text('Criar conta gratuita'),
                ),
                const SizedBox(height: 24),

                // ── Dica de teste ──────────────────────────────────────────
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.06),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    border: Border.all(
                        color: AppTheme.primary.withOpacity(0.2)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '💡 Credenciais de teste:',
                        style: theme.textTheme.labelLarge
                            ?.copyWith(color: AppTheme.primary),
                      ),
                      const SizedBox(height: 4),
                      Text('Morador: qualquer@email.com / 123456',
                          style: theme.textTheme.bodySmall),
                      Text(
                          'Funcionário: nome@prefeitura.gov.br / 123456',
                          style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
