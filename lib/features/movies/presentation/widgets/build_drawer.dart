import 'package:flutter/material.dart';
import 'package:movie_app/features/authentication/presentation/blocs/auth_bloc/auth_bloc.dart';

import '../../../authentication/presentation/screens/login_screen.dart';
import '../screens/app_drawer.dart';
import '../screens/favorites_screen.dart';

Widget buildDrawer(context) {
  return Drawer(
    child: AppDrawer(
      currentIndex: 0,
      onLogout: () => context.read<AuthBloc>().add(LogoutEvent()),
      onItemTap: (index) {
        Navigator.pop(context);

        // Navigation logic
        if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => FavoritesScreen()),
          );
        } else if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => FavoritesScreen()),
          );
        }
      },
      onLogin: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => LoginScreen()),
        );
      },
    ),
  );
}
