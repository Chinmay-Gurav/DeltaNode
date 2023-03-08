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
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // Handle menu button press
          },
        ),
      ),
      body: GridView.count(
        crossAxisCount: gridCount,
        padding: const EdgeInsets.all(16),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          GestureDetector(
            onTap: () {
              // Navigate to the Road Log Complaint page
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Road()));
            },
            child: _buildSquareButton(context, 'Road Dept', Icons.car_repair),
          ),
          GestureDetector(
            onTap: () {
              // Navigate to the Road Log Complaint page
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Water()));
            },
            child: _buildSquareButton(context, 'Water Dept', Icons.water),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Go back'),
          ),
        ],
      ),
    );
  }

  Widget _buildSquareButton(
      BuildContext context, String label, IconData iconData) {
    return Container(
      width: 100,
      height: 100,
      decoration: const BoxDecoration(
        color: Colors.blue,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            iconData,
            color: Colors.white,
          ),
          const SizedBox(height: 20),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontSize: 15,
                ),
          ),
        ],
      ),
    );
  }
}
