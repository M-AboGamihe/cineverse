import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movie_app/core/constants/branding.dart';
import 'package:movie_app/core/theme/app_theme.dart';
import 'package:movie_app/features/authentication/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:movie_app/features/movies/presentation/blocs/movies/movies_bloc.dart';
import 'package:movie_app/features/movies/presentation/blocs/favorites/favorites_bloc.dart';
import 'package:movie_app/features/authentication/presentation/screens/splash_screen.dart';
import 'package:movie_app/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await Hive.initFlutter();
  await Hive.openBox('moviesBox');
  await Hive.openBox('favoritesBox');

  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<AuthBloc>()),
        BlocProvider(create: (_) => di.sl<MoviesBloc>()),
        BlocProvider(
          create: (_) => di.sl<FavoritesBloc>()..add(LoadFavoritesEvent()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: Branding.appName,
        theme: AppTheme.darkTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const SplashScreen(),
      ),
    );
  }
}
