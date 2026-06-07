// lib/screens/denuncia/criar_denuncia_screen.dart
// Tela para criar nova denúncia com foto, categoria e visibilidade

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../controllers/app_controller.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/widgets.dart';

class CriarDenunciaScreen extends StatefulWidget {
  const CriarDenunciaScreen({super.key});

  @override
  State<CriarDenunciaScreen> createState() => _CriarDenunciaScreenState();
}

class _CriarDenunciaScreenState extends State<CriarDenunciaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloCtrl = TextEditingController();
  final _descricaoCtrl = TextEditingController();
  final _enderecoCtrl = TextEditingController();

  DenunciaCategoria _categoria = DenunciaCategoria.outro;
  bool _isPublica = true;
  String _bairro = 'Centro';
  int _etapa = 0; // 0: info, 1: categoria, 2: revisão

  final _bairros = [
    'Centro', 'Boa Vista', 'São João', 'Bairro Novo',
    'Monte Castelo', 'Rendeiras', 'Indianópolis', 'Outro',
  ];

  @override
  void dispose() {
    _tituloCtrl.dispose();
    _descricaoCtrl.dispose();
    _enderecoCtrl.dispose();
    super.dispose();
  }

  Future<void> _enviar() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthController>();
    final denunciaCtrl = context.read<DenunciaController>();
    final user = auth.user!;

    await denunciaCtrl.criarDenuncia(
      titulo: _tituloCtrl.text.trim(),
      descricao: _descricaoCtrl.text.trim(),
      categoria: _categoria,
      isPublica: _isPublica,
      bairro: _bairro,
      endereco: _enderecoCtrl.text.trim(),
      autorId: user.id,
      autorNome: user.nome,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 8),
            Text('Denúncia enviada com sucesso!'),
          ],
        ),
        backgroundColor: AppTheme.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.sm)),
      ),
    );

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final denunciaCtrl = context.watch<DenunciaController>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova denúncia'),
        leading: BackButton(onPressed: () => context.pop()),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: (_etapa + 1) / 3,
            backgroundColor: Colors.grey.shade200,
            valueColor:
                const AlwaysStoppedAnimation<Color>(AppTheme.primary),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: IndexedStack(
          index: _etapa,
          children: [
            _EtapaInfo(
              tituloCtrl: _tituloCtrl,
              descricaoCtrl: _descricaoCtrl,
              enderecoCtrl: _enderecoCtrl,
              bairro: _bairro,
              bairros: _bairros,
              onBairroChanged: (v) => setState(() => _bairro = v),
              onAvancar: () {
                if (_formKey.currentState!.validate()) {
                  setState(() => _etapa = 1);
                }
              },
            ),
            _EtapaCategoria(
              categoriaSelecionada: _categoria,
              isPublica: _isPublica,
              onCategoriaChanged: (c) => setState(() => _categoria = c),
              onPublicaChanged: (v) => setState(() => _isPublica = v),
              onVoltar: () => setState(() => _etapa = 0),
              onAvancar: () => setState(() => _etapa = 2),
            ),
            _EtapaRevisao(
              titulo: _tituloCtrl.text,
              descricao: _descricaoCtrl.text,
              endereco: _enderecoCtrl.text,
              bairro: _bairro,
              categoria: _categoria,
              isPublica: _isPublica,
              isLoading: denunciaCtrl.isLoading,
              onVoltar: () => setState(() => _etapa = 1),
              onEnviar: _enviar,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Etapa 1: Informações básicas ───────────────────────────────────────────
class _EtapaInfo extends StatelessWidget {
  final TextEditingController tituloCtrl;
  final TextEditingController descricaoCtrl;
  final TextEditingController enderecoCtrl;
  final String bairro;
  final List<String> bairros;
  final ValueChanged<String> onBairroChanged;
  final VoidCallback onAvancar;

  const _EtapaInfo({
    required this.tituloCtrl,
    required this.descricaoCtrl,
    required this.enderecoCtrl,
    required this.bairro,
    required this.bairros,
    required this.onBairroChanged,
    required this.onAvancar,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _StepHeader(
            numero: '1',
            titulo: 'O que aconteceu?',
            subtitulo: 'Descreva o problema que você identificou',
          ),
          const SizedBox(height: 20),
          AppTextField(
            label: 'Título da denúncia',
            hint: 'Ex: Buraco na calçada perto do mercado',
            controller: tituloCtrl,
            prefixIcon: const Icon(Icons.title),
            validator: (v) {
              if (v == null || v.trim().length < 5) {
                return 'Título deve ter ao menos 5 caracteres';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          AppTextField(
            label: 'Descrição detalhada',
            hint: 'Descreva o problema com mais detalhes...',
            controller: descricaoCtrl,
            maxLines: 4,
            validator: (v) {
              if (v == null || v.trim().length < 10) {
                return 'Descreva melhor o problema';
              }
              return null;
            },
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: bairro,
            decoration: const InputDecoration(
              labelText: 'Bairro',
              prefixIcon: Icon(Icons.location_city_outlined),
            ),
            items: bairros
                .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                .toList(),
            onChanged: (v) {
              if (v != null) onBairroChanged(v);
            },
          ),
          const SizedBox(height: 12),
          AppTextField(
            label: 'Endereço / Referência',
            hint: 'Ex: Rua das Flores, 150 (perto da farmácia)',
            controller: enderecoCtrl,
            prefixIcon: const Icon(Icons.place_outlined),
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return 'Informe o endereço ou referência';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // ── Adicionar foto ─────────────────────────────────────────────
          OutlinedButton.icon(
            onPressed: () {
              // TODO: integrar image_picker
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content:
                        Text('📸 Câmera disponível após integração')),
              );
            },
            icon: const Icon(Icons.camera_alt_outlined),
            label: const Text('Adicionar foto (opcional)'),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onAvancar,
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Próximo'),
          ),
        ],
      ),
    );
  }
}

// ── Etapa 2: Categoria e visibilidade ─────────────────────────────────────
class _EtapaCategoria extends StatelessWidget {
  final DenunciaCategoria categoriaSelecionada;
  final bool isPublica;
  final ValueChanged<DenunciaCategoria> onCategoriaChanged;
  final ValueChanged<bool> onPublicaChanged;
  final VoidCallback onVoltar;
  final VoidCallback onAvancar;

  const _EtapaCategoria({
    required this.categoriaSelecionada,
    required this.isPublica,
    required this.onCategoriaChanged,
    required this.onPublicaChanged,
    required this.onVoltar,
    required this.onAvancar,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _StepHeader(
            numero: '2',
            titulo: 'Categoria e visibilidade',
            subtitulo: 'Classifique o tipo de problema',
          ),
          const SizedBox(height: 20),
          Text('Categoria do problema',
              style: theme.textTheme.labelLarge),
          const SizedBox(height: 10),

          // ── Grid de categorias ─────────────────────────────────────────
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 2.5,
            children: DenunciaCategoria.values.map((cat) {
              final selecionado = cat == categoriaSelecionada;
              return InkWell(
                onTap: () => onCategoriaChanged(cat),
                borderRadius: BorderRadius.circular(AppRadius.sm),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: selecionado
                        ? AppTheme.primary.withOpacity(0.1)
                        : AppTheme.cardBg,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    border: Border.all(
                      color: selecionado
                          ? AppTheme.primary
                          : const Color(0xFFE8EDF2),
                      width: selecionado ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(cat.icon,
                          style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          cat.label,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: selecionado
                                ? FontWeight.w600
                                : null,
                            color: selecionado ? AppTheme.primary : null,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // ── Visibilidade ───────────────────────────────────────────────
          Text('Visibilidade', style: theme.textTheme.labelLarge),
          const SizedBox(height: 8),
          _VisibilidadeOption(
            titulo: 'Pública',
            subtitulo: 'Outros moradores e funcionários poderão ver',
            icon: Icons.public,
            selecionado: isPublica,
            onTap: () => onPublicaChanged(true),
          ),
          const SizedBox(height: 8),
          _VisibilidadeOption(
            titulo: 'Privada',
            subtitulo: 'Somente você e funcionários autorizados verão',
            icon: Icons.lock_outlined,
            selecionado: !isPublica,
            onTap: () => onPublicaChanged(false),
          ),

          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onVoltar,
                  child: const Text('Voltar'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: onAvancar,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Revisar'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _VisibilidadeOption extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final IconData icon;
  final bool selecionado;
  final VoidCallback onTap;

  const _VisibilidadeOption({
    required this.titulo,
    required this.subtitulo,
    required this.icon,
    required this.selecionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        color: selecionado
            ? AppTheme.primary.withOpacity(0.07)
            : AppTheme.cardBg,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(
          color: selecionado ? AppTheme.primary : const Color(0xFFE8EDF2),
          width: selecionado ? 2 : 1,
        ),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon,
            color: selecionado ? AppTheme.primary : Colors.grey),
        title: Text(titulo,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: selecionado ? AppTheme.primary : null,
            )),
        subtitle: Text(subtitulo),
        trailing: selecionado
            ? const Icon(Icons.check_circle, color: AppTheme.primary)
            : null,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md)),
      ),
    );
  }
}

// ── Etapa 3: Revisão antes de enviar ──────────────────────────────────────
class _EtapaRevisao extends StatelessWidget {
  final String titulo;
  final String descricao;
  final String endereco;
  final String bairro;
  final DenunciaCategoria categoria;
  final bool isPublica;
  final bool isLoading;
  final VoidCallback onVoltar;
  final VoidCallback onEnviar;

  const _EtapaRevisao({
    required this.titulo,
    required this.descricao,
    required this.endereco,
    required this.bairro,
    required this.categoria,
    required this.isPublica,
    required this.isLoading,
    required this.onVoltar,
    required this.onEnviar,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _StepHeader(
            numero: '3',
            titulo: 'Confirme sua denúncia',
            subtitulo: 'Revise antes de enviar',
          ),
          const SizedBox(height: 20),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _RevisaoItem(
                      icon: Icons.title, label: 'Título', valor: titulo),
                  const Divider(height: 20),
                  _RevisaoItem(
                      icon: Icons.description_outlined,
                      label: 'Descrição',
                      valor: descricao),
                  const Divider(height: 20),
                  _RevisaoItem(
                      icon: Icons.category_outlined,
                      label: 'Categoria',
                      valor: '${categoria.icon} ${categoria.label}'),
                  const Divider(height: 20),
                  _RevisaoItem(
                      icon: Icons.place_outlined,
                      label: 'Local',
                      valor: '$bairro — $endereco'),
                  const Divider(height: 20),
                  _RevisaoItem(
                      icon: isPublica ? Icons.public : Icons.lock_outlined,
                      label: 'Visibilidade',
                      valor: isPublica ? 'Pública' : 'Privada'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          LoadingButton(
            label: 'Enviar denúncia',
            onPressed: onEnviar,
            isLoading: isLoading,
            icon: Icons.send,
          ),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: onVoltar,
            child: const Text('Voltar e editar'),
          ),
        ],
      ),
    );
  }
}

class _RevisaoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String valor;

  const _RevisaoItem({
    required this.icon,
    required this.label,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppTheme.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: theme.textTheme.bodySmall),
              const SizedBox(height: 2),
              Text(valor, style: theme.textTheme.bodyLarge),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Cabeçalho de etapa ─────────────────────────────────────────────────────
class _StepHeader extends StatelessWidget {
  final String numero;
  final String titulo;
  final String subtitulo;

  const _StepHeader({
    required this.numero,
    required this.titulo,
    required this.subtitulo,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppTheme.primary,
            borderRadius: BorderRadius.circular(AppRadius.full),
          ),
          child: Center(
            child: Text(
              numero,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(titulo, style: theme.textTheme.titleLarge),
              Text(subtitulo, style: theme.textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }
}
