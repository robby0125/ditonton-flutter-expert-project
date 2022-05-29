import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/network_info.dart';
import 'package:ditonton/data/datasources/tv/tv_local_data_source.dart';
import 'package:ditonton/data/datasources/tv/tv_remote_data_source.dart';
import 'package:ditonton/data/models/tv_table.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:ditonton/domain/entities/tv_season_detail.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';

class TvRepositoryImpl implements TvRepository {
  final TvRemoteDataSource remoteDataSource;
  final TvLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  TvRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Tv>>> getOnAirTvSeries() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getOnAirTvSeries();

        localDataSource.cacheOnAirTvSeries(
            result.map((tv) => TvTable.fromDTO(tv)).toList());

        return Right(result.map((model) => model.toEntity()).toList());
      } on ServerException {
        return Left(ServerFailure(''));
      }
    } else {
      try {
        final result = await localDataSource.getCachedOnAirTvSeries();
        return Right(result.map((tv) => tv.toEntity()).toList());
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> getPopularTvSeries() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getPopularTvSeries();

        localDataSource.cachePopularTvSeries(
            result.map((tv) => TvTable.fromDTO(tv)).toList());

        return Right(result.map((model) => model.toEntity()).toList());
      } on ServerException {
        return Left(ServerFailure(''));
      }
    } else {
      try {
        final result = await localDataSource.getCachedPopularTvSeries();
        return Right(result.map((tv) => tv.toEntity()).toList());
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> getTopRatedTvSeries() async {
    if (await networkInfo.isConnected) {
      try {
        final result = await remoteDataSource.getTopRatedTvSeries();

        localDataSource.cacheTopRatedTvSeries(
            result.map((tv) => TvTable.fromDTO(tv)).toList());

        return Right(result.map((model) => model.toEntity()).toList());
      } on ServerException {
        return Left(ServerFailure(''));
      }
    } else {
      try {
        final result = await localDataSource.getCachedTopRatedTvSeries();
        return Right(result.map((tv) => tv.toEntity()).toList());
      } on CacheException catch (e) {
        return Left(CacheFailure(e.message));
      }
    }
  }

  @override
  Future<Either<Failure, TvDetail>> getTvDetail(int id) async {
    try {
      final _result = await remoteDataSource.getTvDetail(id);
      return Right(_result.toEntity());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> getTvRecommendation(int id) async {
    try {
      final _result = await remoteDataSource.getTvRecommendation(id);
      return Right(_result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, TvSeasonDetail>> getTvSeasonDetail(
    int tvId,
    int seasonNumber,
  ) async {
    try {
      final _result = await remoteDataSource.getTvSeasonDetail(
        tvId,
        seasonNumber,
      );
      return Right(_result.toEntity());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, List<Tv>>> searchTvSeries(String query) async {
    try {
      final _result = await remoteDataSource.searchTvSeries(query);
      return Right(_result.map((model) => model.toEntity()).toList());
    } on ServerException {
      return Left(ServerFailure(''));
    } on SocketException {
      return Left(ConnectionFailure('Failed to connect to the network'));
    }
  }

  @override
  Future<Either<Failure, String>> saveWatchlist(TvDetail tv) async {
    try {
      final _result =
          await localDataSource.insertWatchlist(TvTable.fromEntity(tv));
      return Right(_result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<Either<Failure, String>> removeWatchlist(TvDetail tv) async {
    try {
      final _result =
          await localDataSource.removeWatchlist(TvTable.fromEntity(tv));
      return Right(_result);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<bool> isAddedToWatchlist(int id) async {
    final _result = await localDataSource.getTvById(id);
    return _result != null;
  }

  @override
  Future<Either<Failure, List<Tv>>> getWatchlistTvSeries() async {
    final _result = await localDataSource.getWatchlistTvSeries();
    return Right(_result.map((data) => data.toEntity()).toList());
  }
}
