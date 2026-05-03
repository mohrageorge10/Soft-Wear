part of 'add_item_cubit.dart';

abstract class AddItemState {}

class AddItemInitial extends AddItemState {}

class AddItemLoading extends AddItemState {}

class AddItemSuccess extends AddItemState {}

class AddItemError extends AddItemState {
  final String message;
  AddItemError({required this.message});
}
