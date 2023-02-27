class LLiterature {
  final String refName;
  final String author;
  final String year;

  LLiterature(
      {required this.refName, required this.author, required this.year});

  LLiterature.fromJson(Map<dynamic, dynamic> json)
      : refName = json["ref_name"],
        author = json["author"],
        year = json["year"];

  getHarvardCitation() => '($author, $year)';
}
