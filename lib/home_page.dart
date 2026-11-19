import 'package:flutter/material.dart';
import 'about.dart';
import 'models.dart';
import 'storage.dart';
import 'theme.dart';
import 'util.dart';
import 'vehicle_form.dart';
import 'vehicle_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _add(BuildContext c) =>
      Navigator.push(c, MaterialPageRoute(builder: (_) => const VehicleForm()));

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Store.i,
      builder: (context, _) {
        final vs = Store.i.vehicles;
        return Scaffold(
          appBar: AppBar(
            title: const Text('Mon auto'),
            actions: [
              IconButton(icon: const Icon(Icons.tune), onPressed: () => showOptions(context)),
            ],
          ),
          body: vs.isEmpty
              ? _empty(context)
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                  children: [_hero(vs), ...vs.map((v) => _card(context, v))],
                ),
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => _add(context),
            icon: const Icon(Icons.add),
            label: const Text('Véhicule'),
          ),
        );
      },
    );
  }

  Widget _empty(BuildContext c) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Icon(Icons.directions_car_filled, size: 72, color: C.blue),
            const SizedBox(height: 16),
            const Text('Bienvenue dans Mon auto', style: kTitle),
            const SizedBox(height: 8),
            const Text(
              'Ajoute ta voiture pour suivre ses vidanges, ses pièces et ses réparations.',
              textAlign: TextAlign.center,
              style: kMuted,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () => _add(c),
              icon: const Icon(Icons.add),
              label: const Text('Ajouter ma voiture'),
            ),
          ]),
        ),
      );

  Widget _hero(List<Vehicle> vs) {
    final total = vs.fold<double>(0, (s, v) => s + Store.i.spent(v.id));
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [C.navy, C.navy2],
        ),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Dépenses d’entretien', style: TextStyle(color: Colors.white70)),
        const SizedBox(height: 6),
        Text(fmtMoney(total),
            style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        Text('${vs.length} véhicule${vs.length > 1 ? 's' : ''}',
            style: const TextStyle(color: C.orange, fontWeight: FontWeight.w600)),
      ]),
    );
  }

  Widget _card(BuildContext c, Vehicle v) {
    final sub = [
      if (v.plate.isNotEmpty) v.plate,
      if (v.year > 0) '${v.year}',
      fmtKm(v.currentKm),
    ].join(' • ');
    return Panel(
      onTap: () => Navigator.push(c, MaterialPageRoute(builder: (_) => VehiclePage(id: v.id))),
      child: Row(children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: C.blue.withAlpha(25),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.directions_car_filled, color: C.blue),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(v.name, style: kTitle),
            const SizedBox(height: 4),
            Text(sub, style: kMuted),
          ]),
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(fmtMoney(Store.i.spent(v.id)), style: kBold),
          const Text('entretien', style: kMuted),
        ]),
      ]),
    );
  }
}
