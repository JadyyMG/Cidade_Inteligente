// lib/screens/funcionario/painel_funcionario_screen.dart
// Painel exclusivo para funcionários atualizarem o status das denúncias

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../controllers/app_controller.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/widgets.dart';

class PainelFuncionarioScreen extends StatefulWidget {
  const PainelFuncionarioScreen({super.key});

  @override
  State<PainelFuncionarioScreen> createState() =>
      _PainelFuncionarioScreenState();
}

class _PainelFuncionarioScreenState extends State<PainelFuncionarioScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final denunciaCtrl = context.watch<DenunciaController>();

    // Agrupa por status
    final abertas = denunciaCtrl.denuncias
        .where((d) => d.status == DenunciaStatus.aberta)
        .toList();
    final andamento = denunciaCtrl.denuncias
        .where((d) => d.status == DenunciaStatus.em_andamento)
        .toList();
    final resolvidas = denunciaCtrl.denuncias
        .where((d) => d.status == DenunciaStatus.resolvida)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel do Funcionário'),
        leading: BackButton(onPressed: () => context.pop()),
        bottom: TabBar(
          controller: _tabCtrl,
          tabs: [
            Tab(text: 'Abertas (${abertas.length})'),
            Tab(text: 'Andamento (${andamento.length})'),
            Tab(text: 'Resolvidas (${resolvidas.length})'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabCtrl,
        children: [
          _ListaFuncionario(denuncias: abertas),
          _ListaFuncionario(denuncias: andamento),
          _ListaFuncionario(denuncias: resolvidas),
        ],
      ),
    );
  }
}

// ── Lista de denúncias para o funcionário ─────────────────────────────────
class _ListaFuncionario extends StatelessWidget {
  final List<DenunciaModel> denuncias;

  const _ListaFuncionario({required this.denuncias});

  @override
  Widget build(BuildContext context) {
    if (denuncias.isEmpty) {
      return const EmptyState(
        emoji: '✅',
        titulo: 'Nenhuma denúncia aqui',
        subtitulo: 'Todas as denúncias desta categoria\nforam tratadas.',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: denuncias.length,
      itemBuilder: (context, index) => _CardFuncionario(
        denuncia: denuncias[index],
      ),
    );
  }
}

// ── Card com ações do funcionário ─────────────────────────────────────────
class _CardFuncionario extends StatelessWidget {
  final DenunciaModel denuncia;

  const _CardFuncionario({required this.denuncia});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ───────────────────────────────────────────────────
            Row(
              children: [
                Text(denuncia.categoria.icon,
                    style: const TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    denuncia.categoria.label,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                StatusBadge(status: denuncia.status, small: true),
              ],
            ),
            const SizedBox(height: 6),

            Text(denuncia.titulo, style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),

            Row(
              children: [
                const Icon(Icons.location_on_outlined,
                    size: 13, color: Color(0xFF9CA3AF)),
                const SizedBox(width: 3),
                Expanded(
                  child: Text(
                    '${denuncia.bairro} · ${denuncia.endereco}',
                    style: theme.textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),

            Row(
              children: [
                const Icon(Icons.person_outline,
                    size: 13, color: Color(0xFF9CA3AF)),
                const SizedBox(width: 3),
                Text(denuncia.autorNome, style: theme.textTheme.bodySmall),
                const SizedBox(width: 8),
                const Icon(Icons.thumb_up_outlined,
                    size: 13, color: Color(0xFF9CA3AF)),
                const SizedBox(width: 3),
                Text('${denuncia.curtidas}', style: theme.textTheme.bodySmall),
              ],
            ),

            // Observação existente
            if (denuncia.observacaoFuncionario != null) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  border: Border.all(color: AppTheme.success.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline,
                        size: 14, color: AppTheme.success),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        denuncia.observacaoFuncionario!,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: AppTheme.success),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 10),
            const Divider(height: 1),
            const SizedBox(height: 10),

            // ── Botões de ação ────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        context.push('/denuncia/${denuncia.id}'),
                    icon: const Icon(Icons.visibility_outlined, size: 16),
                    label: const Text('Ver'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(0, 36),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      textStyle: const TextStyle(fontSize: 13),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        _mostrarAtualizarStatus(context, denuncia),
                    icon: const Icon(Icons.edit_outlined, size: 16),
                    label: const Text('Atualizar status'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 36),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      textStyle: const TextStyle(fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _mostrarAtualizarStatus(BuildContext context, DenunciaModel denuncia) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _ModalAtualizarStatus(denuncia: denuncia),
    );
  }
}

// ── Modal para atualizar status ────────────────────────────────────────────
class _ModalAtualizarStatus extends StatefulWidget {
  final DenunciaModel denuncia;

  const _ModalAtualizarStatus({required this.denuncia});

  @override
  State<_ModalAtualizarStatus> createState() => _ModalAtualizarStatusState();
}

class _ModalAtualizarStatusState extends State<_ModalAtualizarStatus> {
  late DenunciaStatus _statusSelecionado;
  final _obsCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _statusSelecionado = widget.denuncia.status;
    _obsCtrl.text = widget.denuncia.observacaoFuncionario ?? '';
  }

  @override
  void dispose() {
    _obsCtrl.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    final ctrl = context.read<DenunciaController>();
    await ctrl.atualizarStatus(
      denunciaId: widget.denuncia.id,
      novoStatus: _statusSelecionado,
      observacao: _obsCtrl.text.trim().isEmpty ? null : _obsCtrl.text.trim(),
    );

    if (!mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Status atualizado com sucesso!'),
        backgroundColor: AppTheme.success,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLoading = context.watch<DenunciaController>().isLoading;

    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Text('Atualizar status', style: theme.textTheme.titleLarge),
          Text(
            widget.denuncia.titulo,
            style: theme.textTheme.bodyMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),

          // ── Opções de status ──────────────────────────────────────────
          ...DenunciaStatus.values.map((status) {
            final cor = AppTheme.statusColor(status.key);
            final selecionado = _statusSelecionado == status;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                onTap: () => setState(() => _statusSelecionado = status),
                borderRadius: BorderRadius.circular(AppRadius.sm),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: selecionado ? cor.withOpacity(0.1) : AppTheme.cardBg,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    border: Border.all(
                      color: selecionado ? cor : const Color(0xFFE8EDF2),
                      width: selecionado ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: cor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        status.label,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: selecionado ? cor : null,
                          fontWeight: selecionado ? FontWeight.w600 : null,
                        ),
                      ),
                      if (selecionado) ...[
                        const Spacer(),
                        Icon(Icons.check_circle, color: cor, size: 18),
                      ],
                    ],
                  ),
                ),
              ),
            );
          }),

          const SizedBox(height: 8),

          // ── Campo de observação ───────────────────────────────────────
          TextField(
            controller: _obsCtrl,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Observação (opcional)',
              hintText: 'Ex: Equipe enviada. Previsão de conclusão: 2 dias.',
              prefixIcon: Icon(Icons.comment_outlined),
            ),
          ),
          const SizedBox(height: 16),

          LoadingButton(
            label: 'Salvar alterações',
            onPressed: _salvar,
            isLoading: isLoading,
            icon: Icons.save_outlined,
          ),
        ],
      ),
    );
  }
}
