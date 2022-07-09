import 'package:core/domain/entities/tv_season_detail.dart';
import 'package:core/domain/repositories/tv_repository.dart';
import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';

class GetTvSeasonDetail {
  final TvRepository repository;

  GetTvSeasonDetail(this.repository);

  Future<Either<Failure, TvSeasonDetail>> execute(int tvId, int seasonNumber) {
    return repository.getTvSeasonDetail(tvId, seasonNumber);
  }
}
