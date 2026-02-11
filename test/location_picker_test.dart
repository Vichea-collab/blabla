import 'package:blabla/model/ride/locations.dart';
import 'package:blabla/widgets/pickers/location_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const paris = Location(name: 'Paris', country: Country.france);
  const lyon = Location(name: 'Lyon', country: Country.france);
  const london = Location(name: 'London', country: Country.uk);
  const locations = [paris, lyon, london];

  Widget wrapWithMaterial(Widget child) {
    return MaterialApp(home: Scaffold(body: child));
  }

  testWidgets('renders title and all locations', (tester) async {
    await tester.pumpWidget(
      wrapWithMaterial(
        const LocationPicker(title: 'Pick a city', locations: locations),
      ),
    );

    expect(find.text('Pick a city'), findsOneWidget);
    expect(find.text('Paris'), findsOneWidget);
    expect(find.text('Lyon'), findsOneWidget);
    expect(find.text('London'), findsOneWidget);
  });

  testWidgets('filters locations by search query', (tester) async {
    await tester.pumpWidget(
      wrapWithMaterial(
        const LocationPicker(title: 'Pick a city', locations: locations),
      ),
    );

    await tester.enterText(
      find.byKey(const Key('locationPicker_searchField')),
      'ly',
    );
    await tester.pump();

    expect(find.text('Lyon'), findsOneWidget);
    expect(find.text('Paris'), findsNothing);
    expect(find.text('London'), findsNothing);
  });

  testWidgets('shows empty state when nothing matches search', (tester) async {
    await tester.pumpWidget(
      wrapWithMaterial(
        const LocationPicker(title: 'Pick a city', locations: locations),
      ),
    );

    await tester.enterText(
      find.byKey(const Key('locationPicker_searchField')),
      'zzzz',
    );
    await tester.pump();

    expect(find.text('No location found'), findsOneWidget);
  });

  testWidgets('calls onLocationSelected when a location is tapped', (
    tester,
  ) async {
    Location? selected;
    await tester.pumpWidget(
      wrapWithMaterial(
        LocationPicker(
          title: 'Pick a city',
          locations: locations,
          onLocationSelected: (value) => selected = value,
        ),
      ),
    );

    await tester.tap(find.text('Paris'));
    await tester.pump();

    expect(selected, paris);
  });
}
