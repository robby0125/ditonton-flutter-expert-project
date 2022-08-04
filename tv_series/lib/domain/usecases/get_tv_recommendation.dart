import 'package:core/utils/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:tv_series/domain/entities/tv.dart';
import 'package:tv_series/domain/repositories/tv_repository.dart';

class GetTvRecommendation {
  final TvRepository repository;

  GetTvRecommendation(this.repository);

  Future<Either<Failure, List<Tv>>> execute(int id) {
    return repository.getTvRecommendation(id);
  }
}
