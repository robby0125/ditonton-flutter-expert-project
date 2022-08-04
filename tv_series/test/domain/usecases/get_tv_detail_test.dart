import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/tv_series.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvDetail useCase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    useCase = GetTvDetail(mockTvRepository);
  });

  const tId = 1;

  test('should get movie detail from the repository', () async {
    // arrange
    when(mockTvRepository.getTvDetail(tId))
        .thenAnswer((_) async => Right(testTvDetail));

    // act
    final result = await useCase.execute(tId);

    // assert
    verify(mockTvRepository.getTvDetail(tId));
    expect(result, Right(testTvDetail));
  });
}
