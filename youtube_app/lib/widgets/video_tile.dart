import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:youtube_app/api.dart';
import 'package:youtube_app/blocs/favorities_bloc.dart';
import 'package:youtube_app/models/video.dart';

class VideoTile extends StatelessWidget {
  final Video video;

  VideoTile(this.video);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          AspectRatio(
            aspectRatio: 16 / 9,
            child: GestureDetector(
              child:Image.network(
                video.thumb,
                fit: BoxFit.cover,
              ),
              onTap: () {
                FlutterYoutube.playYoutubeVideoById(apiKey: YOUTUBE_API_KEY, videoId: video.id);
              },
            )
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: Text(
                        video.title,
                        style: TextStyle(fontSize: 14.0, color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                      child: Text(
                        video.channel,
                        style: TextStyle(fontSize: 14.0, color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
              StreamBuilder<Map<String, Video>>(
                stream: BlocProvider.getBloc<FavoritesBlock>().outFavorites,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return IconButton(
                      icon: Icon(snapshot.data.containsKey(video.id) ? Icons.star : Icons.star_border),
                      color: Colors.white,
                      iconSize: 30,
                      onPressed: () {
                        BlocProvider.getBloc<FavoritesBlock>().toggleFavorite(video);
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
