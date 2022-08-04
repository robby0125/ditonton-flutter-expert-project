String showGenres(List<String> genreNames) {
  String result = '';
  for (var genre in genreNames) {
    result += '$genre, ';
  }

  if (result.isEmpty) {
    return result;
  }

  return result.substring(0, result.length - 2);
}

String showDuration(int runtime) {
  final int hours = runtime ~/ 60;
  final int minutes = runtime % 60;

  if (hours > 0) {
    return '${hours}h ${minutes}m';
  } else {
    return '${minutes}m';
  }
}
