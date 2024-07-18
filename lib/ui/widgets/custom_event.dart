import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:tadbiro_app/services/location_service.dart';

class CustomEvent extends StatefulWidget {
  String image;
  String title;
  DateTime time;
  GeoPoint location;
  Function()? onPressed;
  CustomEvent({
    super.key,
    required this.image,
    required this.location,
    required this.onPressed,
    required this.time,
    required this.title,
  });

  @override
  State<CustomEvent> createState() => _CustomEventState();
}

class _CustomEventState extends State<CustomEvent> {
  String address = '';
  @override
  void initState() {
    super.initState();

    Future.delayed(
      Duration.zero,
      () async {
        address = await LocationService.determinePositionName(widget.location);
      },
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat(
      'HH:mm dd MMMM, yyyy',
    ).format(widget.time);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.grey, width: 3),
            ),
            child: Row(
              children: [
                Container(
                  height: 90,
                  width: 120,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: !widget.image.startsWith('https')
                      ? const Icon(Icons.image)
                      : Image.network(
                          widget.image,
                          fit: BoxFit.cover,
                        ),
                ),
                const Gap(10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const Gap(10),
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Gap(5),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 20,
                          ),
                          Text(
                            address,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Positioned(
            bottom: 5,
            right: 5,
            child: IconButton(
              onPressed: widget.onPressed,
              icon: const Icon(CupertinoIcons.heart),
            ),
          ),
        ],
      ),
    );
  }
}
