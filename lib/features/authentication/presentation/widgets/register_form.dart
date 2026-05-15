import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/widgets/error_message.dart';
import 'package:movie_app/core/widgets/success_message.dart';
import 'package:movie_app/features/authentication/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:movie_app/features/authentication/presentation/screens/login_screen.dart';
import 'package:movie_app/features/authentication/presentation/widgets/button_loading_widget.dart';
import 'package:movie_app/features/authentication/presentation/widgets/text_field_widget.dart';
import 'package:movie_app/features/movies/presentation/screens/movie_screen.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (previous, current) {
        return previous.user != current.user || previous.error != current.error;
      },

      listener: (context, state) {
        if (state.user != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => MoviesScreen()),
          );
          SuccessMessage(message: "Success Register");
        }

        if (state.error != null) {
          ErrorMessage(message: state.error!);
        }
      },

      builder: (context, state) {
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFieldWidget(
                controller: nameController,
                hint: "Name",
                keyboardType: TextInputType.name,
              ),

              const SizedBox(height: 10),

              TextFieldWidget(
                controller: emailController,
                hint: "Email",
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 10),

              TextFieldWidget(
                controller: passwordController,
                hint: "Password",
                obscureText: true,
              ),

              const SizedBox(height: 20),

              ButtonLoadingWidget(
                isLoading: state.isLoading,
                text: "Register",
                onPressed: () {
                  context.read<AuthBloc>().add(
                    RegisterEvent(
                      emailController.text,
                      passwordController.text,
                      nameController.text,
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => LoginScreen()),
                  );
                },
                child: const Text('Login'),
              ),
            ],
          ),
        );
      },
    );
  }
}
