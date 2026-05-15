import 'package:dartz/dartz.dart';
import 'package:movie_app/core/error/failures.dart';
import 'package:movie_app/features/authentication/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login(String email, String password);
  Future<Either<Failure, UserEntity>> register(
    String email,
    String password,
    String name,
  );
  Future<Either<Failure, Unit>> logout();
  Future<Either<Failure, UserEntity?>> getCurrentUser();
  Future<bool> isLoggedIn();
}
