import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

/// Represents the internet connectivity state of the app
enum ConnectivityStatus { online, offline, backOnline }

/// Manages internet connectivity state across the app
class ConnectivityCubit extends Cubit<ConnectivityStatus> {
  ConnectivityCubit() : super(ConnectivityStatus.online) {
    _init(); // Initialize connectivity check
  }

  late StreamSubscription _subscription;
  bool _previouslyOffline = false; // Tracks if app was previously offline

  /// Initializes internet status and starts listening for changes
  Future<void> _init() async {
    final hasInternet = await InternetConnectionChecker().hasConnection;

    // Emit initial connectivity state
    emit(hasInternet ? ConnectivityStatus.online : ConnectivityStatus.offline);

    // Listen for connectivity changes
    _subscription = Connectivity().onConnectivityChanged.listen((event) async {
      final hasInternet = await InternetConnectionChecker().hasConnection;

      if (!hasInternet) {
        _previouslyOffline = true; // Mark as offline
        emit(ConnectivityStatus.offline);
      } else {
        if (_previouslyOffline) {
          // If coming back from offline, show temporary backOnline state
          emit(ConnectivityStatus.backOnline);

          await Future.delayed(const Duration(seconds: 2));
          emit(ConnectivityStatus.online);
        } else {
          emit(ConnectivityStatus.online);
        }

        _previouslyOffline = false;
      }
    });
  }

  @override
  Future<void> close() {
    _subscription.cancel(); // Cancel stream when cubit is disposed
    return super.close();
  }
}
