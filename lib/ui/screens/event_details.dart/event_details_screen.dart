import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tadbiro_app/data/models/event.dart';
import 'package:tadbiro_app/ui/screens/event_details.dart/register_to_event_screen.dart';
import 'package:tadbiro_app/ui/screens/event_details.dart/widgets/detail_yandex_map.dart';
import 'package:tadbiro_app/utils/app_color.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class EventDetailsScreen extends StatelessWidget {
  final Event event;
  const EventDetailsScreen({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
            expandedHeight: 250,
            flexibleSpace: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
                image: DecorationImage(
                  image: NetworkImage(event.imageUrl),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            sliver: SliverToBoxAdapter(
              child: Text(event.name),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildListile(Icons.calendar_month, event.startTime.format()),
                  _buildListile(Icons.place, event.locationName),
                  _buildListile(Icons.person, event.personCount.toString()),
                  const Gap(10),
                  Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage:
                            event.creatorImageUrl.startsWith("https")
                                ? NetworkImage(event.creatorImageUrl)
                                : const AssetImage("assets/images/back.png"),
                      ),
                      title: Text(event.creatorName),
                      subtitle: const Text("Tadbir tashkilotchisi"),
                    ),
                  ),
                  const Gap(10),
                  const Text(
                    "Tadbir haqida",
                  ),
                  Text(
                    event.description,
                  ),
                  const Text(
                    "Manzil",
                  ),
                  Text(
                    event.locationName,
                  ),
                  DetailYandexMap(
                    point: Point(
                        latitude: event.geoPoint.latitude,
                        longitude: event.geoPoint.longitude),
                  ),
                  const Gap(100),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              backgroundColor: Colors.orange.shade100,
              foregroundColor: AppColor.orange,
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return RegisterToEventScreen(event:event);
                  },
                );
              },
              child: const Text(
                "Ro'yhatdan o'tish",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListile(IconData icon, String title) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 5),
      leading: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: Colors.grey.shade600,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Icon(icon),
      ),
      title: Text(title),
    );
  }
}
