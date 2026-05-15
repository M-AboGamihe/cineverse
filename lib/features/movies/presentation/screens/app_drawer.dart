import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../authentication/presentation/blocs/auth_bloc/auth_bloc.dart';

class AppDrawer extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemTap;
  final VoidCallback onLogout;
  final VoidCallback onLogin;

  const AppDrawer({
    super.key,
    required this.currentIndex,
    required this.onItemTap,
    required this.onLogout,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final user = state.user;

            return UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue, Colors.deepPurple],
                ),
              ),

              accountName: Text(
                user?.name ?? "Guest",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              accountEmail: Text(
                user?.email ?? "Please login",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),

              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.redAccent,
                radius: 22,
                child: Text(
                  user != null && user.name.isNotEmpty
                      ? user.name[0].toUpperCase()
                      : "G",
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),

        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _buildItem(icon: Icons.movie, title: "Movies", index: 0),
              _buildItem(icon: Icons.favorite, title: "Favorites", index: 1),
              _buildItem(icon: Icons.settings, title: "Settings", index: 2),
              const Divider(),
              _buildItem(icon: Icons.info, title: "About", index: 3),
            ],
          ),
        ),

        BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final user = state.user;

            return Padding(
              padding: const EdgeInsets.all(12),
              child: ListTile(
                leading: Icon(
                  user != null ? Icons.logout : Icons.login,
                  color: user != null ? Colors.red : Colors.green,
                ),
                title: Text(user != null ? "Logout" : "Login"),
                onTap: () {
                  Navigator.of(context).pop();

                  if (user != null) {
                    onLogout();
                  } else {
                    onLogin();
                  }
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildItem({
    required IconData icon,
    required String title,
    required int index,
  }) {
    final isSelected = currentIndex == index;

    return ListTile(
      leading: Icon(icon, color: isSelected ? Colors.blue : Colors.grey),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? Colors.blue : Colors.white,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onTap: () => onItemTap(index),
    );
  }
}
