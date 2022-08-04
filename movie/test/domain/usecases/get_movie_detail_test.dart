import 'package:movie/domain/usecases/get_movie_detail.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helper/test_helper.mocks.dart';

void main() {
  late GetMovieDetail useCase;
  late MockMovieRepository mockMovieRepository;

  setUp(() {
    mockMovieRepository = MockMovieRepository();
    useCase = GetMovieDetail(mockMovieRepository);
  });

  const tId = 1;

  test('should get movie detail from the repository', () async {
    // arrange
    when(mockMovieRepository.getMovieDetail(tId))
        .thenAnswer((_) async => const Right(testMovieDetail));
    // act
    final result = await useCase.execute(tId);
    // assert
    expect(result, const Right(testMovieDetail));
  });
}
