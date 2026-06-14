package com.cidadeinteligente.api.repositories;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.cidadeinteligente.api.entities.Bairro;

public interface BairroRepository extends JpaRepository<Bairro, Integer> {
    List<Bairro> findByCidade(String cidade);
}