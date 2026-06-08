package com.cidadeinteligente.api.services;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.cidadeinteligente.api.entities.Usuario;
import com.cidadeinteligente.api.repositories.UsuarioRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class UsuarioService {

    private final UsuarioRepository usuarioRepository;
    private final PasswordEncoder passwordEncoder;

    public Usuario cadastrar(String nome, String email, String senha, String telefone, String cidade, String bairro) {
        if (usuarioRepository.existsByEmail(email)) {
            throw new RuntimeException("E-mail já cadastrado");
        }

        Usuario usuario = new Usuario();
        usuario.setNome(nome);
        usuario.setEmail(email);
        usuario.setSenhaHash(passwordEncoder.encode(senha));
        usuario.setTelefone(telefone);
        usuario.setCidade(cidade);
        usuario.setBairroPrincipal(bairro);

        return usuarioRepository.save(usuario);
    }

    public Usuario buscarPorEmail(String email) {
        return usuarioRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado"));
    }

    public Usuario buscarPorId(Long id) {
        return usuarioRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Usuário não encontrado"));
    }
}