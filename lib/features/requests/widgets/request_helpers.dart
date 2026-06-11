import 'package:flutter/material.dart';

const requestStatuses = {
  'draft': 'Draft',
  'submitted': 'Submitted',
  'under_review': 'Under review',
  'more_info_required': 'More info required',
  'quote_sent': 'Quote sent',
  'quote_accepted': 'Quote accepted',
  'quote_rejected': 'Quote rejected',
  'scheduled': 'Scheduled',
  'assigned': 'Assigned',
  'in_progress': 'In progress',
  'completed': 'Completed',
  'report_delivered': 'Report delivered',
  'cancelled': 'Cancelled',
  'rejected': 'Rejected',
};

const requestUrgencies = {
  'normal': 'Normal',
  'urgent': 'Urgent',
};

String requestStatusLabel(String value) => requestStatuses[value] ?? value;

String requestUrgencyLabel(String value) => requestUrgencies[value] ?? value;

String formatQuote(double? amount) {
  if (amount == null) {
    return 'Quote not set';
  }

  final formatted = amount % 1 == 0 ? amount.toStringAsFixed(0) : amount.toStringAsFixed(2);
  return 'INR $formatted';
}

String formatDateLabel(String? value) {
  if (value == null || value.isEmpty) {
    return 'Date not set';
  }

  return value.split('T').first;
}

Color requestStatusColor(String status) {
  return switch (status) {
    'submitted' || 'under_review' || 'more_info_required' => const Color(0xfffff1e5),
    'quote_sent' || 'quote_accepted' => const Color(0xffe5f5ff),
    'scheduled' || 'assigned' || 'in_progress' => const Color(0xffe8ecff),
    'completed' || 'report_delivered' => const Color(0xffdff1e8),
    'cancelled' || 'rejected' || 'quote_rejected' => const Color(0xffffe3e3),
    _ => const Color(0xffeef2f6),
  };
}
