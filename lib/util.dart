import 'package:flutter/material.dart';

String _group(String digits) {
  final b = StringBuffer();
  for (int i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) b.write('\u202F');
    b.write(digits[i]);
  }
  return b.toString();
}

String fmtMoney(double v) {
  final sign = v < 0 ? '-' : '';
  final p = v.abs().toStringAsFixed(2).split('.');
  return '$sign${_group(p[0])},${p[1]} €';
}

String fmtKm(int km) => '${_group(km.toString())} km';

String fmtDate(DateTime d) =>
    '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

double parseD(String s) => double.tryParse(s.trim().replaceAll(',', '.').replaceAll(' ', '')) ?? 0;
int parseI(String s) => int.tryParse(s.trim().replaceAll(' ', '')) ?? 0;

String numText(num? n) {
  if (n == null || n == 0) return '';
  return n % 1 == 0 ? n.toStringAsFixed(0) : n.toStringAsFixed(2);
}

const entryTypes = [
  'Vidange',
  'Pièce remplacée',
  'Freins',
  'Pneus',
  'Révision',
  'Contrôle technique',
  'Autre',
];

IconData iconFor(String t) {
  switch (t) {
    case 'Vidange':
      return Icons.opacity;
    case 'Pièce remplacée':
      return Icons.settings;
    case 'Freins':
      return Icons.album_outlined;
    case 'Pneus':
      return Icons.trip_origin;
    case 'Révision':
      return Icons.fact_check_outlined;
    case 'Contrôle technique':
      return Icons.verified_outlined;
    default:
      return Icons.build_outlined;
  }
}
