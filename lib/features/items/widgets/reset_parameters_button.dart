import 'package:flutter/material.dart';

class ResetParametersButton extends StatelessWidget {
  const ResetParametersButton({
    super.key,
    required this.buttonHeight,
    required this.onTap,
  });

  final double buttonHeight;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        minimumSize: Size(0, buttonHeight),
        padding: const EdgeInsets.symmetric(horizontal: 24),
      ),
      child: const Text('Скинути параметри'),
    );
  }
}
