import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:tv_series/tv_series.dart';

class SearchTvSeries {
  final TvRepository repository;

  SearchTvSeries(this.repository);

  Future<Either<Failure, List<Tv>>> execute(String query) {
    return repository.searchTvSeries(query);
  }
}
