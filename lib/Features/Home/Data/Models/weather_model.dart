class WeatherModel {
  final String cityName;
  final int temperature;
  final String condition;
  final String iconUrl;

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.condition,
    required this.iconUrl,
  });

  
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    String iconCode = json['weather'][0]['icon'];
    return WeatherModel(
      cityName: json['name'],
      temperature: json['main']['temp'].round(),
      condition: json['weather'][0]['main'],
      iconUrl: "https://openweathermap.org/img/wn/$iconCode@2x.png",
    );
  }
}