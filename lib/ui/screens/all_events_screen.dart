import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tadbiro_app/ui/screens/add_event_screen.dart';
import 'package:tadbiro_app/ui/screens/events/my_events.dart';
import 'package:tadbiro_app/utils/app_color.dart';

class AllEventsScreen extends StatefulWidget {
  const AllEventsScreen({super.key});

  @override
  State<AllEventsScreen> createState() => _AllEventsScreenState();
}

class _AllEventsScreenState extends State<AllEventsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final ValueNotifier<int> _selectedTabNotifier = ValueNotifier<int>(0);

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      _selectedTabNotifier.value = _tabController.index;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _selectedTabNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Tadbirlar"),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications),
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            dividerHeight: 0,
            indicatorColor: AppColor.orange,
            isScrollable: true,
            labelColor: AppColor.orange,
            tabs: const [
              Tab(
                text: 'Tashkil qilganlarim',
              ),
              Tab(
                text: 'Yaqinda',
              ),
              Tab(
                text: 'Ishtirok etganlarim',
              ),
              Tab(
                text: 'Bekor qilganlarim',
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            MyEvents(),
            const Center(
              child: Text("qwer"),
            ),
            const Center(
              child: Text("qwerw"),
            ),
            const Center(
              child: Text("qwer"),
            ),
          ],
        ),
        floatingActionButton: ValueListenableBuilder<int>(
          valueListenable: _selectedTabNotifier,
          builder: (context, index, child) {
            return index == 0
                ? FloatingActionButton(
                    backgroundColor: Colors.orange.shade200,
                    onPressed: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => const AddEventScreen(),
                        ),
                      );
                    },
                    child: Icon(
                      Icons.add,
                      color: AppColor.orange,
                      size: 30,
                    ),
                  )
                : const SizedBox();
          },
        ),
      ),
    );
  }
}
