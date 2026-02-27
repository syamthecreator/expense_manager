import 'package:equatable/equatable.dart';

/// Base class for all sync events
abstract class SyncEvent extends Equatable {
  const SyncEvent();

  @override
  List<Object?> get props => [];
}

/// Triggered when user taps "Sync To Cloud"
class StartSync extends SyncEvent {
  const StartSync();
}

class ResetSyncState extends SyncEvent {
  const ResetSyncState();
}