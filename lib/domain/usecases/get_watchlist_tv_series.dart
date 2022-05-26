import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';

class GetWatchlistTvSeries {
  final TvRepository repository;

  GetWatchlistTvSeries(this.repository);

  Future<Either<Failure, List<Tv>>> execute() async {
    return repository.getWatchlistTvSeries();
  }
}
