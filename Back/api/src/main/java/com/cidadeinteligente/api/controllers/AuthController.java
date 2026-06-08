package com.cidadeinteligente.api.controllers;

import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.cidadeinteligente.api.entities.Usuario;
import com.cidadeinteligente.api.services.UsuarioService;

import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/auth")
@RequiredArgsConstructor
public class AuthController {

    private final UsuarioService usuarioService;
    private final AuthenticationManager authenticationManager;

    @PostMapping("/cadastro")
    public ResponseEntity<?> cadastrar(@RequestBody Map<String, String> body) {
        try {
            Usuario usuario = usuarioService.cadastrar(
                body.get("nome"),
                body.get("email"),
                body.get("senha"),
                body.get("telefone"),
                body.get("cidade"),
                body.get("bairro")
            );
            return ResponseEntity.ok(Map.of(
                "mensagem", "Usuário cadastrado com sucesso!",
                "id", usuario.getId(),
                "nome", usuario.getNome()
            ));
        } catch (RuntimeException e) {
            return ResponseEntity.badRequest().body(Map.of("erro", e.getMessage()));
        }
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody Map<String, String> body) {
        try {
            authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                    body.get("email"),
                    body.get("senha")
                )
            );
            Usuario usuario = usuarioService.buscarPorEmail(body.get("email"));
            return ResponseEntity.ok(Map.of(
                "mensagem", "Login realizado com sucesso!",
                "id", usuario.getId(),
                "nome", usuario.getNome(),
                "role", usuario.getRole()
            ));
        } catch (Exception e) {
            return ResponseEntity.badRequest().body(Map.of("erro", "E-mail ou senha incorretos"));
        }
    }
}