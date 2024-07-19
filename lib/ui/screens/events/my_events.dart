import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tadbiro_app/controllers/tadbir_controller.dart';
import 'package:tadbiro_app/data/models/event.dart';
import 'package:tadbiro_app/ui/widgets/custom_event.dart';

class MyEvents extends StatelessWidget {
  const MyEvents({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Consumer<TadbirController>(
        builder: (context, controller, child) {
          return StreamBuilder(
            stream: controller.fetchMyEvents(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("Xatolik yuz berdi: ${snapshot.error}"),
                );
              } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text("Tadbirlar yo'q"),
                );
              }

              List<Event> events = snapshot.data!.docs.map((doc) {
                return Event.fromQuerySnapshot(doc);
              }).toList();

              return ListView.builder(
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];
                  return CustomEvent(onPressed: () {}, event: event);
                },
              );
            },
          );
        },
      ),
    );
  }
}
