part of 'top_rated_tv_series_bloc.dart';

abstract class TopRatedTvSeriesState extends Equatable {
  const TopRatedTvSeriesState();

  @override
  List<Object> get props => [];
}

class TopRatedTvSeriesLoading extends TopRatedTvSeriesState {}

class TopRatedTvSeriesError extends TopRatedTvSeriesState {
  final String message;

  const TopRatedTvSeriesError(this.message);

  @override
  List<Object> get props => [message];
}

class TopRatedTvSeriesHasData extends TopRatedTvSeriesState {
  final List<Tv> tvSeries;

  const TopRatedTvSeriesHasData(this.tvSeries);

  @override
  List<Object> get props => [tvSeries];
}
