import 'package:flutter/material.dart';

import '../../../model/ride/locations.dart';
import '../../../model/ride_pref/ride_pref.dart';
import '../../../service/ride_prefs_service.dart';
import '../../../theme/theme.dart';
import '../../../utils/date_time_util.dart';
import '../../../widgets/actions/bla_button.dart';
import '../../../widgets/pickers/location_picker.dart';

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

  Future<void> _onSelectDeparture() async {
    await _pickLocation(
      title: 'Leaving from',
      currentLocation: departure,
      onPicked: (location) => departure = location,
    );
  }

  Future<void> _onSelectArrival() async {
    await _pickLocation(
      title: 'Going to',
      currentLocation: arrival,
      onPicked: (location) => arrival = location,
    );
  }

  Future<void> _pickLocation({
    required String title,
    required Location? currentLocation,
    required ValueChanged<Location> onPicked,
  }) async {
    Location? selected = await Navigator.of(context).push<Location>(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          body: LocationPicker(title: title, selectedLocation: currentLocation),
        ),
      ),
    );
    if (selected == null) return;

    setState(() => onPicked(selected));
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
  Widget _buildLocationField({
    required Key key,
    required String placeholder,
    required Location? location,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: BlaColors.greyLight),
        borderRadius: BorderRadius.circular(BlaSpacings.radius),
      ),
      child: ListTile(
        key: key,
        onTap: onTap,
        leading: Icon(Icons.radio_button_unchecked, color: BlaColors.iconLight),
        title: Text(
          location?.name ?? placeholder,
          style: BlaTextStyles.body.copyWith(color: BlaColors.textNormal),
        ),
        subtitle: location == null
            ? null
            : Text(
                location.country.name,
                style: BlaTextStyles.label.copyWith(color: BlaColors.textLight),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    VoidCallback? searchButtonAction = _canSearch() ? _onSubmit : null;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: BlaSpacings.m),
        _buildLocationField(
          key: const Key('ridePrefForm_departureDropdown'),
          placeholder: 'Leaving from',
          location: departure,
          onTap: _onSelectDeparture,
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
        _buildLocationField(
          key: const Key('ridePrefForm_arrivalDropdown'),
          placeholder: 'Going to',
          location: arrival,
          onTap: _onSelectArrival,
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
