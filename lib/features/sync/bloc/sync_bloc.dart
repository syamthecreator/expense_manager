import 'package:flutter_bloc/flutter_bloc.dart';
import 'sync_event.dart';
import 'sync_state.dart';
import '../data/sync_repository.dart';

/// BLoC responsible for data synchronization
class SyncBloc extends Bloc<SyncEvent, SyncState> {
  final SyncRepository repository;

  SyncBloc(this.repository) : super(const SyncInitial()) {
    on<StartSync>(_onStartSync);
  }

  Future<void> _onStartSync(
    StartSync event,
    Emitter<SyncState> emit,
  ) async {
    emit(const SyncInProgress());
    try {
      await repository.syncAll();
      emit(const SyncSuccess());
    } catch (e) {
      emit(SyncFailure(e.toString()));
    }
  }
}