import 'package:geolocator/geolocator.dart';
import 'package:soft_wear/Core/Constants/api_constants.dart';
import 'package:soft_wear/Core/Networking/api/api_services.dart';

import '../Models/weather_model.dart';

class WeatherRepository {
  final ApiService _apiService = ApiService();
  static const String _apiKey = ApiConstants.weatherApiKey;

  Future<WeatherModel?> getWeather({String? cityName}) async {
    try {
      Map<String, String> queryParams = {"appid": _apiKey, "units": "metric"};
      if (cityName != null && cityName.isNotEmpty) {
        queryParams["q"] = cityName;
      } else {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) return null;
        }

        Position position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.low,
          ),
        );

        queryParams["lat"] = position.latitude.toString();
        queryParams["lon"] = position.longitude.toString();
      }
      print("======> City Sent to API: $cityName");
print("======> Lat/Lon Sent to API: ${queryParams['lat']} / ${queryParams['lon']}");
      final response = await _apiService.get(
        endPoint: "weather",
        query: queryParams,
      );

      return WeatherModel.fromJson(response);
    } catch (e) {
      print("Error fetching weather: $e");
      return null;
    }
  }
}
