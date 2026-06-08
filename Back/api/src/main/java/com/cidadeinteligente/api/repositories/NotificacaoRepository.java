package com.cidadeinteligente.api.repositories;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.cidadeinteligente.api.entities.Notificacao;
import com.cidadeinteligente.api.entities.Usuario;

public interface NotificacaoRepository extends JpaRepository<Notificacao, Long> {
    List<Notificacao> findByUsuarioOrderByCriadaEmDesc(Usuario usuario);
    long countByUsuarioAndLidaFalse(Usuario usuario);
}