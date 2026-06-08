package com.cidadeinteligente.api.services;

import java.util.List;

import org.springframework.stereotype.Service;

import com.cidadeinteligente.api.entities.Denuncia;
import com.cidadeinteligente.api.entities.Notificacao;
import com.cidadeinteligente.api.entities.Usuario;
import com.cidadeinteligente.api.repositories.NotificacaoRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class NotificacaoService {

    private final NotificacaoRepository notificacaoRepository;

    public List<Notificacao> listarDoUsuario(Usuario usuario) {
        return notificacaoRepository.findByUsuarioOrderByCriadaEmDesc(usuario);
    }

    public long contarNaoLidas(Usuario usuario) {
        return notificacaoRepository.countByUsuarioAndLidaFalse(usuario);
    }

    public void marcarLida(Long id) {
        Notificacao notificacao = notificacaoRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Notificação não encontrada"));
        notificacao.setLida(true);
        notificacaoRepository.save(notificacao);
    }

    public void marcarTodasLidas(Usuario usuario) {
        List<Notificacao> lista = notificacaoRepository
                .findByUsuarioOrderByCriadaEmDesc(usuario);
        lista.forEach(n -> n.setLida(true));
        notificacaoRepository.saveAll(lista);
    }

    // Cria notificação automaticamente quando status de denúncia muda
    public void notificarAtualizacaoStatus(Usuario usuario, Denuncia denuncia) {
        Notificacao notificacao = new Notificacao();
        notificacao.setUsuario(usuario);
        notificacao.setTitulo("Denúncia atualizada");
        notificacao.setCorpo("Sua denúncia \"" + denuncia.getTitulo()
                + "\" teve o status alterado para: " + denuncia.getStatus().name());
        notificacao.setTipo(Notificacao.Tipo.DENUNCIA);
        notificacao.setDenuncia(denuncia);
        notificacaoRepository.save(notificacao);
    }
}