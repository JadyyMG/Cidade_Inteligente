package com.cidadeinteligente.api.repositories;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.cidadeinteligente.api.entities.Chat;
import com.cidadeinteligente.api.entities.Mensagem;

public interface MensagemRepository extends JpaRepository<Mensagem, Long> {
    List<Mensagem> findByChatOrderByEnviadaEmAsc(Chat chat);
}