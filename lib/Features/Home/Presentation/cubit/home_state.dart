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

// ================= Outfit States =================
class HomeOutfitLoading extends HomeState {}

class HomeOutfitGenerated extends HomeState {
  final Outfit outfit; 
  final String style;
  final bool showNotification;

  HomeOutfitGenerated({
    required this.outfit,
    required this.style,
    this.showNotification = true,
  });
}

class HomeWardrobeEmpty extends HomeState {}

class HomeInsufficientItems extends HomeState {
  final String style;
  HomeInsufficientItems({required this.style});
}

class HomeWardrobeError extends HomeState {
  final String message;
  HomeWardrobeError(this.message);
}

// ================= Action States =================
class HomeOutfitActionLoading extends HomeState {}

class HomeOutfitSaved extends HomeState {}

class HomeOutfitFavorited extends HomeState {}

class HomeOutfitWorn extends HomeState {}

class HomeOutfitActionError extends HomeState {
  final String message;
  HomeOutfitActionError(this.message);
}

class HomeOutfitRequiresConsent extends HomeState {
  final String missingItem;
  final String style;
  HomeOutfitRequiresConsent({required this.missingItem, required this.style});
}
