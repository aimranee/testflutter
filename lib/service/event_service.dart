import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_sports/data/event_model.dart';

class EventService {
  final CollectionReference eventsCollection =
      FirebaseFirestore.instance.collection('events');

  Future<DocumentReference<Object?>> addEvent(EventModel event) async {
    return await eventsCollection.add(event.toJson());
  }

  Stream<QuerySnapshot> getEvents() {
    return eventsCollection.snapshots();
  }

  Future<void> updateEvent(EventModel event) async {
    return await eventsCollection.doc(event.id!).update(event.toJson());
  }

  Future<void> deleteEvent(String eventId) async {
    return await eventsCollection.doc(eventId).delete();
  }
}
