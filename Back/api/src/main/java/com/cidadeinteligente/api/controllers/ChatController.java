package com.cidadeinteligente.api.controllers;

import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.cidadeinteligente.api.entities.Chat;
import com.cidadeinteligente.api.entities.Mensagem;
import com.cidadeinteligente.api.entities.Usuario;
import com.cidadeinteligente.api.services.ChatService;
import com.cidadeinteligente.api.services.UsuarioService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/chats")
@RequiredArgsConstructor
public class ChatController {

    private final ChatService chatService;
    private final UsuarioService usuarioService;

    // Lista chats do usuário
    @GetMapping("/usuario/{usuarioId}")
    public ResponseEntity<List<Chat>> listar(@PathVariable Long usuarioId) {
        Usuario usuario = usuarioService.buscarPorId(usuarioId);
        return ResponseEntity.ok(chatService.listarDoUsuario(usuario));
    }

    // Abre novo chat
    @PostMapping
    public ResponseEntity<?> abrir(@RequestBody Map<String, Object> body) {
        try {
            Usuario usuario = usuarioService.buscarPorId(
                Long.parseLong(body.get("usuarioId").toString())
            );
            Chat chat = chatService.abrirChat(
                usuario,
                Integer.parseInt(body.get("orgaoId").toString())
            );
            return ResponseEntity.ok(Map.of(
                "mensagem", "Chat aberto!",
                "chatId", chat.getId()
            ));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(Map.of("erro", e.getMessage()));
        }
    }

    // Lista mensagens de um chat
    @GetMapping("/{chatId}/mensagens")
    public ResponseEntity<List<Mensagem>> mensagens(@PathVariable Long chatId) {
        return ResponseEntity.ok(chatService.listarMensagens(chatId));
    }

    // Envia mensagem
    @PostMapping("/{chatId}/mensagens")
    public ResponseEntity<?> enviar(
            @PathVariable Long chatId,
            @RequestBody Map<String, Object> body) {
        try {
            Usuario autor = usuarioService.buscarPorId(
                Long.parseLong(body.get("autorId").toString())
            );
            Mensagem mensagem = chatService.enviarMensagem(
                chatId, autor, body.get("texto").toString()
            );
            return ResponseEntity.ok(Map.of(
                "mensagem", "Mensagem enviada!",
                "id", mensagem.getId()
            ));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(Map.of("erro", e.getMessage()));
        }
    }
}