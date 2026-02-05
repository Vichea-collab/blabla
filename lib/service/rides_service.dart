import '../dummy_data/dummy_data.dart';
import '../model/ride/locations.dart';
import '../model/ride/ride.dart';

class RidesService {
  static List<Ride> availableRides = fakeRides; // TODO for now fake data
 
  //
  //  filter the rides starting from given departure location
  //
  static List<Ride> _filterByDeparture(Location departure) {
    return fakeRides.where((ride) {
      return ride.departureLocation.name == departure.name &&
          ride.departureLocation.country == departure.country;
    }).toList();
  }

  //
  //  filter the rides starting for the given requested seat number
  //
  static List<Ride> _filterBySeatRequested(int requestedSeat) {
    return fakeRides.where((ride) {
      return ride.availableSeats == RidePref.requestedSeats;
    }).toList();
  }

  //
  //  filter the rides   with several optional criteria (flexible filter options)
  //
  static List<Ride> filterBy({Location? departure, int? seatRequested}) {
    return fakeRides.where((ride){
      return Ride(departureLocation: departureLocation, departureDate: departureDate, arrivalLocation: arrivalLocation, arrivalDateTime: arrivalDateTime, driver: driver, availableSeats: availableSeats, pricePerSeat: pricePerSeat);
    }).toList();
  }
}
