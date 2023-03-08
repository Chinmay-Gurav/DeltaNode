import 'package:flutter/material.dart';
import 'package:delta/road.dart';
import 'package:delta/water.dart';

class Logc extends StatefulWidget {
  const Logc({super.key});

  @override
  State<Logc> createState() => _LogcState();
}

class _LogcState extends State<Logc> {
  @override
  Widget build(BuildContext context) {
    // Calculate the number of columns based on screen size
    final screenWidth = MediaQuery.of(context).size.width;
    final gridCount = (screenWidth / 120).floor();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Complaint'),
      ),
      body: GridView.count(
        crossAxisCount: gridCount,
        padding: const EdgeInsets.all(16),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          _buildSquareButton(context, 'Road Dept', Icons.car_repair, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Road()),
            );
          }),
          _buildSquareButton(context, 'Water Dept', Icons.water, () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Water()),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSquareButton(BuildContext context, String label,
      IconData iconData, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        minimumSize: const Size(100, 100),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Icon(
              iconData,
              color: Colors.white,
              size: 32,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontSize: 14,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
