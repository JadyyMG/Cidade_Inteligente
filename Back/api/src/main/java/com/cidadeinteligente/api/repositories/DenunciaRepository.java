package com.cidadeinteligente.api.repositories;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.cidadeinteligente.api.entities.Denuncia;
import com.cidadeinteligente.api.entities.Usuario;

public interface DenunciaRepository extends JpaRepository<Denuncia, Long> {
    List<Denuncia> findByVisibilidade(Denuncia.Visibilidade visibilidade);
    List<Denuncia> findByUsuario(Usuario usuario);
    List<Denuncia> findByStatus(Denuncia.Status status);
    List<Denuncia> findByBairro(String bairro);
}