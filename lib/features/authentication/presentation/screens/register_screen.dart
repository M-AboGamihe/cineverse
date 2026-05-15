import 'package:flutter/material.dart';
import 'package:movie_app/features/authentication/presentation/widgets/register_form.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildBody());
  }

  AppBar _buildAppBar() {
    return AppBar(title: Text("Register"), centerTitle: true);
  }

  Widget _buildBody() {
    return Padding(padding: const EdgeInsets.all(8.0), child: RegisterForm());
  }
}
