import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_sports/data/event_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'event_state.dart';

class EventCubit extends Cubit<EventState> {
  EventCubit() : super(EventInitial());
  final CollectionReference eventsCollection =
      FirebaseFirestore.instance.collection('events');

  void listenToEvents() {
    emit(EventLoading());

    eventsCollection.snapshots().listen((QuerySnapshot snapshot) {
      List<EventModel> events = snapshot.docs.map((DocumentSnapshot doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return EventModel.fromJson(data);
      }).toList();
      emit(EventLoaded(events: events));
    }, onError: (dynamic error) {
      emit(EventError(message: 'There is no data!'));
    });

  }
}
