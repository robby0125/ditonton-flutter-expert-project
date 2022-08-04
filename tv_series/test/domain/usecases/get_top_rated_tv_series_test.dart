import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:tv_series/tv_series.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTopRatedTvSeries useCase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    useCase = GetTopRatedTvSeries(mockTvRepository);
  });

  final tTvSeries = <Tv>[];

  test('should get list of tv series from the repository', () async {
    // arrange
    when(mockTvRepository.getTopRatedTvSeries())
        .thenAnswer((_) async => Right(tTvSeries));

    // act
    final result = await useCase.execute();

    // assert
    verify(mockTvRepository.getTopRatedTvSeries());
    expect(result, Right(tTvSeries));
  });
}
