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
@Table(name = "denuncias")
public class Denuncia {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "usuario_id", nullable = false)
    private Usuario usuario;

    @ManyToOne
    @JoinColumn(name = "categoria_id", nullable = false)
    private Categoria categoria;

    @Column(nullable = false, length = 200)
    private String titulo;

    @Column(nullable = false, columnDefinition = "TEXT")
    private String descricao;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Status status = Status.ABERTA;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Visibilidade visibilidade = Visibilidade.PUBLICA;

    @Column(nullable = false, length = 100)
    private String bairro;

    @Column(nullable = false, length = 255)
    private String endereco;

    @Column
    private Double latitude;

    @Column
    private Double longitude;

    @Column(nullable = false)
    private Integer curtidas = 0;

    @Column(name = "observacao_funcionario", columnDefinition = "TEXT")
    private String observacaoFuncionario;

    @ManyToOne
    @JoinColumn(name = "funcionario_id")
    private Usuario funcionario;

    @Column(name = "criada_em", nullable = false, updatable = false)
    private LocalDateTime criadaEm = LocalDateTime.now();

    @Column(name = "atualizada_em")
    private LocalDateTime atualizadaEm;

    public enum Status {
        ABERTA, EM_ANDAMENTO, RESOLVIDA, CANCELADA
    }

    public enum Visibilidade {
        PUBLICA, PRIVADA
    }
}