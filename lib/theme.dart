import 'package:flutter/material.dart';

class C {
  static const navy = Color(0xFF0F1B2D);
  static const navy2 = Color(0xFF1B2F4B);
  static const blue = Color(0xFF2F6BFF);
  static const bg = Color(0xFFF3F5F9);
  static const orange = Color(0xFFFF9F1C);
  static const green = Color(0xFF16A877);
  static const red = Color(0xFFE5484D);
  static const text = Color(0xFF1A2433);
  static const muted = Color(0xFF6B778C);
}

const kTitle = TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: C.text);
const kBold = TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: C.text);
const kMuted = TextStyle(fontSize: 13, color: C.muted);

ThemeData buildTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: C.blue).copyWith(primary: C.blue),
    scaffoldBackgroundColor: C.bg,
    appBarTheme: const AppBarTheme(
      backgroundColor: C.navy,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: C.blue,
      foregroundColor: Colors.white,
    ),
  );
}

InputDecoration deco(String label, {String? suffix, IconData? icon}) {
  OutlineInputBorder b(Color c, double w) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: c, width: w),
      );
  return InputDecoration(
    labelText: label,
    suffixText: suffix,
    prefixIcon: icon == null ? null : Icon(icon, size: 20),
    filled: true,
    fillColor: Colors.white,
    border: b(const Color(0xFFE1E6EF), 1),
    enabledBorder: b(const Color(0xFFE1E6EF), 1),
    focusedBorder: b(C.blue, 1.6),
  );
}

class Panel extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets padding;
  const Panel({super.key, required this.child, this.onTap, this.padding = const EdgeInsets.all(16)});

  @override
  Widget build(BuildContext context) {
    final r = BorderRadius.circular(18);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: r,
        boxShadow: const [BoxShadow(color: Color(0x14102A43), blurRadius: 16, offset: Offset(0, 6))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(borderRadius: r, onTap: onTap, child: Padding(padding: padding, child: child)),
      ),
    );
  }
}

Widget sectionLabel(String t) =>
    Padding(padding: const EdgeInsets.only(top: 18, bottom: 8), child: Text(t, style: kBold));

void snack(BuildContext c, String m) => ScaffoldMessenger.of(c)
    .showSnackBar(SnackBar(content: Text(m), behavior: SnackBarBehavior.floating));
