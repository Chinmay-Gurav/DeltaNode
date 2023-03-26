import 'package:delta/logc.dart';
import 'package:delta/feedback.dart';
import 'package:delta/profile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:page_transition/page_transition.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    // Calculate the number of columns based on screen size
    final screenWidth = MediaQuery.of(context).size.width;
    final gridCount = (screenWidth / 120).floor();

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Home'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 150,
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: const Center(
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                  ),
                ),
              ),
            ),
            ListTile(
              title: const Text('Profile'),
              onTap: () {
                // Handle menu item 1
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SetMen()),
                );
              },
            ),
            ListTile(
              title: const Text('Settings'),
              onTap: () {
                // Handle Settings
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () async {
                // Handle LogOut
                // Clear the user's session data
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.clear();

                // Navigate the user back to the login screen
                // ignore: use_build_context_synchronously
                Navigator.pushReplacementNamed(context, '/main');
              },
            ),
          ],
        ),
      ),
      body: GridView.count(
        crossAxisCount: gridCount,
        padding: const EdgeInsets.all(16),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          _buildSquareButton(context, 'Log Complaint', Icons.edit_document, () {
            Navigator.push(
              context,
              PageTransition(
                child: const Logc(),
                type: PageTransitionType
                    .rightToLeft, // choose your transition type
              ),
            );
          }),
          _buildSquareButton(
              context, 'My Complaint Status', Icons.hourglass_bottom, () {
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => const Logc()),
            // );
          }),
          _buildSquareButton(context, 'Suggestion/Feedback', Icons.feedback,
              () {
            Navigator.push(
              context,
              PageTransition(
                child: const FeedbackPage(),
                type: PageTransitionType
                    .rightToLeft, // choose your transition type
              ),
            );
          }),
        ],
      ),
    );
  }

  //Button format
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
                    fontSize: 12,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
