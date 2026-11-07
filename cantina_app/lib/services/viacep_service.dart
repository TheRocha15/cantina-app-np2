import 'dart:convert';

import 'package:http/http.dart' as http;

/// RECURSO ADICIONAL: consumo de API REST (ViaCEP) com o pacote http.
class Endereco {
  final String rua;
  final String bairro;
  final String cidade;

  Endereco({required this.rua, required this.bairro, required this.cidade});
}

class ViaCepService {
  /// Retorna o endereço do CEP ou null se o CEP não existir / houver erro.
  Future<Endereco?> buscar(String cep) async {
    final limpo = cep.replaceAll(RegExp(r'[^0-9]'), '');
    if (limpo.length != 8) return null;

    try {
      final resposta =
          await http.get(Uri.parse('https://viacep.com.br/ws/$limpo/json/'));
      if (resposta.statusCode != 200) return null;

      final dados = jsonDecode(resposta.body) as Map<String, dynamic>;
      if (dados.containsKey('erro')) return null;

      return Endereco(
        rua: dados['logradouro'] ?? '',
        bairro: dados['bairro'] ?? '',
        cidade: dados['localidade'] ?? '',
      );
    } catch (_) {
      return null;
    }
  }
}
