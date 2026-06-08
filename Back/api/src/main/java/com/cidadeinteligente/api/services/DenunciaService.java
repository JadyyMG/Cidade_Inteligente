package com.cidadeinteligente.api.services;

import java.time.LocalDateTime;
import java.util.List;

import org.springframework.stereotype.Service;

import com.cidadeinteligente.api.entities.Categoria;
import com.cidadeinteligente.api.entities.Denuncia;
import com.cidadeinteligente.api.entities.Usuario;
import com.cidadeinteligente.api.repositories.CategoriaRepository;
import com.cidadeinteligente.api.repositories.DenunciaRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class DenunciaService {

    private final DenunciaRepository denunciaRepository;
    private final CategoriaRepository categoriaRepository;

    public Denuncia criar(Usuario usuario, Integer categoriaId, String titulo,
                          String descricao, String bairro, String endereco,
                          boolean publica) {

        Categoria categoria = categoriaRepository.findById(categoriaId)
                .orElseThrow(() -> new RuntimeException("Categoria não encontrada"));

        Denuncia denuncia = new Denuncia();
        denuncia.setUsuario(usuario);
        denuncia.setCategoria(categoria);
        denuncia.setTitulo(titulo);
        denuncia.setDescricao(descricao);
        denuncia.setBairro(bairro);
        denuncia.setEndereco(endereco);
        denuncia.setVisibilidade(publica
                ? Denuncia.Visibilidade.PUBLICA
                : Denuncia.Visibilidade.PRIVADA);

        return denunciaRepository.save(denuncia);
    }

    public List<Denuncia> listarPublicas() {
        return denunciaRepository.findByVisibilidade(Denuncia.Visibilidade.PUBLICA);
    }

    public List<Denuncia> listarDoUsuario(Usuario usuario) {
        return denunciaRepository.findByUsuario(usuario);
    }

    public Denuncia buscarPorId(Long id) {
        return denunciaRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Denúncia não encontrada"));
    }

    public Denuncia atualizarStatus(Long id, Denuncia.Status novoStatus,
                                     String observacao, Usuario funcionario) {
        Denuncia denuncia = buscarPorId(id);
        denuncia.setStatus(novoStatus);
        denuncia.setObservacaoFuncionario(observacao);
        denuncia.setFuncionario(funcionario);
        denuncia.setAtualizadaEm(LocalDateTime.now());
        return denunciaRepository.save(denuncia);
    }
}