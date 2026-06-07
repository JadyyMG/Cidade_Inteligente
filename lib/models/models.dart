// lib/models/models.dart
// Modelos de dados do aplicativo com mock data para desenvolvimento

// ── Enum: tipos de usuário ─────────────────────────────────────────────────
enum UserRole { morador, funcionario, admin }

// ── Enum: status de denúncia ───────────────────────────────────────────────
enum DenunciaStatus { aberta, em_andamento, resolvida, cancelada }

extension DenunciaStatusExt on DenunciaStatus {
  String get label {
    switch (this) {
      case DenunciaStatus.aberta:
        return 'Aberta';
      case DenunciaStatus.em_andamento:
        return 'Em andamento';
      case DenunciaStatus.resolvida:
        return 'Resolvida';
      case DenunciaStatus.cancelada:
        return 'Cancelada';
    }
  }

  String get key {
    switch (this) {
      case DenunciaStatus.aberta:
        return 'aberta';
      case DenunciaStatus.em_andamento:
        return 'em_andamento';
      case DenunciaStatus.resolvida:
        return 'resolvida';
      case DenunciaStatus.cancelada:
        return 'cancelada';
    }
  }
}

// ── Enum: categoria da denúncia ────────────────────────────────────────────
enum DenunciaCategoria {
  iluminacao,
  buraco,
  lixo,
  agua,
  esgoto,
  transito,
  seguranca,
  outro,
}

extension DenunciaCategoriaExt on DenunciaCategoria {
  String get label {
    const labels = {
      DenunciaCategoria.iluminacao: 'Iluminação',
      DenunciaCategoria.buraco: 'Buraco / Pavimento',
      DenunciaCategoria.lixo: 'Lixo / Entulho',
      DenunciaCategoria.agua: 'Água / Abastecimento',
      DenunciaCategoria.esgoto: 'Esgoto',
      DenunciaCategoria.transito: 'Trânsito / Sinalização',
      DenunciaCategoria.seguranca: 'Segurança',
      DenunciaCategoria.outro: 'Outro',
    };
    return labels[this] ?? 'Outro';
  }

  String get icon {
    const icons = {
      DenunciaCategoria.iluminacao: '💡',
      DenunciaCategoria.buraco: '🕳️',
      DenunciaCategoria.lixo: '🗑️',
      DenunciaCategoria.agua: '💧',
      DenunciaCategoria.esgoto: '🚿',
      DenunciaCategoria.transito: '🚦',
      DenunciaCategoria.seguranca: '🔒',
      DenunciaCategoria.outro: '📋',
    };
    return icons[this] ?? '📋';
  }
}

// ── Model: Usuário ─────────────────────────────────────────────────────────
class UserModel {
  final String id;
  final String nome;
  final String email;
  final String telefone;
  final UserRole role;
  final String? avatarUrl;
  final String bairro;
  final String cidade;

  const UserModel({
    required this.id,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.role,
    this.avatarUrl,
    required this.bairro,
    required this.cidade,
  });

  String get iniciais {
    final partes = nome.split(' ');
    if (partes.length >= 2) {
      return '${partes.first[0]}${partes.last[0]}'.toUpperCase();
    }
    return nome.substring(0, 2).toUpperCase();
  }
}

// ── Model: Denúncia ────────────────────────────────────────────────────────
class DenunciaModel {
  final String id;
  final String titulo;
  final String descricao;
  final DenunciaCategoria categoria;
  final DenunciaStatus status;
  final bool isPublica;
  final String autorId;
  final String autorNome;
  final String bairro;
  final String endereco;
  final DateTime criadaEm;
  final DateTime? atualizadaEm;
  final List<String> fotos;
  final int curtidas;
  final int comentarios;
  final String? observacaoFuncionario;

  const DenunciaModel({
    required this.id,
    required this.titulo,
    required this.descricao,
    required this.categoria,
    required this.status,
    required this.isPublica,
    required this.autorId,
    required this.autorNome,
    required this.bairro,
    required this.endereco,
    required this.criadaEm,
    this.atualizadaEm,
    required this.fotos,
    this.curtidas = 0,
    this.comentarios = 0,
    this.observacaoFuncionario,
  });

