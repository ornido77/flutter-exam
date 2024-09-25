part of 'person_list_bloc.dart';

abstract class PersonState extends Equatable {
  const PersonState();

  @override
  List<Object> get props => [];
}

class PersonLoading extends PersonState {
  const PersonLoading();

  @override
  List<Object> get props => [];
}

class PersonLoaded extends PersonState {
  final List<Person> persons;
  final int currentPage;
  final bool hasReachedMax;

  const PersonLoaded({
    required this.persons,
    required this.currentPage,
    required this.hasReachedMax,
  });
  @override
  List<Object> get props => [persons, currentPage, hasReachedMax];
}

class PersonError extends PersonState {
  final String message;
  const PersonError(this.message);
  @override
  List<Object> get props => [message];
}
