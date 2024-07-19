import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tadbiro_app/bloc/theme_bloc/theme_cubit.dart';
import 'package:tadbiro_app/controllers/tadbir_controller.dart';
import 'package:tadbiro_app/firebase_options.dart';
import 'package:tadbiro_app/services/firebase_push_notification_service.dart';
import 'package:tadbiro_app/services/location_service.dart';
import 'package:tadbiro_app/services/tadbir_service_firebase.dart';
import 'package:tadbiro_app/ui/screens/authentication/sign_in_screen.dart';
import 'package:tadbiro_app/ui/screens/homepage.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    await FirebasePushNotificationService.init();
    await LocationService.checkPermissions();
  } catch (e) {
    print('Firebase initialization error: $e');
  }

  runApp(const MainRunner());
}

class MainRunner extends StatelessWidget {
  const MainRunner({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TadbirController(
        tadbirServiceFirebase: TadbirServiceFirebase(),
      ),
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => ThemeCubit(),
            ),
          ],
          child: BlocBuilder<ThemeCubit, bool>(
            builder: (context, isLightTheme) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  fontFamily: 'ComicSans',
                ),
                darkTheme: ThemeData.dark(),
                // .copyWith(
                //     // textTheme: Theme.of(context).textTheme.apply(
                //     //       fontFamily: 'ComicSans',
                //     //       // bodyColor: Colors.white,
                //     //       // displayColor: Colors.white,
                //     //     ),
                //     ),
                themeMode: isLightTheme ? ThemeMode.light : ThemeMode.dark,
                home: const AuthStateHandler(),
              );
            },
          ),
        );
      },
    );
  }
}

class AuthStateHandler extends StatelessWidget {
  const AuthStateHandler({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return const Scaffold(
            body: Center(
              child: Text('Something went wrong!'),
            ),
          );
        }

        return snapshot.hasData ? const Homepage() : const SignInScreen();
      },
    );
  }
}
