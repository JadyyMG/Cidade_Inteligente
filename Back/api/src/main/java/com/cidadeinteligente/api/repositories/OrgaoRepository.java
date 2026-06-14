package com.cidadeinteligente.api.repositories;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.cidadeinteligente.api.entities.Orgao;

public interface OrgaoRepository extends JpaRepository<Orgao, Integer> {
    List<Orgao> findByAtivoTrue();
}