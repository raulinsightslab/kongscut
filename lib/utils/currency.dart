import 'package:intl/intl.dart';

final NumberFormat rupiahFormatter = NumberFormat.decimalPattern("id");

String formatRupiah(dynamic value) {
  if (value == null) return "Rp0";

  // Handle berbagai tipe data
  double number;

  if (value is int) {
    number = value.toDouble();
  } else if (value is double) {
    number = value;
  } else if (value is String) {
    // Parse string ke double, handle comma dan dot
    number = double.tryParse(value.replaceAll(',', '.')) ?? 0.0;
  } else {
    number = double.tryParse(value.toString()) ?? 0.0;
  }

  // Format tanpa decimal (menghilangkan .00)
  return "Rp${rupiahFormatter.format(number).replaceAll(RegExp(r'\.00$'), '')}";
}
