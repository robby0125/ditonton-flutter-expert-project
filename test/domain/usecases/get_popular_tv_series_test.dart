import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_popular_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetPopularTvSeries useCase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    useCase = GetPopularTvSeries(mockTvRepository);
  });

  final tTvSeries = <Tv>[];

  test('should get list of tv series from the repository', () async {
    // arrange
    when(mockTvRepository.getPopularTvSeries())
        .thenAnswer((_) async => Right(tTvSeries));

    // act
    final result = await useCase.execute();

    // assert
    verify(mockTvRepository.getPopularTvSeries());
    expect(result, Right(tTvSeries));
  });
}
