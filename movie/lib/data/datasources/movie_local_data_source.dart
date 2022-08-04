import 'package:core/core.dart';
import 'package:movie/movie.dart';

abstract class MovieLocalDataSource {
  Future<String> insertWatchlist(MovieTable movie);

  Future<String> removeWatchlist(MovieTable movie);

  Future<MovieTable?> getMovieById(int id);

  Future<List<MovieTable>> getWatchlistMovies();

  Future<void> cacheNowPlayingMovies(List<MovieTable> movies);

  Future<List<MovieTable>> getCachedNowPlayingMovies();

  Future<void> cachePopularMovies(List<MovieTable> movies);

  Future<List<MovieTable>> getCachedPopularMovies();

  Future<void> cacheTopRatedMovies(List<MovieTable> movies);

  Future<List<MovieTable>> getCachedTopRatedMovies();
}

class MovieLocalDataSourceImpl implements MovieLocalDataSource {
  final MovieDatabaseHelper movieDatabaseHelper;

  MovieLocalDataSourceImpl({required this.movieDatabaseHelper});

  @override
  Future<String> insertWatchlist(MovieTable movie) async {
    try {
      await movieDatabaseHelper.insertMovieWatchlist(movie);
      return 'Added to Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<String> removeWatchlist(MovieTable movie) async {
    try {
      await movieDatabaseHelper.removeMovieWatchlist(movie);
      return 'Removed from Watchlist';
    } catch (e) {
      throw DatabaseException(e.toString());
    }
  }

  @override
  Future<MovieTable?> getMovieById(int id) async {
    final result = await movieDatabaseHelper.getMovieById(id);
    if (result != null) {
      return MovieTable.fromMap(result);
    } else {
      return null;
    }
  }

  @override
  Future<List<MovieTable>> getWatchlistMovies() async {
    final result = await movieDatabaseHelper.getWatchlistMovies();
    return result.map((data) => MovieTable.fromMap(data)).toList();
  }

  @override
  Future<void> cacheNowPlayingMovies(List<MovieTable> movies) async {
    await movieDatabaseHelper.clearMoviesCache('now playing');
    await movieDatabaseHelper.insertMovieCacheTransaction(movies, 'now playing');
  }

  @override
  Future<List<MovieTable>> getCachedNowPlayingMovies() async {
    final result = await movieDatabaseHelper.getCacheMovies('now playing');

    if (result.isNotEmpty) {
      return result.map((movie) => MovieTable.fromMap(movie)).toList();
    } else {
      throw CacheException("Can't get the data :(");
    }
  }

  @override
  Future<void> cachePopularMovies(List<MovieTable> movies) async {
    await movieDatabaseHelper.clearMoviesCache('popular');
    await movieDatabaseHelper.insertMovieCacheTransaction(movies, 'popular');
  }

  @override
  Future<List<MovieTable>> getCachedPopularMovies() async {
    final result = await movieDatabaseHelper.getCacheMovies('popular');

    if (result.isNotEmpty) {
      return result.map((movie) => MovieTable.fromMap(movie)).toList();
    } else {
      throw CacheException("Can't get the data :(");
    }
  }

  @override
  Future<void> cacheTopRatedMovies(List<MovieTable> movies) async {
    await movieDatabaseHelper.clearMoviesCache('top rated');
    await movieDatabaseHelper.insertMovieCacheTransaction(movies, 'top rated');
  }

  @override
  Future<List<MovieTable>> getCachedTopRatedMovies() async {
    final result = await movieDatabaseHelper.getCacheMovies('top rated');

    if (result.isNotEmpty) {
      return result.map((movie) => MovieTable.fromMap(movie)).toList();
    } else {
      throw CacheException("Can't get the data :(");
    }
  }
}
