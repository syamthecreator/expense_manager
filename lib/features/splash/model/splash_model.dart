import 'package:equatable/equatable.dart';

class SplashModel extends Equatable {
  final String logoPath;
  final Duration duration;

  const SplashModel({
    required this.logoPath,
    required this.duration,
  });

  @override
  List<Object?> get props => [logoPath, duration];
}