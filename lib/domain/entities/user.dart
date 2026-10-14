import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String fullName;
  final String email;
  final String? profileImageUrl;

  const UserEntity({
    required this.id,
    required this.fullName,
    required this.email,
    this.profileImageUrl,
  });

  @override
  List<Object?> get props => [id, fullName, email, profileImageUrl];
}