  DenunciaModel copyWith({
    DenunciaStatus? status,
    String? observacaoFuncionario,
    DateTime? atualizadaEm,
  }) {
    return DenunciaModel(
      id: id,
      titulo: titulo,
      descricao: descricao,
      categoria: categoria,
      status: status ?? this.status,
      isPublica: isPublica,
      autorId: autorId,
      autorNome: autorNome,
      bairro: bairro,
      endereco: endereco,
      criadaEm: criadaEm,
      atualizadaEm: atualizadaEm ?? this.atualizadaEm,
      fotos: fotos,
      curtidas: curtidas,
      comentarios: comentarios,
      observacaoFuncionario:
          observacaoFuncionario ?? this.observacaoFuncionario,
    );
  }
}

// ── Model: Mensagem do Chat ────────────────────────────────────────────────
class MensagemModel {
  final String id;
  final String chatId;
  final String autorId;
  final String autorNome;
  final String texto;
  final DateTime enviadaEm;
  final bool lida;
  final bool isMinhaMsg; // computed no controller

  const MensagemModel({
    required this.id,
    required this.chatId,
    required this.autorId,
    required this.autorNome,
    required this.texto,
    required this.enviadaEm,
    this.lida = false,
    this.isMinhaMsg = false,
  });
}

// ── Model: Chat ────────────────────────────────────────────────────────────
class ChatModel {
  final String id;
  final String titulo;
  final String subtitulo; // ex: "Prefeitura de Caruaru"
  final String avatarIcon;
  final MensagemModel? ultimaMensagem;
  final int naoLidas;
  final DateTime atualizadoEm;

  const ChatModel({
    required this.id,
    required this.titulo,
    required this.subtitulo,
    required this.avatarIcon,
    this.ultimaMensagem,
    this.naoLidas = 0,
    required this.atualizadoEm,
  });
}

// ── Model: Notificação ─────────────────────────────────────────────────────
enum NotificacaoTipo { denuncia, emergencia, reforma, aviso, resolucao }

class NotificacaoModel {
  final String id;
  final String titulo;
  final String corpo;
  final NotificacaoTipo tipo;
  final bool lida;
  final DateTime criadaEm;
  final String? denunciaId;

  const NotificacaoModel({
    required this.id,
    required this.titulo,
    required this.corpo,
    required this.tipo,
    this.lida = false,
    required this.criadaEm,
    this.denunciaId,
  });

  NotificacaoModel marcarLida() => NotificacaoModel(
        id: id,
        titulo: titulo,
        corpo: corpo,
        tipo: tipo,
        lida: true,
        criadaEm: criadaEm,
        denunciaId: denunciaId,
      );
}

// ═══════════════════════════════════════════════════════════════════════════
// MOCK DATA – usado enquanto não há backend
// ═══════════════════════════════════════════════════════════════════════════

class MockData {
  // Usuário logado
  static const currentUser = UserModel(
    id: 'u1',
    nome: 'João Silva',
    email: 'joao.silva@email.com',
    telefone: '(81) 99999-0001',
    role: UserRole.morador,
    bairro: 'Centro',
    cidade: 'Caruaru',
  );

  // Usuário funcionário (para testar tela do funcionário)
  static const funcionario = UserModel(
    id: 'f1',
    nome: 'Maria Santos',
    email: 'maria.santos@prefeitura.gov.br',
    telefone: '(81) 99999-0002',
    role: UserRole.funcionario,
    bairro: 'Prefeitura',
    cidade: 'Caruaru',
  );

