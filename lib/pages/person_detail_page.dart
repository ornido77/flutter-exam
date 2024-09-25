import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exam/widgets/widgets.dart';
import 'package:intl/intl.dart';
import '../models/person_model.dart';

class PersonDetailPage extends StatelessWidget {
  final Person person;
  const PersonDetailPage({super.key, required this.person});

  String _formatDate(String date) {
    try {
      final parsedDate = DateTime.parse(date);
      return DateFormat('MMMM d, y').format(parsedDate);
    } catch (e) {
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: reusableText(
          'Profile',
          size: 24,
          color: Colors.white,
        ),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header/Profile Image Card
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple, Colors.purpleAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Profile Image
                    SizedBox(
                      width: 150,
                      height: 150,
                      child: ClipOval(
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
                    const SizedBox(height: 16),
                    // Name
                    reusableText(
                      person.name,
                      size: 28,
                      fw: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Details Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      reusableText('Details', size: 22, fw: FontWeight.w600),
                      const SizedBox(height: 16),
                      _buildDetailRow(Icons.email, person.email),
                      _buildDetailRow(Icons.phone_android, person.phone),
                      _buildDetailRow(
                        Icons.calendar_today,
                        _formatDate(
                          person.birthDay,
                        ),
                      ),
                      _buildDetailRow(
                        person.gender == 'female' ? Icons.female : Icons.male,
                        person.gender,
                      ),
                      _buildDetailRow(Icons.link, person.website),
                      _buildDetailRow(Icons.location_on, person.address),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _buildDetailRow(IconData icon, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.deepPurpleAccent),
        const SizedBox(width: 12),
        Expanded(
          child: reusableText(value, size: 16, color: Colors.black87),
        ),
      ],
    );
  }
}
