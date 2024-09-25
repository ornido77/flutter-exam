import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/person_model.dart';
import '../repositories/person_repository.dart';

part 'person_list_event.dart';
part 'person_list_state.dart';

class PersonBloc extends Bloc<PersonEvent, PersonState> {
  final PersonRepository personRepository;
  int _fetchAttempts = 0;
  final int maxFetchAttempts = 3;

  PersonBloc({required this.personRepository}) : super(const PersonLoading()) {
    on<FetchPersons>(_onFetchPersons);
    on<RefreshPersons>(_onRefreshPersons);
  }

  void _onFetchPersons(FetchPersons event, Emitter<PersonState> emit) async {
    try {
      final currentState = state;
      List<Person> persons =
          currentState is PersonLoaded ? currentState.persons : [];

      final newPersons = await personRepository.fetchPersons();
      _fetchAttempts += 1;

      if (newPersons.isEmpty) {
        emit(PersonLoaded(persons: persons, hasReachedMax: true));
      } else {
        emit(
          PersonLoaded(
            persons: persons + newPersons,
            hasReachedMax: _fetchAttempts == maxFetchAttempts,
          ),
        );
      }
    } catch (e) {
      emit(const PersonError('Failed to fetch persons'));
    }
  }

  void _onRefreshPersons(
      RefreshPersons event, Emitter<PersonState> emit) async {
    try {
      emit(const PersonLoading());
      final newPersons = await personRepository.fetchPersons();

      _fetchAttempts = 1;
      emit(PersonLoaded(persons: newPersons, hasReachedMax: false));
    } catch (e) {
      emit(const PersonError('Failed to refresh persons'));
    }
  }
}
