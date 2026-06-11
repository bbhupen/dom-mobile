import 'package:flutter/material.dart';

import '../../../core/api/api_client.dart';
import '../../../core/utils/parsing.dart';
import '../../../core/widgets/app_snackbar.dart';
import '../../../core/widgets/option_picker.dart';
import '../../../core/widgets/sheets.dart';
import '../../auth/models/auth_session.dart';
import '../models/service_item.dart';
import 'service_helpers.dart';

class ServiceFormSheet extends StatefulWidget {
  const ServiceFormSheet({super.key, required this.session, this.service});

  final AuthSession session;
  final ServiceItem? service;

  @override
  State<ServiceFormSheet> createState() => _ServiceFormSheetState();
}

class _ServiceFormSheetState extends State<ServiceFormSheet> {
  final api = ApiClient();
  late final name = TextEditingController(text: widget.service?.name ?? '');
  late final description = TextEditingController(
    text: widget.service?.description ?? '',
  );
  late final basePrice = TextEditingController(
    text: widget.service?.basePrice?.toString() ?? '',
  );
  late final currency = TextEditingController(
    text: widget.service?.currency ?? 'INR',
  );
  late final duration = TextEditingController(
    text: widget.service?.estimatedDurationMinutes?.toString() ?? '',
  );
  late final deliverables = TextEditingController(
    text: widget.service?.deliverables ?? '',
  );
  late final notes = TextEditingController(text: widget.service?.notes ?? '');
  late String category = widget.service?.category ?? 'mapping_survey';
  late String pricingUnit = widget.service?.pricingUnit ?? 'per_project';
  bool isSaving = false;

  @override
  void dispose() {
    name.dispose();
    description.dispose();
    basePrice.dispose();
    currency.dispose();
    duration.dispose();
    deliverables.dispose();
    notes.dispose();
    super.dispose();
  }

  Future<void> save() async {
    setState(() => isSaving = true);
    final input = {
      'name': name.text.trim(),
      'category': category,
      'description': emptyToNull(description.text),
      'pricingUnit': pricingUnit,
      'basePrice': parseOptionalNumber(basePrice.text),
      'currency': currency.text.trim().isEmpty ? 'INR' : currency.text.trim(),
      'estimatedDurationMinutes': parseOptionalNumber(duration.text),
      'deliverables': emptyToNull(deliverables.text),
      'notes': emptyToNull(notes.text),
    };

    try {
      if (widget.service == null) {
        await api.createService(widget.session.token, input);
      } else {
        await api.updateService(
          widget.session.token,
          widget.service!.id,
          input,
        );
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
              title: widget.service == null ? 'Add service' : 'Edit service',
              subtitle:
                  'Name and category are required. Pricing can stay flexible.',
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
                children: [
                  FormSection(
                    title: 'Catalog',
                    children: [
                      TextField(
                        controller: name,
                        decoration: const InputDecoration(
                          labelText: 'Service name *',
                        ),
                      ),
                      OptionPickerField<String>(
                        label: 'Category *',
                        sheetTitle: 'Choose category',
                        enabled: !isSaving,
                        valueLabel: serviceCategoryLabel(category),
                        items: serviceCategories.entries
                            .map(
                              (entry) => OptionPickerItem(
                                value: entry.key,
                                label: entry.value,
                              ),
                            )
                            .toList(),
                        onChanged: (value) => setState(() => category = value),
                      ),
                      TextField(
                        controller: description,
                        minLines: 2,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                        ),
                      ),
                    ],
                  ),
                  FormSection(
                    title: 'Pricing',
                    children: [
                      OptionPickerField<String>(
                        label: 'Pricing unit',
                        sheetTitle: 'Choose pricing unit',
                        enabled: !isSaving,
                        valueLabel: servicePricingUnitLabel(pricingUnit),
                        items: servicePricingUnits.entries
                            .map(
                              (entry) => OptionPickerItem(
                                value: entry.key,
                                label: entry.value,
                              ),
                            )
                            .toList(),
                        onChanged: (value) =>
                            setState(() => pricingUnit = value),
                      ),
                      TextField(
                        controller: basePrice,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Base price',
                        ),
                      ),
                      TextField(
                        controller: currency,
                        decoration: const InputDecoration(
                          labelText: 'Currency',
                        ),
                      ),
                      TextField(
                        controller: duration,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Estimated duration minutes',
                        ),
                      ),
                    ],
                  ),
                  FormSection(
                    title: 'Outputs',
                    children: [
                      TextField(
                        controller: deliverables,
                        minLines: 2,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelText: 'Deliverables',
                        ),
                      ),
                      TextField(
                        controller: notes,
                        minLines: 2,
                        maxLines: 4,
                        decoration: const InputDecoration(labelText: 'Notes'),
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
                      child: Text(isSaving ? 'Saving...' : 'Save service'),
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
