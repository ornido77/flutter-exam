import 'package:flutter/material.dart';
import 'package:flutter_exam/pages/person_detail_page.dart';
import '../models/person_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PersonListItem extends StatelessWidget {
  final Person person;

  const PersonListItem({
    super.key,
    required this.person,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        width: 40,
        height: 40,
        child: ClipOval(
          child: 
          CachedNetworkImage(
            imageUrl: person.imageUrl,
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) =>
                Image.asset('assets/images/person.jpg'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      title: Text(person.name),
      subtitle: Text(person.email),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PersonDetailPage(
              person: person,
            ),
          ),
        );
      },
    );
  }
}
