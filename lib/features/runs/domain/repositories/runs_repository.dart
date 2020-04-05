import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:hotfoot/core/error/failures.dart';
import 'package:hotfoot/features/runs/data/models/run_model.dart';
import 'package:hotfoot/features/runs/domain/entities/run_entity.dart';
import 'package:meta/meta.dart';

abstract class IRunsRepository {
  /// Returns all runs that the user placed.
  Future<Either<Failure, List<String>>> getRunsIds({@required String userId});

  /// Returns the updated or inserted run.
  Future<Either<Failure, RunEntity>> updateOrInsertRun(
      {@required RunModel runModel});

  /// Returns the run details for the given id.
  Future<Either<Failure, RunEntity>> getRunById({@required String id});

  /// Returns a stream that can be listened to for run updates.
  Future<Either<Failure, Stream<QuerySnapshot>>> getRunStream(String runId);
}