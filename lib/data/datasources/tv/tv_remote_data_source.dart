import 'dart:convert';

import 'package:ditonton/common/constants.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/models/tv_model.dart';
import 'package:ditonton/data/models/tv_response.dart';
import 'package:http/http.dart' as http;

abstract class TvRemoteDataSource {
  Future<List<TvModel>> getOnAirTvSeries();

  Future<List<TvModel>> getPopularTvSeries();

  Future<List<TvModel>> getTopRatedTvSeries();
}

class TvRemoteDataSourceImpl implements TvRemoteDataSource {
  final http.Client client;

  TvRemoteDataSourceImpl({required this.client});

  @override
  Future<List<TvModel>> getOnAirTvSeries() async {
    final _response =
        await http.get(Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY'));

    if (_response.statusCode == 200) {
      return TvResponse.fromJson(jsonDecode(_response.body)).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> getPopularTvSeries() async {
    final _response =
        await http.get(Uri.parse('$BASE_URL/tv/popular?$API_KEY'));

    if (_response.statusCode == 200) {
      return TvResponse.fromJson(jsonDecode(_response.body)).tvList;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TvModel>> getTopRatedTvSeries() async {
    final _response =
        await http.get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY'));

    if (_response.statusCode == 200) {
      return TvResponse.fromJson(jsonDecode(_response.body)).tvList;
    } else {
      throw ServerException();
    }
  }
}
