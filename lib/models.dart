class Vehicle {
  String id, name, plate;
  int year, purchaseKm, currentKm;
  double price;
  Vehicle({
    required this.id,
    required this.name,
    this.plate = '',
    this.year = 0,
    this.price = 0,
    this.purchaseKm = 0,
    this.currentKm = 0,
  });

  Map<String, dynamic> toJson() => {
        'id': id, 'name': name, 'plate': plate, 'year': year,
        'price': price, 'purchaseKm': purchaseKm, 'currentKm': currentKm,
      };

  factory Vehicle.fromJson(Map<String, dynamic> j) => Vehicle(
        id: j['id'],
        name: j['name'],
        plate: j['plate'] ?? '',
        year: j['year'] ?? 0,
        price: (j['price'] ?? 0).toDouble(),
        purchaseKm: j['purchaseKm'] ?? 0,
        currentKm: j['currentKm'] ?? 0,
      );
}

class Entry {
  String id, vehicleId, type, title, garage, notes;
  DateTime date;
  int km;
  double parts, labor;
  bool byGarage;
  Entry({
    required this.id,
    required this.vehicleId,
    required this.type,
    required this.title,
    required this.date,
    this.km = 0,
    this.parts = 0,
    this.labor = 0,
    this.byGarage = false,
    this.garage = '',
    this.notes = '',
  });

  double get total => parts + labor;

  Map<String, dynamic> toJson() => {
        'id': id, 'vehicleId': vehicleId, 'type': type, 'title': title,
        'date': date.toIso8601String(), 'km': km, 'parts': parts, 'labor': labor,
        'byGarage': byGarage, 'garage': garage, 'notes': notes,
      };

  factory Entry.fromJson(Map<String, dynamic> j) => Entry(
        id: j['id'],
        vehicleId: j['vehicleId'],
        type: j['type'],
        title: j['title'],
        date: DateTime.parse(j['date']),
        km: j['km'] ?? 0,
        parts: (j['parts'] ?? 0).toDouble(),
        labor: (j['labor'] ?? 0).toDouble(),
        byGarage: j['byGarage'] ?? false,
        garage: j['garage'] ?? '',
        notes: j['notes'] ?? '',
      );
}
