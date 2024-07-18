import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:tadbiro_app/bloc/tadbir_bloc/tadbir_bloc.dart';
import 'package:tadbiro_app/ui/screens/event_details_screen.dart';
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
            Expanded(
              child: BlocBuilder<TadbirBloc, TadbirState>(
                bloc: context.read<TadbirBloc>()..add(FetchTadbirEvent()),
                builder: (context, state) {
                  if (state is TadbirInitial) {
                    return const Center(
                      child: Text("Initial"),
                    );
                  }

                  if (state is TadbirLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (state is TadbirError) {
                    return Center(
                      child: Text(state.errorMessage),
                    );
                  } else {
                    final data = (state as TadbirLoaded);
                    print('Ishlash kere');
                    print(data.events.length);
                    return ListView.builder(
                      itemCount: data.events.length,
                      itemBuilder: (context, index) {
                        final event = data.events[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              CupertinoPageRoute(
                                builder: (context) => EventDetailsScreen(),
                              ),
                            );
                          },
                          child: CustomEvent(
                            onPressed: () {},
                            event: event,
                          ),
                        );
                      },
                    );
                  }
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
