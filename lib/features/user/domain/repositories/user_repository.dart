import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

abstract class IUserRepository {
  Future<Either<Failure, FirebaseUser>> getUser();

  Future<Either<Failure, List<String>>> getPastOrderIds();
}