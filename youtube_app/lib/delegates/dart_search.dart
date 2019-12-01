

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_app/factories/youtube_url_factory.dart';

class DataSearch extends SearchDelegate<String> {

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    print("building suggestions");
    if (query.trim().isEmpty) {
      return Container();
    }

    return FutureBuilder<List<String>>(
      future: suggestions(query),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(snapshot.data[index]),
                onTap: () {
                  close(context, snapshot.data[index]);
                }
              );
            },
            itemCount: snapshot.data.length,
          );
        } else {
          return Center(
            child: CircularProgressIndicator()
          );
        }
      },
    );

  }

  Future<List<String>> suggestions(String search) async {
    http.Response response = await http.get(YoutubeURLFactory().createSuggestionsURL(search));

    if (response.statusCode == 200) {
      var decodedResponse = json.decode(response.body);
      List<String> results = [];
      decodedResponse[1].forEach( (item) {
        results.add(item[0]);
      });
      return results;
    } else {
      throw Exception("Failed loading suggestions");
    }
  }

}