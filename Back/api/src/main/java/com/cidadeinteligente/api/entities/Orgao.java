package com.cidadeinteligente.api.entities;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Data;

@Data
@Entity
@Table(name = "orgaos")
public class Orgao {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false, length = 150)
    private String nome;

    @Column(length = 150)
    private String subtitulo;

    @Column(length = 10)
    private String emoji;

    @Column(nullable = false)
    private Boolean ativo = true;
}