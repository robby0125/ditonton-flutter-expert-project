part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class OnQueryChanged extends SearchEvent {
  final String query;
  final ContentSearch contentSearch;

  const OnQueryChanged({
    required this.query,
    required this.contentSearch,
  });

  @override
  List<Object> get props => [
        query,
        contentSearch,
      ];
}

class ClearState extends SearchEvent {
  const ClearState();
}