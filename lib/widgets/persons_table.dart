import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_exam/models/person_model.dart';
import 'package:flutter_exam/pages/person_detail_page.dart';

class PersonsTable extends StatelessWidget {
  const PersonsTable({
    super.key,
    required this.allPersons,
  });

  final List<Person> allPersons;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: DataTable(
        dataRowMinHeight: 30,
        headingRowHeight: 40,
        columnSpacing: 200,
        columns: const [
          DataColumn(
            label: Text(
              'Name',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'Email',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          DataColumn(
            label: Text(
              'Image',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
        ],
        rows: allPersons
            .map(
              (person) => DataRow(
                cells: [
                  _clickableDataCell(
                    context,
                    Text(
                      person.name,
                      style: const TextStyle(fontSize: 12),
                    ),
                    person,
                  ),
                  _clickableDataCell(
                    context,
                    Text(
                      person.email,
                      style: const TextStyle(fontSize: 12),
                    ),
                    person,
                  ),
                  _clickableDataCell(
                    context,
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: person.imageUrl,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(strokeWidth: 2),
                          errorWidget: (context, url, error) =>
                              Image.asset('assets/images/person.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    person,
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }

  DataCell _clickableDataCell(
      BuildContext context, Widget child, Person person) {
    return DataCell(
      InkWell(
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
        child: child,
      ),
    );
  }
}
