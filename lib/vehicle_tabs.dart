import 'package:flutter/material.dart';
import 'entry_form.dart';
import 'models.dart';
import 'storage.dart';
import 'theme.dart';
import 'util.dart';

class HistoryTab extends StatelessWidget {
  final Vehicle v;
  const HistoryTab(this.v, {super.key});

  @override
  Widget build(BuildContext context) {
    final list = Store.i.forVehicle(v.id);
    if (list.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text(
            'Aucune intervention.\nAppuie sur « Intervention » pour ajouter une vidange, une pièce, une réparation…',
            textAlign: TextAlign.center,
            style: kMuted,
          ),
        ),
      );
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
      children: [for (final e in list) _tile(context, e)],
    );
  }

  Widget _tile(BuildContext context, Entry e) {
    return Panel(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => EntryForm(vehicleId: v.id, entry: e))),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: C.orange.withAlpha(30),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(iconFor(e.type), color: C.orange),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(e.title, style: kBold),
            const SizedBox(height: 3),
            Text('${fmtDate(e.date)} • ${fmtKm(e.km)}', style: kMuted),
            if (e.byGarage)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Row(children: [
                  const Icon(Icons.store_outlined, size: 14, color: C.blue),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      e.garage.isEmpty ? 'Garage' : e.garage,
                      style: const TextStyle(fontSize: 12, color: C.blue, fontWeight: FontWeight.w600),
                    ),
                  ),
                ]),
              ),
          ]),
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(fmtMoney(e.total), style: kBold),
          if (e.byGarage)
            Text('pièces ${fmtMoney(e.parts)}\nM.O. ${fmtMoney(e.labor)}',
                textAlign: TextAlign.right, style: const TextStyle(fontSize: 11, color: C.muted)),
        ]),
      ]),
    );
  }
}

class CostsTab extends StatelessWidget {
  final Vehicle v;
  const CostsTab(this.v, {super.key});

  Widget _stat(String label, double val, Color color) => Expanded(
        child: Panel(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: kMuted),
            const SizedBox(height: 6),
            Text(fmtMoney(val), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: color)),
          ]),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final es = Store.i.forVehicle(v.id);
    final parts = es.fold<double>(0, (s, e) => s + e.parts);
    final labor = es.fold<double>(0, (s, e) => s + e.labor);
    final byType = <String, double>{};
    for (final e in es) {
      byType[e.type] = (byType[e.type] ?? 0) + e.total;
    }
    final sorted = byType.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    final maxV = sorted.isEmpty || sorted.first.value <= 0 ? 1.0 : sorted.first.value;
    final driven = v.currentKm - v.purchaseKm;

    return ListView(padding: const EdgeInsets.all(16), children: [
      Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [C.navy, C.navy2],
          ),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Coût total du véhicule', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 6),
          Text(fmtMoney(v.price + parts + labor),
              style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800)),
          const SizedBox(height: 4),
          const Text('Achat + pièces + main d’œuvre', style: TextStyle(color: C.orange, fontSize: 12)),
        ]),
      ),
      Row(children: [
        _stat('Achat', v.price, C.navy),
        const SizedBox(width: 10),
        _stat('Pièces', parts, C.blue),
        const SizedBox(width: 10),
        _stat('Main d’œuvre', labor, C.orange),
      ]),
      if (sorted.isNotEmpty)
        Panel(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Par catégorie', style: kBold),
            const SizedBox(height: 12),
            for (final s in sorted) ...[
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(s.key, style: kMuted),
                Text(fmtMoney(s.value), style: kBold),
              ]),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: s.value / maxV,
                  minHeight: 8,
                  backgroundColor: C.bg,
                  color: C.blue,
                ),
              ),
              const SizedBox(height: 12),
            ],
          ]),
        ),
      if (driven > 0 && parts + labor > 0)
        Panel(
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Entretien / 100 km', style: kBold),
            Text(fmtMoney((parts + labor) / driven * 100), style: kTitle),
          ]),
        ),
    ]);
  }
}

class InfoTab extends StatelessWidget {
  final Vehicle v;
  const InfoTab(this.v, {super.key});

  Widget _row(String l, String val) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(l, style: kMuted),
          Flexible(child: Text(val, style: kBold, textAlign: TextAlign.right)),
        ]),
      );

  Future<void> _editKm(BuildContext c) async {
    final ctl = TextEditingController(text: v.currentKm.toString());
    final ok = await showDialog<bool>(
      context: c,
      builder: (ctx) => AlertDialog(
        title: const Text('Kilométrage actuel'),
        content: TextField(
          controller: ctl,
          keyboardType: TextInputType.number,
          decoration: deco('Kilométrage', suffix: 'km'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Annuler')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Enregistrer')),
        ],
      ),
    );
    if (ok == true) {
      v.currentKm = parseI(ctl.text);
      Store.i.upsertVehicle(v);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vid = Store.i.forVehicle(v.id).where((e) => e.type == 'Vidange').toList();
    return ListView(padding: const EdgeInsets.all(16), children: [
      Panel(
        child: Column(children: [
          _row('Modèle', v.name),
          if (v.plate.isNotEmpty) _row('Immatriculation', v.plate),
          if (v.year > 0) _row('Année', '${v.year}'),
          _row('Prix d’achat', fmtMoney(v.price)),
          _row('Km à l’achat', fmtKm(v.purchaseKm)),
          _row('Km actuel', fmtKm(v.currentKm)),
        ]),
      ),
      Panel(
        child: Column(children: [
          _row('Dernière vidange',
              vid.isEmpty ? '—' : '${fmtDate(vid.first.date)} • ${fmtKm(vid.first.km)}'),
          _row('Prochaine (indicatif)', vid.isEmpty ? '—' : fmtKm(vid.first.km + 15000)),
        ]),
      ),
      OutlinedButton.icon(
        onPressed: () => _editKm(context),
        icon: const Icon(Icons.speed),
        label: const Text('Mettre à jour le kilométrage'),
        style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
      ),
    ]);
  }
}
