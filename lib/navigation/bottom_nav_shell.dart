import 'package:expense_manager/app/app_routes.dart';
import 'package:expense_manager/core/constants/app_colors.dart';
import 'package:expense_manager/navigation/bloc/nav_bloc.dart';
import 'package:expense_manager/navigation/bloc/nav_event.dart';
import 'package:expense_manager/navigation/bloc/nav_state.dart';
import 'package:expense_manager/navigation/widgets/custom_bottom_nav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Shell widget that wraps screens with a bottom navigation bar
class BottomNavShell extends StatelessWidget {
  final Widget child;

  const BottomNavShell({super.key, required this.child});

  /// Maps route location to bottom navigation index
  int _indexFromLocation(String location) {
    if (location.startsWith(AppRoutes.transaction)) {
      return 1;
    }
    if (location.startsWith(AppRoutes.profileAndSettings)) {
      return 2;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final index = _indexFromLocation(location);

    context.read<NavBloc>().add(NavItemTapped(index));

    return Scaffold(
      backgroundColor: AppColors.blackColor,
      body: child,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: BlocBuilder<NavBloc, NavState>(
          builder: (context, state) {
            return state.hideBottomNav
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.all(10),
                    child: CustomBottomNav(
                      selectedIndex: index,
                      onTap: (index) {
                        switch (index) {
                          case 0:
                            context.go(AppRoutes.home);
                            break;
                          case 1:
                            context.go(AppRoutes.transaction);
                            break;
                          case 2:
                            context.go(AppRoutes.profileAndSettings);
                            break;
                        }
                      },
                    ),
                  );
          },
        ),
      ),
    );
  }
}
