import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/chp_record.dart';
import '../state/auth_controller.dart';
import '../state/sync_bloc.dart';
import 'form_screen.dart';

class QueueScreen extends StatefulWidget {
  const QueueScreen({super.key});

  @override
  State<QueueScreen> createState() => _QueueScreenState();
}

class _QueueScreenState extends State<QueueScreen> {
  bool _syncRequestedOnOpen = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_syncRequestedOnOpen) return;
    _syncRequestedOnOpen = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      try {
        await context.read<SyncBloc>().syncPending();
      } catch (_) {
        // The queue state exposes sync failures to the user.
      }
    });
  }

  Future<void> _sync(BuildContext context, SyncBloc bloc) async {
    try {
      final count = await bloc.syncPending();
      if (context.mounted) {
        final message = count == 0
            ? 'No records to sync.'
            : 'Synced $count ${count == 1 ? 'record' : 'records'}.';
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Sync failed: $error')));
      }
    }
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await context.read<AuthController>().signOut();
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signed out locally: $error')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.watch<SyncBloc>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('CHP Records'),
        actions: [
          IconButton(
            onPressed: bloc.isSyncing ? null : () => _sync(context, bloc),
            tooltip: 'Sync pending records',
            icon: bloc.isSyncing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.sync),
          ),
          IconButton(
            onPressed: () => _signOut(context),
            tooltip: 'Sign out',
            icon: const Icon(Icons.logout),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          _NetworkStatusBar(isOnline: bloc.isOnline),
          _QueueSummary(pendingCount: bloc.pendingCount),
          if (bloc.legacyRecordCount > 0)
            _LegacyRecordsNotice(count: bloc.legacyRecordCount),
          if (bloc.error case final error?) _ErrorBanner(message: error),
          Expanded(
            child: bloc.isLoading && bloc.records.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : bloc.records.isEmpty
                ? const _EmptyQueue()
                : RefreshIndicator(
                    onRefresh: bloc.loadRecords,
                    child: ListView.separated(
                      padding: const EdgeInsets.only(bottom: 88),
                      itemCount: bloc.records.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, index) =>
                          _RecordTile(record: bloc.records[index]),
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push<void>(
          MaterialPageRoute<void>(
            builder: (_) => FormScreen(isOnline: bloc.isOnline),
          ),
        ),
        icon: const Icon(Icons.add),
        label: const Text('New record'),
      ),
    );
  }
}

class _QueueSummary extends StatelessWidget {
  const _QueueSummary({required this.pendingCount});

  final int pendingCount;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: ListTile(
        leading: const Icon(Icons.cloud_upload_outlined),
        title: Text(
          '$pendingCount pending ${pendingCount == 1 ? 'record' : 'records'}',
        ),
        subtitle: const Text('Saved on this device until synced.'),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.errorContainer,
      child: ListTile(
        leading: const Icon(Icons.error_outline),
        title: const Text('An operation failed'),
        subtitle: Text(message),
        trailing: IconButton(
          tooltip: 'Dismiss error',
          onPressed: context.read<SyncBloc>().clearError,
          icon: const Icon(Icons.close),
        ),
      ),
    );
  }
}

class _NetworkStatusBar extends StatelessWidget {
  const _NetworkStatusBar({required this.isOnline});

  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    final color = isOnline ? Colors.green.shade800 : Colors.red.shade800;
    return Container(
      width: double.infinity,
      color: color,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        isOnline ? 'ONLINE · Network available' : 'OFFLINE · No network',
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _LegacyRecordsNotice extends StatelessWidget {
  const _LegacyRecordsNotice({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.info_outline),
      title: Text('$count legacy record(s) need review'),
      subtitle: const Text(
        'They were kept during the schema upgrade but do not include the '
        'required clinical fields.',
      ),
    );
  }
}

class _EmptyQueue extends StatelessWidget {
  const _EmptyQueue();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.assignment_outlined, size: 48),
            SizedBox(height: 12),
            Text('No records yet'),
            Text('Add a record to begin your offline queue.'),
          ],
        ),
      ),
    );
  }
}

class _RecordTile extends StatelessWidget {
  const _RecordTile({required this.record});

  final CHPRecord record;

  @override
  Widget build(BuildContext context) {
    final date = record.createdAtLocal.toLocal().toString().split(' ').first;
    return ListTile(
      leading: Icon(
        record.isSynced ? Icons.cloud_done_outlined : Icons.cloud_off_outlined,
      ),
      title: Text(record.patientName),
      subtitle: Text(
        '${record.villageName} · ${record.visitType} · ${record.urgencyLevel} · $date',
      ),
      trailing: Text(record.syncStatus.value),
    );
  }
}
