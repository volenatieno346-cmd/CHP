import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../db/chp_dao.dart';
import '../models/chp_record.dart';
import '../services/sync_service.dart';

class SyncBloc extends ChangeNotifier {
  SyncBloc({required this.dao, required this.syncService}) {
    unawaited(_initialize());
  }

  final CHPDao dao;
  final SyncService syncService;
  final Connectivity _connectivity = Connectivity();
  final Uuid _uuid = const Uuid();

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;
  List<CHPRecord> _records = [];
  bool _isLoading = true;
  bool _isSyncing = false;
  bool _isOnline = false;
  int _legacyRecordCount = 0;
  String? _error;

  List<CHPRecord> get records => List.unmodifiable(_records);
  bool get isLoading => _isLoading;
  bool get isSyncing => _isSyncing;
  bool get isOnline => _isOnline;
  int get pendingCount => _records.where((record) => !record.isSynced).length;
  int get legacyRecordCount => _legacyRecordCount;
  String? get error => _error;

  Future<void> _initialize() async {
    try {
      await dao.resetInterruptedSyncs();
      await loadRecords();
      _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
        _handleConnectivityChange,
        onError: (Object error) {
          _error = 'Could not monitor network status: $error';
          notifyListeners();
        },
      );
      _updateConnectivity(await _connectivity.checkConnectivity());
    } catch (error) {
      _error = error.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadRecords() async {
    _isLoading = true;
    notifyListeners();
    try {
      _records = await dao.getAllRecords();
      _legacyRecordCount = await dao.getLegacyRecordCount();
      _error = null;
    } catch (error) {
      _error = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addRecord({
    required String patientChwId,
    required String patientName,
    required String villageName,
    required String visitType,
    required String vitalsBP,
    required double vitalsTemp,
    required String urgencyLevel,
    required String visitNotes,
  }) async {
    final patientId = patientChwId.trim().toUpperCase();
    final record = CHPRecord(
      localId: _uuid.v4(),
      chwId: patientId,
      patientId: patientId,
      patientName: patientName.trim(),
      villageName: villageName.trim(),
      visitType: visitType,
      vitalsBP: vitalsBP.trim(),
      vitalsTemp: vitalsTemp,
      urgencyLevel: urgencyLevel,
      visitNotes: visitNotes.trim(),
      createdAtLocal: DateTime.now().toUtc(),
    );

    try {
      await dao.insertRecord(record);
      _records = [record, ..._records];
      _error = null;
      notifyListeners();
      if (_isOnline) {
        _syncAutomatically();
      }
    } catch (error) {
      _error = error.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<int> syncPending() async {
    if (_isSyncing || !_isOnline) {
      return 0;
    }
    _isSyncing = true;
    _error = null;
    notifyListeners();

    var syncedCount = 0;
    try {
      final pendingRecords = await dao.getPendingRecords();
      for (final record in pendingRecords) {
        await _updateRecordStatus(record.localId, SyncStatus.syncing);
      }
      try {
        await syncService.syncRecords(pendingRecords);
      } catch (_) {
        for (final record in pendingRecords) {
          await _updateRecordStatus(record.localId, SyncStatus.pending);
        }
        rethrow;
      }
      for (final record in pendingRecords) {
        await _updateRecordStatus(record.localId, SyncStatus.synced);
        syncedCount++;
      }
      return syncedCount;
    } catch (error) {
      _error = error.toString();
      rethrow;
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

  Future<void> _updateRecordStatus(String localId, SyncStatus status) async {
    await dao.setSyncStatus(localId, status);
    _records = [
      for (final record in _records)
        if (record.localId == localId)
          record.copyWith(syncStatus: status)
        else
          record,
    ];
    notifyListeners();
  }

  void _handleConnectivityChange(List<ConnectivityResult> results) {
    _updateConnectivity(results);
  }

  void _updateConnectivity(List<ConnectivityResult> results) {
    final wasOnline = _isOnline;
    _isOnline = results.any((result) => result != ConnectivityResult.none);
    notifyListeners();
    if (_isOnline && !wasOnline) {
      _syncAutomatically();
    }
  }

  void _syncAutomatically() {
    unawaited(_syncAndSurfaceError());
  }

  Future<void> _syncAndSurfaceError() async {
    try {
      await syncPending();
    } catch (_) {
      // syncPending stores the failure in state for the queue screen to show.
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  @override
  void dispose() {
    unawaited(_connectivitySubscription?.cancel());
    syncService.dispose();
    super.dispose();
  }
}
