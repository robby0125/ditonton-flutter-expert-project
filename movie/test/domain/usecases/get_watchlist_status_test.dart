import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie/domain/usecases/get_movie_watchlist_status.dart';

import '../../helper/test_helper.mocks.dart';

void main() {
  late GetMovieWatchListStatus useCase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    useCase = GetMovieWatchListStatus(mockMovieRepository);
  });

  test('should get watchlist status from repository', () async {
    // arrange
    when(mockMovieRepository.isAddedToWatchlist(1))
        .thenAnswer((_) async => true);
    // act
    final result = await useCase.execute(1);
    // assert
    expect(result, true);
  });
}
