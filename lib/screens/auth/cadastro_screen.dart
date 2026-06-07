// lib/screens/auth/cadastro_screen.dart
// Tela de Cadastro de novo usuário

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../controllers/app_controller.dart';
import '../../theme/app_theme.dart';
import '../../widgets/widgets.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _telefoneCtrl = TextEditingController();
  final _senhaCtrl = TextEditingController();
  final _confirmaCtrl = TextEditingController();
  String _bairro = '';
  bool _verSenha = false;

  // Lista de bairros mock
  final _bairros = [
    'Centro', 'Boa Vista', 'São João', 'Bairro Novo',
    'Monte Castelo', 'Rendeiras', 'Indianópolis', 'Outro',
  ];

  @override
  void dispose() {
    _nomeCtrl.dispose();
    _emailCtrl.dispose();
    _telefoneCtrl.dispose();
    _senhaCtrl.dispose();
    _confirmaCtrl.dispose();
    super.dispose();
  }

  Future<void> _cadastrar() async {
    if (!_formKey.currentState!.validate()) return;
    if (_bairro.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecione seu bairro')),
      );
      return;
    }

    final auth = context.read<AuthController>();
    await auth.cadastrar(
      nome: _nomeCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      senha: _senhaCtrl.text,
      telefone: _telefoneCtrl.text.trim(),
      bairro: _bairro,
    );

    if (!mounted) return;
    context.go('/selecao-area');
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar conta'),
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Seus dados',
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),
              Text(
                'Preencha para criar sua conta',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),

              // ── Campos de dados ────────────────────────────────────────
              AppTextField(
                label: 'Nome completo',
                controller: _nomeCtrl,
                prefixIcon: const Icon(Icons.person_outlined),
                validator: (v) {
                  if (v == null || v.trim().length < 3) {
                    return 'Informe seu nome completo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              AppTextField(
                label: 'E-mail',
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.email_outlined),
                validator: (v) {
                  if (v == null || !v.contains('@')) {
                    return 'E-mail inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              AppTextField(
                label: 'Telefone / WhatsApp',
                controller: _telefoneCtrl,
                keyboardType: TextInputType.phone,
                prefixIcon: const Icon(Icons.phone_outlined),
                validator: (v) {
                  if (v == null || v.length < 10) {
                    return 'Informe um telefone válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // ── Seleção de bairro ──────────────────────────────────────
              Text('Seu bairro', style: theme.textTheme.labelLarge),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _bairro.isEmpty ? null : _bairro,
                hint: const Text('Selecione o bairro'),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.location_city_outlined),
                ),
                items: _bairros
                    .map((b) =>
                        DropdownMenuItem(value: b, child: Text(b)))
                    .toList(),
                onChanged: (v) => setState(() => _bairro = v ?? ''),
              ),
              const SizedBox(height: 16),

              // ── Senha ──────────────────────────────────────────────────
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
                    return 'Mínimo 6 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              AppTextField(
                label: 'Confirmar senha',
                controller: _confirmaCtrl,
                obscureText: true,
                prefixIcon: const Icon(Icons.lock_outlined),
                validator: (v) {
                  if (v != _senhaCtrl.text) {
                    return 'As senhas não coincidem';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              LoadingButton(
                label: 'Criar minha conta',
                onPressed: _cadastrar,
                isLoading: auth.isLoading,
                icon: Icons.check_circle_outline,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
