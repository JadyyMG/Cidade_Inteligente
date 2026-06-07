// lib/screens/perfil/perfil_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../controllers/app_controller.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/widgets.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthController>();
    final denunciaCtrl = context.watch<DenunciaController>();
    final user = auth.user!;
    final minhasDenuncias = denunciaCtrl.minhasDenuncias(user.id);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Cabeçalho do perfil ─────────────────────────────────────
            Container(
              color: AppTheme.cardBg,
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppTheme.primary.withOpacity(0.15),
                    child: Text(
                      user.iniciais,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(user.nome, style: theme.textTheme.headlineSmall),
                  const SizedBox(height: 4),
                  Text(user.email, style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.location_on, size: 14, color: AppTheme.primary),
                      const SizedBox(width: 4),
                      Text(
                        '${user.bairro} · ${user.cidade}',
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: AppTheme.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Badge de papel
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: user.role == UserRole.funcionario
                          ? AppTheme.secondary.withOpacity(0.12)
                          : AppTheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: Text(
                      user.role == UserRole.funcionario
                          ? '🏛️ Funcionário Público'
                          : '👤 Morador',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: user.role == UserRole.funcionario
                            ? AppTheme.secondary
                            : AppTheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // ── Estatísticas ────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _StatCard(
                    valor: '${minhasDenuncias.length}',
                    label: 'Denúncias',
                    icon: Icons.report_outlined,
                    cor: AppTheme.primary,
                  ),
                  const SizedBox(width: 12),
                  _StatCard(
                    valor: '${minhasDenuncias.where((d) => d.status == DenunciaStatus.resolvida).length}',
                    label: 'Resolvidas',
                    icon: Icons.check_circle_outline,
                    cor: AppTheme.success,
                  ),
                  const SizedBox(width: 12),
                  _StatCard(
                    valor: '${minhasDenuncias.where((d) => d.status == DenunciaStatus.aberta).length}',
                    label: 'Abertas',
                    icon: Icons.pending_outlined,
                    cor: AppTheme.warning,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // ── Minhas denúncias ────────────────────────────────────────
            SectionHeader(titulo: 'Minhas denúncias'),
            if (minhasDenuncias.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24),
                child: EmptyState(
                  emoji: '📋',
                  titulo: 'Nenhuma denúncia ainda',
                  subtitulo: 'Suas denúncias aparecerão aqui.',
                ),
              )
            else
              ...minhasDenuncias.take(3).map(
                    (d) => DenunciaCard(
                      denuncia: d,
                      onTap: () => context.push('/denuncia/${d.id}'),
                    ),
                  ),

            const SizedBox(height: 8),

            // ── Menu de opções ──────────────────────────────────────────
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Column(
                children: [
                  _MenuItem(
                    icon: Icons.person_outline,
                    label: 'Editar perfil',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 56),
                  _MenuItem(
                    icon: Icons.notifications_outlined,
                    label: 'Preferências de notificação',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 56),
                  _MenuItem(
                    icon: Icons.location_city_outlined,
                    label: 'Alterar área de acompanhamento',
                    onTap: () => context.push('/selecao-area'),
                  ),
                  const Divider(height: 1, indent: 56),
                  _MenuItem(
                    icon: Icons.help_outline,
                    label: 'Ajuda e suporte',
                    onTap: () {},
                  ),
                  const Divider(height: 1, indent: 56),
                  _MenuItem(
                    icon: Icons.logout,
                    label: 'Sair',
                    cor: AppTheme.error,
                    onTap: () {
                      auth.logout();
                      context.go('/login');
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String valor;
  final String label;
  final IconData icon;
  final Color cor;

  const _StatCard({
    required this.valor,
    required this.label,
    required this.icon,
    required this.cor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: cor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: cor.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: cor, size: 22),
            const SizedBox(height: 4),
            Text(
              valor,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: cor,
              ),
            ),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? cor;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.cor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: cor ?? const Color(0xFF6B7280)),
      title: Text(
        label,
        style: TextStyle(color: cor),
      ),
      trailing: const Icon(Icons.chevron_right, color: Color(0xFFD1D5DB)),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
    );
  }
}
