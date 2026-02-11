import 'package:blabla/model/ride/locations.dart';
import 'package:blabla/model/ride_pref/ride_pref.dart';
import 'package:blabla/screens/ride_pref/widgets/ride_pref_form.dart';
import 'package:blabla/service/ride_prefs_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final london = const Location(name: 'London', country: Country.uk);
  final paris = const Location(name: 'Paris', country: Country.france);

  Widget wrapWithMaterial(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(padding: const EdgeInsets.all(16), child: child),
      ),
    );
  }

  ElevatedButton _searchButton(WidgetTester tester) {
    return tester.widget<ElevatedButton>(
      find.descendant(
        of: find.byKey(const Key('ridePrefForm_searchButton')),
        matching: find.byType(ElevatedButton),
      ),
    );
  }

  setUp(() {
    RidePrefService.currentRidePref = null;
    RidePrefService.ridePrefsHistory = [];
  });

  testWidgets('search is disabled when form is empty', (tester) async {
    await tester.pumpWidget(wrapWithMaterial(const RidePrefForm()));

    expect(_searchButton(tester).onPressed, isNull);
  });

  testWidgets('search is disabled when departure equals arrival', (
    tester,
  ) async {
    final sameLocationPref = RidePref(
      departure: paris,
      departureDate: DateTime(2026, 2, 11, 9, 0),
      arrival: paris,
      requestedSeats: 2,
    );

    await tester.pumpWidget(
      wrapWithMaterial(RidePrefForm(initRidePref: sameLocationPref)),
    );

    expect(_searchButton(tester).onPressed, isNull);
  });

  testWidgets('submits valid init preference and updates service', (
    tester,
  ) async {
    final initPref = RidePref(
      departure: london,
      departureDate: DateTime(2026, 2, 11, 8, 0),
      arrival: paris,
      requestedSeats: 2,
    );

    RidePref? submitted;
    await tester.pumpWidget(
      wrapWithMaterial(
        RidePrefForm(
          initRidePref: initPref,
          onSubmit: (value) => submitted = value,
        ),
      ),
    );

    expect(_searchButton(tester).onPressed, isNotNull);
    await tester.tap(find.byKey(const Key('ridePrefForm_searchButton')));
    await tester.pump();

    expect(submitted, isNotNull);
    expect(submitted!.departure, london);
    expect(submitted!.arrival, paris);
    expect(submitted!.requestedSeats, 2);
    expect(RidePrefService.currentRidePref, isNotNull);
    expect(RidePrefService.ridePrefsHistory.length, 1);
    expect(RidePrefService.ridePrefsHistory.first.departure, london);
    expect(RidePrefService.ridePrefsHistory.first.arrival, paris);
  });

  testWidgets('swap action swaps departure and arrival before submit', (
    tester,
  ) async {
    final initPref = RidePref(
      departure: london,
      departureDate: DateTime(2026, 2, 11, 8, 0),
      arrival: paris,
      requestedSeats: 1,
    );

    RidePref? submitted;
    await tester.pumpWidget(
      wrapWithMaterial(
        RidePrefForm(
          initRidePref: initPref,
          onSubmit: (value) => submitted = value,
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('ridePrefForm_swapButton')));
    await tester.pump();

    await tester.tap(find.byKey(const Key('ridePrefForm_searchButton')));
    await tester.pump();

    expect(submitted, isNotNull);
    expect(submitted!.departure, paris);
    expect(submitted!.arrival, london);
  });
}
