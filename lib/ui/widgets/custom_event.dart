import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:tadbiro_app/data/models/event.dart';

class CustomEvent extends StatelessWidget {
  Event event;
  Function()? onPressed;
  CustomEvent({
    super.key,
    required this.onPressed,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat(
      'HH:mm dd MMMM, yyyy',
    ).format(event.startTime.toDate());

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
                  child: !event.imageUrl.startsWith('https')
                      ? const Icon(Icons.image)
                      : Image.network(
                          event.imageUrl,
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
                        event.name,
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
                          SizedBox(
                            width: 150,
                            child: Text(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              event.locationName,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                              ),
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
              onPressed: onPressed,
              icon: const Icon(CupertinoIcons.heart),
            ),
          ),
        ],
      ),
    );
  }
}
