import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/sync_bloc.dart';

const _brandTeal = Color(0xFF00796B);
const _visitTypes = {
  'Routine Checkup': 'General',
  'Antenatal Care': 'Maternal',
  'Immunization': 'Child',
};
const _urgencyLevels = ['Routine', 'Urgent', 'Emergency'];

class FormScreen extends StatefulWidget {
  const FormScreen({super.key, this.isOnline = false});

  final bool isOnline;

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _patientChwIdController = TextEditingController();
  final _patientNameController = TextEditingController();
  final _villageController = TextEditingController();
  final _bloodPressureController = TextEditingController();
  final _temperatureController = TextEditingController();
  final _notesController = TextEditingController();
  String? _selectedVisitType;
  String _selectedUrgency = 'Routine';
  bool _isSaving = false;

  @override
  void dispose() {
    _patientChwIdController.dispose();
    _patientNameController.dispose();
    _villageController.dispose();
    _bloodPressureController.dispose();
    _temperatureController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String? _requiredText(String? value, String label) {
    if (value == null || value.trim().isEmpty) return 'Enter $label';
    return null;
  }

  Future<void> _saveRecord() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    try {
      await context.read<SyncBloc>().addRecord(
        patientChwId: _patientChwIdController.text,
        patientName: _patientNameController.text,
        villageName: _villageController.text,
        visitType: _visitTypes[_selectedVisitType]!,
        vitalsBP: _bloodPressureController.text,
        vitalsTemp: double.parse(_temperatureController.text),
        urgencyLevel: _selectedUrgency,
        visitNotes: _notesController.text,
      );

      if (!mounted) return;
      if (_selectedUrgency == 'Emergency') {
        await showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Emergency visit saved'),
            content: const Text(
              'Follow your local emergency referral protocol immediately. '
              'This app does not notify emergency services.',
            ),
            actions: [
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Understood'),
              ),
            ],
          ),
        );
      }
      if (!mounted) return;

      _formKey.currentState!.reset();
      _patientChwIdController.clear();
      _patientNameController.clear();
      _villageController.clear();
      _bloodPressureController.clear();
      _temperatureController.clear();
      _notesController.clear();
      setState(() {
        _selectedVisitType = null;
        _selectedUrgency = 'Routine';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Record saved locally and queued to sync.'),
        ),
      );
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not save record: $error')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  InputDecoration _decoration({
    required String label,
    String? hint,
    IconData? icon,
    String? suffix,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: icon == null ? null : Icon(icon),
      suffixText: suffix,
      border: const OutlineInputBorder(),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: _brandTeal, width: 2),
      ),
    );
  }

  Widget _sectionHeader(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: _brandTeal,
        fontSize: 13,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.7,
      ),
    );
  }

  Widget _divider() {
    return const Padding(
      padding: EdgeInsets.only(top: 24, bottom: 20),
      child: Divider(height: 1, thickness: 1.5),
    );
  }

  Widget _vitalsFields({required bool sideBySide}) {
    final bloodPressure = TextFormField(
      controller: _bloodPressureController,
      decoration: _decoration(
        label: 'Blood Pressure (optional)',
        hint: 'SYS/DIA (e.g. 120/80)',
        icon: Icons.favorite_border,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) return null;
        return RegExp(r'^\d{2,3}/\d{2,3}$').hasMatch(value.trim())
            ? null
            : 'Use SYS/DIA format, e.g. 120/80';
      },
    );
    final temperature = TextFormField(
      controller: _temperatureController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: _decoration(
        label: 'Temperature *',
        suffix: '°C',
        icon: Icons.thermostat_outlined,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) return 'Required';
        final temp = double.tryParse(value.trim());
        if (temp == null || temp < 35 || temp > 43) {
          return 'Range: 35.0 - 43.0';
        }
        return null;
      },
    );

    if (!sideBySide) {
      return Column(
        children: [bloodPressure, const SizedBox(height: 16), temperature],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: bloodPressure),
        const SizedBox(width: 16),
        Expanded(child: temperature),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Log Patient Visit',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: _brandTeal,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Chip(
              avatar: Icon(
                widget.isOnline ? Icons.cloud_done : Icons.cloud_off,
                size: 16,
                color: widget.isOnline ? Colors.lightGreenAccent : Colors.amber,
              ),
              label: Text(
                widget.isOnline ? 'Online' : 'Offline Mode',
                style: const TextStyle(fontSize: 12, color: Colors.white),
              ),
              backgroundColor: Colors.white.withValues(alpha: 0.15),
              side: BorderSide.none,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final sideBySideVitals = constraints.maxWidth >= 600;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 760),
                  child: Form(
                    key: _formKey,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionHeader('SECTION 1: DEMOGRAPHICS & LOGISTICS'),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _patientChwIdController,
                          decoration: _decoration(
                            label: 'Patient CHW ID *',
                            hint: 'Use the same ID for this patient on every visit',
                            icon: Icons.badge_outlined,
                          ),
                          validator: (value) =>
                              _requiredText(value, 'a patient CHW ID'),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _patientNameController,
                          textCapitalization: TextCapitalization.words,
                          decoration: _decoration(
                            label: 'Patient Full Name *',
                            hint: "Enter patient's full name",
                            icon: Icons.person_outline,
                          ),
                          validator: (value) {
                            final error = _requiredText(
                              value,
                              'a patient name',
                            );
                            if (error != null) return error;
                            if (value!.trim().length < 2) {
                              return 'Name must be at least 2 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _villageController,
                          textCapitalization: TextCapitalization.words,
                          decoration: _decoration(
                            label: 'Village Name *',
                            hint: 'e.g. Kakamega Central',
                            icon: Icons.location_on_outlined,
                          ),
                          validator: (value) =>
                              _requiredText(value, 'a village name'),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          initialValue: _selectedVisitType,
                          decoration: _decoration(
                            label: 'Visit Type *',
                            icon: Icons.medical_services_outlined,
                          ),
                          items: _visitTypes.keys
                              .map(
                                (type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(type),
                                ),
                              )
                              .toList(),
                          onChanged: (value) =>
                              setState(() => _selectedVisitType = value),
                          validator: (value) =>
                              value == null ? 'Select a visit type' : null,
                        ),
                        _divider(),
                        _sectionHeader('SECTION 2: PATIENT VITALS'),
                        const SizedBox(height: 12),
                        _vitalsFields(sideBySide: sideBySideVitals),
                        _divider(),
                        _sectionHeader('SECTION 3: URGENCY LEVEL *'),
                        const SizedBox(height: 12),
                        Row(
                          children: _urgencyLevels.map((level) {
                            final selected = _selectedUrgency == level;
                            final color = switch (level) {
                              'Urgent' => Colors.orange,
                              'Emergency' => Colors.red,
                              _ => Colors.green,
                            };
                            return Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                ),
                                child: ChoiceChip(
                                  avatar: selected
                                      ? const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 16,
                                        )
                                      : null,
                                  label: Center(
                                    child: Text(
                                      level,
                                      style: TextStyle(
                                        color: selected
                                            ? Colors.white
                                            : Colors.black87,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  selected: selected,
                                  selectedColor: color,
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    side: BorderSide(
                                      color: selected
                                          ? color
                                          : Colors.grey.shade400,
                                    ),
                                  ),
                                  onSelected: (value) {
                                    if (value) {
                                      setState(() => _selectedUrgency = level);
                                    }
                                  },
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        _divider(),
                        _sectionHeader('SECTION 4: VISIT NOTES'),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _notesController,
                          maxLines: 4,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: const InputDecoration(
                            labelText: 'Observations & Action Taken',
                            alignLabelWithHint: true,
                            hintText: 'Describe complaints, treatments or referrals...',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton.icon(
                            onPressed: _isSaving ? null : _saveRecord,
                            icon: _isSaving
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.save_alt),
                            label: Text(
                              _isSaving ? 'Saving...' : 'Save Record Locally',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _brandTeal,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
