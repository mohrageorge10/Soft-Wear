// المسار: lib/Logic/Home_Cubit/home_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soft_wear/Core/Constants/app_strings.dart';
import 'package:soft_wear/Features/Home/Data/Models/weather_model.dart';
import 'package:soft_wear/Features/Home/Data/Repo/weather_repo.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final WeatherRepository weatherRepository;

  HomeCubit(this.weatherRepository) : super(HomeInitial());

  WeatherModel? currentWeather; 

  String currentStyle = "Casual";
  String currentTopName = AppStrings.shirtDefault;
  String currentBottomName = AppStrings.pantsDefault;
  String currentShoesName = AppStrings.shoesDefault;

  // ================= Fetch Weather =================
  Future<void> fetchWeather({String? userCity}) async {
    emit(HomeWeatherLoading()); 
    
    final weather = await weatherRepository.getWeather(cityName: userCity);

    if (weather != null) {
      currentWeather = weather; 
      emit(HomeWeatherLoaded(weather));
    } else {
      emit(HomeWeatherError(AppStrings.weatherFailed));
    }
  }

  // ================= Generate Outfit =================
  void generateOutfit(String style) {
    currentStyle = style;
    
    if (style == 'Formal') {
      currentTopName = AppStrings.formalTop;
      currentBottomName = AppStrings.formalBottom;
      currentShoesName = AppStrings.formalShoes;
    } else {
      currentTopName = AppStrings.casualTop;
      currentBottomName = AppStrings.casualBottom;
      currentShoesName = AppStrings.casualShoes;
    }
    
    emit(HomeOutfitGenerated());
  }

  // ================= Smart Suggestion =================
  String getSmartSuggestion(int temp) {
    if (temp == 0) return AppStrings.suggestionDefault;
    if (temp < 22) return AppStrings.suggestionChilly;
    if (temp > 28) return AppStrings.suggestionHot;
    return AppStrings.suggestionGreat;
  }
}