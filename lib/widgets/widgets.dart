// lib/widgets/widgets.dart
// Widgets reutilizáveis do aplicativo Cidade Inteligente

import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

// ── Badge de status da denúncia ────────────────────────────────────────────
class StatusBadge extends StatelessWidget {
  final DenunciaStatus status;
  final bool small;

  const StatusBadge({super.key, required this.status, this.small = false});

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.statusColor(status.key);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: small ? 8 : 10,
        vertical: small ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: small ? 5 : 7,
            height: small ? 5 : 7,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: small ? 4 : 5),
          Text(
            status.label,
            style: TextStyle(
              fontSize: small ? 11 : 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Card de denúncia no feed ───────────────────────────────────────────────
class DenunciaCard extends StatelessWidget {
  final DenunciaModel denuncia;
  final VoidCallback onTap;

  const DenunciaCard({
    super.key,
    required this.denuncia,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header: categoria + status ─────────────────────────────
              Row(
                children: [
                  Text(
                    denuncia.categoria.icon,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      denuncia.categoria.label,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                  StatusBadge(status: denuncia.status, small: true),
                ],
              ),
              const SizedBox(height: 8),

              // ── Título ─────────────────────────────────────────────────
              Text(
                denuncia.titulo,
                style: theme.textTheme.titleMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),

              // ── Localização ────────────────────────────────────────────
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

              // ── Foto (se houver) ───────────────────────────────────────
              if (denuncia.fotos.isNotEmpty) ...[
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  child: Image.network(
                    denuncia.fotos.first,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 140,
                      color: const Color(0xFFEEF2F7),
                      child: const Icon(Icons.image_not_supported,
                          color: Colors.grey),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 10),
              const Divider(height: 1),
              const SizedBox(height: 8),

              // ── Rodapé: autor + curtidas + tempo ──────────────────────
              Row(
                children: [
                  _AvatarIniciais(
                      nome: denuncia.autorNome, radius: 12),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      denuncia.autorNome,
                      style: theme.textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(Icons.thumb_up_outlined,
                      size: 13, color: Color(0xFF9CA3AF)),
                  const SizedBox(width: 3),
                  Text('${denuncia.curtidas}',
                      style: theme.textTheme.bodySmall),
                  const SizedBox(width: 10),
                  const Icon(Icons.chat_bubble_outline,
                      size: 13, color: Color(0xFF9CA3AF)),
                  const SizedBox(width: 3),
                  Text('${denuncia.comentarios}',
                      style: theme.textTheme.bodySmall),
                  const SizedBox(width: 10),
                  _TimeAgo(data: denuncia.criadaEm),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Avatar com iniciais do nome ────────────────────────────────────────────
class _AvatarIniciais extends StatelessWidget {
  final String nome;
  final double radius;

  const _AvatarIniciais({required this.nome, this.radius = 20});

  String _iniciais() {
    final partes = nome.trim().split(' ');
    if (partes.length >= 2) {
      return '${partes.first[0]}${partes.last[0]}'.toUpperCase();
    }
    return nome.substring(0, nome.length.clamp(0, 2)).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppTheme.primary.withOpacity(0.15),
      child: Text(
        _iniciais(),
        style: TextStyle(
          fontSize: radius * 0.7,
          fontWeight: FontWeight.w700,
          color: AppTheme.primary,
        ),
      ),
    );
  }
}

// ── Widget de tempo relativo ───────────────────────────────────────────────
class _TimeAgo extends StatelessWidget {
  final DateTime data;
  const _TimeAgo({required this.data});

  String _formatar() {
    final diff = DateTime.now().difference(data);
    if (diff.inMinutes < 60) return '${diff.inMinutes}min';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return '${(diff.inDays / 7).floor()}sem';
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatar(),
      style: Theme.of(context).textTheme.bodySmall,
    );
  }
}

// ── Campo de texto customizado ─────────────────────────────────────────────
class AppTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int maxLines;
  final bool enabled;

  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    required this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLines = 1,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
    );
  }
}

// ── Botão de carregamento ──────────────────────────────────────────────────
class LoadingButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  const LoadingButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Colors.white,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18),
                  const SizedBox(width: 8),
                ],
                Text(label),
              ],
            ),
    );
  }
}

// ── Card de notificação ────────────────────────────────────────────────────
class NotificacaoCard extends StatelessWidget {
  final NotificacaoModel notificacao;
  final VoidCallback onTap;

  const NotificacaoCard({
    super.key,
    required this.notificacao,
    required this.onTap,
  });

  Color get _cor {
    switch (notificacao.tipo) {
      case NotificacaoTipo.emergencia:
        return AppTheme.error;
      case NotificacaoTipo.denuncia:
        return AppTheme.primary;
      case NotificacaoTipo.reforma:
        return AppTheme.warning;
      case NotificacaoTipo.resolucao:
        return AppTheme.success;
      case NotificacaoTipo.aviso:
        return const Color(0xFF7C3AED);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Indicador colorido
              Container(
                width: 4,
                height: 44,
                decoration: BoxDecoration(
                  color: notificacao.lida
                      ? Colors.transparent
                      : _cor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notificacao.titulo,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: notificacao.lida
                                ? FontWeight.w400
                                : FontWeight.w600,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notificacao.corpo,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    _TimeAgo(data: notificacao.criadaEm),
                  ],
                ),
              ),
              if (!notificacao.lida)
                Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    color: _cor,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Chip de categoria ──────────────────────────────────────────────────────
class CategoriaChip extends StatelessWidget {
  final DenunciaCategoria categoria;
  final bool selecionado;
  final VoidCallback onTap;

  const CategoriaChip({
    super.key,
    required this.categoria,
    required this.selecionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      selected: selecionado,
      onSelected: (_) => onTap(),
      label: Text('${categoria.icon} ${categoria.label}'),
      selectedColor: AppTheme.primary.withOpacity(0.15),
      checkmarkColor: AppTheme.primary,
    );
  }
}

// ── Empty state genérico ───────────────────────────────────────────────────
class EmptyState extends StatelessWidget {
  final String emoji;
  final String titulo;
  final String subtitulo;
  final Widget? action;

  const EmptyState({
    super.key,
    required this.emoji,
    required this.titulo,
    required this.subtitulo,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 56)),
            const SizedBox(height: 16),
            Text(
              titulo,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitulo,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (action != null) ...[
              const SizedBox(height: 24),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

// ── Seção com título ───────────────────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String titulo;
  final String? acao;
  final VoidCallback? onAcao;

  const SectionHeader({
    super.key,
    required this.titulo,
    this.acao,
    this.onAcao,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(titulo,
              style: Theme.of(context).textTheme.titleLarge),
          if (acao != null)
            TextButton(
              onPressed: onAcao,
              child: Text(acao!),
            ),
        ],
      ),
    );
  }
}

// ── Chip de status para filtro ─────────────────────────────────────────────
class StatusFilterChip extends StatelessWidget {
  final String label;
  final String value;
  final String selected;
  final ValueChanged<String> onChanged;

  const StatusFilterChip({
    super.key,
    required this.label,
    required this.value,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isSelecionado = selected == value;
    return FilterChip(
      selected: isSelecionado,
      onSelected: (_) => onChanged(value),
      label: Text(label),
      selectedColor: AppTheme.primary.withOpacity(0.15),
      checkmarkColor: AppTheme.primary,
    );
  }
}
