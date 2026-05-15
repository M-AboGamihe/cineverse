import 'package:flutter/material.dart';
import 'package:movie_app/features/authentication/presentation/widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildBody());
  }

  AppBar _buildAppBar() {
    return AppBar(title: Text("Login"), centerTitle: true);
  }

  Widget _buildBody() {
    return Padding(padding: const EdgeInsets.all(8.0), child: LoginForm());
  }
}
