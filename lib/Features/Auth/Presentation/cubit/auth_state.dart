part of 'auth_cubit.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthError extends AuthState {
  final String message;
  AuthError({required this.message});
}

class ProfileDataLoaded extends AuthState {}

class ProfileImageUpdated extends AuthState {}