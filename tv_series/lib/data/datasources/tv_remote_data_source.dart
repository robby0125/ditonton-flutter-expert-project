import 'dart:convert';

import 'package:core/core.dart';
import 'package:http/io_client.dart';
import 'package:tv_series/data/models/tv_detail_model.dart';
import 'package:tv_series/data/models/tv_model.dart';
import 'package:tv_series/data/models/tv_response.dart';
import 'package:tv_series/data/models/tv_season_detail_model.dart';

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
  final IOClient client;

  TvRemoteDataSourceImpl({required this.client});

  @override
  Future<List<TvModel>> getOnAirTvSeries() async {
    final response =
        await client.get(Uri.parse('$baseUrl/tv/on_the_air?$apiKey'));

    if (response.statusCode == 200) {
      return TvResponse.fromJson(jsonDecode(response.body)).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> getPopularTvSeries() async {
    final response =
        await client.get((Uri.parse('$baseUrl/tv/popular?$apiKey')));

    if (response.statusCode == 200) {
      return TvResponse.fromJson(jsonDecode(response.body)).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> getTopRatedTvSeries() async {
    final response =
        await client.get(Uri.parse('$baseUrl/tv/top_rated?$apiKey'));

    if (response.statusCode == 200) {
      return TvResponse.fromJson(jsonDecode(response.body)).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TvDetailResponse> getTvDetail(int id) async {
    final response = await client.get(Uri.parse('$baseUrl/tv/$id?$apiKey'));

    if (response.statusCode == 200) {
      return TvDetailResponse.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> getTvRecommendation(int id) async {
    final response =
        await client.get(Uri.parse('$baseUrl/tv/$id/recommendations?$apiKey'));

    if (response.statusCode == 200) {
      return TvResponse.fromJson(jsonDecode(response.body)).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<TvSeasonDetailResponse> getTvSeasonDetail(
    int tvId,
    int seasonNumber,
  ) async {
    final result = await client.get(
      Uri.parse('$baseUrl/tv/$tvId/season/$seasonNumber?$apiKey'),
    );

    if (result.statusCode == 200) {
      return TvSeasonDetailResponse.fromJson(jsonDecode(result.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> searchTvSeries(String query) async {
    final result = await client.get(
      Uri.parse('$baseUrl/search/tv?$apiKey&query=$query'),
    );

    if (result.statusCode == 200) {
      return TvResponse.fromJson(jsonDecode(result.body)).tvList;
    } else {
      throw ServerException();
    }
  }
}
