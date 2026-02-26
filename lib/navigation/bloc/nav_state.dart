import 'package:equatable/equatable.dart';

/// Navigation state for bottom navigation handling
class NavState extends Equatable {
  final int selectedIndex;
  final bool hideBottomNav;

  const NavState({this.selectedIndex = 0, this.hideBottomNav = false});

  /// Returns a new NavState with updated values
  NavState copyWith({int? selectedIndex, bool? hideBottomNav}) {
    return NavState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
      hideBottomNav: hideBottomNav ?? this.hideBottomNav,
    );
  }

  @override
  List<Object> get props => [selectedIndex, hideBottomNav];
}
