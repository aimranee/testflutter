import 'package:event_sports/app/configs/theme.dart';
import 'package:event_sports/app/resources/constant/named_routes.dart';
import 'package:event_sports/firebase_options.dart';
import 'package:event_sports/ui/auth_page.dart';
import 'package:event_sports/ui/pages/add_event.dart';
import 'package:event_sports/ui/pages/detail_page.dart';
import 'package:event_sports/ui/pages/home_page.dart';
import 'package:event_sports/ui/pages/ticket_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: Themes.lightTheme,
      home: const AuthPage(), // Use AuthPage as the initial page
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case NamedRoutes.homeScreen:
            return MaterialPageRoute(builder: (context) => const HomePage());
          case NamedRoutes.detailScreen:
            return MaterialPageRoute(
              builder: (_) => const DetailPage(),
              settings: settings,
            );
          case NamedRoutes.ticketScreen:
            return MaterialPageRoute(
              builder: (context) => const TicketPage(),
              settings: settings,
            );
          case NamedRoutes.addScreen:
            return MaterialPageRoute(
              builder: (context) => const AddEventPage(),
              settings: settings,
            );
          default:
            return MaterialPageRoute(builder: (context) => const AuthPage());
        }
      },
    );
  }
}
