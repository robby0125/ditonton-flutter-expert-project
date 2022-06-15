import 'package:ditonton/data/models/genre_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tGenre = GenreModel(
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
