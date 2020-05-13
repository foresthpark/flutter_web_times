import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertimesweb/models/Article.dart';
import 'package:http/http.dart' as http;

class APIService {
  static final String _baseUrl = 'api.nytimes.com';
  static final String _apiKey = DotEnv().env['API_KEY'];

  Future<dynamic> fetchArticlesBySection(String section) async {
    Map<String, String> parameters = {
      'api-key': _apiKey,
    };

    Uri uri =
        Uri.https(_baseUrl, '/svc/topstories/v2/$section.json', parameters);

    try {
      List<Article> articles = [];
      http.Response response = await http.get(uri);
      Map<String, dynamic> data = json.decode(response.body);
      data['results']
          .forEach((articleMap) => articles.add(Article.fromJson(articleMap)));

      return data;
    } catch (err) {
      print(err);
      throw err.toString();
    }
  }
}
