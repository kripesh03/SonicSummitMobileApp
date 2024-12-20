import 'package:flutter/material.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text(
      'Explore',
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
    ));
  }
}
