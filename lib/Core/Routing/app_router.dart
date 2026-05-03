import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soft_wear/Core/Presentation/onboarding_screen.dart';
import 'package:soft_wear/Core/Presentation/splash_app.dart';
import 'package:soft_wear/Core/Routing/app_routes.dart';
import 'package:soft_wear/Features/Add_Item/Presentation/Screens/add_item.dart';
import 'package:soft_wear/Features/Add_Item/Presentation/cubit/add_item_cubit.dart';
import 'package:soft_wear/Features/Auth/Presentation/Screens/about_screen.dart';
import 'package:soft_wear/Features/Auth/Presentation/Screens/auth_wrapper_screen.dart';
import 'package:soft_wear/Features/Auth/Presentation/Screens/edit_profile_screen.dart';
import 'package:soft_wear/Features/Auth/Presentation/Screens/forgot_password_screen.dart';
import 'package:soft_wear/Features/Auth/Presentation/Screens/login_screen.dart';
import 'package:soft_wear/Features/Auth/Presentation/Screens/privacy_screen.dart';
import 'package:soft_wear/Features/Auth/Presentation/Screens/profile_screen.dart';
import 'package:soft_wear/Features/Auth/Presentation/Screens/settings_screen.dart';
import 'package:soft_wear/Features/Auth/Presentation/Screens/sign_up_screen.dart';
import 'package:soft_wear/Features/Auth/Presentation/cubit/auth_cubit.dart';
import 'package:soft_wear/Features/Main%20Layout/Presentation/Screens/main_layout.dart';
import 'package:soft_wear/Features/Main%20Layout/Presentation/cubit/layout_cubit.dart';
import 'package:soft_wear/Features/Wardrobe/Presentation/Screens/Wardrobe_Analysis.dart';
import 'package:soft_wear/Features/Wardrobe/Presentation/Screens/favorite.dart';
import 'package:soft_wear/Features/Wardrobe/Presentation/Screens/saved_outfits.dart';

class AppRouter {
  Route generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

      case AppRoutes.onBoarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());

      case AppRoutes.authWrapper:
        return MaterialPageRoute(builder: (_) => const AuthWrapperScreen());

      case AppRoutes.signUpScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => AuthCubit(),
            child: const SignUpScreen(),
          ),
        );

      case AppRoutes.loginScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => AuthCubit(),
            child: const LoginScreen(),
          ),
        );

      case AppRoutes.forgetPassScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => AuthCubit(),
            child: const ForgotPasswordScreen(),
          ),
        );

      case AppRoutes.profileScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => AuthCubit(),
            child: const ProfileScreen(),
          ),
        );

      case AppRoutes.addItemScreen:
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => AddItemCubit(),
            child: const AddItemScreen(),
          ),
        );

      case AppRoutes.mainLayoutScreen:
        return MaterialPageRoute(
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => LayoutCubit()),
              BlocProvider(create: (context) => AuthCubit()..getUserData()),
            ],
            child: const MainLayoutScreen(),
          ),
        );

      case AppRoutes.wardrobeAnalysisScreen:
        return MaterialPageRoute(
          builder: (_) => const WardrobeAnalysisScreen(),
        );

      case AppRoutes.favoriteOutfitsScreen:
        return MaterialPageRoute(builder: (_) => const FavoriteScreen());

      case AppRoutes.savedOutfitsScreen:
        return MaterialPageRoute(builder: (_) => const SavedOutfitsScreen());
      
      case AppRoutes.privacyScreen:
        return MaterialPageRoute(builder: (_) => const PrivacyScreen());
     
      case AppRoutes.aboutScreen:
        return MaterialPageRoute(builder: (_) => const AboutScreen());

      case AppRoutes.editProfileScreen:
        final authCubit = settings.arguments as AuthCubit?;

        if (authCubit == null) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(child: Text("Error: AuthCubit Missing")),
            ),
          );
        }

        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: authCubit,
            child: const EditProfileScreen(),
          ),
        );

      case AppRoutes.settingsScreen:
        final authCubit = settings.arguments as AuthCubit?;

        if (authCubit == null) {
          return MaterialPageRoute(
            builder: (_) => const Scaffold(
              body: Center(child: Text("Error: AuthCubit missing")),
            ),
          );
        }
        return MaterialPageRoute(
          builder: (_) => BlocProvider.value(
            value: authCubit,
            child: const SettingsScreen(),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}
