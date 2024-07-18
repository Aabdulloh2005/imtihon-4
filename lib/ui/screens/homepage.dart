import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:tadbiro_app/bloc/theme_bloc/theme_cubit.dart';
import 'package:tadbiro_app/ui/screens/all_events_screen.dart';
import 'package:tadbiro_app/ui/screens/notification_screen.dart';
import 'package:tadbiro_app/ui/screens/profile_screen.dart';
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
                Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => const NotificationScreen(),
                ));
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
            Container(
              padding: const EdgeInsets.all(10),
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: const DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/images/back.png'),
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
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.all(5),
                        child: const Column(
                          children: [
                            Text(
                              "12",
                            ),
                            Text(
                              'May',
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
                  const Text(
                    'Cillum dolore nostrud ullamco irure do nostrud magna culpa consectetur.',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
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
            Stack(
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
                          image: const DecorationImage(
                            image: AssetImage(
                              'assets/images/smoke.png',
                            ),
                          ),
                        ),
                      ),
                      const Gap(10),
                      const Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Flutter Global Hakaton 2024",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            Gap(10),
                            Text(
                              "10:00 06 Sentabr,2024",
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Gap(5),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 20,
                                ),
                                Text(
                                  "Yoshlar ijod saroyi",
                                  style: TextStyle(
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
                const Positioned(
                  bottom: 20,
                  right: 20,
                  child: Icon(CupertinoIcons.heart),
                )
              ],
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            const DrawerHeader(
              child: SizedBox(),
            ),
            BlocBuilder<ThemeCubit, bool>(
              builder: (context, state) {
                return SwitchListTile(
                  title: const Text("Mode"),
                  value: state,
                  onChanged: (value) {
                    context.read<ThemeCubit>().changeTheme();
                  },
                );
              },
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => const AllEventsScreen(),
                  ),
                );
              },
              leading: const Icon(CupertinoIcons.ticket),
              title: const Text("Mening tadbirlarim"),
              trailing: const Icon(Icons.keyboard_arrow_right),
            ),
            ListTile(
              onTap: () {
                Navigator.of(context).push(
                  CupertinoPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
              leading: const Icon(CupertinoIcons.person),
              title: const Text("Profil malumotlari"),
              trailing: const Icon(Icons.keyboard_arrow_right),
            ),
            const ListTile(
              leading: Icon(Icons.translate),
              title: Text("Tillarni o'zgartirish"),
              trailing: Icon(Icons.keyboard_arrow_right),
            ),
          ],
        ),
      ),
    );
  }
}
