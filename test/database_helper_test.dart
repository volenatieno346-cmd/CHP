import 'package:chp/db/database_helper.dart';
import 'package:chp/db/chp_dao.dart';
import 'package:chp/models/chp_record.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('initializes and opens the local SQLite database', () async {
    final database = await DatabaseHelper.instance.database;
    final tables = await database.rawQuery(
      "SELECT name FROM sqlite_master WHERE type = 'table' AND name = ?",
      ['records'],
    );

    expect(tables, hasLength(1));

    final columns = await database.rawQuery('PRAGMA table_info(records)');
    expect(
      columns.map((column) => column['name']),
      containsAll([
        'local_id',
        'chw_id',
        'patient_id',
        'patient_name',
        'village_name',
        'visit_type',
        'vitals_bp',
        'vitals_temp',
        'urgency_level',
        'visit_notes',
        'created_at_local',
        'sync_status',
      ]),
    );
    final patients = await database.rawQuery(
      "SELECT name FROM sqlite_master WHERE type = 'table' AND name = ?",
      ['patients'],
    );
    expect(patients, hasLength(1));
  });

  test('reuses patient identity while storing separate visits', () async {
    final helper = DatabaseHelper.instance;
    final dao = CHPDao(helper);
    final suffix = DateTime.now().microsecondsSinceEpoch;
    final first = CHPRecord(
      localId: 'visit-$suffix-1',
      chwId: 'CHW-$suffix',
      patientId: 'CHW-$suffix',
      patientName: 'Amina Example',
      villageName: 'Shibuye',
      visitType: 'General',
      vitalsBP: '',
      vitalsTemp: 37,
      urgencyLevel: 'Routine',
      visitNotes: '',
      createdAtLocal: DateTime.now().toUtc(),
    );
    final secondVisit = CHPRecord(
      localId: 'visit-$suffix-2',
      chwId: first.chwId.toLowerCase(),
      patientId: first.patientId.toLowerCase(),
      patientName: first.patientName,
      villageName: first.villageName,
      visitType: 'Maternal',
      vitalsBP: '',
      vitalsTemp: 37.2,
      urgencyLevel: 'Routine',
      visitNotes: '',
      createdAtLocal: DateTime.now().toUtc(),
      syncStatus: SyncStatus.pending,
    );

    await dao.insertRecord(first);
    await dao.insertRecord(secondVisit);

    final database = await helper.database;
    final patientCount = await database.rawQuery(
      'SELECT COUNT(*) AS count FROM patients WHERE patient_id = ?',
      [first.patientId],
    );
    final visitCount = await database.rawQuery(
      'SELECT COUNT(*) AS count FROM records WHERE patient_id = ?',
      [first.patientId],
    );
    expect(patientCount.single['count'], 1);
    expect(visitCount.single['count'], 2);
  });
}
