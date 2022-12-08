class CalcUtils {
  static String? vectorSelectionString(Set<int> selection) {
    if (selection.isEmpty) return null;
    List<String> vectorNames = [];
    for (var index in selection) {
      vectorNames.add('v$index');
    }
    return vectorNames.join(', ');
  }
}
