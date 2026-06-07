// lib/screens/chat/historico_chats_screen.dart
// Tela com histórico de todos os chats do usuário

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../controllers/app_controller.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';
import '../../widgets/widgets.dart';

class HistoricoChatsScreen extends StatelessWidget {
  const HistoricoChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final chatCtrl = context.watch<ChatController>();
    final chats = chatCtrl.chats;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Suporte'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_comment_outlined),
            tooltip: 'Novo chat',
            onPressed: () => _mostrarNovoChat(context),
          ),
        ],
      ),
      body: chats.isEmpty
          ? const EmptyState(
              emoji: '💬',
              titulo: 'Nenhuma conversa',
              subtitulo:
                  'Inicie um chat com a Prefeitura\nou uma empresa de serviços.',
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: chats.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, indent: 72),
              itemBuilder: (context, index) =>
                  _ChatTile(chat: chats[index]),
            ),
    );
  }

  void _mostrarNovoChat(BuildContext context) {
    final opcoes = [
      {'titulo': 'Prefeitura de Caruaru', 'icon': '🏛️', 'id': 'c1'},
      {'titulo': 'COMPESA - Água', 'icon': '💧', 'id': 'c2'},
      {'titulo': 'CELPE - Energia', 'icon': '⚡', 'id': 'c3'},
      {'titulo': 'EMLUR - Limpeza', 'icon': '🗑️', 'id': 'c4'},
    ];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Com quem deseja falar?',
                style: Theme.of(ctx).textTheme.titleLarge),
            const SizedBox(height: 16),
            ...opcoes.map(
              (o) => ListTile(
                leading: Text(o['icon']!,
                    style: const TextStyle(fontSize: 24)),
                title: Text(o['titulo']!),
                onTap: () {
                  Navigator.pop(ctx);
                  context.push(
                      '/chat/${o['id']}?titulo=${o['titulo']}');
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.sm)),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// ── Tile de chat na lista ──────────────────────────────────────────────────
class _ChatTile extends StatelessWidget {
  final ChatModel chat;

  const _ChatTile({required this.chat});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final temMsgNaoLida = chat.naoLidas > 0;

    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppTheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: Center(
          child: Text(chat.avatarIcon,
              style: const TextStyle(fontSize: 22)),
        ),
      ),
      title: Text(
        chat.titulo,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight:
              temMsgNaoLida ? FontWeight.w700 : FontWeight.w500,
        ),
      ),
      subtitle: Row(
        children: [
          if (chat.ultimaMensagem?.isMinhaMsg == true)
            const Padding(
              padding: EdgeInsets.only(right: 3),
              child: Icon(Icons.done_all,
                  size: 14, color: AppTheme.primary),
            ),
          Expanded(
            child: Text(
              chat.ultimaMensagem?.texto ?? 'Nenhuma mensagem',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight:
                    temMsgNaoLida ? FontWeight.w500 : null,
                color: temMsgNaoLida
                    ? const Color(0xFF374151)
                    : null,
              ),
            ),
          ),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _formatarHora(chat.atualizadoEm),
            style: theme.textTheme.bodySmall?.copyWith(
              color: temMsgNaoLida ? AppTheme.primary : null,
              fontWeight: temMsgNaoLida ? FontWeight.w600 : null,
            ),
          ),
          if (temMsgNaoLida) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Text(
                '${chat.naoLidas}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ],
      ),
      onTap: () =>
          context.push('/chat/${chat.id}?titulo=${chat.titulo}'),
    );
  }

  String _formatarHora(DateTime data) {
    final diff = DateTime.now().difference(data);
    if (diff.inMinutes < 60) return '${diff.inMinutes}min';
    if (diff.inHours < 24) {
      final h = data.hour.toString().padLeft(2, '0');
      final m = data.minute.toString().padLeft(2, '0');
      return '$h:$m';
    }
    return '${data.day}/${data.month}';
  }
}
