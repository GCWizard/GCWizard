int newID(List<int> existingIDs) {
  if (existingIDs.length == 0) return 1;

  existingIDs.sort();

  for (int i = 1; i <= existingIDs.length + 1; i++) {
    if (!existingIDs.contains(i)) return i;
  }

  return null;
}
