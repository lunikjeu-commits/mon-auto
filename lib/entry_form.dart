import 'package:flutter/material.dart';
import 'models.dart';
import 'storage.dart';
import 'theme.dart';
import 'util.dart';

class EntryForm extends StatefulWidget {
  final String vehicleId;
  final Entry? entry;
  const EntryForm({super.key, required this.vehicleId, this.entry});
  @override
  State<EntryForm> createState() => _EntryFormState();
}

class _EntryFormState extends State<EntryForm> {
  Entry? get e => widget.entry;
  late String type = e?.type ?? entryTypes.first;
  late DateTime date = e?.date ?? DateTime.now();
  late bool byGarage = e?.byGarage ?? false;
  late final title = TextEditingController(text: e?.title ?? '');
  late final km = TextEditingController(
      text: numText(e?.km ?? Store.i.vehicle(widget.vehicleId)?.currentKm));
  late final parts = TextEditingController(text: numText(e?.parts));
  late final labor = TextEditingController(text: numText(e?.labor));
  late final garage = TextEditingController(text: e?.garage ?? '');
  late final notes = TextEditingController(text: e?.notes ?? '');

  Widget _f(TextEditingController c, String l,
      {IconData? icon, String? suffix, bool number = false, int lines = 1, bool live = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        maxLines: lines,
        onChanged: live ? (_) => setState(() {}) : null,
        keyboardType: number ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
        decoration: deco(l, suffix: suffix, icon: icon),
      ),
    );
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(1980),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (d != null) setState(() => date = d);
  }

  void _save() {
    Store.i.upsertEntry(Entry(
      id: e?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      vehicleId: widget.vehicleId,
      type: type,
      title: title.text.trim().isEmpty ? type : title.text.trim(),
      date: date,
      km: parseI(km.text),
      parts: parseD(parts.text),
      labor: byGarage ? parseD(labor.text) : 0,
      byGarage: byGarage,
      garage: byGarage ? garage.text.trim() : '',
      notes: notes.text.trim(),
    ));
    Navigator.pop(context);
  }

  Future<void> _delete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer cette intervention ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Annuler')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Supprimer')),
        ],
      ),
    );
    if (ok == true && mounted) {
      Store.i.deleteEntry(e!.id);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final total = parseD(parts.text) + (byGarage ? parseD(labor.text) : 0);
    return Scaffold(
      appBar: AppBar(
        title: Text(e == null ? 'Nouvelle intervention' : 'Modifier'),
        actions: [if (e != null) IconButton(icon: const Icon(Icons.delete_outline), onPressed: _delete)],
      ),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        const Text('Type', style: kBold),
        const SizedBox(height: 8),
        Wrap(spacing: 8, runSpacing: 8, children: [
          for (final t in entryTypes)
            ChoiceChip(
              avatar: Icon(iconFor(t), size: 18),
              label: Text(t),
              selected: type == t,
              onSelected: (_) => setState(() => type = t),
            ),
        ]),
        sectionLabel('Détails'),
        _f(title, 'Intitulé (ex : Filtre à huile, plaquettes AV)', icon: Icons.edit_outlined),
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            child: ListTile(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              leading: const Icon(Icons.event_outlined),
              title: Text(fmtDate(date)),
              subtitle: const Text('Date de l’intervention'),
              onTap: _pickDate,
            ),
          ),
        ),
        _f(km, 'Kilométrage au moment', icon: Icons.speed, suffix: 'km', number: true),
        sectionLabel('Coûts'),
        _f(parts, 'Prix des pièces', icon: Icons.settings, suffix: '€', number: true, live: true),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Réparé par un garage'),
          subtitle: const Text('Ajoute la main d’œuvre facturée'),
          value: byGarage,
          onChanged: (b) => setState(() => byGarage = b),
        ),
        if (byGarage) ...[
          _f(garage, 'Nom du garage', icon: Icons.store_outlined),
          _f(labor, 'Main d’œuvre', icon: Icons.engineering_outlined, suffix: '€', number: true, live: true),
        ],
        _f(notes, 'Notes (facultatif)', icon: Icons.notes, lines: 3),
        Panel(
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Total', style: kBold),
            Text(fmtMoney(total), style: kTitle),
          ]),
        ),
        FilledButton.icon(
          onPressed: _save,
          icon: const Icon(Icons.check),
          label: const Text('Enregistrer'),
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(54)),
        ),
      ]),
    );
  }
}
