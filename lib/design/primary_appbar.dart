import 'package:flutter/material.dart';

class PrimaryAppBar extends StatefulWidget implements PreferredSizeWidget {
  const PrimaryAppBar({
    required this.title,
    super.key,
  });

  final String title;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<PrimaryAppBar> createState() => _PrimaryAppBarState();
}

class _PrimaryAppBarState extends State<PrimaryAppBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: AppBar(
        shadowColor: Colors.transparent,
        title: const Text('title'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: IconButton(
              onPressed: () {
                setState(() {});
              },
              icon: const Icon(Icons.delete),
            ),
          ),
        ],
      ),
    );
  }
}
