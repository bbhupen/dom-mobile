import 'package:flutter/material.dart';

class EmptyFleetCard extends StatelessWidget {
  const EmptyFleetCard({super.key, required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'No drones added yet',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 6),
            const Text(
              'Add the first drone to start building this fleet.',
              style: TextStyle(color: Color(0xff536170)),
            ),
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text('Add drone'),
            ),
          ],
        ),
      ),
    );
  }
}
