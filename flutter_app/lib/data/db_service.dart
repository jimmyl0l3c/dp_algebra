import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:dp_algebra/models/db/learn_article.dart';
import 'package:dp_algebra/models/db/learn_chapter.dart';
import 'package:dp_algebra/models/db/learn_literature.dart';
import 'package:dp_algebra/models/db/learn_ref.dart';
import 'package:http/http.dart' as http;

class DbService {
  // final String _apiUrl = '127.0.0.1:8000';
  final String _apiUrl = 'algebra2.joska.dev';
  late http.Client _httpClient;
  final int languageId = 1;

  List<LChapter> _chapters = [];
  bool _allChaptersAvailable = false;
  final List<LArticle> _articles = [];

  Map<String, LLiterature> _literature = {};
  final Map<String, LRef> _references = {};

  DbService() {
    _httpClient = http.Client();
  }

  Future<List<LChapter>> fetchChapters({bool forceRefresh = false}) async {
    List<LChapter> chapters = [];

    if (!forceRefresh && _allChaptersAvailable) return _chapters;

    Uri chaptersUri = Uri.https(_apiUrl, '/api/learn/$languageId/chapter/');
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
    LChapter? cachedChapter = _chapters.firstWhereOrNull((c) => c.id == id);
    if (!forceRefresh &&
        cachedChapter != null &&
        cachedChapter.articles.isNotEmpty) {
      return cachedChapter;
    }

    Uri chapterUri = Uri.https(_apiUrl, '/api/learn/$languageId/chapter/$id');
    try {
      final response = await _httpClient.get(chapterUri);

      if (response.statusCode == 200) {
        final data = await json.decode(response.body);
        final loadedChapter = LChapter.fromJson(data);

        if (cachedChapter != null) {
          cachedChapter.articles = loadedChapter.articles;
        }

        return loadedChapter;
      }

      return null;
    } on Error {
      return null;
    }
  }

  Future<LArticle?> fetchArticle(int id, {bool forceRefresh = false}) async {
    LArticle? cachedArticle = _articles.firstWhereOrNull((a) => a.id == id);
    if (!forceRefresh && cachedArticle != null) return cachedArticle;

    Uri articleUri = Uri.https(_apiUrl, '/api/learn/$languageId/article/$id');
    try {
      final response = await _httpClient.get(articleUri);

      if (response.statusCode == 200) {
        final data = await json.decode(response.body);
        LArticle article = LArticle.fromJson(data);

        if (cachedArticle != null) {
          _articles.remove(cachedArticle);
        }
        _articles.add(article);

        return article;
      }
      return null;
    } on Error {
      return null;
    }
  }

  Future<Map<String, LLiterature>?> fetchLiteratureMap() async {
    Uri literatureUri = Uri.https(_apiUrl, '/api/learn/literature');
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

  Future<LRef?> fetchReference(String refName) async {
    if (!_references.containsKey(refName)) {
      Uri refUri = Uri.https(_apiUrl, '/api/learn/ref', {'ref_name': refName});
      try {
        final response = await _httpClient.get(refUri);

        if (response.statusCode == 200) {
          final data = await json.decode(response.body);

          LRef ref = LRef.fromJson(data);
          _references[refName] = ref;

          return ref;
        }

        return null;
      } on Error {
        return null;
      }
    }

    if (_references.containsKey(refName)) return _references[refName];

    return null;
  }
}
