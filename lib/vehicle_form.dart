import 'package:flutter/material.dart';
import 'models.dart';
import 'storage.dart';
import 'theme.dart';
import 'util.dart';

class VehicleForm extends StatefulWidget {
  final Vehicle? vehicle;
  const VehicleForm({super.key, this.vehicle});
  @override
  State<VehicleForm> createState() => _VehicleFormState();
}

class _VehicleFormState extends State<VehicleForm> {
  Vehicle? get v => widget.vehicle;
  late final name = TextEditingController(text: v?.name ?? '');
  late final plate = TextEditingController(text: v?.plate ?? '');
  late final year = TextEditingController(text: numText(v?.year));
  late final price = TextEditingController(text: numText(v?.price));
  late final purchaseKm = TextEditingController(text: numText(v?.purchaseKm));
  late final currentKm = TextEditingController(text: numText(v?.currentKm));

  Widget _f(TextEditingController c, String l,
      {IconData? icon, String? suffix, bool number = false, TextCapitalization cap = TextCapitalization.none}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        textCapitalization: cap,
        keyboardType: number ? const TextInputType.numberWithOptions(decimal: true) : TextInputType.text,
        decoration: deco(l, suffix: suffix, icon: icon),
      ),
    );
  }

  void _save() {
    if (name.text.trim().isEmpty) {
      snack(context, 'Indique le modèle de la voiture');
      return;
    }
    final pk = parseI(purchaseKm.text);
    var ck = parseI(currentKm.text);
    if (ck < pk) ck = pk;
    Store.i.upsertVehicle(Vehicle(
      id: v?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      name: name.text.trim(),
      plate: plate.text.trim().toUpperCase(),
      year: parseI(year.text),
      price: parseD(price.text),
      purchaseKm: pk,
      currentKm: ck,
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(v == null ? 'Nouveau véhicule' : 'Modifier le véhicule')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        _f(name, 'Modèle (ex : Renault Clio 4)', icon: Icons.directions_car_outlined, cap: TextCapitalization.words),
        _f(plate, 'Immatriculation (facultatif)', icon: Icons.pin_outlined, cap: TextCapitalization.characters),
        _f(year, 'Année', icon: Icons.event_outlined, number: true),
        _f(price, 'Prix d’achat', icon: Icons.euro, suffix: '€', number: true),
        _f(purchaseKm, 'Kilométrage à l’achat', icon: Icons.speed, suffix: 'km', number: true),
        _f(currentKm, 'Kilométrage actuel', icon: Icons.route_outlined, suffix: 'km', number: true),
        const SizedBox(height: 8),
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
