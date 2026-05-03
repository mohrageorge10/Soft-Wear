import 'package:flutter_bloc/flutter_bloc.dart';

class LayoutState {
  final int bottomNavIndex;

  LayoutState({required this.bottomNavIndex});
}

class LayoutCubit extends Cubit<LayoutState> {
  LayoutCubit() : super(LayoutState(bottomNavIndex: 0));
  void changeBottomNav(int index) {
    emit(LayoutState(bottomNavIndex: index));
  }
}
