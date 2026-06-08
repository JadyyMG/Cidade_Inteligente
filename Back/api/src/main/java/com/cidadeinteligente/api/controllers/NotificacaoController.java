package com.cidadeinteligente.api.controllers;

import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.cidadeinteligente.api.entities.Notificacao;
import com.cidadeinteligente.api.entities.Usuario;
import com.cidadeinteligente.api.services.NotificacaoService;
import com.cidadeinteligente.api.services.UsuarioService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/notificacoes")
@RequiredArgsConstructor
public class NotificacaoController {

    private final NotificacaoService notificacaoService;
    private final UsuarioService usuarioService;

    // Lista notificações do usuário
    @GetMapping("/usuario/{usuarioId}")
    public ResponseEntity<List<Notificacao>> listar(@PathVariable Long usuarioId) {
        Usuario usuario = usuarioService.buscarPorId(usuarioId);
        return ResponseEntity.ok(notificacaoService.listarDoUsuario(usuario));
    }

    // Conta não lidas
    @GetMapping("/usuario/{usuarioId}/nao-lidas")
    public ResponseEntity<?> contarNaoLidas(@PathVariable Long usuarioId) {
        Usuario usuario = usuarioService.buscarPorId(usuarioId);
        return ResponseEntity.ok(Map.of(
            "naoLidas", notificacaoService.contarNaoLidas(usuario)
        ));
    }

    // Marca uma como lida
    @PatchMapping("/{id}/lida")
    public ResponseEntity<?> marcarLida(@PathVariable Long id) {
        notificacaoService.marcarLida(id);
        return ResponseEntity.ok(Map.of("mensagem", "Notificação marcada como lida"));
    }

    // Marca todas como lidas
    @PatchMapping("/usuario/{usuarioId}/todas-lidas")
    public ResponseEntity<?> marcarTodasLidas(@PathVariable Long usuarioId) {
        Usuario usuario = usuarioService.buscarPorId(usuarioId);
        notificacaoService.marcarTodasLidas(usuario);
        return ResponseEntity.ok(Map.of("mensagem", "Todas marcadas como lidas"));
    }
}