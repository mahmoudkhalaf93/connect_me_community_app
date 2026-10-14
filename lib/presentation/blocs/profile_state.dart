import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final Map<String, String> deviceInfo;
  final String? profileImageUrl;

  const ProfileLoaded({required this.deviceInfo, this.profileImageUrl});

  @override
  List<Object?> get props => [deviceInfo, profileImageUrl];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object> get props => [message];
}

class BiometricAuthSuccess extends ProfileState {}

class BiometricAuthFailed extends ProfileState {}
