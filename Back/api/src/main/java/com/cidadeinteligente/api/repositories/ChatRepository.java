package com.cidadeinteligente.api.repositories;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.cidadeinteligente.api.entities.Chat;
import com.cidadeinteligente.api.entities.Usuario;

public interface ChatRepository extends JpaRepository<Chat, Long> {
    List<Chat> findByUsuario(Usuario usuario);
}