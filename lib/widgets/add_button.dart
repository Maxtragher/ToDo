import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  const AddButton({
    required this.isVisible,
    required this.onTap,
    super.key,
  });
  final bool isVisible;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: FloatingActionButton(
        onPressed: onTap,
        tooltip: 'Add a todo',
        child: const Icon(Icons.add),
      ),
    );
  }
}
