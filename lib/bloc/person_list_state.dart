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
  final bool hasReachedMax;

  const PersonLoaded({required this.persons, required this.hasReachedMax});
  @override
  List<Object> get props => [persons, hasReachedMax];
}

class PersonError extends PersonState {
  final String message;
  const PersonError(this.message);
  @override
  List<Object> get props => [message];
}
