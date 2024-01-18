import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_sports/data/event_model.dart';
import 'package:event_sports/ui/auth_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:event_sports/ui/widgets/circle_button.dart';
import 'package:event_sports/ui/widgets/custom_app_bar.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddEventPage extends StatefulWidget {
  const AddEventPage({super.key});

  @override
  _AddEventPageState createState() => _AddEventPageState();
}

class _AddEventPageState extends State<AddEventPage> {
  final _formKey = GlobalKey<FormState>();
  EventModel? event;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController prixController = TextEditingController();
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          const PreferredSize(preferredSize: Size(0, 0), child: CustomAppBar()),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppBar(context),
                const SizedBox(height: 24),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Event Name'),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: prixController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: dateController,
                  decoration: const InputDecoration(labelText: 'Event Date'),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2101),
                    );

                    if (pickedDate != null) {
                      String formattedDate =
                          DateFormat('dd MMM').format(pickedDate);
                      dateController.text = formattedDate;
                    }
                  },
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: locationController,
                  decoration: const InputDecoration(labelText: 'City'),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _pickImage,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    'Upload Image',
                  ),
                ),
                if (_image != null)
                  Image.file(
                    _image!,
                    height: 100,
                  ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    _submitForm(
                        titleController.text,
                        dateController.text,
                        locationController.text,
                        descriptionController.text,
                        prixController.text,
                        _image);
                    Navigator.pop(context);
                  },
                  child: const Text('Add event!!'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleButton(
            icon: 'assets/images/ic_arrow_left.png',
            onTap: () => Navigator.pop(context),
          ),
          const Text(
            "Detail",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          CircleButton(icon: 'assets/images/log-out.png', onTap: signUserOut)
        ],
      );
  void signUserOut() {
    FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AuthPage()),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _submitForm(String title, String date, String location,
      String description, String prix, File? image) async {
    try {
      String photoUrl = await _uploadImage(image);
      await FirebaseFirestore.instance.collection('events').add({
        'title': title,
        'image': photoUrl,
        'date': date,
        'location': location,
        'description': description,
        'prix': prix
      });

      print('Event added to Firebase');
      // You can navigate to another screen or perform additional actions here
    } catch (error) {
      print('Failed to add event to Firebase: $error');
    }
  }

  Future<String> _uploadImage(File? image) async {
    if (image == null) {
      return Future.error("Image is null");
    }

    try {
      String fileName = "image_${DateTime.now().millisecondsSinceEpoch}.jpg";
      Reference storageReference =
          FirebaseStorage.instance.ref().child("images/$fileName");
      await storageReference.putFile(image);
      String downloadURL = await storageReference.getDownloadURL();
      return downloadURL;
    } catch (error) {
      return Future.error("Failed to upload image");
    }
  }
}
