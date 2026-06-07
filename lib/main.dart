// lib/main.dart
// Ponto de entrada do aplicativo Cidade Inteligente

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/app_controller.dart';
import 'routes/app_router.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(
    // MultiProvider para disponibilizar os controllers globalmente
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => DenunciaController()),
        ChangeNotifierProvider(create: (_) => ChatController()),
        ChangeNotifierProvider(create: (_) => NotificacaoController()),
      ],
      child: const CidadeInteligenteApp(),
    ),
  );
}

class CidadeInteligenteApp extends StatefulWidget {
  const CidadeInteligenteApp({super.key});

  @override
  State<CidadeInteligenteApp> createState() => _CidadeInteligenteAppState();
}

class _CidadeInteligenteAppState extends State<CidadeInteligenteApp> {
  // O router precisa ser construído após os providers estarem disponíveis
  late final _router = buildRouter(context);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Cidade Inteligente',
      debugShowCheckedModeBanner: false,

      // Tema Material Design 3
      theme: AppTheme.lightTheme,

      // Configuração do GoRouter
      routerConfig: _router,
    );
  }
}
