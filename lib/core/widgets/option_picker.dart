import 'package:flutter/material.dart';

class OptionPickerItem<T> {
  const OptionPickerItem({required this.value, required this.label});

  final T value;
  final String label;
}

class OptionPickerField<T> extends StatelessWidget {
  const OptionPickerField({
    super.key,
    required this.label,
    required this.valueLabel,
    required this.items,
    required this.onChanged,
    this.sheetTitle,
    this.enabled = true,
  });

  final String label;
  final String valueLabel;
  final String? sheetTitle;
  final List<OptionPickerItem<T>> items;
  final ValueChanged<T> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: enabled ? () => openPicker(context) : null,
      child: InputDecorator(
        decoration: InputDecoration(
          enabled: enabled,
          labelText: label,
          suffixIcon: const Icon(Icons.keyboard_arrow_down),
        ),
        child: Text(valueLabel, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
    );
  }

  Future<void> openPicker(BuildContext context) async {
    final selected = await showDialog<T>(
      context: context,
      builder: (context) =>
          _OptionPickerPopup<T>(title: sheetTitle ?? label, items: items),
    );

    if (selected != null) {
      onChanged(selected);
    }
  }
}

class _OptionPickerPopup<T> extends StatelessWidget {
  const _OptionPickerPopup({required this.title, required this.items});

  final String title;
  final List<OptionPickerItem<T>> items;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      shadowColor: Colors.black26,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Color(0xffd8e0e8)),
      ),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420, maxHeight: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 12, 8, 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 6),
                itemCount: items.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = items[index];

                  return ListTile(
                    dense: true,
                    title: Text(item.label),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Navigator.of(context).pop(item.value),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
