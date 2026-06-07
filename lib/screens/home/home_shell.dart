// lib/screens/home/home_shell.dart
// Shell que envolve as telas principais com BottomNavigationBar

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../controllers/app_controller.dart';
import '../../theme/app_theme.dart';

class HomeShell extends StatelessWidget {
  final Widget child;
  final String location;

  const HomeShell({
    super.key,
    required this.child,
    required this.location,
  });

  // Retorna o índice ativo com base na rota atual
  int _indexAtivo() {
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/chats')) return 1;
    if (location.startsWith('/notificacoes')) return 2;
    if (location.startsWith('/perfil')) return 3;
    return 0;
  }

  void _navegar(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/chats');
        break;
      case 2:
        context.go('/notificacoes');
        break;
      case 3:
        context.go('/perfil');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatCtrl = context.watch<ChatController>();
    final notifCtrl = context.watch<NotificacaoController>();
    final index = _indexAtivo();

    return Scaffold(
      body: child,

      // ── FAB: criar denúncia ────────────────────────────────────────────
      floatingActionButton: index == 0
          ? FloatingActionButton.extended(
              onPressed: () => context.push('/criar-denuncia'),
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add),
              label: const Text('Denunciar'),
              elevation: 3,
            )
          : null,
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,

      // ── Bottom Navigation ──────────────────────────────────────────────
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) => _navegar(context, i),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Início',
          ),
          NavigationDestination(
            icon: _BadgeIcon(
              icon: Icons.chat_bubble_outline,
              count: chatCtrl.totalNaoLidas,
            ),
            selectedIcon: _BadgeIcon(
              icon: Icons.chat_bubble,
              count: chatCtrl.totalNaoLidas,
            ),
            label: 'Chats',
          ),
          NavigationDestination(
            icon: _BadgeIcon(
              icon: Icons.notifications_outlined,
              count: notifCtrl.naoLidas,
            ),
            selectedIcon: _BadgeIcon(
              icon: Icons.notifications,
              count: notifCtrl.naoLidas,
            ),
            label: 'Avisos',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outlined),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

/// Ícone com badge de contagem
class _BadgeIcon extends StatelessWidget {
  final IconData icon;
  final int count;

  const _BadgeIcon({required this.icon, required this.count});

  @override
  Widget build(BuildContext context) {
    return Badge(
      isLabelVisible: count > 0,
      label: Text('$count', style: const TextStyle(fontSize: 10)),
      backgroundColor: AppTheme.error,
      child: Icon(icon),
    );
  }
}
