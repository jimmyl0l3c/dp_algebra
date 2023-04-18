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

  LLiterature(
    this.refName,
    this.author,
    this.year,
    this.title,
    this.location,
    this.publisher, {
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

  @override
  bool operator ==(Object other) =>
      other is LLiterature && refName == other.refName;

  @override
  int get hashCode => refName.hashCode;
}
