import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/usecases/remove_movie_watchlist.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helper/test_helper.mocks.dart';

void main() {
  late RemoveMovieWatchlist useCase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    useCase = RemoveMovieWatchlist(mockMovieRepository);
  });

  test('should remove watchlist movie from repository', () async {
    // arrange
    when(mockMovieRepository.removeWatchlist(testMovieDetail))
        .thenAnswer((_) async => const Right('Removed from watchlist'));
    // act
    final result = await useCase.execute(testMovieDetail);
    // assert
    verify(mockMovieRepository.removeWatchlist(testMovieDetail));
    expect(result, const Right('Removed from watchlist'));
  });
}
