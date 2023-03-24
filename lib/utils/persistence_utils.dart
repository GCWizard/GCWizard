int newID(List<int?> existingIDs) {
  if (existingIDs.isEmpty) return 1;

  existingIDs.sort();

  for (int i = 1; i <= existingIDs.length + 1; i++) {
    if (!existingIDs.contains(i)) return i;
  }

  throw Exception('No id generated');
}
