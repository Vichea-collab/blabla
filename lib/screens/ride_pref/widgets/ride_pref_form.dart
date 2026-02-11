import 'package:flutter/material.dart';

import '../../../model/ride/locations.dart';
import '../../../model/ride_pref/ride_pref.dart';
import '../../../service/locations_service.dart';
import '../../../service/ride_prefs_service.dart';
import '../../../theme/theme.dart';
import '../../../utils/date_time_util.dart';
import '../../../widgets/actions/bla_button.dart';

///
/// A Ride Preference From is a view to select:
///   - A depcarture location
///   - An arrival location
///   - A date
///   - A number of seats
///
/// The form can be created with an existing RidePref (optional).
///
class RidePrefForm extends StatefulWidget {
  // The form can be created with an optional initial RidePref.
  final RidePref? initRidePref;
  final ValueChanged<RidePref>? onSubmit;

  const RidePrefForm({super.key, this.initRidePref, this.onSubmit});

  @override
  State<RidePrefForm> createState() => _RidePrefFormState();
}

class _RidePrefFormState extends State<RidePrefForm> {
  Location? departure;
  late DateTime departureDate;
  Location? arrival;
  late int requestedSeats;

  // ----------------------------------
  // Initialize the Form attributes
  // ----------------------------------

  @override
  void initState() {
    super.initState();
    departure = widget.initRidePref?.departure;
    arrival = widget.initRidePref?.arrival;
    departureDate = widget.initRidePref?.departureDate ?? DateTime.now();
    requestedSeats = widget.initRidePref?.requestedSeats ?? 1;
  }

  // ----------------------------------
  // Handle events
  // ----------------------------------
  void _onSwapLocations() {
    setState(() {
      Location? temp = departure;
      departure = arrival;
      arrival = temp;
    });
  }

  Future<void> _onSelectDate() async {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime initialDate = departureDate.isBefore(today)
        ? today
        : departureDate;

    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: today,
      lastDate: DateTime(now.year + 1, 12, 31),
    );

    if (selectedDate == null) return;
    DateTime pickedDate = selectedDate;

    setState(() => departureDate = pickedDate);
  }

  void _onSubmit() {
    if (!_canSearch()) return;

    RidePref ridePref = RidePref(
      departure: departure!,
      departureDate: departureDate,
      arrival: arrival!,
      requestedSeats: requestedSeats,
    );

    RidePrefService.currentRidePref = ridePref;
    RidePrefService.ridePrefsHistory.insert(0, ridePref);
    widget.onSubmit?.call(ridePref);
  }

  // ----------------------------------
  // Compute the widgets rendering
  // ----------------------------------
  bool _canSearch() {
    if (departure == null) return false;
    if (arrival == null) return false;
    if (departure == arrival) return false;
    if (requestedSeats <= 0) return false;
    return true;
  }

  // ----------------------------------
  // Build the widgets
  // ----------------------------------
  @override
  Widget build(BuildContext context) {
    VoidCallback? searchButtonAction = _canSearch() ? _onSubmit : null;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: BlaSpacings.m),
        DropdownButtonFormField<Location>(
          key: const Key('ridePrefForm_departureDropdown'),
          initialValue: departure,
          isExpanded: true,
          decoration: InputDecoration(
            labelText: 'Leaving from',
            labelStyle: BlaTextStyles.label.copyWith(
              color: BlaColors.textLight,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(BlaSpacings.radius),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: BlaSpacings.m,
            ),
          ),
          items: LocationsService.availableLocations.map((location) {
            return DropdownMenuItem<Location>(
              value: location,
              child: Text(location.name),
            );
          }).toList(),
          onChanged: (newDeparture) {
            setState(() => departure = newDeparture);
          },
        ),
        const SizedBox(height: BlaSpacings.s),
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            key: const Key('ridePrefForm_swapButton'),
            onPressed: _onSwapLocations,
            icon: Icon(Icons.swap_vert, color: BlaColors.iconNormal),
          ),
        ),
        const SizedBox(height: BlaSpacings.s),
        DropdownButtonFormField<Location>(
          key: const Key('ridePrefForm_arrivalDropdown'),
          initialValue: arrival,
          isExpanded: true,
          decoration: InputDecoration(
            labelText: 'Going to',
            labelStyle: BlaTextStyles.label.copyWith(
              color: BlaColors.textLight,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(BlaSpacings.radius),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: BlaSpacings.m,
            ),
          ),
          items: LocationsService.availableLocations.map((location) {
            return DropdownMenuItem<Location>(
              value: location,
              child: Text(location.name),
            );
          }).toList(),
          onChanged: (newArrival) {
            setState(() => arrival = newArrival);
          },
        ),
        const SizedBox(height: BlaSpacings.m),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: BlaColors.greyLight),
            borderRadius: BorderRadius.circular(BlaSpacings.radius),
          ),
          child: ListTile(
            key: const Key('ridePrefForm_dateField'),
            onTap: _onSelectDate,
            leading: Icon(
              Icons.calendar_today,
              color: BlaColors.iconNormal,
              size: 20,
            ),
            title: Text(
              DateTimeUtils.formatDateTime(departureDate),
              style: BlaTextStyles.body.copyWith(color: BlaColors.textNormal),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: BlaSpacings.m,
            ),
          ),
        ),
        const SizedBox(height: BlaSpacings.m),
        DropdownButtonFormField<int>(
          key: const Key('ridePrefForm_seatsDropdown'),
          initialValue: requestedSeats,
          decoration: InputDecoration(
            labelText: 'Passengers',
            labelStyle: BlaTextStyles.label.copyWith(
              color: BlaColors.textLight,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(BlaSpacings.radius),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: BlaSpacings.m,
            ),
          ),
          items: List.generate(6, (index) => index + 1).map((seats) {
            return DropdownMenuItem<int>(value: seats, child: Text('$seats'));
          }).toList(),
          onChanged: (newSeats) {
            if (newSeats == null) return;
            setState(() => requestedSeats = newSeats);
          },
        ),
        const SizedBox(height: BlaSpacings.m),
        BlaButton(
          key: const Key('ridePrefForm_searchButton'),
          text: 'Search',
          onPressed: searchButtonAction,
          icon: Icons.search,
          variant: BlaButtonVariant.primary,
        ),
      ],
    );
  }
}
