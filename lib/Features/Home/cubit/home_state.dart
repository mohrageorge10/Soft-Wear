
part of 'home_cubit.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

// ================= Weather States =================
class HomeWeatherLoading extends HomeState {}

class HomeWeatherLoaded extends HomeState {
  final WeatherModel weather;
  HomeWeatherLoaded(this.weather);
}

class HomeWeatherError extends HomeState {
  final String message;
  HomeWeatherError(this.message); 
}
 
// ================= Generate Outfits States =================
class HomeOutfitGenerated extends HomeState {
  HomeOutfitGenerated(); 
}