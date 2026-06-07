// lib/screens/notificacoes/notificacoes_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../controllers/app_controller.dart';
import '../../theme/app_theme.dart';
import '../../widgets/widgets.dart';

class NotificacoesScreen extends StatelessWidget {
  const NotificacoesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = context.watch<NotificacaoController>();
    final notifs = ctrl.notificacoes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificações'),
        actions: [
          if (ctrl.naoLidas > 0)
            TextButton(
              onPressed: ctrl.marcarTodasLidas,
              child: const Text('Marcar todas lidas'),
            ),
        ],
      ),
      body: notifs.isEmpty
          ? const EmptyState(
              emoji: '🔔',
              titulo: 'Sem notificações',
              subtitulo: 'Você será avisado sobre\nproblemas e atualizações da sua área.',
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: notifs.length,
              itemBuilder: (context, index) => NotificacaoCard(
                notificacao: notifs[index],
                onTap: () {
                  ctrl.marcarLida(notifs[index].id);
                  if (notifs[index].denunciaId != null) {
                    context.push('/denuncia/${notifs[index].denunciaId}');
                  }
                },
              ),
            ),
    );
  }
}
