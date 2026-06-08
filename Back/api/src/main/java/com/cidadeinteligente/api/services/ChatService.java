package com.cidadeinteligente.api.services;

import com.cidadeinteligente.api.entities.Chat;
import com.cidadeinteligente.api.entities.Mensagem;
import com.cidadeinteligente.api.entities.Orgao;
import com.cidadeinteligente.api.entities.Usuario;
import com.cidadeinteligente.api.repositories.ChatRepository;
import com.cidadeinteligente.api.repositories.MensagemRepository;
import com.cidadeinteligente.api.repositories.OrgaoRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.time.LocalDateTime;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ChatService {

    private final ChatRepository chatRepository;
    private final MensagemRepository mensagemRepository;
    private final OrgaoRepository orgaoRepository;

    public Chat abrirChat(Usuario usuario, Integer orgaoId) {
        Orgao orgao = orgaoRepository.findById(orgaoId)
                .orElseThrow(() -> new RuntimeException("Órgão não encontrado"));

        Chat chat = new Chat();
        chat.setUsuario(usuario);
        chat.setOrgao(orgao);
        return chatRepository.save(chat);
    }

    public List<Chat> listarDoUsuario(Usuario usuario) {
        return chatRepository.findByUsuario(usuario);
    }

    public Mensagem enviarMensagem(Long chatId, Usuario autor, String texto) {
        Chat chat = chatRepository.findById(chatId)
                .orElseThrow(() -> new RuntimeException("Chat não encontrado"));

        Mensagem mensagem = new Mensagem();
        mensagem.setChat(chat);
        mensagem.setAutor(autor);
        mensagem.setTexto(texto);

        chat.setAtualizadoEm(LocalDateTime.now());
        chatRepository.save(chat);

        return mensagemRepository.save(mensagem);
    }

    public List<Mensagem> listarMensagens(Long chatId) {
        Chat chat = chatRepository.findById(chatId)
                .orElseThrow(() -> new RuntimeException("Chat não encontrado"));
        return mensagemRepository.findByChatOrderByEnviadaEmAsc(chat);
    }
}