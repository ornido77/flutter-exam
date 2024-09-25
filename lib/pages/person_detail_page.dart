import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../models/person_model.dart';

class PersonDetailPage extends StatelessWidget {
  final Person person;
  const PersonDetailPage({super.key, required this.person});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Person\'s Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Center(
              child: SizedBox(
                width: 250,
                height: 250,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: CachedNetworkImage(
                    imageUrl: person.imageUrl,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        Image.asset('assets/images/person.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(person.name, style: const TextStyle(fontSize: 24)),
            Text(person.email, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
