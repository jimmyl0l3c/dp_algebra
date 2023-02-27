import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:dp_algebra/models/db/learn_article.dart';
import 'package:dp_algebra/models/db/learn_chapter.dart';
import 'package:dp_algebra/models/db/learn_literature.dart';
import 'package:http/http.dart' as http;

class DbService {
  final String _apiUrl = '127.0.0.1:8000';
  late http.Client _httpClient;

  List<LChapter> _chapters = [];
  bool _allChaptersAvailable =
      false; // TODO: save data age, use it to determine, whether we need to update them

  Map<String, LLiterature> _literature = {};

  DbService() {
    _httpClient = http.Client();
  }

  Future<List<LChapter>> fetchChapters({bool forceRefresh = false}) async {
    List<LChapter> chapters = [];

    if (!forceRefresh && _allChaptersAvailable) return _chapters;

    Uri chaptersUri = Uri.http(_apiUrl, '/api/learn/1/chapter/');
    try {
      final response = await _httpClient.get(chaptersUri);

      if (response.statusCode == 200) {
        final data = await json.decode(response.body);

        for (var chapter in data['chapters']) {
          chapters.add(LChapter.fromJson(chapter));
        }

        if (chapters.isNotEmpty) {
          _chapters = chapters;
          _allChaptersAvailable = true;
        }
      }

      return chapters;
    } on Error {
      return chapters;
    }
  }

  Future<LChapter?> fetchChapter(int id, {bool forceRefresh = false}) async {
    LChapter? chapter = _chapters.firstWhereOrNull((c) => c.id == id);
    if (!forceRefresh && chapter != null && chapter.articles.isNotEmpty) {
      return chapter;
    }

    Uri chapterUri = Uri.http(_apiUrl, '/api/learn/1/chapter/$id');
    try {
      final response = await _httpClient.get(chapterUri);

      if (response.statusCode == 200) {
        final data = await json.decode(response.body);
        final loadedChapter = LChapter.fromJson(data);

        if (chapter != null) {
          chapter.articles = loadedChapter.articles;
        }

        return loadedChapter;
      }

      return null;
    } on Error {
      return null;
    }
  }

  Future<LArticle?> fetchArticle(int id) async {
    Uri articleUri = Uri.http(_apiUrl, '/api/learn/1/article/$id');
    try {
      final response = await _httpClient.get(articleUri);

      if (response.statusCode == 200) {
        final data = await json.decode(response.body);

        // LChapter chapter = LChapter.fromJson(data);
        // chapter.articles = [LArticle.fromJson(data)];
        return LArticle.fromJson(data); // TODO: also add to _chapters
      }
      return null;
    } on Error {
      return null;
    }
  }

  Future<Map<String, LLiterature>?> fetchLiteratureMap() async {
    Uri literatureUri = Uri.http(_apiUrl, '/api/learn/literature');
    try {
      final response = await _httpClient.get(literatureUri);

      if (response.statusCode == 200) {
        final data = await json.decode(response.body);

        Map<String, LLiterature> literature = {};
        for (var lit in data["literature"]) {
          var value = LLiterature.fromJson(lit);
          literature[value.refName] = value;
        }
        return literature;
      }

      return null;
    } on Error {
      return null;
    }
  }

  Future<LLiterature?> fetchLiterature(String refName) async {
    if (_literature.isEmpty) {
      await fetchLiteratureMap().then(
        (value) => {if (value != null) _literature = value},
      );
    }

    if (_literature.containsKey(refName)) return _literature[refName];

    return null;
  }
}
