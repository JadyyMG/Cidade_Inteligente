// lib/screens/area/selecao_area_screen.dart
// Tela de seleção da área/bairro de interesse do usuário

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/app_theme.dart';

class SelecaoAreaScreen extends StatefulWidget {
  const SelecaoAreaScreen({super.key});

  @override
  State<SelecaoAreaScreen> createState() => _SelecaoAreaScreenState();
}

class _SelecaoAreaScreenState extends State<SelecaoAreaScreen> {
  final Set<String> _selecionados = {'Centro'};

  // Mock de bairros com estatísticas
  final List<Map<String, dynamic>> _bairros = [
    {'nome': 'Centro', 'denuncias': 47, 'emoji': '🏙️'},
    {'nome': 'Boa Vista', 'denuncias': 23, 'emoji': '🌳'},
    {'nome': 'São João', 'denuncias': 31, 'emoji': '⛪'},
    {'nome': 'Bairro Novo', 'denuncias': 18, 'emoji': '🏘️'},
    {'nome': 'Monte Castelo', 'denuncias': 12, 'emoji': '🏔️'},
    {'nome': 'Rendeiras', 'denuncias': 8, 'emoji': '🧵'},
    {'nome': 'Indianópolis', 'denuncias': 15, 'emoji': '🌿'},
    {'nome': 'Universitário', 'denuncias': 9, 'emoji': '🎓'},
    {'nome': 'Petrópolis', 'denuncias': 21, 'emoji': '🌸'},
    {'nome': 'Lauritzen', 'denuncias': 6, 'emoji': '🏡'},
    {'nome': 'Divinópolis', 'denuncias': 11, 'emoji': '⭐'},
    {'nome': 'Salgado', 'denuncias': 7, 'emoji': '🌾'},
  ];

  void _toggleBairro(String bairro) {
    setState(() {
      if (_selecionados.contains(bairro)) {
        if (_selecionados.length > 1) {
          _selecionados.remove(bairro);
        }
      } else {
        _selecionados.add(bairro);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),

              // ── Cabeçalho ────────────────────────────────────────────────
              const Icon(
                Icons.my_location,
                size: 48,
                color: AppTheme.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Sua área na cidade',
                style: theme.textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Selecione os bairros que deseja acompanhar. '
                'Você receberá notificações sobre denúncias e avisos dessas áreas.',
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '${_selecionados.length} bairro(s) selecionado(s)',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // ── Grid de bairros ──────────────────────────────────────────
              Expanded(
                child: GridView.builder(
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.6,
                  ),
                  itemCount: _bairros.length,
                  itemBuilder: (context, index) {
                    final bairro = _bairros[index];
                    final nome = bairro['nome'] as String;
                    final selecionado = _selecionados.contains(nome);

                    return _BairroTile(
                      nome: nome,
                      emoji: bairro['emoji'] as String,
                      denuncias: bairro['denuncias'] as int,
                      selecionado: selecionado,
                      onTap: () => _toggleBairro(nome),
                    );
                  },
                ),
              ),

              const SizedBox(height: 16),

              // ── Botão continuar ──────────────────────────────────────────
              ElevatedButton.icon(
                onPressed: () => context.go('/home'),
                icon: const Icon(Icons.arrow_forward),
                label: const Text('Começar'),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _BairroTile extends StatelessWidget {
  final String nome;
  final String emoji;
  final int denuncias;
  final bool selecionado;
  final VoidCallback onTap;

  const _BairroTile({
    required this.nome,
    required this.emoji,
    required this.denuncias,
    required this.selecionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: selecionado
            ? AppTheme.primary.withOpacity(0.1)
            : AppTheme.cardBg,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: selecionado ? AppTheme.primary : const Color(0xFFE8EDF2),
          width: selecionado ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(emoji,
                      style: const TextStyle(fontSize: 22)),
                  if (selecionado)
                    const Icon(Icons.check_circle,
                        size: 18, color: AppTheme.primary),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nome,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: selecionado ? AppTheme.primary : null,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '$denuncias denúncias',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
