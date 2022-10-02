part of 'tv_series_detail_bloc.dart';

class FetchTvSeriesDetail extends Equatable {
  final int id;

  const FetchTvSeriesDetail(this.id);

  @override
  List<Object?> get props => [id];
}
