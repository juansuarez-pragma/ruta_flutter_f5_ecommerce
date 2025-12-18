import 'package:dartz/dartz.dart';

import 'package:ecommerce/features/auth/domain/entities/user.dart';
import 'package:ecommerce/features/auth/domain/repositories/auth_repository.dart';
import 'package:ecommerce/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:ecommerce/features/auth/data/errors/auth_local_exception.dart';

/// Authentication repository implementation.
///
/// Uses [AuthLocalDataSource] for local persistence.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required this.localDataSource});
  final AuthLocalDataSource localDataSource;

  @override
  Future<Either<AuthFailure, User>> login({
    required String email,
    required String password,
  }) async {
    try {
      // Validate email
      if (!_isValidEmail(email)) {
        return Left(AuthFailure.invalidEmail());
      }

      // Attempt login
      final user = await localDataSource.loginUser(
        email: email,
        password: password,
      );

      if (user == null) {
        return Left(AuthFailure.invalidCredentials());
      }

      // Cache current user
      await localDataSource.cacheCurrentUser(user);

      return Right(user);
    } on AuthLocalException catch (e) {
      return Left(AuthFailure.unknown(e.message));
    } catch (e) {
      return Left(AuthFailure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<AuthFailure, User>> register({
    required String email,
    required String password,
    required String username,
    required String firstName,
    required String lastName,
  }) async {
    try {
      // Validate email
      if (!_isValidEmail(email)) {
        return Left(AuthFailure.invalidEmail());
      }

      // Validate password
      if (!_isValidPassword(password)) {
        return Left(AuthFailure.weakPassword());
      }

      // Register user
      final user = await localDataSource.registerUser(
        email: email,
        password: password,
        username: username,
        firstName: firstName,
        lastName: lastName,
      );

      // Cache current user
      await localDataSource.cacheCurrentUser(user);

      return Right(user);
    } on AuthLocalException catch (e) {
      if (e.message.contains('already registered')) {
        return Left(AuthFailure.emailAlreadyInUse());
      }
      return Left(AuthFailure.unknown(e.message));
    } catch (e) {
      return Left(AuthFailure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<AuthFailure, void>> logout() async {
    try {
      await localDataSource.clearCurrentUser();
      return const Right(null);
    } catch (e) {
      return Left(AuthFailure.unknown(e.toString()));
    }
  }

  @override
  Future<Either<AuthFailure, User>> getCurrentUser() async {
    try {
      final user = await localDataSource.getCachedUser();

      if (user == null) {
        return Left(AuthFailure.userNotFound());
      }

      return Right(user);
    } catch (e) {
      return Left(AuthFailure.unknown(e.toString()));
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    final user = await localDataSource.getCachedUser();
    return user != null && user.isAuthenticated;
  }

  // ============ Validation Methods ============

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool _isValidPassword(String password) {
    return password.length >= 6;
  }
}
