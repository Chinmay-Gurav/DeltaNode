import 'package:delta/logc.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the number of columns based on screen size
    final screenWidth = MediaQuery.of(context).size.width;
    final gridCount = (screenWidth / 120).floor();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
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
              // Navigate to the Log Complaint page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Logc()),
              );
            },
            child: _buildSquareButton(
                context, 'Log Complaint', Icons.edit_document),
          ),
          _buildSquareButton(
              context, 'My Complaint Status', Icons.hourglass_bottom),
          _buildSquareButton(context, 'Suggestion/Feedback', Icons.feedback),
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
