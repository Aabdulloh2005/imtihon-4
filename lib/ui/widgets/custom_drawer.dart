import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadbiro_app/bloc/theme_bloc/theme_cubit.dart';
import 'package:tadbiro_app/services/user_auth_service.dart';
import 'package:tadbiro_app/ui/screens/events/all_events_screen.dart';
import 'package:tadbiro_app/ui/screens/profile/profile_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: ListTile(
              contentPadding: EdgeInsets.only(left: 0, right: 0, top: 40),
              leading: CircleAvatar(
                radius: 40,
                backgroundImage: AssetImage("assets/images/back.png"),
              ),
              title: Text("Abdulloh Ganiev"),
              subtitle: Text("ganievabdulloh2005@gmail.com"),
            ),
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
          ListTile(
            onTap: () async {
              await UserAuthService().signOut();
            },
            leading: const Icon(
              Icons.logout,
              color: Colors.red,
            ),
            title: const Text(
              "Chiqish",
              style: TextStyle(color: Colors.red),
            ),
          )
        ],
      ),
    );
  }
}
