import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:tadbiro_app/controllers/tadbir_controller.dart';
import 'package:tadbiro_app/data/models/event.dart';
import 'package:tadbiro_app/services/local_notification_service.dart';
import 'package:tadbiro_app/ui/screens/homepage.dart';

class RegisterToEventScreen extends StatefulWidget {
  final Event event;
  const RegisterToEventScreen({
    super.key,
    required this.event,
  });

  @override
  State<RegisterToEventScreen> createState() => _RegisterToEventScreenState();
}

class _RegisterToEventScreenState extends State<RegisterToEventScreen> {
  int seatCount = 0;
  String paymentMethod = 'Click';

  void eslatmabelgilash(String name) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        Navigator.pop(context);

        DateTime selectedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );
        print('----------------------------------');
        print(selectedDateTime);
        await LocalNotificationsServices.scheduleNotification(
            1, "Notificaation", name, selectedDateTime);
        Navigator.of(context).pushReplacement(
          CupertinoPageRoute(
            builder: (context) => Homepage(),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Ro\'yxatdan O\'tish',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Joylar sonini tanlang',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    if (seatCount > 0) seatCount--;
                  });
                },
              ),
              Text(
                '$seatCount',
                style: const TextStyle(fontSize: 24),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    seatCount++;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 40),
          const Text(
            'To\'lov turini tanlang',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          RadioListTile<String>(
            title: const Text('Click'),
            value: 'Click',
            groupValue: paymentMethod,
            onChanged: (String? value) {
              setState(() {
                paymentMethod = value!;
              });
            },
          ),
          RadioListTile<String>(
            title: const Text('Payme'),
            value: 'Payme',
            groupValue: paymentMethod,
            onChanged: (String? value) {
              setState(() {
                paymentMethod = value!;
              });
            },
          ),
          RadioListTile<String>(
            title: const Text('Naqd'),
            value: 'Naqd',
            groupValue: paymentMethod,
            onChanged: (String? value) {
              setState(() {
                paymentMethod = value!;
              });
            },
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: () {
              print(widget.event.id);

              context.read<TadbirController>().updateEvent(
                  widget.event.id!, widget.event.personCount + seatCount);
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return AlertDialog(
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Lottie.asset('assets/images/success.json'),
                        const Text(
                          "Tabriklaymiz",
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          widget.event.name,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        FloatingActionButton(
                          backgroundColor: Colors.yellow.shade700,
                          onPressed: () {
                            Navigator.of(context).pop();
                            eslatmabelgilash(widget.event.name);
                          },
                          child: const Text("Eslatma belgilash"),
                        ),
                        const Gap(15),
                        FloatingActionButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              CupertinoPageRoute(
                                builder: (context) => const Homepage(),
                              ),
                            );
                          },
                          child: const Text("Bosh Sahifaga"),
                        )
                      ],
                    ),
                  );
                },
              );
            },
            child: const Text('Keyingi'),
          ),
        ],
      ),
    );
  }
}
