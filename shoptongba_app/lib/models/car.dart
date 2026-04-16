class Car {
  final String id;
  final String name;
  final String category; // e.g., "SUV", "Berline"
  final double pricePerDay;
  final String imageUrl;
  final int seats;
  final bool isAutomatic;

  Car({
    required this.id,
    required this.name,
    required this.category,
    required this.pricePerDay,
    required this.imageUrl,
    required this.seats,
    required this.isAutomatic,
  });
}

List<Car> dummyCars = [
  Car(
    id: '1',
    name: 'Range Rover Velar',
    category: 'SUV',
    pricePerDay: 150000,
    imageUrl: 'https://images.unsplash.com/photo-1609521263047-f8f205293f24?auto=format&fit=crop&q=80&w=800', // Placeholder
    seats: 5,
    isAutomatic: true,
  ),
  Car(
    id: '2',
    name: 'Mercedes-Benz C-Class',
    category: 'Berline',
    pricePerDay: 100000,
    imageUrl: 'https://images.unsplash.com/photo-1617788138017-80ad40651399?auto=format&fit=crop&q=80&w=800',
    seats: 5,
    isAutomatic: true,
  ),
  Car(
    id: '3',
    name: 'Toyota Prado',
    category: '4x4',
    pricePerDay: 80000,
    imageUrl: 'https://images.unsplash.com/photo-1533473359331-0135ef1bcfb0?auto=format&fit=crop&q=80&w=800',
    seats: 7,
    isAutomatic: true,
  ),
  Car(
    id: '4',
    name: 'Hyundai Tucson',
    category: 'SUV',
    pricePerDay: 60000,
    imageUrl: 'https://images.unsplash.com/photo-1626077388041-33f1108cea81?auto=format&fit=crop&q=80&w=800',
    seats: 5,
    isAutomatic: true,
  ),
];
