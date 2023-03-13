class Term {
  final int id;
  final String term;
  final String? shortenedTerm;
  final String? definition; // replace with LBlock id?
  final int pageId;

  Term({
    required this.id,
    required this.term,
    this.shortenedTerm,
    this.definition,
    required this.pageId,
  });
}
