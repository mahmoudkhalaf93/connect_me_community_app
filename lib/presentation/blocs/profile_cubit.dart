import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/biometric_service.dart';
import '../../services/device_info_service.dart';
import '../../services/storage_service.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final BiometricService biometricService;
  final DeviceInfoService deviceInfoService;
  final StorageService storageService;
  final FirebaseFirestore firestore;

  ProfileCubit({
    required this.biometricService,
    required this.deviceInfoService,
    required this.storageService,
    required this.firestore,
  }) : super(ProfileInitial());

  Future<void> authenticateAndLoadProfile(
    String userId,
    String? initialImageUrl,
  ) async {
    emit(ProfileLoading());
    final authenticated = await biometricService.authenticate();

    if (authenticated) {
      emit(BiometricAuthSuccess());
      // Load device info immediately after
      final deviceInfo = await deviceInfoService.getDeviceDetails();
      emit(
        ProfileLoaded(deviceInfo: deviceInfo, profileImageUrl: initialImageUrl),
      );
    } else {
      emit(BiometricAuthFailed());
    }
  }

  Future<void> uploadProfileImage(
    String userId,
    File imageFile,
    Map<String, String> currentDeviceInfo,
  ) async {
    emit(ProfileLoading());

    final imageUrl = await storageService.uploadProfileImage(userId, imageFile);

    if (imageUrl != null) {
      // Update Firestore user document
      await firestore.collection('users').doc(userId).update({
        'profileImageUrl': imageUrl,
      });
      emit(
        ProfileLoaded(deviceInfo: currentDeviceInfo, profileImageUrl: imageUrl),
      );
    } else {
      emit(const ProfileError('Failed to upload image'));
      emit(ProfileLoaded(deviceInfo: currentDeviceInfo)); // revert
    }
  }
}
