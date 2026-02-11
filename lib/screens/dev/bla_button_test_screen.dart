import 'package:flutter/material.dart';

import '../../theme/theme.dart';
import '../../widgets/actions/bla_button.dart';

class BlaButtonTestScreen extends StatelessWidget {
  const BlaButtonTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BlaButton Variations'),
        backgroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(BlaSpacings.l),
        children: [
          BlaButton(
            text: 'Search',
            onPressed: () {},
            variant: BlaButtonVariant.primary,
          ),
          const SizedBox(height: BlaSpacings.m),
          BlaButton(
            text: 'Search',
            onPressed: () {},
            variant: BlaButtonVariant.primary,
            icon: Icons.search,
          ),
          const SizedBox(height: BlaSpacings.m),
          BlaButton(
            text: 'Swap',
            onPressed: () {},
            variant: BlaButtonVariant.secondary,
            icon: Icons.swap_vert,
          ),
          const SizedBox(height: BlaSpacings.m),
          BlaButton(
            text: 'Continue',
            onPressed: () {},
            variant: BlaButtonVariant.secondary,
            icon: Icons.arrow_forward,
            iconAtEnd: true,
          ),
          const SizedBox(height: BlaSpacings.m),
          const BlaButton(
            text: 'Disabled',
            onPressed: null,
            variant: BlaButtonVariant.primary,
          ),
        ],
      ),
    );
  }
}
