import 'package:youtube_app/api.dart';

class YoutubeURLFactory {

  static final YoutubeURLFactory _instance = YoutubeURLFactory._internal();

  factory YoutubeURLFactory() => _instance;

  YoutubeURLFactory._internal();

  String createPaginatedSearchURL(String query, String nextToken) {
    return "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$query&type=video&key=$YOUTUBE_API_KEY&maxResults=10&pageToken=$nextToken";
  }

  String createSearchURL(String query) {
    return "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$query&type=video&key=$YOUTUBE_API_KEY&maxResults=10";
  }

  String createSuggestionsURL(String query) {
    return "http://suggestqueries.google.com/complete/search?hl=en&ds=yt&client=youtube&hjson=t&cp=1&q=$query&format=5&alt=json";
  }

}