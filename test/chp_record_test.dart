import 'package:flutter_test/flutter_test.dart';
import 'package:chp/models/chp_record.dart';

void main() {
  test('record round-trips through the local database map', () {
    final record = CHPRecord(
      localId: 'record-1',
      chwId: 'CHW-KKG-04',
      patientId: 'CHW-KKG-04',
      patientName: 'Amina Example',
      villageName: 'Shibuye',
      visitType: 'Maternal',
      vitalsBP: '120/80',
      vitalsTemp: 37.2,
      urgencyLevel: 'Routine',
      visitNotes: 'Follow-up visit',
      createdAtLocal: DateTime.utc(2026, 10, 16, 12),
    );

    final restored = CHPRecord.fromMap(record.toMap());

    expect(restored.localId, record.localId);
    expect(restored.patientId, record.patientId);
    expect(restored.patientName, record.patientName);
    expect(restored.villageName, record.villageName);
    expect(restored.vitalsTemp, record.vitalsTemp);
    expect(restored.createdAtLocal, record.createdAtLocal);
    expect(restored.syncStatus, SyncStatus.pending);
  });

  test('API payload uses the required project schema', () {
    final record = CHPRecord(
      localId: 'record-1',
      chwId: 'CHW-KKG-04',
      patientId: 'CHW-KKG-04',
      patientName: 'Amina Example',
      villageName: 'Shibuye',
      visitType: 'Maternal',
      vitalsBP: '120/80',
      vitalsTemp: 37.2,
      urgencyLevel: 'Routine',
      visitNotes: '',
      createdAtLocal: DateTime.utc(2026, 10, 16, 12),
    );

    expect(record.toApiJson(), {
      'local_id': 'record-1',
      'chw_id': 'CHW-KKG-04',
      'patient_id': 'CHW-KKG-04',
      'patient_name': 'Amina Example',
      'village_name': 'Shibuye',
      'visit_type': 'Maternal',
      'vitals_bp': '120/80',
      'vitals_temp': 37.2,
      'urgency_level': 'Routine',
      'visit_notes': '',
      'created_at_local': '2026-10-16T12:00:00.000Z',
      'sync_status': 'Pending',
    });
  });
}
