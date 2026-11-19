import 'package:flutter/material.dart';
import 'entry_form.dart';
import 'storage.dart';
import 'theme.dart';
import 'vehicle_form.dart';
import 'vehicle_tabs.dart';

class VehiclePage extends StatelessWidget {
  final String id;
  const VehiclePage({super.key, required this.id});

  Future<void> _delete(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer ce véhicule ?'),
        content: const Text('Toutes ses interventions seront aussi supprimées.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Annuler')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Supprimer')),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      Navigator.pop(context);
      Store.i.deleteVehicle(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Store.i,
      builder: (context, _) {
        final v = Store.i.vehicle(id);
        if (v == null) return const Scaffold(body: SizedBox());
        return DefaultTabController(
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              title: Text(v.name),
              actions: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => Navigator.push(
                      context, MaterialPageRoute(builder: (_) => VehicleForm(vehicle: v))),
                ),
                IconButton(icon: const Icon(Icons.delete_outline), onPressed: () => _delete(context)),
              ],
              bottom: const TabBar(
                indicatorColor: C.orange,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white60,
                tabs: [
                  Tab(icon: Icon(Icons.build_circle_outlined), text: 'Entretien'),
                  Tab(icon: Icon(Icons.pie_chart_outline), text: 'Coûts'),
                  Tab(icon: Icon(Icons.directions_car_outlined), text: 'Fiche'),
                ],
              ),
            ),
            body: TabBarView(children: [HistoryTab(v), CostsTab(v), InfoTab(v)]),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (_) => EntryForm(vehicleId: v.id))),
              icon: const Icon(Icons.add),
              label: const Text('Intervention'),
            ),
          ),
        );
      },
    );
  }
}
