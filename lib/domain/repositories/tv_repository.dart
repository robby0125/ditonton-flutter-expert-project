import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/entities/tv_season_detail.dart';

abstract class TvRepository {
  Future<Either<Failure, List<Tv>>> getOnAirTvSeries();

  Future<Either<Failure, List<Tv>>> getPopularTvSeries();

  Future<Either<Failure, List<Tv>>> getTopRatedTvSeries();

  Future<Either<Failure, TvDetail>> getTvDetail(int id);

  Future<Either<Failure, List<Tv>>> getTvRecommendation(int id);

  Future<Either<Failure, TvSeasonDetail>> getTvSeasonDetail(
    int tvId,
    int seasonNumber,
  );
}
