enum AlphabetModificationMode { J_TO_I, C_TO_K, W_TO_VV, REMOVE_Q }

String applyAlphabetModification(String input, AlphabetModificationMode mode) {
  switch (mode) {
    case AlphabetModificationMode.J_TO_I:
      input = input.replaceAll('J', 'I');
      break;
    case AlphabetModificationMode.C_TO_K:
      input = input.replaceAll('C', 'K');
      break;
    case AlphabetModificationMode.W_TO_VV:
      input = input.replaceAll('W', 'VV');
      break;
    case AlphabetModificationMode.REMOVE_Q:
      input = input.replaceAll('Q', '');
      break;
  }

  return input;
}