import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/core/constants/branding.dart';
import 'package:movie_app/core/widgets/loading_widget.dart';
import 'package:movie_app/features/authentication/presentation/blocs/auth_bloc/auth_bloc.dart';
import 'package:movie_app/features/authentication/presentation/screens/login_screen.dart';
import 'package:movie_app/features/movies/presentation/blocs/movies/movies_bloc.dart';
import 'package:movie_app/features/movies/presentation/widgets/movie_list_widget.dart';
import 'package:movie_app/features/movies/presentation/widgets/movie_search_delegate.dart';

import '../widgets/build_drawer.dart';

class MoviesScreen extends StatefulWidget {
  const MoviesScreen({super.key});
  @override
  State<MoviesScreen> createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MoviesBloc>().add(GetPopularMoviesEvent());
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final bloc = context.read<MoviesBloc>();
    final state = bloc.state;

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      if (!state.isLoadingMore && !state.hasReachedMax) {
        bloc.add(LoadMoreMoviesEvent());
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      drawer: buildDrawer(context),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar(BuildContext context) => AppBar(
    title: Text(
      Branding.appName,
      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    actions: [
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: () {
          showSearch(context: context, delegate: MovieSearchDelegate());
        },
      ),
      BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state.user != null) {
            return PopupMenuButton<String>(
              icon: CircleAvatar(
                backgroundColor: Colors.redAccent,
                radius: 14,
                child: Text(
                  state.user!.name.isNotEmpty
                      ? state.user!.name[0].toUpperCase()
                      : 'U',
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  enabled: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.user!.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        state.user!.email,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem(value: 'logout', child: Text('Logout')),
              ],
              onSelected: (value) {
                if (value == 'logout') {
                  context.read<AuthBloc>().add(LogoutEvent());
                }
              },
            );
          }
          return IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
          );
        },
      ),
    ],
  );

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: BlocBuilder<MoviesBloc, MoviesState>(
        builder: (context, state) {
          // Initial load (empty list)
          if (state.status == MoviesStatus.loading && state.movies.isEmpty) {
            return const LoadingWidget();
          }

          if (state.status == MoviesStatus.error) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.wifi_off_rounded,
                      size: 56,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      state.message ?? 'Something went wrong.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      onPressed: () {
                        context.read<MoviesBloc>().add(GetPopularMoviesEvent());
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state.status == MoviesStatus.success ||
              state.status == MoviesStatus.refreshing) {
            if (state.movies.isEmpty) {
              return const Center(child: Text("No Movies Found"));
            }
            return Stack(
              children: [
                RefreshIndicator(
                  onRefresh: () async {
                    context.read<MoviesBloc>().add(RefreshMoviesEvent());
                  },
                  child: MovieListWidget(
                    movies: state.movies,
                    hasReachedMax: state.hasReachedMax,
                    controller: _scrollController,
                  ),
                ),
                if (state.status == MoviesStatus.refreshing)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.7),
                      child: LoadingWidget(),
                    ),
                  ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
