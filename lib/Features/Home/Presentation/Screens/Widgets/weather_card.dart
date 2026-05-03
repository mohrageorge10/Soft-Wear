import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:soft_wear/Core/Constants/app_colors.dart';
import 'package:soft_wear/Core/Constants/app_strings.dart';
import 'package:soft_wear/Features/Home/Presentation/cubit/home_cubit.dart';

class WeatherCard extends StatelessWidget {
  final HomeCubit cubit;
  final HomeState state;

  const WeatherCard({super.key, required this.cubit, required this.state});

  // 🚀 الدالة بعد إضافة ذكاء الليل والنهار!
  String _getWeatherGifAsset(String? condition) {
    if (condition == null) return 'assets/weather/cloudy.gif';

    String lowerCondition = condition.toLowerCase();

    // 💡 بنجيب الساعة دلوقتي (من 0 لـ 23)
    int currentHour = DateTime.now().hour;
    // 💡 بنعتبر إن الليل بيبدأ من 6 المغرب (18) لحد 6 الصبح (6)
    bool isNight = currentHour < 6 || currentHour >= 18;

    if (lowerCondition.contains('clear') || lowerCondition.contains('sun')) {
      // لو الجو صافي، بنشيك على الوقت.. لو ليل نعرض قمر، لو نهار نعرض شمس
      return isNight ? 'assets/weather/night.gif' : 'assets/weather/sunny.gif';
    } else if (lowerCondition.contains('rain') ||
        lowerCondition.contains('drizzle')) {
      return 'assets/weather/rain.gif';
    } else if (lowerCondition.contains('thunder') ||
        lowerCondition.contains('storm')) {
      return 'assets/weather/storm.gif';
    } else if (lowerCondition.contains('snow')) {
      return 'assets/weather/snow.gif';
    } else {
      return 'assets/weather/cloudy.gif';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (state is HomeWeatherLoading && cubit.currentWeather == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state is HomeWeatherError && cubit.currentWeather == null) {
      return Center(
        child: Text(
          (state as HomeWeatherError).message,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }

    final weather = cubit.currentWeather;
    final String date = DateFormat('EEEE, d MMM').format(DateTime.now());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Text(
            cubit.getSmartSuggestion(weather?.temperature ?? 0),
            style: const TextStyle(
              color: AppColors.subtitleColor,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 15),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.chartMustard.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    weather?.cityName ?? AppStrings.detectingLocation,
                    style: const TextStyle(
                      color: AppColors.titleColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    date,
                    style: const TextStyle(
                      color: AppColors.subtitleColor,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    weather != null
                        ? "${weather.temperature}°C"
                        : AppStrings.defaultTemp,
                    style: const TextStyle(
                      color: AppColors.titleColor,
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    weather?.condition ?? AppStrings.loading,
                    style: const TextStyle(
                      color: AppColors.subtitleColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withValues(alpha: 0.6),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Image.asset(
                  _getWeatherGifAsset(weather?.condition),
                  width: 90,
                  height: 90,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.broken_image_rounded,
                    size: 50,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
