package com.cidadeinteligente.api.repositories;

import org.springframework.data.jpa.repository.JpaRepository;

import com.cidadeinteligente.api.entities.Categoria;

public interface CategoriaRepository extends JpaRepository<Categoria, Integer> {
}