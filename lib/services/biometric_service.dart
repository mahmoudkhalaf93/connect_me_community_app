import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> authenticate() async {
    try {
      final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
      final bool canAuthenticate =
          canAuthenticateWithBiometrics || await _auth.isDeviceSupported();

      if (!canAuthenticate) {
        return false;
      }

      // Minimal parameter call for local_auth compatibility depending on local cache version
      return await _auth.authenticate(
        localizedReason: 'Please authenticate to access your profile',
      );
    } on PlatformException catch (e) {
      print('Biometric Error: $e');
      return false;
    }
  }
}
