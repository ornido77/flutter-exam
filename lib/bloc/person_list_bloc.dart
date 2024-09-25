import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/person_model.dart';
import '../repositories/person_repository.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

part 'person_list_event.dart';
part 'person_list_state.dart';

class PersonBloc extends Bloc<PersonEvent, PersonState> {
  final PersonRepository personRepository;
  List<Person> allPersons = [];
  int currentPage = 1;
  final int itemsPerPage = 20;
  final int totalItems = 60;

  PersonBloc({required this.personRepository}) : super(const PersonLoading()) {
    on<FetchPersons>(_onFetchPersons);
    on<RefreshPersons>(_onRefreshPersons);
  }

  void _onFetchPersons(FetchPersons event, Emitter<PersonState> emit) async {
    try {
      if (allPersons.isEmpty) {
        allPersons = await personRepository.fetchPersons();
      }
      if (kIsWeb) {
        emit(const PersonLoading());
        // Web: Display only 20 items per page
        final startIndex = (currentPage - 1) * itemsPerPage;
        final endIndex = (startIndex + itemsPerPage) > allPersons.length
            ? allPersons.length
            : startIndex + itemsPerPage;

        final currentPersons = allPersons.sublist(startIndex, endIndex);

        await Future.delayed(const Duration(seconds: 1));
        emit(PersonLoaded(
          persons: currentPersons,
          currentPage: currentPage,
          hasReachedMax: endIndex >= allPersons.length,
        ));
      } else {
        // Mobile: Append data cumulatively for all pages
        const startIndex = 0;
        final endIndex = currentPage * itemsPerPage > allPersons.length
            ? allPersons.length
            : currentPage * itemsPerPage;

        final currentPersons = allPersons.sublist(startIndex, endIndex);

        await Future.delayed(const Duration(seconds: 1));
        emit(
          PersonLoaded(
            persons: currentPersons,
            currentPage: currentPage,
            hasReachedMax: endIndex >= allPersons.length,
          ),
        );
      }

      // Increment the page for the next request
      currentPage += 1;
    } catch (e) {
      emit(const PersonError('Failed to fetch persons'));
    }
  }

  void _onRefreshPersons(
      RefreshPersons event, Emitter<PersonState> emit) async {
    try {
      emit(const PersonLoading());

      // Fetch the first page again
      currentPage = 1;

      final currentPersons = allPersons.sublist(0, itemsPerPage);

      await Future.delayed(const Duration(seconds: 1));

      emit(
        PersonLoaded(
          persons: currentPersons,
          currentPage: currentPage,
          hasReachedMax: false,
        ),
      );

      currentPage += 1; // Ready for the next page
    } catch (e) {
      emit(const PersonError('Failed to refresh persons'));
    }
  }
}
