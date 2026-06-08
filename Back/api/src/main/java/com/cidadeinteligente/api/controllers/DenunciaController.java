package com.cidadeinteligente.api.controllers;

import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.cidadeinteligente.api.entities.Denuncia;
import com.cidadeinteligente.api.entities.Usuario;
import com.cidadeinteligente.api.services.DenunciaService;
import com.cidadeinteligente.api.services.NotificacaoService;
import com.cidadeinteligente.api.services.UsuarioService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/denuncias")
@RequiredArgsConstructor
public class DenunciaController {

    private final DenunciaService denunciaService;
    private final UsuarioService usuarioService;
    private final NotificacaoService notificacaoService;

    // Lista todas as denúncias públicas
    @GetMapping
    public ResponseEntity<List<Denuncia>> listar() {
        return ResponseEntity.ok(denunciaService.listarPublicas());
    }

    // Busca uma denúncia por ID
    @GetMapping("/{id}")
    public ResponseEntity<?> buscar(@PathVariable Long id) {
        try {
            return ResponseEntity.ok(denunciaService.buscarPorId(id));
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }

    // Lista denúncias do usuário logado
    @GetMapping("/minhas/{usuarioId}")
    public ResponseEntity<List<Denuncia>> minhas(@PathVariable Long usuarioId) {
        Usuario usuario = usuarioService.buscarPorId(usuarioId);
        return ResponseEntity.ok(denunciaService.listarDoUsuario(usuario));
    }

    // Cria nova denúncia
    @PostMapping
    public ResponseEntity<?> criar(@RequestBody Map<String, Object> body) {
        try {
            Usuario usuario = usuarioService.buscarPorId(
                Long.parseLong(body.get("usuarioId").toString())
            );
            Denuncia denuncia = denunciaService.criar(
                usuario,
                Integer.parseInt(body.get("categoriaId").toString()),
                body.get("titulo").toString(),
                body.get("descricao").toString(),
                body.get("bairro").toString(),
                body.get("endereco").toString(),
                Boolean.parseBoolean(body.get("publica").toString())
            );
            return ResponseEntity.ok(Map.of(
                "mensagem", "Denúncia registrada!",
                "protocolo", denuncia.getId()
            ));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(Map.of("erro", e.getMessage()));
        }
    }

    // Atualiza status (funcionário)
    @PatchMapping("/{id}/status")
    public ResponseEntity<?> atualizarStatus(
            @PathVariable Long id,
            @RequestBody Map<String, Object> body) {
        try {
            Usuario funcionario = usuarioService.buscarPorId(
                Long.parseLong(body.get("funcionarioId").toString())
            );
            Denuncia.Status novoStatus = Denuncia.Status.valueOf(
                body.get("status").toString()
            );
            Denuncia denuncia = denunciaService.atualizarStatus(
                id, novoStatus,
                body.get("observacao") != null ? body.get("observacao").toString() : null,
                funcionario
            );
            // Notifica o autor da denúncia
            notificacaoService.notificarAtualizacaoStatus(denuncia.getUsuario(), denuncia);

            return ResponseEntity.ok(Map.of(
                "mensagem", "Status atualizado!",
                "status", denuncia.getStatus()
            ));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(Map.of("erro", e.getMessage()));
        }
    }
}