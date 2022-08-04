import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:search/domain/usecases/search_tv_series.dart';
import 'package:tv_series/tv_series.dart';

import 'search_tv_series_test.mocks.dart';

@GenerateMocks([TvRepository])
void main() {
  late SearchTvSeries useCase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    useCase = SearchTvSeries(mockTvRepository);
  });

  final tTvSeries = <Tv>[];
  const tQuery = 'halo';

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
