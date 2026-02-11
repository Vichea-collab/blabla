import '../dummy_data/dummy_data.dart';
import '../model/ride/locations.dart';
import '../model/ride/ride.dart';

class RidesService {
  static List<Ride> availableRides = fakeRides; // TODO for now fake data

  // Filter rides by departure city.
  static List<Ride> filterByDeparture(Location departure) {
    return availableRides.where((ride) {
      return ride.departureLocation == departure;
    }).toList();
  }

  // Filter rides that can satisfy requested seats.
  static List<Ride> filterBySeatRequested(int requestedSeat) {
    return availableRides.where((ride) {
      return ride.availableSeats >= requestedSeat;
    }).toList();
  }

  // Filter rides with optional criteria.
  static List<Ride> filterBy({Location? departure, int? seatRequested}) {
    return availableRides.where((ride) {
      final matchDeparture =
          departure == null || ride.departureLocation == departure;
      final matchSeat =
          seatRequested == null || ride.availableSeats >= seatRequested;
      return matchDeparture && matchSeat;
    }).toList();
  }
}

