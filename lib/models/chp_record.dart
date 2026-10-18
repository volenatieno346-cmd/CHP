enum SyncStatus {
  pending('Pending'),
  syncing('Syncing'),
  synced('Synced');

  const SyncStatus(this.value);

  final String value;

  static SyncStatus fromValue(String value) {
    return SyncStatus.values.firstWhere((status) => status.value == value);
  }
}

class CHPRecord {
  const CHPRecord({
    required this.localId,
    required this.chwId,
    required this.patientId,
    required this.patientName,
    required this.villageName,
    required this.visitType,
    required this.vitalsBP,
    required this.vitalsTemp,
    required this.urgencyLevel,
    required this.visitNotes,
    required this.createdAtLocal,
    this.syncStatus = SyncStatus.pending,
  });

  final String localId;
  final String chwId;
  final String patientId;
  final String patientName;
  final String villageName;
  final String visitType;
  final String vitalsBP;
  final double vitalsTemp;
  final String urgencyLevel;
  final String visitNotes;
  final DateTime createdAtLocal;
  final SyncStatus syncStatus;

  bool get isSynced => syncStatus == SyncStatus.synced;

  factory CHPRecord.fromMap(Map<String, Object?> map) {
    return CHPRecord(
      localId: map['local_id']! as String,
      chwId: map['chw_id']! as String,
      patientId: map['patient_id']! as String,
      patientName: map['patient_name']! as String,
      villageName: map['village_name']! as String,
      visitType: map['visit_type']! as String,
      vitalsBP: map['vitals_bp']! as String,
      vitalsTemp: (map['vitals_temp']! as num).toDouble(),
      urgencyLevel: map['urgency_level']! as String,
      visitNotes: map['visit_notes']! as String,
      createdAtLocal: DateTime.parse(map['created_at_local']! as String),
      syncStatus: SyncStatus.fromValue(map['sync_status']! as String),
    );
  }

  Map<String, Object?> toMap() {
    return {
      'local_id': localId,
      'chw_id': chwId,
      'patient_id': patientId,
      'patient_name': patientName,
      'village_name': villageName,
      'visit_type': visitType,
      'vitals_bp': vitalsBP,
      'vitals_temp': vitalsTemp,
      'urgency_level': urgencyLevel,
      'visit_notes': visitNotes,
      'created_at_local': createdAtLocal.toUtc().toIso8601String(),
      'sync_status': syncStatus.value,
    };
  }

  Map<String, Object?> toApiJson() {
    return toMap();
  }

  CHPRecord copyWith({SyncStatus? syncStatus}) {
    return CHPRecord(
      localId: localId,
      chwId: chwId,
      patientId: patientId,
      patientName: patientName,
      villageName: villageName,
      visitType: visitType,
      vitalsBP: vitalsBP,
      vitalsTemp: vitalsTemp,
      urgencyLevel: urgencyLevel,
      visitNotes: visitNotes,
      createdAtLocal: createdAtLocal,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }
}
