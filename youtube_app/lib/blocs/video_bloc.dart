
import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:youtube_app/api.dart';
import 'package:youtube_app/models/video.dart';

class VideoBloc extends BlocBase {

  YoutubeAPI api;

  final StreamController _controller = StreamController();
  final StreamController _searchController = StreamController();

  List<Video> videos;

  Stream get outVideosStream {
    return _controller.stream;
  }

  Sink get inSearch => _searchController.sink;

  VideoBloc() {
    api = YoutubeAPI();
    _searchController.stream.listen((data) {
      _search(data);
    });
  }

  _search(String query) async {

    if (query == null) {
      videos = await api.nextPage();
    } else {
      videos = await api.search(query);
    }
    _controller.sink.add(videos);
  }


  @override
  void dispose() {
    super.dispose();
    _controller.close();
    _searchController.close();
  }

}