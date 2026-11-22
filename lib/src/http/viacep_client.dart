
import 'package:dio/dio.dart';

class ViaCepClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://viacep.com.br/ws',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  // Consulta um endereço pelo CEP.
  Future<Map<String, dynamic>> searchByCep(String cep) async {
    final cleanCep = cep.replaceAll(RegExp(r'\D'), '');

    if (cleanCep.length != 8) {
      throw Exception('Digite um CEP válido com 8 números.');
    }

    try {
      final response = await _dio.get('/$cleanCep/json/');

      final data = response.data;

      if (data is! Map ||
          data['erro'] == true ||
          data['cep'] == null ||
          data['cep'].toString().trim().isEmpty) {
        throw Exception('CEP não encontrado. Verifique o número informado.');
      }

      return Map<String, dynamic>.from(data);
    } on DioException {
      throw Exception(
        'Não foi possível consultar o CEP. Verifique sua conexão e tente novamente.',
      );
    }
  }

  // Consulta CEPs pelo estado, cidade e logradouro.
  Future<List<Map<String, dynamic>>> searchByAddress({
    required String state,
    required String city,
    required String street,
  }) async {
    if (state.trim().isEmpty ||
        city.trim().isEmpty ||
        street.trim().isEmpty) {
      throw Exception(
        'Informe o estado, a cidade e o logradouro.',
      );
    }

    try {
      final response = await _dio.get(
        '/${Uri.encodeComponent(state.trim())}/'
        '${Uri.encodeComponent(city.trim())}/'
        '${Uri.encodeComponent(street.trim())}/json/',
      );

      final data = response.data;

      if (data is! List || data.isEmpty) {
        throw Exception('Nenhum endereço encontrado.');
      }

      return data
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    } on DioException {
      throw Exception(
        'Não foi possível consultar o endereço. Verifique sua conexão e tente novamente.',
      );
    }
  }
}
