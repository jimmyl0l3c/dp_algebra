class LLiterature {
  final String name;
  final String author;
  final String year;

  LLiterature({required this.name, required this.author, required this.year});

  LLiterature.fromJson(Map<dynamic, dynamic> json)
      : name = json["refName"],
        author = json["author"],
        year = json["year"];

  getHarvardCitation() => '($author, $year)';
}
