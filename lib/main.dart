import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 
import 'package:soft_wear/Core/Routing/app_router.dart';
import 'package:soft_wear/Core/Routing/app_routes.dart';
import 'package:soft_wear/Core/Shared%20Pref/cache_helper.dart';
import 'package:soft_wear/Core/Theme/app_theme.dart';
import 'package:soft_wear/Features/Home/Data/Repo/weather_repo.dart';
import 'package:soft_wear/Features/Home/Presentation/cubit/home_cubit.dart';
import 'package:soft_wear/Features/Wardrobe/Data/Repo/wardrobe_repo.dart';
import 'package:soft_wear/Features/Wardrobe/Presentation/cubit/wardrobe_cubit.dart';

void main() async {
  try {
    print("🚀 1. App is starting...");
    WidgetsFlutterBinding.ensureInitialized();
    print("✅ 2. Widgets initialized successfully");

    await Firebase.initializeApp();
    print("✅ 3. Firebase initialized successfully");

    await CacheHelper.init();
    print("✅ 4. CacheHelper initialized successfully");

    print("🚀 5. Running App...");

    runApp(const MyApp());
  } catch (e, stacktrace) {
    print("❌ CRITICAL ERROR IN MAIN: $e");
    print(stacktrace);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final String? savedCity = CacheHelper.getData(key: 'userCity');

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              HomeCubit(WeatherRepository(), WardrobeRepo())
                ..fetchWeather(userCity: savedCity),
        ),
        BlocProvider(
          create: (context) => WardrobeCubit(WardrobeRepo())..fetchWardrobe(),
        ),
      ],
      child: MaterialApp(
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRouter().generateRoute,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
