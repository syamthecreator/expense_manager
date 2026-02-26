import 'package:flutter_bloc/flutter_bloc.dart';
import 'nav_event.dart';
import 'nav_state.dart';

/// Bloc for managing bottom navigation bar state
class NavBloc extends Bloc<NavEvent, NavState> {
  NavBloc() : super(const NavState()) {
    // Handle bottom navigation item tap - updates selected index
    on<NavItemTapped>((event, emit) {
      emit(state.copyWith(selectedIndex: event.index));
    });

    // Handle hiding bottom navigation bar (e.g., when keyboard appears)
    on<HideBottomNav>((event, emit) {
      emit(state.copyWith(hideBottomNav: true));
    });

    // Handle showing bottom navigation bar (e.g., when keyboard hides)
    on<ShowBottomNav>((event, emit) {
      emit(state.copyWith(hideBottomNav: false));
    });
  }
}