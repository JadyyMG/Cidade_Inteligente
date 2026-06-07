// lib/routes/app_router.dart
// Configuração de navegação com GoRouter

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../controllers/app_controller.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/cadastro_screen.dart';
import '../screens/area/selecao_area_screen.dart';
import '../screens/home/home_shell.dart';
import '../screens/home/feed_screen.dart';
import '../screens/denuncia/criar_denuncia_screen.dart';
import '../screens/denuncia/detalhe_denuncia_screen.dart';
import '../screens/chat/chat_screen.dart';
import '../screens/chat/historico_chats_screen.dart';
import '../screens/notificacoes/notificacoes_screen.dart';
import '../screens/perfil/perfil_screen.dart';
import '../screens/funcionario/painel_funcionario_screen.dart';

// Chave global para o Navigator raiz
final _rootNavigatorKey = GlobalKey<NavigatorState>();
// Chave para o shell (tab navigation)
final _shellNavigatorKey = GlobalKey<NavigatorState>();

GoRouter buildRouter(BuildContext context) {
  final authController =
      Provider.of<AuthController>(context, listen: false);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/login',
    debugLogDiagnostics: false,

    // Redireciona se não estiver logado
    redirect: (context, state) {
      final isLogado = authController.isLogado;
      final isAuthRoute = state.matchedLocation.startsWith('/login') ||
          state.matchedLocation.startsWith('/cadastro') ||
          state.matchedLocation.startsWith('/selecao-area');

      if (!isLogado && !isAuthRoute) return '/login';
      if (isLogado && state.matchedLocation == '/login') return '/home';
      return null;
    },

    // Ouve mudanças de auth para redirecionar
    refreshListenable: authController,

    routes: [
      // ── Auth ──────────────────────────────────────────────────────────
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/cadastro',
        builder: (context, state) => const CadastroScreen(),
      ),
      GoRoute(
        path: '/selecao-area',
        builder: (context, state) => const SelecaoAreaScreen(),
      ),

      // ── Shell com BottomNav ────────────────────────────────────────────
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) =>
            HomeShell(child: child, location: state.matchedLocation),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const FeedScreen(),
          ),
          GoRoute(
            path: '/chats',
            builder: (context, state) => const HistoricoChatsScreen(),
          ),
          GoRoute(
            path: '/notificacoes',
            builder: (context, state) => const NotificacoesScreen(),
          ),
          GoRoute(
            path: '/perfil',
            builder: (context, state) => const PerfilScreen(),
          ),
        ],
      ),

      // ── Rotas sem BottomNav ────────────────────────────────────────────
      GoRoute(
        path: '/criar-denuncia',
        builder: (context, state) => const CriarDenunciaScreen(),
      ),
      GoRoute(
        path: '/denuncia/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return DetalheDenunciaScreen(denunciaId: id);
        },
      ),
      GoRoute(
        path: '/chat/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          final titulo =
              state.uri.queryParameters['titulo'] ?? 'Chat';
          return ChatScreen(chatId: id, titulo: titulo);
        },
      ),
      GoRoute(
        path: '/funcionario',
        builder: (context, state) => const PainelFuncionarioScreen(),
      ),
    ],

    // Tela de erro
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Página não encontrada',
                style: Theme.of(context).textTheme.headlineSmall),
            TextButton(
              onPressed: () => context.go('/home'),
              child: const Text('Voltar ao início'),
            ),
          ],
        ),
      ),
    ),
  );
}