  static final List<DenunciaModel> denuncias = [
    DenunciaModel(
      id: 'd1',
      titulo: 'Poste apagado na Rua das Flores',
      descricao:
          'O poste de iluminação pública no número 150 da Rua das Flores está apagado há mais de uma semana, deixando a rua perigosa à noite.',
      categoria: DenunciaCategoria.iluminacao,
      status: DenunciaStatus.em_andamento,
      isPublica: true,
      autorId: 'u1',
      autorNome: 'João Silva',
      bairro: 'Centro',
      endereco: 'Rua das Flores, 150',
      criadaEm: DateTime.now().subtract(const Duration(days: 3)),
      atualizadaEm: DateTime.now().subtract(const Duration(hours: 5)),
      fotos: [
        'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400',
      ],
      curtidas: 12,
      comentarios: 3,
      observacaoFuncionario: 'Equipe técnica acionada. Previsão: 2 dias úteis.',
    ),
    DenunciaModel(
      id: 'd2',
      titulo: 'Buraco enorme na Av. Principal',
      descricao:
          'Há um buraco de aproximadamente 1 metro na Av. Principal próximo ao semáforo. Já causou acidentes com motos.',
      categoria: DenunciaCategoria.buraco,
      status: DenunciaStatus.aberta,
      isPublica: true,
      autorId: 'u2',
      autorNome: 'Ana Pereira',
      bairro: 'Boa Vista',
      endereco: 'Av. Principal, próx. ao n° 200',
      criadaEm: DateTime.now().subtract(const Duration(days: 1)),
      fotos: [
        'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=400',
      ],
      curtidas: 47,
      comentarios: 8,
    ),
    DenunciaModel(
      id: 'd3',
      titulo: 'Lixo acumulado no Beco da Paz',
      descricao:
          'Acúmulo de lixo e entulho no beco há mais de 10 dias. Mau cheiro e risco de doenças.',
      categoria: DenunciaCategoria.lixo,
      status: DenunciaStatus.resolvida,
      isPublica: true,
      autorId: 'u3',
      autorNome: 'Carlos Oliveira',
      bairro: 'São João',
      endereco: 'Beco da Paz, s/n',
      criadaEm: DateTime.now().subtract(const Duration(days: 7)),
      atualizadaEm: DateTime.now().subtract(const Duration(days: 1)),
      fotos: [],
      curtidas: 5,
      comentarios: 2,
      observacaoFuncionario: 'Limpeza realizada com sucesso. Área monitorada.',
    ),
    DenunciaModel(
      id: 'd4',
      titulo: 'Falta de água no bairro Novo',
      descricao:
          'O bairro Novo está sem água há 3 dias. Empresa de saneamento não deu retorno.',
      categoria: DenunciaCategoria.agua,
      status: DenunciaStatus.aberta,
      isPublica: true,
      autorId: 'u4',
      autorNome: 'Fernanda Lima',
      bairro: 'Bairro Novo',
      endereco: 'Bairro Novo (geral)',
      criadaEm: DateTime.now().subtract(const Duration(hours: 12)),
      fotos: [],
      curtidas: 93,
      comentarios: 21,
    ),
    DenunciaModel(
      id: 'd5',
      titulo: 'Semáforo quebrado - Risco de acidente',
      descricao:
          'Semáforo da esquina das ruas Barão e São Paulo está quebrado e piscando em amarelo 24h.',
      categoria: DenunciaCategoria.transito,
      status: DenunciaStatus.em_andamento,
      isPublica: true,
      autorId: 'u5',
      autorNome: 'Roberto Mendes',
      bairro: 'Centro',
      endereco: 'Rua Barão c/ Rua São Paulo',
      criadaEm: DateTime.now().subtract(const Duration(days: 2)),
      fotos: [],
      curtidas: 28,
      comentarios: 6,
    ),
  ];

