import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exam/models/person_model.dart';

class PersonsTable extends StatelessWidget {
  const PersonsTable({
    super.key,
    required this.allPersons,
  });

  final List<Person> allPersons;

  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const [
        DataColumn(label: Text('Name')),
        DataColumn(label: Text('Email')),
        DataColumn(label: Text('Image')),
      ],
      rows: allPersons
          .map(
            (person) => DataRow(
              cells: [
                DataCell(Text(person.name)),
                DataCell(Text(person.email)),
                DataCell(
                  SizedBox(
                    width: 40,
                    height: 40,
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
                ),
              ],
            ),
          )
          .toList(),
    );
  }
}
