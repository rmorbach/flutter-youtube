import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:youtube_app/api.dart';
import 'package:youtube_app/blocs/favorities_bloc.dart';
import 'package:youtube_app/models/video.dart';

class Favorites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favoritesBloc = BlocProvider.getBloc<FavoritesBlock>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Favorites"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder<Map<String, Video>>(
        stream: favoritesBloc.outFavorites,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: snapshot.data.values.map((item) {
                return InkWell(
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 100,
                        height: 50,
                        child: Image.network(item.thumb),
                      ),
                      Expanded(
                        child: Text(
                          item.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.start,
                        ),
                      )
                    ],
                  ),
                  onTap: () {
                    FlutterYoutube.playYoutubeVideoById(
                        apiKey: YOUTUBE_API_KEY, videoId: item.id);
                  },
                  onLongPress: () {
                    favoritesBloc.toggleFavorite(item);
                  },
                );
              }).toList(),
            );
          } else {
            return Center(
              child: Text("Favorites is empty"),
            );
          }
        },
      ),
      backgroundColor: Colors.black,
    );
  }
}
