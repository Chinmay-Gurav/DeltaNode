import 'package:flutter/material.dart';

import 'Widgets/contactus_dbox.dart';

class Stat extends StatelessWidget {
  final String complaintId;

  const Stat({required this.complaintId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complaint #$complaintId'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StatusItem(
                icon: Icons.check_circle_outline,
                label: 'Complaint Received',
                status: true,
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StatusItem(
                icon: Icons.cancel_outlined,
                label: 'Service Man Allotted',
                status: false,
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StatusItem(
                icon: Icons.cancel_outlined,
                label: 'Out For Service',
                status: false,
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StatusItem(
                icon: Icons.cancel_outlined,
                label: 'Resolved',
                status: false,
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            'Estimated Resolution Time:',
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {},
            child: const Text('Service Men info'),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const MyDialog();
                },
              );
            },
            child: const Text('Contact Us'),
          ),
        ],
      ),
    );
  }
}

class StatusItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool status;

  const StatusItem({
    required this.icon,
    required this.label,
    required this.status,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = status ? Colors.green : Colors.grey;
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 28,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(color: color, fontSize: 12),
        ),
      ],
    );
  }
}
