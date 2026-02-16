import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventCard extends StatelessWidget {
  final Map<String, dynamic> event;
  final VoidCallback? onTap;

  const EventCard({
    super.key,
    required this.event,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final title = event['title'] ?? 'Untitled Event';
    final date = event['date'] != null 
        ? (event['date'] as Timestamp).toDate() 
        : DateTime.now(); // Handle Firestore Timestamp
    final location = event['location'] ?? 'No location determined';
    final formattedDate = DateFormat.yMMMd().format(date);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 4),
                Text(formattedDate),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on, size: 16),
                const SizedBox(width: 4),
                Text(location),
              ],
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}

