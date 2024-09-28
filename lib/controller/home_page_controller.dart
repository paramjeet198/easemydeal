import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:easemydeal/services/http_service.dart';
import 'package:easemydeal/utils/api_url.dart';
import 'package:easemydeal/utils/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/event_response.dart';

part 'home_page_controller.g.dart';

@riverpod
Future<List<Event>?> events(EventsRef ref) async {
  var httpService = ref.read(httpServicesProvider);
  List<Event>? events = await _fetchEvenData(httpService);

  return events;
}

Future<List<Event>?> _fetchEvenData(HttpService httpService) async {
  Response? res = await httpService.get(ApiUrl.task1);
  if (res != null) {
    if (res.statusCode! >= 200 || res.statusCode! < 300) {
      final json = jsonDecode(res.data) as Map<String, dynamic>;
      return EventResponse.fromJson(json).data;
    } else {
      throw Exception('Something went wrong');
    }
  } else {
    throw Exception('No Data Found');
  }
}
