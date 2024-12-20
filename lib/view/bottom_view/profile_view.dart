import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(
        child: Text(
      'Profile Screen',
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
    ));
  }
}
