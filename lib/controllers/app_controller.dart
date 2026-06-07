// lib/controllers/app_controller.dart
// Controlador principal usando Provider — versão com Mock Data (sem backend)

import 'package:flutter/material.dart';
import '../models/models.dart';

// ── Controlador de Autenticação ────────────────────────────────────────────
class AuthController extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;

  UserModel? get user => _user;
  bool get isLogado => _user != null;
  bool get isFuncionario =>
      _user?.role == UserRole.funcionario || _user?.role == UserRole.admin;
  bool get isLoading => _isLoading;

  Future<bool> login(String email, String senha) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    if (email.isNotEmpty && senha.length >= 6) {
      _user = email.contains('prefeitura') || email.contains('gov')
          ? MockData.funcionario
          : MockData.currentUser;
      _isLoading = false;
      notifyListeners();
      return true;
    }
    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> cadastrar({
    required String nome,
    required String email,
    required String senha,
    required String telefone,
    required String bairro,
  }) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(seconds: 1));
    _user = UserModel(
      id: 'u_new',
      nome: nome,
      email: email,
      telefone: telefone,
      role: UserRole.morador,
      bairro: bairro,
      cidade: 'Caruaru',
    );
    _isLoading = false;
    notifyListeners();
    return true;
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}

// ── Controlador de Denúncias ───────────────────────────────────────────────
class DenunciaController extends ChangeNotifier {
  final List<DenunciaModel> _denuncias = List.from(MockData.denuncias);
  bool _isLoading = false;
  String _filtroStatus = 'todos';
  DenunciaCategoria? _filtroCategoria;

  List<DenunciaModel> get denuncias => _denunciasFiltradas;
  bool get isLoading => _isLoading;
  String get filtroStatus => _filtroStatus;
  DenunciaCategoria? get filtroCategoria => _filtroCategoria;

  List<DenunciaModel> get _denunciasFiltradas {
    var lista = _denuncias.where((d) => d.isPublica).toList();
    if (_filtroStatus != 'todos') {
      lista = lista.where((d) => d.status.key == _filtroStatus).toList();
    }
    if (_filtroCategoria != null) {
      lista = lista.where((d) => d.categoria == _filtroCategoria).toList();
    }
    lista.sort((a, b) => b.criadaEm.compareTo(a.criadaEm));
    return lista;
  }

  List<DenunciaModel> minhasDenuncias(String userId) {
    return _denuncias
        .where((d) => d.autorId == userId)
        .toList()
      ..sort((a, b) => b.criadaEm.compareTo(a.criadaEm));
  }

  DenunciaModel? porId(String id) {
    try {
      return _denuncias.firstWhere((d) => d.id == id);
    } catch (_) {
      return null;
    }
  }

  void setFiltroStatus(String status) {
    _filtroStatus = status;
    notifyListeners();
  }

  void setFiltroCategoria(DenunciaCategoria? categoria) {
    _filtroCategoria = categoria;
    notifyListeners();
  }

  Future<void> carregarDenuncias() async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 500));
    _isLoading = false;
    notifyListeners();
  }

  Future<void> criarDenuncia({
    required String titulo,
    required String descricao,
    required DenunciaCategoria categoria,
    required bool isPublica,
    required String bairro,
    required String endereco,
    required String autorId,
    required String autorNome,
    List<String> fotos = const [],
  }) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 800));
    final nova = DenunciaModel(
      id: 'd${_denuncias.length + 1}',
      titulo: titulo,
      descricao: descricao,
      categoria: categoria,
      status: DenunciaStatus.aberta,
      isPublica: isPublica,
      autorId: autorId,
      autorNome: autorNome,
      bairro: bairro,
      endereco: endereco,
      criadaEm: DateTime.now(),
      fotos: fotos,
    );
    _denuncias.insert(0, nova);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> atualizarStatus({
    required String denunciaId,
    required DenunciaStatus novoStatus,
    String? observacao,
  }) async {
    _isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 600));
    final index = _denuncias.indexWhere((d) => d.id == denunciaId);
    if (index != -1) {
      _denuncias[index] = _denuncias[index].copyWith(
        status: novoStatus,
        observacaoFuncionario: observacao,
        atualizadaEm: DateTime.now(),
      );
    }
    _isLoading = false;
    notifyListeners();
  }
}

// ── Controlador de Chat ────────────────────────────────────────────────────
class ChatController extends ChangeNotifier {
  final List<ChatModel> _chats = List.from(MockData.chats);
  final Map<String, List<MensagemModel>> _mensagens =
      Map.from(MockData.mensagensPorChat);

  List<ChatModel> get chats =>
      _chats..sort((a, b) => b.atualizadoEm.compareTo(a.atualizadoEm));

  int get totalNaoLidas =>
      _chats.fold(0, (sum, c) => sum + c.naoLidas);

  List<MensagemModel> mensagensDoChat(String chatId) =>
      _mensagens[chatId] ?? [];

  void enviarMensagem({
    required String chatId,
    required String texto,
    required String autorId,
    required String autorNome,
  }) {
    final msg = MensagemModel(
      id: 'm${DateTime.now().millisecondsSinceEpoch}',
      chatId: chatId,
      autorId: autorId,
      autorNome: autorNome,
      texto: texto,
      enviadaEm: DateTime.now(),
      isMinhaMsg: true,
    );
    _mensagens.putIfAbsent(chatId, () => []);
    _mensagens[chatId]!.add(msg);
    final index = _chats.indexWhere((c) => c.id == chatId);
    if (index != -1) {
      _chats[index] = ChatModel(
        id: _chats[index].id,
        titulo: _chats[index].titulo,
        subtitulo: _chats[index].subtitulo,
        avatarIcon: _chats[index].avatarIcon,
        naoLidas: 0,
        atualizadoEm: DateTime.now(),
        ultimaMensagem: msg,
      );
    }
    notifyListeners();
    Future.delayed(const Duration(seconds: 2), () => _simularResposta(chatId));
  }

  void _simularResposta(String chatId) {
    final respostas = [
      'Obrigado pelo contato! Sua solicitação foi registrada.',
      'Em breve um atendente entrará em contato.',
      'Já estamos verificando o problema.',
    ];
    final chat = _chats.firstWhere((c) => c.id == chatId,
        orElse: () => _chats.first);
    final resposta = MensagemModel(
      id: 'm${DateTime.now().millisecondsSinceEpoch}',
      chatId: chatId,
      autorId: 'sistema',
      autorNome: chat.titulo,
      texto: respostas[DateTime.now().second % respostas.length],
      enviadaEm: DateTime.now(),
      isMinhaMsg: false,
    );
    _mensagens[chatId]!.add(resposta);
    notifyListeners();
  }
}

// ── Controlador de Notificações ────────────────────────────────────────────
class NotificacaoController extends ChangeNotifier {
  final List<NotificacaoModel> _notificacoes =
      List.from(MockData.notificacoes);

  List<NotificacaoModel> get notificacoes => _notificacoes;
  int get naoLidas => _notificacoes.where((n) => !n.lida).length;

  void marcarLida(String id) {
    final index = _notificacoes.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notificacoes[index] = _notificacoes[index].marcarLida();
      notifyListeners();
    }
  }

  void marcarTodasLidas() {
    for (int i = 0; i < _notificacoes.length; i++) {
      _notificacoes[i] = _notificacoes[i].marcarLida();
    }
    notifyListeners();
  }
}
