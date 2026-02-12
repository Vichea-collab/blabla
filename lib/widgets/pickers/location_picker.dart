import 'package:flutter/material.dart';

import '../../model/ride/locations.dart';
import '../../service/locations_service.dart';
import '../../theme/theme.dart';
import '../display/bla_divider.dart';

class LocationPicker extends StatefulWidget {
  final String title;
  final List<Location> locations;
  final Location? selectedLocation;
  final ValueChanged<Location>? onLocationSelected;

  const LocationPicker({
    super.key,
    required this.title,
    this.locations = LocationsService.availableLocations,
    this.selectedLocation,
    this.onLocationSelected,
  });

  @override
  State<LocationPicker> createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  String query = '';

  List<Location> get filteredLocations {
    final lowerQuery = query.trim().toLowerCase();
    if (lowerQuery.isEmpty) return widget.locations;

    return widget.locations.where((location) {
      return location.name.toLowerCase().contains(lowerQuery) ||
          location.country.name.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  void _onLocationTap(Location location) {
    widget.onLocationSelected?.call(location);

    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop(location);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(height: BlaSpacings.s),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: BlaColors.greyLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(BlaSpacings.m),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.title,
                    style: BlaTextStyles.body.copyWith(
                      color: BlaColors.textNormal,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close, color: BlaColors.iconNormal),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: BlaSpacings.m),
            child: TextField(
              key: const Key('locationPicker_searchField'),
              onChanged: (value) => setState(() => query = value),
              decoration: InputDecoration(
                hintText: 'Search a city',
                prefixIcon: Icon(Icons.search, color: BlaColors.iconLight),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(BlaSpacings.radius),
                ),
              ),
            ),
          ),
          const SizedBox(height: BlaSpacings.m),
          Expanded(
            child: filteredLocations.isEmpty
                ? Center(
                    child: Text(
                      'No location found',
                      style: BlaTextStyles.body.copyWith(
                        color: BlaColors.textLight,
                      ),
                    ),
                  )
                : ListView.separated(
                    key: const Key('locationPicker_list'),
                    itemCount: filteredLocations.length,
                    separatorBuilder: (_, _) => const BlaDivider(),
                    itemBuilder: (context, index) {
                      final location = filteredLocations[index];
                      final isSelected = location == widget.selectedLocation;

                      return ListTile(
                        onTap: () => _onLocationTap(location),
                        title: Text(
                          location.name,
                          style: BlaTextStyles.body.copyWith(
                            color: BlaColors.textNormal,
                          ),
                        ),
                        subtitle: Text(
                          location.country.name,
                          style: BlaTextStyles.label.copyWith(
                            color: BlaColors.textLight,
                          ),
                        ),
                        trailing: isSelected
                            ? Icon(Icons.check, color: BlaColors.primary)
                            : null,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
