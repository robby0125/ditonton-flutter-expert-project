part of 'movie_detail_bloc.dart';

class FetchMovieDetail extends Equatable {
  final int id;

  const FetchMovieDetail(this.id);

  @override
  List<Object> get props => [id];
}
