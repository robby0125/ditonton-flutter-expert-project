import 'dart:convert';

import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/models/tv_detail_model.dart';
import 'package:ditonton/data/models/tv_model.dart';
import 'package:ditonton/data/models/tv_response.dart';
import 'package:ditonton/data/models/tv_season_detail_model.dart';
import 'package:http/http.dart' as http;

abstract class TvRemoteDataSource {
  Future<List<TvModel>> getOnAirTvSeries();

  Future<List<TvModel>> getPopularTvSeries();

  Future<List<TvModel>> getTopRatedTvSeries();

  Future<TvDetailResponse> getTvDetail(int id);

  Future<List<TvModel>> getTvRecommendation(int id);

  Future<TvSeasonDetailResponse> getTvSeasonDetail(int tvId, int seasonNumber);

  Future<List<TvModel>> searchTvSeries(String query);
}

class TvRemoteDataSourceImpl implements TvRemoteDataSource {
  final http.Client client;

  TvRemoteDataSourceImpl({required this.client});

  @override
  Future<List<TvModel>> getOnAirTvSeries() async {
    final _response =
        await client.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY'));

    if (_response.statusCode == 200) {
      return TvResponse.fromJson(jsonDecode(_response.body)).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> getPopularTvSeries() async {
    final _response =
        await client.get((Uri.parse('$BASE_URL/tv/popular?$API_KEY')));

    if (_response.statusCode == 200) {
      return TvResponse.fromJson(jsonDecode(_response.body)).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> getTopRatedTvSeries() async {
    final _response =
        await client.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY'));

    if (_response.statusCode == 200) {
      return TvResponse.fromJson(jsonDecode(_response.body)).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TvDetailResponse> getTvDetail(int id) async {
    final _response = await client.get(Uri.parse('$BASE_URL/tv/$id?$API_KEY'));

    if (_response.statusCode == 200) {
      return TvDetailResponse.fromJson(jsonDecode(_response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> getTvRecommendation(int id) async {
    final _response = await client
        .get(Uri.parse('$BASE_URL/tv/$id/recommendations?$API_KEY'));

    if (_response.statusCode == 200) {
      return TvResponse.fromJson(jsonDecode(_response.body)).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TvSeasonDetailResponse> getTvSeasonDetail(
    int tvId,
    int seasonNumber,
  ) async {
    final _result = await client.get(
      Uri.parse('$BASE_URL/tv/$tvId/season/$seasonNumber?$API_KEY'),
    );

    if (_result.statusCode == 200) {
      return TvSeasonDetailResponse.fromJson(jsonDecode(_result.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> searchTvSeries(String query) async {
    final _result = await client.get(
      Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$query'),
    );

    if (_result.statusCode == 200) {
      return TvResponse.fromJson(jsonDecode(_result.body)).tvList;
    } else {
      throw ServerException();
    }
  }
}
