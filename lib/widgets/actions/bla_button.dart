import 'package:flutter/material.dart';

import '../../theme/theme.dart';

enum BlaButtonVariant { primary, secondary }

class BlaButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final BlaButtonVariant variant;
  final IconData? icon;
  final bool iconAtEnd;
  final bool expand;
  final double height;

  const BlaButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = BlaButtonVariant.primary,
    this.icon,
    this.iconAtEnd = false,
    this.expand = true,
    this.height = 52,
  });

  bool get _isDisabled => onPressed == null;

  @override
  Widget build(BuildContext context) {
    final bool isPrimary = variant == BlaButtonVariant.primary;

    final Color backgroundColor = _isDisabled
        ? BlaColors.disabled
        : (isPrimary ? BlaColors.primary : BlaColors.white);
    final Color foregroundColor = _isDisabled
        ? BlaColors.neutralLighter
        : (isPrimary ? BlaColors.white : BlaColors.neutralDark);
    final Color borderColor = _isDisabled
        ? BlaColors.disabled
        : (isPrimary ? Colors.transparent : BlaColors.primary);

    final Widget label = Text(
      text,
      style: BlaTextStyles.button.copyWith(color: foregroundColor),
    );

    Widget content = label;
    if (icon != null) {
      final Widget iconWidget = Icon(icon, size: 18, color: foregroundColor);
      content = Row(
        mainAxisSize: MainAxisSize.min,
        children: iconAtEnd
            ? <Widget>[label, const SizedBox(width: 8), iconWidget]
            : <Widget>[iconWidget, const SizedBox(width: 8), label],
      );
    }

    return SizedBox(
      width: expand ? double.infinity : null,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: BlaSpacings.m,
            vertical: BlaSpacings.s,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(BlaSpacings.radius),
            side: BorderSide(color: borderColor, width: 1.5),
          ),
        ),
        child: content,
      ),
    );
  }
}
