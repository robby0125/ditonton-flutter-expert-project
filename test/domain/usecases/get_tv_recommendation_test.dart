import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvRecommendation useCase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    useCase = GetTvRecommendation(mockTvRepository);
  });

  final tTvSeries = <Tv>[];
  final tId = 1;

  test('should get list of tv series from the repository', () async {
    // arrange
    when(mockTvRepository.getTvRecommendation(tId)).thenAnswer((_) async=> Right(tTvSeries));

    // act
    final result = await useCase.execute(tId);

    // assert
    verify(mockTvRepository.getTvRecommendation(tId));
    expect(result, Right(tTvSeries));
  });
}