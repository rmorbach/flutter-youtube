import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:youtube_app/blocs/favorities_bloc.dart';
import 'package:youtube_app/blocs/video_bloc.dart';
import 'package:youtube_app/delegates/dart_search.dart';
import 'package:youtube_app/models/video.dart';
import 'package:youtube_app/screens/favorites_screen.dart';
import 'package:youtube_app/widgets/video_tile.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Container(
          height: 25,
          child: Image.asset("images/youtube-logo.jpeg"),
        ),
        elevation: 0,
        backgroundColor: Colors.black,
        actions: <Widget>[
          Align(
            alignment: Alignment.center,
            child: StreamBuilder<Map<String, Video>>(
              stream: BlocProvider.getBloc<FavoritesBlock>().outFavorites,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text("${snapshot.data.length}");
                } else {
                  return Text("0");
                }
              },
            ),
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () async {
              String result =
                  await showSearch(context: context, delegate: DataSearch());
              if (result != null) {
                BlocProvider.getBloc<VideoBloc>().inSearch.add(result);
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.star),
            onPressed: () {
              _favorite(context);
            },
          )
        ],
      ),
      body: StreamBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemBuilder: (context, index) {
                if (index < snapshot.data.length) {
                  return VideoTile(snapshot.data[index]);
                } else {
                  BlocProvider.getBloc<VideoBloc>().inSearch.add(null);
                  return Container(
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    ),
                  );
                }
              },
              itemCount: snapshot.data.length + 1,
            );
          } else {
            return Center(
              child: Container(
                child: Text(
                  "Perform a search to view the results",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            );
          }
        },
        stream: BlocProvider.getBloc<VideoBloc>().outVideosStream,
      ),
    );
  }

  _favorite(context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return Favorites();
    }));
  }
}
