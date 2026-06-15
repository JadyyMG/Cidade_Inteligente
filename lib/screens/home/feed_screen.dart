// lib/screens/home/feed_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../controllers/app_controller.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/widgets.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final denunciaCtrl = context.watch<DenunciaController>();
    final theme = Theme.of(context);
    final user = auth.user;

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: const Icon(Icons.location_city, size: 20, color: Colors.white),
          ),
        ),
        title: Column(
          children: [
            const Text('Cidade Inteligente'),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.location_on, size: 12, color: AppTheme.primary),
                const SizedBox(width: 2),
                Text(
                  user?.bairro ?? 'Sua área',
                  style: theme.textTheme.bodySmall?.copyWith(color: AppTheme.primary),
                ),
              ],
            ),
          ],
        ),
        actions: [
          if (auth.isFuncionario)
            IconButton(
              icon: const Icon(Icons.admin_panel_settings_outlined),
              onPressed: () => context.push('/funcionario'),
            ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          _FiltroStatus(
            selecionado: denunciaCtrl.filtroStatus,
            onChanged: denunciaCtrl.setFiltroStatus,
          ),
          Expanded(
            child: _ListaDenuncias(
              denuncias: denunciaCtrl.denuncias,
              onTap: (d) => context.push('/denuncia/${d.id}'),
            ),
          ),
        ],
      ),
    );
  }
}

class _FiltroStatus extends StatelessWidget {
  final String selecionado;
  final ValueChanged<String> onChanged;

  const _FiltroStatus({required this.selecionado, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final filtros = [
      {'label': 'Todas', 'value': 'todos'},
      {'label': 'Abertas', 'value': 'aberta'},
      {'label': 'Em andamento', 'value': 'em_andamento'},
      {'label': 'Resolvidas', 'value': 'resolvida'},
    ];
    return Container(
      color: AppTheme.cardBg,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: filtros.map((f) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: StatusFilterChip(
              label: f['label']!,
              value: f['value']!,
              selected: selecionado,
              onChanged: onChanged,
            ),
          )).toList(),
        ),
      ),
    );
  }
}

class _ListaDenuncias extends StatelessWidget {
  final List<DenunciaModel> denuncias;
  final void Function(DenunciaModel) onTap;

  const _ListaDenuncias({required this.denuncias, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (denuncias.isEmpty) {
      return const EmptyState(
        emoji: '🏙️',
        titulo: 'Nenhuma denúncia encontrada',
        subtitulo: 'Seja o primeiro a reportar um problema na sua área.',
      );
    }
    return RefreshIndicator(
      onRefresh: () async => await Future.delayed(const Duration(seconds: 1)),
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 160),
        itemCount: denuncias.length,
        itemBuilder: (context, index) => DenunciaCard(
          denuncia: denuncias[index],
          onTap: () => onTap(denuncias[index]),
        ),
      ),
    );
  }
}
