import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:soft_wear/Features/Auth/Presentation/cubit/auth_cubit.dart';
import 'sign_up_screen.dart';

mixin SignUpMixin on State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final List<String> cities = [
  'Al Mansurah', 'Al Minya', 'Alexandria', 'Arish', 'Aswan',
  'Asyut', 'Banha', 'Beni Suef', 'Cairo', 'Damanhur',
  'Damietta', 'Faiyum', 'Giza', 'Hurghada', 'Ismailia',
  'Kafr el-Sheikh', 'Luxor', 'Marsa Matrouh', 'Port Said', 'Qena',
  'Sharm el-Sheikh', 'Sohag', 'Suez', 'Tanta', 'Zagazig'
];
  
  String? selectedCity;
  bool useGps = false;

  // ================= 1. دالة التسجيل =================
  void signUp() {
    if (formKey.currentState!.validate()) {
      if (selectedCity == null && !useGps) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a city or use GPS')),
        );
        return;
      }

      String finalCity = useGps ? "Auto (GPS)" : selectedCity!;

      BlocProvider.of<AuthCubit>(context).signUpFunction(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        name: nameController.text.trim(),
        city: finalCity,
      );
    }
  }

  // ================= 2. دالة طلب الـ GPS =================
  Future<void> requestGpsPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please turn on your GPS.')));
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission(); 
      if (permission == LocationPermission.denied) {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location permission denied.')));
        return; 
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Permissions permanently denied.')));
      return;
    }

    // لو وافق:
    setState(() {
      useGps = true;
      selectedCity = null; 
    });
  }

  // ================= 3. دالة تنظيف الميموري =================
  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose(); // لازم تفضل موجودة
  }
}