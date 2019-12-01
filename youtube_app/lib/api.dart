import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:youtube_app/factories/youtube_url_factory.dart';
import 'package:youtube_app/models/video.dart';

// Put your Youtube's API key here
const YOUTUBE_API_KEY = "";

class YoutubeAPI {
  final YoutubeURLFactory youtubeFactory = YoutubeURLFactory();
  String _nextToken;
  String searchTerm;

  YoutubeAPI();

  Future<List<Video>> search(String search) async {
    searchTerm = search;
    final url = youtubeFactory.createSearchURL(search);
    print(url);
    http.Response response = await http.get(url);
    return _decode(response);
  }

  Future<List<Video>> nextPage() async {
    http.Response response = await http
        .get(youtubeFactory.createPaginatedSearchURL(searchTerm, _nextToken));
    return _decode(response);
  }

  List<Video> _decode(http.Response response) {
    if (response.statusCode == 200) {
      var decoded = json.decode(response.body);
      _nextToken = decoded["nextPageToken"];
      List<Video> videos = decoded["items"].map<Video>((item) {
        return Video.fromJson(item);
      }).toList();
      return videos;
    }
    throw Exception("Failed loading videos");
  }
}
