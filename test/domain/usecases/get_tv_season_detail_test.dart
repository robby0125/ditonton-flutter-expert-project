import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/get_tv_season_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvSeasonDetail useCase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    useCase = GetTvSeasonDetail(mockTvRepository);
  });

  final tId = 1;
  final tSeasonNumber = 1;

  test('should get tv season detail from the repository', () async {
    // arrange
    when(mockTvRepository.getTvSeasonDetail(tId, tSeasonNumber))
        .thenAnswer((_) async => Right(testSeasonDetail));

    // act
    final result = await useCase.execute(tId, tSeasonNumber);

    // assert
    verify(mockTvRepository.getTvSeasonDetail(tId, tSeasonNumber));
    expect(result, Right(testSeasonDetail));
  });
}
