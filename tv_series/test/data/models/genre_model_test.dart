import 'package:tv_series/tv_series.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const tGenre = GenreModel(
    id: 1,
    name: 'action',
  );

  test('should return Map with proper data when toJson is called', () {
    // act
    final result = tGenre.toJson();

    // assert
    final expectedMap = {
      'id': 1,
      'name': 'action',
    };
    expect(result, expectedMap);
  });
}
