part of 'wardrobe_cubit.dart';

abstract class WardrobeState {}

class WardrobeInitial extends WardrobeState {}

class WardrobeLoading extends WardrobeState {}

class WardrobeLoaded extends WardrobeState {
  final List<ClothingItem> items;
  final int favCount; 
  final int savedCount; 

  WardrobeLoaded({
    required this.items,
    this.favCount = 0,
    this.savedCount = 0,
  });
}

class WardrobeError extends WardrobeState {
  final String message;
  WardrobeError(this.message);
}