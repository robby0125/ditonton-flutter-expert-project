import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  test('should return Map with proper data when toJson is called', () {
    // act
    final result = testMovieTable.toJson();

    // assert
    expect(result, testMovieMap);
  });
}
