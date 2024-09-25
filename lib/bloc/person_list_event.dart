part of 'person_list_bloc.dart';

abstract class PersonEvent extends Equatable {
  const PersonEvent();

  @override
  List<Object> get props => [];
}

class FetchPersons extends PersonEvent {
  const FetchPersons();

  @override
  List<Object> get props => [];
}

class RefreshPersons extends PersonEvent {
  const RefreshPersons();

  @override
  List<Object> get props => [];
}
