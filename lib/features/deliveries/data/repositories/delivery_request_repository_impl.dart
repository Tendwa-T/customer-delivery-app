import 'package:customer_delivery_app/core/database/database_helper.dart';
import 'package:customer_delivery_app/core/error/failures.dart';
import 'package:customer_delivery_app/features/deliveries/data/models/delivery_request_model.dart';
import 'package:customer_delivery_app/features/deliveries/domain/entity/delivery_request.dart';
import 'package:customer_delivery_app/features/deliveries/domain/repository/delivery_request_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:sqflite/sqlite_api.dart';

class DeliveryRequestRepositoryImpl implements DeliveryRequestRepository {
  DeliveryRequestRepositoryImpl({DatabaseHelper? dbHelper})
    : _dbHelper = dbHelper ?? DatabaseHelper.instance;

  final DatabaseHelper _dbHelper;

  @override
  Future<Either<AppFailure, List<DeliveryRequest>>> getAll() async {
    try {
      final db = await _dbHelper.database;
      final rows = await db.query(
        'delivery_request',
        orderBy: 'created_at DESC',
      );

      final results = rows
          .map((r) => DeliveryRequestModel.fromMap(r).toEntity())
          .toList();
      return right(results);
    } on DatabaseException catch (e) {
      return left(DatabaseFailure(cause: e.toString()));
    } catch (e) {
      return left(UnexpectedFailure(cause: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, DeliveryRequest>> getById(int id) async {
    try {
      final db = await _dbHelper.database;
      final rows = await db.query(
        'delivery_request',
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      if (rows.isEmpty) left(RecordNotFound(id: id));

      return right(DeliveryRequestModel.fromMap(rows.first).toEntity());
    } on DatabaseException catch (e) {
      return left(DatabaseFailure(cause: e.toString()));
    } catch (e) {
      return left(UnexpectedFailure(cause: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, List<DeliveryRequest>>> search(String query) async {
    if (query.trim().isEmpty) return getAll();

    try {
      final db = await _dbHelper.database;
      final pattern = '%${query.trim()}%';
      final rows = await db.query(
        'delivery_request',
        where: '''
				pickup_address LIKE ? OR
				delivery_address LIKE ? OR
				package_name LIKE ? OR
				package_code LIKE ?
			''',
        whereArgs: [pattern, pattern, pattern],
        orderBy: 'created_at DESC',
      );

      return right(
        rows.map((r) => DeliveryRequestModel.fromMap(r).toEntity()).toList(),
      );
    } on DatabaseException catch (e) {
      return left(DatabaseFailure(cause: e.toString()));
    } catch (e) {
      return left(UnexpectedFailure(cause: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, List<DeliveryRequest>>> filterByStatus(
    DeliveryStatus? status,
  ) async {
    try {
      final db = await _dbHelper.database;
      final rows = await db.query(
        'delivery_request',
        where: 'status = ?',
        whereArgs: [status!.toDbString()],
        orderBy: 'created_at DESC',
      );

      return right(
        rows.map((r) => DeliveryRequestModel.fromMap(r).toEntity()).toList(),
      );
    } on DatabaseException catch (e) {
      return left(DatabaseFailure(cause: e.toString()));
    } catch (e) {
      return left(UnexpectedFailure(cause: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, DeliveryRequest>> insert(
    DeliveryRequest req,
  ) async {
    try {
      final db = await _dbHelper.database;
      final model = DeliveryRequestModel.fromEntity(req);
      final id = await db.insert('delivery_request', model.toMap());

      return right(req.copyWith(id: id));
    } on DatabaseException catch (e) {
      return left(DatabaseFailure(cause: e.toString()));
    } catch (e) {
      return left(UnexpectedFailure(cause: e.toString()));
    }
  }

  @override
  Future<Either<AppFailure, Unit>> update(DeliveryRequest req) async {
    if (req.id == null) {
      return left(
        const UnexpectedFailure(
          cause: 'update cannot be called with a null id',
        ),
      );
    }

    final currentResult = await getById(req.id!);
    return currentResult.fold((failure) => left(failure), (current) async {
      if (!current.status.canEdit) {
        return left(EditNotAllowed(statusLabel: current.status.displayLabel));
      }

      try {
        final db = await _dbHelper.database;
        final model = DeliveryRequestModel.fromEntity(req);
        await db.update(
          'delivery_request',
          model.toMap(),
          where: 'id = ?',
          whereArgs: [req.id],
        );
        return right(unit);
      } on DatabaseException catch (e) {
        return left(DatabaseFailure(cause: e.toString()));
      } catch (e) {
        return left(UnexpectedFailure(cause: e.toString()));
      }
    });
  }

  @override
  Future<Either<AppFailure, Unit>> delete(int id) async {
    final curr = await getById(id);

    return curr.fold((failure) => left(failure), (current) async {
      try {
        final db = await _dbHelper.database;
        await db.delete('delivery_request', where: 'id = ?', whereArgs: [id]);
        return right(unit);
      } on DatabaseException catch (e) {
        return left(DatabaseFailure(cause: e.toString()));
      } catch (e) {
        return left(UnexpectedFailure(cause: e.toString()));
      }
    });
  }
}
