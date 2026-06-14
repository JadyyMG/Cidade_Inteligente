import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8080';


  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // AUTENTICAÇÃO

  Future<Map<String, dynamic>> cadastrar({
    required String nome,
    required String email,
    required String senha,
    required String telefone,
    required String cidade,
    required String bairro,
  }) async {
    final body = jsonEncode({
      'nome': nome,
      'email': email,
      'senha': senha,
      'telefone': telefone,
      'cidade': cidade,
      'bairro': bairro,
    });

    final response = await http.post(
      Uri.parse('$baseUrl/auth/cadastro'),
      headers: _headers,
      body: body,
    ).timeout(
      const Duration(seconds: 10),
      onTimeout: () => throw Exception('Servidor não respondeu'),
    );

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (data.containsKey('erro')) throw Exception(data['erro']);

    return data;
  }

Future<Map<String, dynamic>> login({
    required String email,
    required String senha,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: _headers,
        body: jsonEncode({'email': email, 'senha': senha}),
      ).timeout(const Duration(seconds: 10),
          onTimeout: () => throw Exception('Servidor não respondeu'));

      // Adicione estas linhas para ver o que está chegando
      debugPrint('STATUS LOGIN: ${response.statusCode}');
      debugPrint('BODY LOGIN: ${response.body}');

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (data.containsKey('erro')) throw Exception(data['erro']);
      return data;

    } catch (e) {
      debugPrint('ERRO LOGIN: $e');
      rethrow;
    }
  }
  
  // DENÚNCIAS

  Future<List<dynamic>> listarDenuncias() async {
    final response = await http.get(
      Uri.parse('$baseUrl/denuncias'),
      headers: _headers,
    ).timeout(const Duration(seconds: 10),
        onTimeout: () => throw Exception('Servidor não respondeu'));

    if (response.statusCode != 200) {
      throw Exception('Erro ao buscar denúncias');
    }

    return jsonDecode(response.body) as List<dynamic>;
  }

  Future<List<dynamic>> minhasDenuncias(int usuarioId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/denuncias/minhas/$usuarioId'),
      headers: _headers,
    ).timeout(const Duration(seconds: 10),
        onTimeout: () => throw Exception('Servidor não respondeu'));

    return jsonDecode(response.body) as List<dynamic>;
  }

  Future<Map<String, dynamic>> criarDenuncia({
    required int usuarioId,
    required int categoriaId,
    required String titulo,
    required String descricao,
    required String bairro,
    required String endereco,
    required bool publica,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/denuncias'),
      headers: _headers,
      body: jsonEncode({
        'usuarioId': usuarioId,
        'categoriaId': categoriaId,
        'titulo': titulo,
        'descricao': descricao,
        'bairro': bairro,
        'endereco': endereco,
        'publica': publica,
      }),
    ).timeout(const Duration(seconds: 10),
        onTimeout: () => throw Exception('Servidor não respondeu'));

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (data.containsKey('erro')) throw Exception(data['erro']);
    return data;
  }

  Future<void> atualizarStatus({
    required int denunciaId,
    required int funcionarioId,
    required String status,
    String? observacao,
  }) async {
    final body = <String, dynamic>{
      'funcionarioId': funcionarioId,
      'status': status,
    };
    if (observacao != null) body['observacao'] = observacao;

    final response = await http.patch(
      Uri.parse('$baseUrl/denuncias/$denunciaId/status'),
      headers: _headers,
      body: jsonEncode(body),
    ).timeout(const Duration(seconds: 10),
        onTimeout: () => throw Exception('Servidor não respondeu'));

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (data.containsKey('erro')) throw Exception(data['erro']);
  }

  // CHAT

  Future<List<dynamic>> listarChats(int usuarioId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/chats/usuario/$usuarioId'),
      headers: _headers,
    ).timeout(const Duration(seconds: 10),
        onTimeout: () => throw Exception('Servidor não respondeu'));

    return jsonDecode(response.body) as List<dynamic>;
  }


  Future<Map<String, dynamic>> abrirChat({
    required int usuarioId,
    required int orgaoId,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/chats'),
      headers: _headers,
      body: jsonEncode({'usuarioId': usuarioId, 'orgaoId': orgaoId}),
    ).timeout(const Duration(seconds: 10),
        onTimeout: () => throw Exception('Servidor não respondeu'));

    return jsonDecode(response.body) as Map<String, dynamic>;
  }


  Future<List<dynamic>> listarMensagens(int chatId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/chats/$chatId/mensagens'),
      headers: _headers,
    ).timeout(const Duration(seconds: 10),
        onTimeout: () => throw Exception('Servidor não respondeu'));

    return jsonDecode(response.body) as List<dynamic>;
  }


  Future<void> enviarMensagem({
    required int chatId,
    required int autorId,
    required String texto,
  }) async {
    await http.post(
      Uri.parse('$baseUrl/chats/$chatId/mensagens'),
      headers: _headers,
      body: jsonEncode({'autorId': autorId, 'texto': texto}),
    ).timeout(const Duration(seconds: 10),
        onTimeout: () => throw Exception('Servidor não respondeu'));
  }

  // NOTIFICAÇÕES

  Future<List<dynamic>> listarNotificacoes(int usuarioId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/notificacoes/usuario/$usuarioId'),
      headers: _headers,
    ).timeout(const Duration(seconds: 10),
        onTimeout: () => throw Exception('Servidor não respondeu'));

    return jsonDecode(response.body) as List<dynamic>;
  }

  Future<void> marcarLida(int notificacaoId) async {
    await http.patch(
      Uri.parse('$baseUrl/notificacoes/$notificacaoId/lida'),
      headers: _headers,
    );
  }

  Future<bool> isOnline() async {
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/'))
          .timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}