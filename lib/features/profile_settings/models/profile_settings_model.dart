import 'package:equatable/equatable.dart';

class ProfileSettingsModel extends Equatable {
  final String nickname;
  final double alertLimit;
  final List<String> categories;

  const ProfileSettingsModel({
    required this.nickname,
    required this.alertLimit,
    required this.categories,
  });

  /// Creates a new instance by copying current values and replacing specified fields
  ProfileSettingsModel copyWith({
    String? nickname,
    double? alertLimit,
    List<String>? categories,
  }) {
    return ProfileSettingsModel(
      nickname: nickname ?? this.nickname,
      alertLimit: alertLimit ?? this.alertLimit,
      categories: categories ?? this.categories,
    );
  }

  // Equatable props for comparison
  @override
  List<Object> get props => [nickname, alertLimit, categories];
}
