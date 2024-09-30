import 'package:dio/dio.dart';
import 'package:easemydeal/utils/api_url.dart';
import 'package:easemydeal/utils/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'http_service.g.dart';

class HttpService {
  static HttpService instance = HttpService._internal();

  HttpService._internal();

  final _dio = Dio(BaseOptions(baseUrl: ApiUrl.baseUrl));

  Future<Response?> get(String path) async {
    try {
      Response response = await _dio.get(path);
      return response;
    } on DioException catch (e) {
      Log.v('Error fetching data: $e');
      throw _handleException(e);
    }
  }

  Exception _handleException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        throw Exception('Connection Timeout. Please try again later.');
      case DioExceptionType.sendTimeout:
        throw Exception('Send Timeout. Please try again later.');
      case DioExceptionType.receiveTimeout:
        throw Exception('Receive Timeout. Please try again later.');
      case DioExceptionType.badCertificate:
        throw Exception('Bad Certificate Error.');
      case DioExceptionType.badResponse:
        throw Exception('Bad Response.');
      case DioExceptionType.cancel:
        throw Exception('Request cancelled. Please try again.');
      case DioExceptionType.connectionError:
        throw Exception('Connection Error.');
      case DioExceptionType.unknown:
        throw Exception('An unexpected error occurred: $e');
    }
  }
}

@riverpod
HttpService httpServices(HttpServicesRef ref) {
  return HttpService.instance;
}
