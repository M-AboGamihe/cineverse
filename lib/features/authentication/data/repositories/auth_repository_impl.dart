import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movie_app/core/error/failures.dart';
import 'package:movie_app/features/authentication/data/datasources/auth_remote_data_source.dart';
import 'package:movie_app/features/authentication/data/models/user_model.dart';
import 'package:movie_app/features/authentication/domain/entities/user_entity.dart';
import 'package:movie_app/features/authentication/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;

  AuthRepositoryImpl(this.remote);

  @override
  Future<Either<Failure, UserEntity>> login(
    String email,
    String password,
  ) async {
    try {
      final user = await remote.login(email, password);
      return Right(UserModel.fromFirebase(user));
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message ?? "Login failed"));
    } catch (e) {
      return Left(ServerFailure("Unexpected error"));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register(
    String email,
    String password,
    String name,
  ) async {
    try {
      final user = await remote.register(email, password);

      // Keep display name in sync with Firebase profile
      await user.updateDisplayName(name);

      return Right(UserModel.fromFirebase(user));
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(e.message ?? "Register failed"));
    } catch (e) {
      return Left(ServerFailure("Unexpected error"));
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await remote.logout();
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure("Logout failed"));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final user = remote.getCurrentUser();
      if (user == null) return const Right(null);
      return Right(UserModel.fromFirebase(user));
    } catch (e) {
      return Left(ServerFailure("Failed to get user"));
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return remote.getCurrentUser() != null;
  }
}
