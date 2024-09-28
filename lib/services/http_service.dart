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
    } catch (e) {
      Log.v('Error fetching data: $e');
    }
    return null;
  }
}

@riverpod
HttpService httpServices(HttpServicesRef ref) {
  return HttpService.instance;
}
