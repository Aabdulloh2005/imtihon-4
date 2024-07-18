import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Xabarlar"),
      ),
      body: const Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(
                "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8YXZhdGFyfGVufDB8fDB8fHww",
              ),
            ),
            title: Text("Botir Murodov"),
            subtitle: Text("22:00 19-iyun, 2024"),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              "Universitetlar bo'yicha tadbirda qatnashish  niyatim bor edi, qabul qila olasizmi?",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
