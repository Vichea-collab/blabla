import 'package:blabla/widgets/actions/bla_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) {
    return MaterialApp(
      home: Scaffold(body: Center(child: child)),
    );
  }

  testWidgets('renders primary button without icon', (tester) async {
    await tester.pumpWidget(
      wrap(
        BlaButton(
          text: 'Search',
          onPressed: () {},
          variant: BlaButtonVariant.primary,
        ),
      ),
    );

    expect(find.text('Search'), findsOneWidget);
    expect(find.byType(Icon), findsNothing);
  });

  testWidgets('renders secondary button with leading icon', (tester) async {
    await tester.pumpWidget(
      wrap(
        BlaButton(
          text: 'Swap',
          onPressed: () {},
          variant: BlaButtonVariant.secondary,
          icon: Icons.swap_vert,
        ),
      ),
    );

    expect(find.text('Swap'), findsOneWidget);
    expect(find.byIcon(Icons.swap_vert), findsOneWidget);
  });

  testWidgets('renders secondary button with trailing icon', (tester) async {
    await tester.pumpWidget(
      wrap(
        BlaButton(
          text: 'Continue',
          onPressed: () {},
          variant: BlaButtonVariant.secondary,
          icon: Icons.arrow_forward,
          iconAtEnd: true,
        ),
      ),
    );

    expect(find.text('Continue'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_forward), findsOneWidget);
  });

  testWidgets('calls onPressed when tapped', (tester) async {
    int taps = 0;
    await tester.pumpWidget(
      wrap(
        BlaButton(
          text: 'Search',
          onPressed: () {
            taps++;
          },
          variant: BlaButtonVariant.primary,
        ),
      ),
    );

    await tester.tap(find.byType(BlaButton));
    await tester.pump();

    expect(taps, 1);
  });

  testWidgets('does not call onPressed when disabled', (tester) async {
    int taps = 0;
    await tester.pumpWidget(
      wrap(
        BlaButton(
          text: 'Disabled',
          onPressed: null,
          variant: BlaButtonVariant.primary,
        ),
      ),
    );

    await tester.tap(find.byType(BlaButton));
    await tester.pump();

    expect(taps, 0);
  });
}
