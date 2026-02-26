/// Base class for all navigation-related events
abstract class NavEvent {}

/// Event triggered when user taps on a bottom navigation item
class NavItemTapped extends NavEvent {
  final int index; // Index of the tapped navigation item (0-based)

  NavItemTapped(this.index);
}

/// Event to hide the bottom navigation bar (e.g., when bottomsheet opens)
class HideBottomNav extends NavEvent {}

/// Event to show the bottom navigation bar (e.g., when bottomsheet closes)
class ShowBottomNav extends NavEvent {}
