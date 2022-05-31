import 'package:ditonton/domain/usecases/get_tv_watchlist_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvWatchlistStatus useCase;
  late MockTvRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockTvRepository();
    useCase = GetTvWatchlistStatus(mockTvRepository);
  });

  final tId = 1;

  test('should get tv watchlist status from the repository', () async {
    // arrange
    when(mockTvRepository.isAddedToWatchlist(tId)).thenAnswer((_) async => true);

    // act
    final result = await useCase.execute(tId);

    // assert
    verify(mockTvRepository.isAddedToWatchlist(tId));
    expect(result, true);
  });
}