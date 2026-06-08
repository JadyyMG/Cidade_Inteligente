package com.cidadeinteligente.api.entities;

import java.time.LocalDateTime;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.Data;

@Data
@Entity
@Table(name = "notificacoes")
public class Notificacao {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "usuario_id", nullable = false)
    private Usuario usuario;

    @Column(nullable = false, length = 200)
    private String titulo;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String corpo;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Tipo tipo;

    @Column(nullable = false)
    private Boolean lida = false;

    @ManyToOne
    @JoinColumn(name = "denuncia_id")
    private Denuncia denuncia;

    @Column(name = "criada_em", nullable = false, updatable = false)
    private LocalDateTime criadaEm = LocalDateTime.now();

    public enum Tipo {
        DENUNCIA, EMERGENCIA, REFORMA, AVISO, RESOLUCAO
    }
}