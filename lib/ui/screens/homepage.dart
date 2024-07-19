import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:tadbiro_app/controllers/tadbir_controller.dart';
import 'package:tadbiro_app/data/models/event.dart';
import 'package:tadbiro_app/ui/screens/event_details.dart/event_details_screen.dart';
import 'package:tadbiro_app/ui/screens/notification_screen.dart';
import 'package:tadbiro_app/ui/widgets/custom_drawer.dart';
import 'package:tadbiro_app/ui/widgets/custom_event.dart';
import 'package:tadbiro_app/utils/app_color.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Bosh sahifa"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => const NotificationScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.notifications))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              readOnly: true,
              decoration: InputDecoration(
                suffixIcon: const Icon(Icons.youtube_searched_for),
                labelText: "Tadbirlarni izlash...",
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                prefixIcon: const Icon(Icons.search),
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(
                    color: AppColor.orange,
                    width: 3,
                  ),
                ),
              ),
            ),
            const Gap(10),
            const Text(
              "Yaqin 7 kun ichida",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                height: 2,
              ),
            ),
            StreamBuilder(
              stream: context.read<TadbirController>().fetchRecentEvents(),
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

                return CarouselSlider.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index, realIndex) {
                    final event = events[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) =>
                                EventDetailsScreen(event: event),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        padding: const EdgeInsets.all(10),
                        height: 200,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                            fit: BoxFit.fill,
                            image: NetworkImage(event.imageUrl),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade600,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.all(5),
                                  child: Column(
                                    children: [
                                      Text(
                                        event.startTime.toDay(),
                                      ),
                                      Text(
                                        event.startTime.toMonth(),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    CupertinoIcons.heart_circle,
                                    size: 35,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              event.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  options:
                      CarouselOptions(viewportFraction: 0.9, autoPlay: true),
                );
              },
            ),
            const Gap(10),
            const Text(
              "Barcha tadbirlar",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                height: 2,
              ),
            ),
            Expanded(
              child: Consumer<TadbirController>(
                builder: (context, controller, child) {
                  return StreamBuilder(
                    stream: controller.fetchEvents(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text("Xatolik yuz berdi: ${snapshot.error}"),
                        );
                      } else if (!snapshot.hasData ||
                          snapshot.data!.docs.isEmpty) {
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
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                CupertinoPageRoute(
                                  builder: (context) => EventDetailsScreen(
                                    event: event,
                                  ),
                                ),
                              );
                            },
                            child: CustomEvent(onPressed: () {}, event: event),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      drawer: const CustomDrawer(),
    );
  }
}
