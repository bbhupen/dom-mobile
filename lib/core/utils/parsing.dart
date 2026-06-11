Object? emptyToNull(String value) {
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}

double? parseOptionalNumber(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) {
    return null;
  }
  return double.tryParse(trimmed);
}

double? nullableDouble(dynamic value) {
  if (value == null) {
    return null;
  }
  return asDouble(value, 0);
}

int? nullableInt(dynamic value) {
  if (value == null) {
    return null;
  }
  return asInt(value, 0);
}

double asDouble(dynamic value, double fallback) {
  if (value is num) {
    return value.toDouble();
  }
  if (value is String) {
    return double.tryParse(value) ?? fallback;
  }
  return fallback;
}

int asInt(dynamic value, int fallback) {
  if (value is num) {
    return value.toInt();
  }
  if (value is String) {
    return int.tryParse(value) ?? fallback;
  }
  return fallback;
}
