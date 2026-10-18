import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class DatabaseHelper {
  DatabaseHelper._();

  static final instance = DatabaseHelper._();

  late final Future<Database> database = _openDatabase();

  Future<Database> _openDatabase() async {
    if (Platform.isLinux || Platform.isWindows) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final databasePath = await getDatabasesPath();
    return openDatabase(
      path.join(databasePath, 'chw_records.db'),
      version: 5,
      onCreate: (db, version) async {
        await _createPatientsTable(db);
        await _createRecordsTable(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE chw_records RENAME TO CHP_records');
        }
        if (oldVersion < 3) {
          await db.execute(
            'ALTER TABLE CHP_records RENAME TO CHP_legacy_records',
          );
        }
        if (oldVersion < 4) {
          await _createRecordsTable(db, includePatientId: false);
          if (oldVersion == 3) {
            await db.execute(
              'ALTER TABLE CHP_records RENAME TO CHP_v3_records',
            );
            await db.execute('''
              INSERT INTO records (
                local_id, chw_id, patient_name, village_name, visit_type,
                vitals_bp, vitals_temp, urgency_level, visit_notes,
                created_at_local, sync_status
              )
              SELECT
                local_id, chw_id, patient_name, village_name, visit_type,
                vitals_bp, vitals_temp, urgency_level, visit_notes,
                created_at_local, sync_status
              FROM CHP_v3_records
            ''');
          }
        }
        if (oldVersion < 5) {
          await _createPatientsTable(db);
          await db.execute(
            "ALTER TABLE records ADD COLUMN patient_id TEXT NOT NULL DEFAULT ''",
          );
          await db.execute(
            "UPDATE records SET patient_id = 'LEGACY-' || local_id",
          );
          await db.execute('''
            INSERT INTO patients (patient_id, patient_name, village_name)
            SELECT patient_id, patient_name, village_name
            FROM records
          ''');
        }
      },
    );
  }

  Future<void> _createRecordsTable(
    DatabaseExecutor db, {
    bool includePatientId = true,
  }) {
    final patientIdColumn = includePatientId
        ? 'patient_id TEXT NOT NULL,'
        : '';
    return db.execute('''
      CREATE TABLE records (
        local_id TEXT PRIMARY KEY,
        chw_id TEXT NOT NULL,
        $patientIdColumn
        patient_name TEXT NOT NULL,
        village_name TEXT NOT NULL,
        visit_type TEXT NOT NULL,
        vitals_bp TEXT,
        vitals_temp REAL,
        urgency_level TEXT,
        visit_notes TEXT,
        created_at_local TEXT NOT NULL,
        sync_status TEXT
      )
    ''');
  }

  Future<void> _createPatientsTable(DatabaseExecutor db) {
    return db.execute('''
      CREATE TABLE patients (
        patient_id TEXT PRIMARY KEY,
        patient_name TEXT NOT NULL,
        village_name TEXT NOT NULL
      )
    ''');
  }
}
