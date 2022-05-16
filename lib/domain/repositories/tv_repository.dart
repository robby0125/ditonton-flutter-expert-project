import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';

abstract class TvRepository {
  Future<Either<Failure, List<Tv>>> getOnAirTvSeries();

  Future<Either<Failure, List<Tv>>> getPopularTvSeries();

  Future<Either<Failure, List<Tv>>> getTopRatedTvSeries();
}
