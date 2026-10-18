import 'package:sqflite/sqflite.dart' show ConflictAlgorithm;

import '../models/chp_record.dart';
import 'database_helper.dart';

class CHPDao {
  const CHPDao(this._databaseHelper);

  final DatabaseHelper _databaseHelper;

  Future<int> getLegacyRecordCount() async {
    final db = await _databaseHelper.database;
    final tables = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type = 'table' AND name = ?",
      ['CHP_legacy_records'],
    );
    if (tables.isEmpty) {
      return 0;
    }
    final result = await db.rawQuery(
      'SELECT COUNT(*) AS count FROM CHP_legacy_records',
    );
    return result.single['count']! as int;
  }

  Future<List<CHPRecord>> getAllRecords() async {
    final db = await _databaseHelper.database;
    final rows = await db.query('records', orderBy: 'created_at_local DESC');
    return rows.map(CHPRecord.fromMap).toList();
  }

  Future<List<CHPRecord>> getPendingRecords() async {
    final db = await _databaseHelper.database;
    final rows = await db.query(
      'records',
      where: 'sync_status = ?',
      whereArgs: [SyncStatus.pending.value],
      orderBy: 'created_at_local ASC',
    );
    return rows.map(CHPRecord.fromMap).toList();
  }

  Future<void> insertRecord(CHPRecord record) async {
    final db = await _databaseHelper.database;
    final patientId = record.patientId.trim().toUpperCase();
    await db.transaction((transaction) async {
      await transaction.insert('patients', {
        'patient_id': patientId,
        'patient_name': record.patientName,
        'village_name': record.villageName,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
      await transaction.insert(
        'records',
        {...record.toMap(), 'patient_id': patientId},
      );
    });
  }

  Future<void> markSynced(String id) async {
    await setSyncStatus(id, SyncStatus.synced);
  }

  Future<void> setSyncStatus(String id, SyncStatus status) async {
    final db = await _databaseHelper.database;
    await db.update(
      'records',
      {'sync_status': status.value},
      where: 'local_id = ?',
      whereArgs: [id],
    );
  }

  Future<void> resetInterruptedSyncs() async {
    final db = await _databaseHelper.database;
    await db.update(
      'records',
      {'sync_status': SyncStatus.pending.value},
      where: 'sync_status = ?',
      whereArgs: [SyncStatus.syncing.value],
    );
  }
}
