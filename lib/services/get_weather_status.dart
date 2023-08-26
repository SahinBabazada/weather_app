import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../models/weather_model.dart';

Future<Weather?> getWeather(double? lat, double? long) async {
  final params = {
    'lat': '$lat',
    'lon': '$long',
    'appid': 'd6252210c5c5d0de96584180e2e59732',
  };

  final url = Uri.parse('https://api.openweathermap.org/data/2.5/weather')
      .replace(queryParameters: params);

  var dio = Dio();
  var res = await dio.get(
    url.toString(),
    options: Options(
      responseType: ResponseType.json,
      receiveTimeout: const Duration(seconds: 2),
    ),
  );
  debugPrint(res.toString());
  if (res.statusCode == 200) {
    Weather result = Weather.fromJson(res.data);
    debugPrint('Weather: ${result.name}');
    return result;
  }
  return null;
}
