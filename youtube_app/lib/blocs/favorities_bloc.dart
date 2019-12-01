import 'dart:async';
import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youtube_app/models/video.dart';

class FavoritesBlock extends BlocBase {

  final _controller = BehaviorSubject<Map<String, Video>>.seeded({});

  Stream<Map<String, Video>> get outFavorites => _controller.stream;

  Map<String, Video> _favorites = {};

  FavoritesBlock() {
    SharedPreferences.getInstance().then( (preference) {
      if(preference.getKeys().contains("favorites")) {
        _favorites = json.decode(preference.getString("favorites")).map( (key, item) {
          return MapEntry(key, Video.fromJson(item));
        }).cast<String, Video>();
      }
      _controller.add(_favorites);
    });
  }

  void toggleFavorite(Video video) {
    if (_favorites.containsKey(video.id)) {
      _favorites.remove(video.id);
    } else {
      _favorites[video.id] = video;
    }
    _controller.sink.add(_favorites);
    _saveFavorites();
  }

  _saveFavorites() {
    SharedPreferences.getInstance().then( (preference) {
      preference.setString("favorites", json.encode(_favorites));
    });
  }


  @override
  void dispose() {
    super.dispose();
    _controller.close();
  }

}