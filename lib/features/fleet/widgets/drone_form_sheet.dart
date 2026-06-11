import 'package:flutter/material.dart';

import '../../../core/api/api_client.dart';
import '../../../core/utils/parsing.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/sheets.dart';
import '../../auth/models/auth_session.dart';
import '../models/drone.dart';

class DroneFormSheet extends StatefulWidget {
  const DroneFormSheet({super.key, required this.session, this.drone});

  final AuthSession session;
  final Drone? drone;

  @override
  State<DroneFormSheet> createState() => _DroneFormSheetState();
}

class _DroneFormSheetState extends State<DroneFormSheet> {
  final api = ApiClient();
  late final name = TextEditingController(text: widget.drone?.name ?? '');
  late final manufacturer = TextEditingController(
    text: widget.drone?.manufacturer ?? '',
  );
  late final model = TextEditingController(text: widget.drone?.model ?? '');
  late final serialNumber = TextEditingController(
    text: widget.drone?.serialNumber ?? '',
  );
  late final uin = TextEditingController(text: widget.drone?.uin ?? '');
  late final category = TextEditingController(
    text: widget.drone?.category ?? '',
  );
  late final weightKg = TextEditingController(
    text: widget.drone?.weightKg?.toString() ?? '',
  );
  late final payloadKg = TextEditingController(
    text: widget.drone?.payloadCapacityKg?.toString() ?? '',
  );
  late final notes = TextEditingController(text: widget.drone?.notes ?? '');
  bool isSaving = false;

  @override
  void dispose() {
    name.dispose();
    manufacturer.dispose();
    model.dispose();
    serialNumber.dispose();
    uin.dispose();
    category.dispose();
    weightKg.dispose();
    payloadKg.dispose();
    notes.dispose();
    super.dispose();
  }

  Future<void> save() async {
    setState(() => isSaving = true);
    final input = {
      'name': name.text.trim(),
      'manufacturer': manufacturer.text.trim(),
      'model': model.text.trim(),
      'serialNumber': serialNumber.text.trim(),
      'uin': emptyToNull(uin.text),
      'category': emptyToNull(category.text),
      'weightKg': parseOptionalNumber(weightKg.text),
      'payloadCapacityKg': parseOptionalNumber(payloadKg.text),
      'notes': emptyToNull(notes.text),
    };

    try {
      if (widget.drone == null) {
        await api.createDrone(widget.session.token, input);
      } else {
        await api.updateDrone(widget.session.token, widget.drone!.id, input);
      }
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (error) {
      if (mounted) {
        showToast(context, error.toString(), isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return SheetFrame(
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SheetHeader(
              title: widget.drone == null ? 'Add drone' : 'Edit drone',
              subtitle: 'Name, manufacturer, model, and serial are required.',
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
                children: [
                  FormSection(
                    title: 'Identity',
                    children: [
                      TextField(
                        controller: name,
                        decoration: const InputDecoration(
                          labelText: 'Drone name *',
                        ),
                      ),
                      TextField(
                        controller: manufacturer,
                        decoration: const InputDecoration(
                          labelText: 'Manufacturer *',
                        ),
                      ),
                      TextField(
                        controller: model,
                        decoration: const InputDecoration(labelText: 'Model *'),
                      ),
                      TextField(
                        controller: serialNumber,
                        decoration: const InputDecoration(
                          labelText: 'Serial number *',
                        ),
                      ),
                    ],
                  ),
                  FormSection(
                    title: 'Registration and capability',
                    children: [
                      TextField(
                        controller: uin,
                        decoration: const InputDecoration(
                          labelText: 'UIN / registration',
                        ),
                      ),
                      TextField(
                        controller: category,
                        decoration: const InputDecoration(
                          labelText: 'Category',
                        ),
                      ),
                      TextField(
                        controller: weightKg,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Weight kg',
                        ),
                      ),
                      TextField(
                        controller: payloadKg,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Payload kg',
                        ),
                      ),
                    ],
                  ),
                  FormSection(
                    title: 'Notes',
                    children: [
                      TextField(
                        controller: notes,
                        minLines: 3,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          labelText: 'Maintenance notes or context',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 28),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: isSaving
                          ? null
                          : () => Navigator.of(context).pop(false),
                      child: const Text('Discard'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FilledButton(
                      onPressed: isSaving ? null : save,
                      child: Text(isSaving ? 'Saving...' : 'Save drone'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
