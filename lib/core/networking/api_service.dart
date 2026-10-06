import 'package:dio/dio.dart';
import 'api_constants.dart';

class ApiService {
  final Dio _dio;

  ApiService()
      : _dio = Dio(BaseOptions(
          baseUrl: ApiConstants.baseUrl,
          headers: {
            'Authorization': 'Bearer ${ApiConstants.accessToken}',
            'accept': 'application/json',
          },
        ));

  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? query,
  }) async {
    final response = await _dio.get(endpoint, queryParameters: query);
    return response.data as Map<String, dynamic>;
  } 
}