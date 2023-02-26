import 'dart:convert';

import 'package:dp_algebra/models/db/learn_article.dart';
import 'package:dp_algebra/models/db/learn_chapter.dart';
import 'package:http/http.dart' as http;

class DbService {
  final String _apiUrl = '127.0.0.1:8000';
  late http.Client _httpClient;

  DbService() {
    _httpClient = http.Client();
  }

  // TODO: test the service, change Model.fromJson to match the backend response
  Future<List<LChapter>> fetchChapters() async {
    List<LChapter> chapters = [];
    Uri chaptersUri = Uri.http(_apiUrl, '/api/learn/1/chapter/');
    try {
      final response = await _httpClient.get(chaptersUri);

      if (response.statusCode == 200) {
        final data = await json.decode(response.body);

        for (var chapter in data['chapters']) {
          chapters.add(LChapter.fromJson2(chapter));
        }
      }

      return chapters;
    } on Error {
      return chapters;
    }
  }

  Future<LChapter?> fetchChapter(int id) async {
    Uri chapterUri = Uri.http(_apiUrl, '/api/learn/1/chapter/$id');
    try {
      final response = await _httpClient.get(chapterUri);

      if (response.statusCode == 200) {
        final data = await json.decode(response.body);

        return LChapter.fromJson2(data);
      }

      return null;
    } on Error {
      return null;
    }
  }

  Future<LArticle?> fetchArticle(int id, int? pageId) async {
    Uri chapterUri = Uri.http(
      _apiUrl,
      '/api/learn/1/article/$id',
      {'page_id': pageId},
    );
    try {
      final response = await _httpClient.get(chapterUri);

      if (response.statusCode == 200) {
        final data = await json.decode(response.body);

        return LArticle.fromJson(data);
      }

      return null;
    } on Error {
      return null;
    }
  }
}
