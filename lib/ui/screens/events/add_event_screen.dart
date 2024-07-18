import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tadbiro_app/bloc/tadbir_bloc/tadbir_bloc.dart';
import 'package:tadbiro_app/data/models/event.dart';
import 'package:tadbiro_app/services/location_service.dart';
import 'package:tadbiro_app/services/user_auth_service.dart';
import 'package:tadbiro_app/ui/widgets/custom_textfornfield.dart';
import 'package:tadbiro_app/ui/widgets/yandex_map_widget.dart';
import 'package:tadbiro_app/utils/app_color.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';
import 'dart:io';

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  final _userService = UserAuthService();
  Timestamp _timestamp = Timestamp.now();
  DateTime dateTime = DateTime.now();
  Point? currentPoint;
  XFile? _image;
  String? _imageUrl;

  Future<String> uploadImageToFirebase(XFile image) async {
    final storageRef = FirebaseStorage.instance.ref();
    final imageRef =
        storageRef.child('images/${DateTime.now().toString()}.jpg');
    final uploadTask = imageRef.putFile(File(image.path));

    final snapshot = await uploadTask.whenComplete(() {});
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  void _addEvent() async {
    final locationName = await LocationService.determinePositionName(
        GeoPoint(currentPoint!.latitude, currentPoint!.longitude));
    print(locationName);
    context.read<TadbirBloc>().add(
          AddTadbirEvent(
            event: Event(
              creatorId: FirebaseAuth.instance.currentUser!.uid,
              creatorName: await _userService.getUserName(),
              creatorImageUrl: await _userService.getUserPhoto(),
              name: _nameController.text,
              startTime: _timestamp,
              geoPoint:
                  GeoPoint(currentPoint!.latitude, currentPoint!.longitude),
              description: _detailsController.text,
              imageUrl: _imageUrl!,
              locationName: locationName,
              personCount: 0,
            ),
          ),
        );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tadbir Qo'shish"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextFormField(
                icon: Icons.event,
                controller: _nameController,
                labelText: 'Nomi',
                obscureText: false,
              ),
              CustomTextFormField(
                readOnly: true,
                icon: Icons.calendar_today,
                controller: _dateController,
                labelText: 'Kuni',
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    dateTime = pickedDate;
                    _dateController.text =
                        pickedDate.toLocal().toString().split(' ')[0];
                  }
                },
              ),
              CustomTextFormField(
                readOnly: true,
                controller: _timeController,
                labelText: 'Vahti',
                icon: Icons.access_time,
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    _timeController.text = pickedTime.format(context);

                    _timestamp = Timestamp.fromDate(
                      DateTime(
                        dateTime.year,
                        dateTime.month,
                        dateTime.day,
                        pickedTime.hour,
                        pickedTime.minute,
                      ),
                    );
                  }
                },
              ),
              CustomTextFormField(
                controller: _detailsController,
                labelText: "Tadbir haqida ma'lumot:",
                icon: Icons.info,
                maxLines: 2,
              ),
              const Text("Rasm yoki video yuklash"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: () async {
                      final ImagePicker _picker = ImagePicker();
                      XFile? image =
                          await _picker.pickImage(source: ImageSource.camera);
                      if (image != null) {
                        final imageUrl = await uploadImageToFirebase(image);
                        setState(() {
                          _image = image;
                          _imageUrl = imageUrl;
                        });
                      }
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.image),
                    onPressed: () async {
                      final ImagePicker _picker = ImagePicker();
                      XFile? gallery =
                          await _picker.pickImage(source: ImageSource.gallery);
                      if (gallery != null) {
                        final imageUrl = await uploadImageToFirebase(gallery);
                        setState(() {
                          _image = gallery;
                          _imageUrl = imageUrl;
                        });
                      }
                    },
                  ),
                ],
              ),
              const Text("Manzini belgilang"),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColor.orange,
                    width: 2,
                  ),
                ),
                height: 280.0,
                child: YandexMapWidget(
                  onLocationTap: (p0) {
                    currentPoint = p0;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FloatingActionButton(
              onPressed: _addEvent,
              child: const Text("Qo'shish"),
            )
          ],
        ),
      ),
    );
  }
}