  static final List<ChatModel> chats = [
    ChatModel(
      id: 'c1',
      titulo: 'Prefeitura de Caruaru',
      subtitulo: 'Suporte Geral',
      avatarIcon: '🏛️',
      naoLidas: 2,
      atualizadoEm: DateTime.now().subtract(const Duration(minutes: 15)),
      ultimaMensagem: MensagemModel(
        id: 'm_last_1',
        chatId: 'c1',
        autorId: 'pref',
        autorNome: 'Prefeitura',
        texto: 'Sua solicitação foi recebida e está sendo analisada.',
        enviadaEm: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
    ),
    ChatModel(
      id: 'c2',
      titulo: 'COMPESA',
      subtitulo: 'Água e Saneamento',
      avatarIcon: '💧',
      naoLidas: 0,
      atualizadoEm: DateTime.now().subtract(const Duration(hours: 2)),
      ultimaMensagem: MensagemModel(
        id: 'm_last_2',
        chatId: 'c2',
        autorId: 'u1',
        autorNome: 'João Silva',
        texto: 'Obrigado pelo atendimento!',
        enviadaEm: DateTime.now().subtract(const Duration(hours: 2)),
      ),
    ),
    ChatModel(
      id: 'c3',
      titulo: 'CELPE',
      subtitulo: 'Energia Elétrica',
      avatarIcon: '⚡',
      naoLidas: 1,
      atualizadoEm: DateTime.now().subtract(const Duration(hours: 5)),
      ultimaMensagem: MensagemModel(
        id: 'm_last_3',
        chatId: 'c3',
        autorId: 'celpe',
        autorNome: 'CELPE',
        texto: 'Equipe enviada para verificação do poste.',
        enviadaEm: DateTime.now().subtract(const Duration(hours: 5)),
      ),
    ),
  ];

  static Map<String, List<MensagemModel>> mensagensPorChat = {
    'c1': [
      MensagemModel(
        id: 'm1',
        chatId: 'c1',
        autorId: 'u1',
        autorNome: 'João Silva',
        texto: 'Olá, gostaria de saber sobre o status da denúncia do poste.',
        enviadaEm: DateTime.now().subtract(const Duration(hours: 1)),
        lida: true,
        isMinhaMsg: true,
      ),
      MensagemModel(
        id: 'm2',
        chatId: 'c1',
        autorId: 'pref',
        autorNome: 'Prefeitura',
        texto:
            'Olá, João! Identificamos sua denúncia no sistema. A equipe de manutenção foi acionada.',
        enviadaEm:
            DateTime.now().subtract(const Duration(minutes: 45)),
        lida: true,
        isMinhaMsg: false,
      ),
      MensagemModel(
        id: 'm3',
        chatId: 'c1',
        autorId: 'pref',
        autorNome: 'Prefeitura',
        texto: 'Sua solicitação foi recebida e está sendo analisada.',
        enviadaEm:
            DateTime.now().subtract(const Duration(minutes: 15)),
        lida: false,
        isMinhaMsg: false,
      ),
    ],
  };

  static final List<NotificacaoModel> notificacoes = [
    NotificacaoModel(
      id: 'n1',
      titulo: '🔧 Denúncia atualizada',
      corpo: 'Sua denúncia "Poste apagado na Rua das Flores" está em andamento.',
      tipo: NotificacaoTipo.denuncia,
      lida: false,
      criadaEm: DateTime.now().subtract(const Duration(hours: 2)),
      denunciaId: 'd1',
    ),
    NotificacaoModel(
      id: 'n2',
      titulo: '⚠️ Emergência no bairro',
      corpo:
          'Interdição temporária na Av. Norte para reparo de tubulação. Previsão: 48h.',
      tipo: NotificacaoTipo.emergencia,
      lida: false,
      criadaEm: DateTime.now().subtract(const Duration(hours: 4)),
    ),
    NotificacaoModel(
      id: 'n3',
      titulo: '✅ Problema resolvido',
      corpo: 'A denúncia de lixo no Beco da Paz foi resolvida com sucesso.',
      tipo: NotificacaoTipo.resolucao,
      lida: true,
      criadaEm: DateTime.now().subtract(const Duration(days: 1)),
      denunciaId: 'd3',
    ),
    NotificacaoModel(
      id: 'n4',
      titulo: '🏗️ Reforma programada',
      corpo:
          'Recapeamento da Rua das Palmeiras começa segunda-feira. Desvio pelo Beco Verde.',
      tipo: NotificacaoTipo.reforma,
      lida: true,
      criadaEm: DateTime.now().subtract(const Duration(days: 2)),
    ),
    NotificacaoModel(
      id: 'n5',
      titulo: '📢 Aviso da Prefeitura',
      corpo:
          'Coleta de lixo suspensa na quinta-feira por conta do feriado municipal.',
      tipo: NotificacaoTipo.aviso,
      lida: true,
      criadaEm: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];
}
