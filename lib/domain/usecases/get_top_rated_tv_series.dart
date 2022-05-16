import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';

class GetTopRatedTvSeries {
  final TvRepository repository;

  GetTopRatedTvSeries(this.repository);

  Future<Either<Failure, List<Tv>>> execute() {
    return repository.getTopRatedTvSeries();
  }
}
