import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/usecases/get_watchlist_movies.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helper/test_helper.mocks.dart';

void main() {
  late GetWatchlistMovies useCase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    useCase = GetWatchlistMovies(mockMovieRepository);
  });

  test('should get list of movies from the repository', () async {
    // arrange
    when(mockMovieRepository.getWatchlistMovies())
        .thenAnswer((_) async => Right(testMovieList));
    // act
    final result = await useCase.execute();
    // assert
    expect(result, Right(testMovieList));
  });
}
