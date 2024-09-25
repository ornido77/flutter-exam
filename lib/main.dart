import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_exam/pages/person_list_page.dart';
import 'bloc/person_list_bloc.dart';
import 'repositories/person_repository.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({super.key});
  final PersonRepository personRepository = PersonRepository();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Exam App',
      home: BlocProvider(
        create: (context) => PersonBloc(personRepository:personRepository)..add(const FetchPersons()),
        child: const PersonListPage(),
      ),
    );
  }
}
