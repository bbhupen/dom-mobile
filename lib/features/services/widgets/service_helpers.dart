import 'package:flutter/material.dart';

const serviceCategories = {
  'mapping_survey': 'Mapping / survey',
  'inspection': 'Inspection',
  'agriculture': 'Agriculture',
  'media': 'Media',
  'monitoring': 'Monitoring',
  'custom': 'Custom',
};

const servicePricingUnits = {
  'per_project': 'Per project',
  'per_hour': 'Per hour',
  'per_acre': 'Per acre',
  'per_day': 'Per day',
};

String serviceCategoryLabel(String value) => serviceCategories[value] ?? value;

String servicePricingUnitLabel(String value) =>
    servicePricingUnits[value] ?? value;

String formatMoney(double? amount, String currency) {
  if (amount == null) {
    return 'Price not set';
  }

  final formatted = amount % 1 == 0
      ? amount.toStringAsFixed(0)
      : amount.toStringAsFixed(2);
  return '$currency $formatted';
}

Color serviceCategoryColor(String category) {
  return switch (category) {
    'mapping_survey' => const Color(0xffdff1e8),
    'inspection' => const Color(0xfffff1e5),
    'agriculture' => const Color(0xffe3f7d8),
    'media' => const Color(0xffe8ecff),
    'monitoring' => const Color(0xffe5f5ff),
    _ => const Color(0xffeef2f6),
  };
}
