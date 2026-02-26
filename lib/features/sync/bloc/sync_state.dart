import 'package:equatable/equatable.dart';

/// Base class for all sync states
abstract class SyncState extends Equatable {
  const SyncState();

  @override
  List<Object?> get props => [];
}

/// Initial idle state
class SyncInitial extends SyncState {
  const SyncInitial();
}

/// Sync is in progress
class SyncInProgress extends SyncState {
  const SyncInProgress();
}

/// Sync completed successfully
class SyncSuccess extends SyncState {
  const SyncSuccess();
}

/// Sync failed with error
class SyncFailure extends SyncState {
  final String message;

  const SyncFailure(this.message);

  @override
  List<Object?> get props => [message];
}