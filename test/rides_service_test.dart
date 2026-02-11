import 'package:blabla/model/ride/locations.dart';
import 'package:blabla/model/ride/ride.dart';
import 'package:blabla/model/user/user.dart';
import 'package:blabla/service/rides_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final dijon = const Location(name: 'Dijon', country: Country.france);
  final paris = const Location(name: 'Paris', country: Country.france);
  final lyon = const Location(name: 'Lyon', country: Country.france);

  final driver = User(
    firstName: 'Test',
    lastName: 'Driver',
    email: 'driver@test.com',
    phone: '+000000',
    profilePicture: '',
    verifiedProfile: true,
  );

  Ride buildRide({
    required Location departure,
    required Location arrival,
    required int availableSeats,
  }) {
    final now = DateTime(2026, 2, 11, 8, 0);
    return Ride(
      departureLocation: departure,
      departureDate: now,
      arrivalLocation: arrival,
      arrivalDateTime: now.add(const Duration(hours: 2)),
      driver: driver,
      availableSeats: availableSeats,
      pricePerSeat: 10,
    );
  }

  setUp(() {
    RidesService.availableRides = [
      buildRide(departure: dijon, arrival: paris, availableSeats: 2),
      buildRide(departure: dijon, arrival: lyon, availableSeats: 1),
      buildRide(departure: paris, arrival: lyon, availableSeats: 3),
    ];
  });

  test('filterByDeparture returns rides departing from Dijon', () {
    final result = RidesService.filterByDeparture(dijon);
    expect(result.length, 2);
    expect(result.every((ride) => ride.departureLocation == dijon), true);
  });

  test('filterBySeatRequested returns rides with enough seats', () {
    final result = RidesService.filterBySeatRequested(2);
    expect(result.length, 2);
    expect(result.every((ride) => ride.availableSeats >= 2), true);
  });

  test('filterBy with both criteria returns one ride for Dijon + 2 seats', () {
    final result = RidesService.filterBy(departure: dijon, seatRequested: 2);
    expect(result.length, 1);
    expect(result.first.departureLocation, dijon);
    expect(result.first.availableSeats >= 2, true);
  });
}
