import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models.dart';

class Store extends ChangeNotifier {
  static final Store i = Store._();
  Store._();

  final List<Vehicle> vehicles = [];
  final List<Entry> entries = [];
  static const _key = 'mon_auto_data';

  Future<void> load() async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getString(_key);
    if (raw != null) importJson(raw, save: false);
  }

  String exportJson() => jsonEncode({
        'vehicles': vehicles.map((e) => e.toJson()).toList(),
        'entries': entries.map((e) => e.toJson()).toList(),
      });

  bool importJson(String raw, {bool save = true}) {
    try {
      final m = jsonDecode(raw) as Map<String, dynamic>;
      final vs = (m['vehicles'] as List)
          .map((e) => Vehicle.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      final es = (m['entries'] as List)
          .map((e) => Entry.fromJson(Map<String, dynamic>.from(e)))
          .toList();
      vehicles..clear()..addAll(vs);
      entries..clear()..addAll(es);
      if (save) _save();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> _save() async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_key, exportJson());
    notifyListeners();
  }

  Vehicle? vehicle(String id) {
    for (final v in vehicles) {
      if (v.id == id) return v;
    }
    return null;
  }

  List<Entry> forVehicle(String id) =>
      entries.where((e) => e.vehicleId == id).toList()..sort((a, b) => b.date.compareTo(a.date));

  double spent(String vid) => entries.where((e) => e.vehicleId == vid).fold<double>(0, (s, e) => s + e.total);

  void upsertVehicle(Vehicle v) {
    final k = vehicles.indexWhere((x) => x.id == v.id);
    if (k >= 0) {
      vehicles[k] = v;
    } else {
      vehicles.add(v);
    }
    _save();
  }

  void deleteVehicle(String id) {
    vehicles.removeWhere((v) => v.id == id);
    entries.removeWhere((e) => e.vehicleId == id);
    _save();
  }

  void upsertEntry(Entry e) {
    final k = entries.indexWhere((x) => x.id == e.id);
    if (k >= 0) {
      entries[k] = e;
    } else {
      entries.add(e);
    }
    final v = vehicle(e.vehicleId);
    if (v != null && e.km > v.currentKm) v.currentKm = e.km;
    _save();
  }

  void deleteEntry(String id) {
    entries.removeWhere((e) => e.id == id);
    _save();
  }
}
