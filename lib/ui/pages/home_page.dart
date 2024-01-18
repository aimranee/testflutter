import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_sports/app/configs/colors.dart';
import 'package:event_sports/app/resources/constant/named_routes.dart';
import 'package:event_sports/bloc/event_cubit.dart';
import 'package:event_sports/data/event_model.dart';
import 'package:event_sports/ui/auth_page.dart';
import 'package:event_sports/ui/widgets/card_event_this_month.dart';
import 'package:event_sports/ui/widgets/card_popular_event.dart';
import 'package:event_sports/ui/widgets/circle_button.dart';
import 'package:event_sports/ui/widgets/custom_app_bar.dart';
import 'package:event_sports/ui/widgets/my_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CollectionReference eventsCollection =
      FirebaseFirestore.instance.collection('events');

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      appBar:
          const PreferredSize(preferredSize: Size(0, 0), child: CustomAppBar()),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        child: MyNavigationBar(
          onNavigate: (index) {
            switch (index) {
              case 0:
                Navigator.pushNamed(context, NamedRoutes.homeScreen);
                break;
              case 1:
                Navigator.pushNamed(context, NamedRoutes.addScreen);
                break;
              case 2:
                // Handle navigation to the event screen
                break;
            }
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 24),
          child: BlocProvider(
            create: (_) => EventCubit()..listenToEvents(),
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Popular Event",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                BlocBuilder<EventCubit, EventState>(
                  builder: (context, state) {
                    if (state is EventError) {
                      return Center(child: Text(state.message));
                    } else if (state is EventLoaded) {
                      return _listPopularEvent(state.events);
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
                const SizedBox(height: 24),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Event This Month",
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 16),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                BlocBuilder<EventCubit, EventState>(
                  builder: (context, state) {
                    if (state is EventError) {
                      return Center(child: Text(state.message));
                    } else if (state is EventLoaded) {
                      return _listEventThisMonth(state.events);
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildHeader() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Events app",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8),
              ],
            ),
            CircleButton(icon: 'assets/images/log-out.png', onTap: signUserOut)
          ],
        ),
      );

  _listPopularEvent(List<EventModel> events) => Container(
        width: double.infinity,
        height: 270,
        padding: const EdgeInsets.only(left: 16),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: events.length,
          itemBuilder: (context, index) => GestureDetector(
            onTap: () => Navigator.pushNamed(
              arguments: events[index].toJson(),
              context,
              NamedRoutes.detailScreen,
            ),
            child: CardPopularEvent(eventModel: events[index]),
          ),
        ),
      );

  void signUserOut() {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AuthPage()),
    );
  }

  _listEventThisMonth(List<EventModel> events) => Container(
        height: 300,
        margin: const EdgeInsets.symmetric(horizontal: 24),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: events.length,
          itemBuilder: (context, index) => BlocBuilder<EventCubit, EventState>(
            builder: (context, state) {
              if (state is EventError) {
                return const Center(child: Text("Error"));
              } else if (state is EventLoaded) {
                return GestureDetector(
                  onTap: () => Navigator.pushNamed(
                      arguments: events[index].toJson(),
                      context,
                      NamedRoutes.detailScreen),
                  child: CardEventThisMonth(eventModel: events[index]),
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      );
}
