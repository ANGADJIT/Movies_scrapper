import 'dart:convert';
import 'package:movies_scrapper/src/api/movie_model.dart';
import 'package:stream_variable/stream_variable.dart';
import 'package:http/http.dart' as http;

class MoviesAPI {
  // making it singleton
  static final MoviesAPI _instance = MoviesAPI.init();
  MoviesAPI.init() {
    // init stream of data
    _moviesData = StreamVariable<List<Movies>>();
    _getAndModelData('').then((value) => {
          _moviesData.setVariable = value,
          _moviesData.variableSink.add(_moviesData.getVariable)
        });
  }

  factory MoviesAPI() => _instance;

  // method : to get and model the data
  static Future<List<Movies>> _getAndModelData(String movieName) async {
    http.Response response;

    if (movieName.isEmpty) {
      response =
          await http.get(Uri.parse('http://192.168.1.4:5000/movies_home'));
    } else {
      // clean movie name before passing to url
      movieName = movieName.trim().replaceAll(' ', '+').toLowerCase();

      response = await http.get(
          Uri.parse('http://192.168.1.4:5000/movies?movie_name=$movieName'));
    }

    // now model the data
    final movies = jsonDecode(response.body) as Map;
    final moviesList = <Movies>[];

    for (var movie in movies['movies']) {
      moviesList.add(Movies(
          movieRef: movie['mov_ref'],
          thumbnailUrl: movie['thumbnail'],
          title: movie['title'].toString().replaceAll('Watch', '')));
    }

    return moviesList;
  }

  // method : to search movies
  static Future<void> searchForMovies(String movieName) async {
    final moviesResult = await _getAndModelData(movieName);

    _moviesData.setVariable = moviesResult;
    _moviesData.variableSink.add(_moviesData.getVariable);
  }

  // stream for movies data
  static late StreamVariable<List<Movies>> _moviesData;

  // getter : for movies data stream
  static Stream<List<Movies>> get movies => _moviesData.variableStream;
}
