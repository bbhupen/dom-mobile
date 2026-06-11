import 'package:flutter/material.dart';

class DroneAvatar extends StatelessWidget {
  const DroneAvatar({super.key, required this.name, this.large = false});

  final String name;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final initials = name.trim().isEmpty
        ? 'DR'
        : name
              .trim()
              .substring(0, name.trim().length >= 2 ? 2 : 1)
              .toUpperCase();
    return Container(
      height: large ? 52 : 42,
      width: large ? 52 : 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xffdff1e8),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        initials,
        style: const TextStyle(
          color: Color(0xff3f7b62),
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      'active' => const Color(0xffdff1e8),
      'under_maintenance' => const Color(0xfffff1e5),
      'grounded' => const Color(0xffffe3e3),
      _ => const Color(0xffeef2f6),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status.replaceAll('_', ' '),
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
      ),
    );
  }
}

class SpecPill extends StatelessWidget {
  const SpecPill({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xfff7f9fc),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xffd8e0e8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              color: Color(0xff6b7886),
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
