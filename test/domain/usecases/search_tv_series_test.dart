import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/search_tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late SearchTvSeries useCase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    useCase = SearchTvSeries(mockTvRepository);
  });

  final tTvSeries = <Tv>[];
  final tQuery = 'halo';

  test('should get list of tv series from the repository', () async {
    // arrange
    when(mockTvRepository.searchTvSeries(tQuery))
        .thenAnswer((_) async => Right(tTvSeries));

    // act
    final result = await useCase.execute(tQuery);

    // assert
    verify(mockTvRepository.searchTvSeries(tQuery));
    expect(result, Right(tTvSeries));
  });
}
