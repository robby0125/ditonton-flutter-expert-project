import 'package:core/core.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:movie/movie.dart';
import 'package:search/presentation/bloc/search_bloc.dart';
import 'package:search/search.dart';
import 'package:tv_series/tv_series.dart';

final locator = GetIt.instance;

void init() {
  // bloc
  locator.registerFactory(
    () => MovieListNotifier(
      getNowPlayingMovies: locator(),
      getPopularMovies: locator(),
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => MovieDetailNotifier(
      getMovieDetail: locator(),
      getMovieRecommendations: locator(),
      getMovieWatchListStatus: locator(),
      saveWatchlist: locator(),
      removeWatchlist: locator(),
    ),
  );
  locator.registerFactory(
    () => SearchNotifier(
      searchMovies: locator(),
      searchTvSeries: locator(),
    ),
  );
  locator.registerFactory(
    () => PopularMoviesNotifier(
      locator(),
    ),
  );
  locator.registerFactory(
    () => TopRatedMoviesNotifier(
      getTopRatedMovies: locator(),
    ),
  );
  locator.registerFactory(
    () => WatchlistMovieNotifier(
      getWatchlistMovies: locator(),
    ),
  );
  locator.registerLazySingleton(
    () => TvListNotifier(
      getOnAirTvSeries: locator(),
      getPopularTvSeries: locator(),
      getTopRatedTvSeries: locator(),
    ),
  );
  locator.registerLazySingleton(
    () => ZoomDrawerBloc(
      controller: locator(),
      homeMoviePage: locator<HomeMoviePage>(),
      homeTvPage: locator<HomeTvPage>(),
    ),
  );
  locator.registerLazySingleton(
    () => PopularTvSeriesNotifier(
      getPopularTvSeries: locator(),
    ),
  );
  locator.registerLazySingleton(
    () => TopRatedTvSeriesNotifier(getTopRatedTvSeries: locator()),
  );
  locator.registerLazySingleton(
    () => TvDetailNotifier(
      getTvDetail: locator(),
      getTvRecommendation: locator(),
      getTvWatchlistStatus: locator(),
      saveTvWatchlist: locator(),
      removeTvWatchlist: locator(),
    ),
  );
  locator.registerLazySingleton(
    () => TvSeasonDetailNotifier(
      getTvDetail: locator(),
      getTvSeasonDetail: locator(),
    ),
  );
  locator.registerLazySingleton(
    () => WatchlistTvNotifier(
      getWatchlistTvSeries: locator(),
    ),
  );
  locator.registerLazySingleton(
    () => SearchBloc(
      searchMovies: locator(),
      searchTvSeries: locator(),
    ),
  );

  // use case
  locator.registerLazySingleton(() => GetNowPlayingMovies(locator()));
  locator.registerLazySingleton(() => GetPopularMovies(locator()));
  locator.registerLazySingleton(() => GetTopRatedMovies(locator()));
  locator.registerLazySingleton(() => GetMovieDetail(locator()));
  locator.registerLazySingleton(() => GetMovieRecommendations(locator()));
  locator.registerLazySingleton(() => SearchMovies(locator()));
  locator.registerLazySingleton(() => GetMovieWatchListStatus(locator()));
  locator.registerLazySingleton(() => SaveMovieWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveMovieWatchlist(locator()));
  locator.registerLazySingleton(() => GetWatchlistMovies(locator()));
  locator.registerLazySingleton(() => GetOnAirTvSeries(locator()));
  locator.registerLazySingleton(() => GetPopularTvSeries(locator()));
  locator.registerLazySingleton(() => GetTopRatedTvSeries(locator()));
  locator.registerLazySingleton(() => GetTvDetail(locator()));
  locator.registerLazySingleton(() => GetTvRecommendation(locator()));
  locator.registerLazySingleton(() => GetTvSeasonDetail(locator()));
  locator.registerLazySingleton(() => SearchTvSeries(locator()));
  locator.registerLazySingleton(() => SaveTvWatchlist(locator()));
  locator.registerLazySingleton(() => RemoveTvWatchlist(locator()));
  locator.registerLazySingleton(() => GetTvWatchlistStatus(locator()));
  locator.registerLazySingleton(() => GetWatchlistTvSeries(locator()));

  // repository
  locator.registerLazySingleton<MovieRepository>(
    () => MovieRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
      networkInfo: locator(),
    ),
  );
  locator.registerLazySingleton<TvRepository>(
    () => TvRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
      networkInfo: locator(),
    ),
  );

  // data sources
  locator.registerLazySingleton<MovieRemoteDataSource>(
    () => MovieRemoteDataSourceImpl(client: locator()),
  );
  locator.registerLazySingleton<MovieLocalDataSource>(
    () => MovieLocalDataSourceImpl(movieDatabaseHelper: locator()),
  );
  locator.registerLazySingleton<TvRemoteDataSource>(
    () => TvRemoteDataSourceImpl(client: locator()),
  );
  locator.registerLazySingleton<TvLocalDataSource>(
    () => TvLocalDataSourceImpl(tvDatabaseHelper: locator()),
  );

  // helper
  locator.registerLazySingleton<DatabaseHelper>(() => DatabaseHelper());
  locator.registerLazySingleton(() => MovieDatabaseHelper());
  locator.registerLazySingleton(() => TvDatabaseHelper());

  // network info
  locator.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(locator()));

  // external
  locator.registerLazySingleton(() => http.Client());
  locator.registerLazySingleton(() => DataConnectionChecker());
  locator.registerLazySingleton(() => ZoomDrawerController());

  // page
  locator.registerLazySingleton(() => HomeMoviePage());
  locator.registerLazySingleton(() => HomeTvPage());
}
