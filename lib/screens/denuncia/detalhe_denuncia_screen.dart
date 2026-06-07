// lib/screens/denuncia/detalhe_denuncia_screen.dart
// Tela de detalhes de uma denúncia específica

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../controllers/app_controller.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/widgets.dart';

class DetalheDenunciaScreen extends StatelessWidget {
  final String denunciaId;

  const DetalheDenunciaScreen({super.key, required this.denunciaId});

  @override
  Widget build(BuildContext context) {
    final denunciaCtrl = context.watch<DenunciaController>();
    final denuncia = denunciaCtrl.porId(denunciaId);

    if (denuncia == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Denúncia')),
        body: const EmptyState(
          emoji: '🔍',
          titulo: 'Denúncia não encontrada',
          subtitulo: 'A denúncia pode ter sido removida.',
        ),
      );
    }

    return _DetalheConteudo(denuncia: denuncia);
  }
}

class _DetalheConteudo extends StatelessWidget {
  final DenunciaModel denuncia;

  const _DetalheConteudo({required this.denuncia});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = context.watch<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes'),
        leading: BackButton(onPressed: () => context.pop()),
        actions: [
          // Compartilhar
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {},
          ),
          // Mais opções
          PopupMenuButton<String>(
            onSelected: (v) {},
            itemBuilder: (_) => const [
              PopupMenuItem(
                  value: 'reportar', child: Text('Reportar conteúdo')),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Fotos ────────────────────────────────────────────────────
            if (denuncia.fotos.isNotEmpty)
              _GaleriaFotos(fotos: denuncia.fotos),

            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Categoria e status ─────────────────────────────────
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withOpacity(0.1),
                          borderRadius:
                              BorderRadius.circular(AppRadius.full),
                        ),
                        child: Text(
                          '${denuncia.categoria.icon} ${denuncia.categoria.label}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      StatusBadge(status: denuncia.status),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // ── Título ─────────────────────────────────────────────
                  Text(denuncia.titulo,
                      style: theme.textTheme.headlineSmall),
                  const SizedBox(height: 8),

                  // ── Localização ────────────────────────────────────────
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 16, color: AppTheme.primary),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${denuncia.bairro} · ${denuncia.endereco}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppTheme.primary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // ── Data ───────────────────────────────────────────────
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 14, color: Color(0xFF9CA3AF)),
                      const SizedBox(width: 4),
                      Text(
                        _formatarData(denuncia.criadaEm),
                        style: theme.textTheme.bodySmall,
                      ),
                      if (denuncia.atualizadaEm != null) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.update,
                            size: 14, color: Color(0xFF9CA3AF)),
                        const SizedBox(width: 4),
                        Text(
                          'Atualizado ${_formatarData(denuncia.atualizadaEm!)}',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),

                  // ── Descrição ──────────────────────────────────────────
                  Text('Descrição',
                      style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(denuncia.descricao,
                      style: theme.textTheme.bodyLarge),

                  // ── Observação do funcionário ──────────────────────────
                  if (denuncia.observacaoFuncionario != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.primary.withOpacity(0.06),
                        borderRadius:
                            BorderRadius.circular(AppRadius.md),
                        border: Border.all(
                          color: AppTheme.primary.withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.admin_panel_settings,
                                  size: 16, color: AppTheme.primary),
                              const SizedBox(width: 6),
                              Text(
                                'Resposta da equipe responsável',
                                style: theme.textTheme.labelLarge
                                    ?.copyWith(color: AppTheme.primary),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            denuncia.observacaoFuncionario!,
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 12),

                  // ── Autor ──────────────────────────────────────────────
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor:
                            AppTheme.primary.withOpacity(0.15),
                        child: Text(
                          denuncia.autorNome.substring(0, 2).toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppTheme.primary,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(denuncia.autorNome,
                              style: theme.textTheme.titleMedium),
                          Text('Morador',
                              style: theme.textTheme.bodySmall),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // ── Curtidas / Comentários ─────────────────────────────
                  Row(
                    children: [
                      _AcaoBtn(
                        icon: Icons.thumb_up_outlined,
                        label: '${denuncia.curtidas} apoios',
                        onTap: () {},
                      ),
                      const SizedBox(width: 12),
                      _AcaoBtn(
                        icon: Icons.chat_bubble_outline,
                        label: '${denuncia.comentarios} comentários',
                        onTap: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ── Botão de chat (só para morador) ───────────────────
                  if (!auth.isFuncionario)
                    ElevatedButton.icon(
                      onPressed: () => context.push(
                          '/chat/c1?titulo=Prefeitura de Caruaru'),
                      icon: const Icon(Icons.chat),
                      label: const Text('Falar com a Prefeitura'),
                    ),

                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatarData(DateTime data) {
    final diff = DateTime.now().difference(data);
    if (diff.inDays == 0) return 'Hoje';
    if (diff.inDays == 1) return 'Ontem';
    return '${data.day}/${data.month}/${data.year}';
  }
}

// ── Galeria de fotos ───────────────────────────────────────────────────────
class _GaleriaFotos extends StatelessWidget {
  final List<String> fotos;

  const _GaleriaFotos({required this.fotos});

  @override
  Widget build(BuildContext context) {
    if (fotos.length == 1) {
      return Image.network(
        fotos.first,
        height: 220,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          height: 220,
          color: const Color(0xFFEEF2F7),
          child: const Icon(Icons.image_not_supported,
              size: 48, color: Colors.grey),
        ),
      );
    }
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: fotos.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: Image.network(
              fotos[index],
              width: 200,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Botão de ação (apoiar / comentar) ─────────────────────────────────────
class _AcaoBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _AcaoBtn({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 16),
      label: Text(label,
          style: const TextStyle(fontSize: 13)),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(
            horizontal: 12, vertical: 8),
        minimumSize: Size.zero,
      ),
    );
  }
}
