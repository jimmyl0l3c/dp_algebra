import '../../utils/extensions.dart';

class LLiterature {
  final String refName;
  final String author;
  final String year;
  final String title;
  final String location;
  final String publisher;
  final String? isbn;
  final int? edition;
  final int? pages;

  LLiterature({
    required this.refName,
    required this.author,
    required this.year,
    required this.title,
    required this.location,
    required this.publisher,
    this.isbn,
    this.edition,
    this.pages,
  });

  LLiterature.fromJson(Map<dynamic, dynamic> json)
      : refName = json["ref_name"],
        author = json["author"],
        year = json["year"],
        title = json["title"],
        location = json["location"],
        publisher = json["publisher"],
        isbn = json["isbn"],
        edition = json["edition"],
        pages = json["pages"];

  String get firstAuthor =>
      RegExp(r'(\S*?),').firstMatch(author)?.group(1)?.capitalize() ?? '...';

  String get harvardCitation => '$firstAuthor, $year';

  String get fullCitation {
    StringBuffer buffer = StringBuffer('$author. $title.');

    if (edition != null) {
      buffer.write(' $edition. vyd.');
    }

    buffer.write(' $location: $publisher, $year.');

    if (isbn != null) {
      buffer.write(' ISBN $isbn');
    }

    return buffer.toString();
  }
}
