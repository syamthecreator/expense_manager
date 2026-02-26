import 'package:equatable/equatable.dart';
import '../models/profile_settings_model.dart';

/// State for profile settings
class ProfileSettingsState extends Equatable {
  final ProfileSettingsModel data;

  const ProfileSettingsState(this.data);

  @override
  List<Object> get props => [data];
}