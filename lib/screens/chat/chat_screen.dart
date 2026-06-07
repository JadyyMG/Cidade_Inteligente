// lib/screens/chat/chat_screen.dart
// Tela de chat individual com prefeitura ou empresa

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../controllers/app_controller.dart';
import '../../models/models.dart';
import '../../theme/app_theme.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String titulo;

  const ChatScreen({
    super.key,
    required this.chatId,
    required this.titulo,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _msgCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  bool _enviando = false;

  @override
  void dispose() {
    _msgCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _enviar() {
    final texto = _msgCtrl.text.trim();
    if (texto.isEmpty) return;

    final auth = context.read<AuthController>();
    final chatCtrl = context.read<ChatController>();
    final user = auth.user!;

    _msgCtrl.clear();

    chatCtrl.enviarMensagem(
      chatId: widget.chatId,
      texto: texto,
      autorId: user.id,
      autorNome: user.nome,
    );

    // Scrolla para o final
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatCtrl = context.watch<ChatController>();
    final mensagens = chatCtrl.mensagensDoChat(widget.chatId);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        title: Row(
          children: [
            // Avatar do chat
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: Center(
                child: Text(
                  _emojiDoChat(widget.chatId),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.titulo,
                    style: const TextStyle(fontSize: 15)),
                const Text(
                  '● Online',
                  style: TextStyle(
                      fontSize: 11, color: AppTheme.success),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // ── Lista de mensagens ───────────────────────────────────────
          Expanded(
            child: mensagens.isEmpty
                ? _ChatVazio(titulo: widget.titulo)
                : ListView.builder(
                    controller: _scrollCtrl,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 16),
                    itemCount: mensagens.length,
                    itemBuilder: (context, index) {
                      final msg = mensagens[index];
                      final anterior = index > 0 ? mensagens[index - 1] : null;
                      final mesmoDono = anterior?.autorId == msg.autorId;

                      return _BolhaMensagem(
                        mensagem: msg,
                        mostrarAvatar: !mesmoDono,
                      );
                    },
                  ),
          ),

          // ── Campo de digitação ───────────────────────────────────────
          _CampoMensagem(
            controller: _msgCtrl,
            onEnviar: _enviar,
          ),
        ],
      ),
    );
  }

  String _emojiDoChat(String chatId) {
    const map = {'c1': '🏛️', 'c2': '💧', 'c3': '⚡'};
    return map[chatId] ?? '💬';
  }
}

// ── Bolha de mensagem ──────────────────────────────────────────────────────
class _BolhaMensagem extends StatelessWidget {
  final MensagemModel mensagem;
  final bool mostrarAvatar;

  const _BolhaMensagem({
    required this.mensagem,
    required this.mostrarAvatar,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMinha = mensagem.isMinhaMsg;

    return Padding(
      padding: EdgeInsets.only(
        bottom: mostrarAvatar ? 12 : 3,
        left: isMinha ? 48 : 0,
        right: isMinha ? 0 : 48,
      ),
      child: Row(
        mainAxisAlignment:
            isMinha ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Avatar do remetente (apenas quando muda)
          if (!isMinha)
            mostrarAvatar
                ? Container(
                    width: 28,
                    height: 28,
                    margin: const EdgeInsets.only(right: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.primary.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        mensagem.autorNome.substring(0, 1),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                  )
                : const SizedBox(width: 34),

          // Bolha
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isMinha ? AppTheme.primary : AppTheme.cardBg,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft:
                      Radius.circular(isMinha ? 16 : 4),
                  bottomRight:
                      Radius.circular(isMinha ? 4 : 16),
                ),
                border: isMinha
                    ? null
                    : Border.all(color: const Color(0xFFE8EDF2)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    mensagem.texto,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isMinha ? Colors.white : null,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    _formatarHora(mensagem.enviadaEm),
                    style: TextStyle(
                      fontSize: 10,
                      color: isMinha
                          ? Colors.white70
                          : const Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatarHora(DateTime data) {
    final h = data.hour.toString().padLeft(2, '0');
    final m = data.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}

// ── Campo de digitação ─────────────────────────────────────────────────────
class _CampoMensagem extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onEnviar;

  const _CampoMensagem({
    required this.controller,
    required this.onEnviar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        border: const Border(
            top: BorderSide(color: Color(0xFFEAEDF0))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Anexo
            IconButton(
              icon: const Icon(Icons.attach_file),
              color: Colors.grey,
              onPressed: () {},
            ),
            // Campo de texto
            Expanded(
              child: TextField(
                controller: controller,
                maxLines: 4,
                minLines: 1,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: 'Digite sua mensagem...',
                  filled: true,
                  fillColor: AppTheme.surface,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppRadius.full),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppRadius.full),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (_) => onEnviar(),
              ),
            ),
            const SizedBox(width: 8),
            // Botão enviar
            Container(
              decoration: const BoxDecoration(
                color: AppTheme.primary,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.send_rounded),
                color: Colors.white,
                onPressed: onEnviar,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Estado vazio do chat ───────────────────────────────────────────────────
class _ChatVazio extends StatelessWidget {
  final String titulo;

  const _ChatVazio({required this.titulo});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('💬', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text(
            'Inicie a conversa com\n$titulo',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Tempo médio de resposta: 2 horas úteis',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
