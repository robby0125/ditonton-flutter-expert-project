import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

void main() {
  test('should return Map with proper data when toJson is called', () {
    // act
    final result = testTvTable.toJson();

    // assert
    final expectedMap = {
      'id': 1,
      'name': 'name',
      'overview': 'overview',
      'posterPath': '/path.jpg',
    };
    expect(result, expectedMap);
  });
}
