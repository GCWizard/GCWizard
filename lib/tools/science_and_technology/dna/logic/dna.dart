enum NucleobaseSequenceType { NORMAL, START, STOP }

class AminoAcid {
  final String name;
  final String symbolShort;
  final String symbolLong;
  final List<String> nucleobaseSequences;
  final NucleobaseSequenceType type;

  AminoAcid(this.name, this.symbolShort, this.symbolLong, this.nucleobaseSequences, this.type);
}

List<AminoAcid> aminoAcids = [
  AminoAcid('dna_aminoacid_phenylalanine', 'F', 'Phe', ['UUC', 'UUU'], NucleobaseSequenceType.NORMAL),
  AminoAcid(
      'dna_aminoacid_leucine', 'L', 'Leu', ['UUA', 'UUG', 'CUU', 'CUC', 'CUA', 'CUG'], NucleobaseSequenceType.NORMAL),
  AminoAcid(
      'dna_aminoacid_serine', 'S', 'Ser', ['UCU', 'UCC', 'UCA', 'UCG', 'AGU', 'AGC'], NucleobaseSequenceType.NORMAL),
  AminoAcid('dna_aminoacid_tyrosine', 'Y', 'Tyr', ['UAC', 'UAU'], NucleobaseSequenceType.NORMAL),
  AminoAcid(null, null, null, ['UAA', 'UAG', 'UGA'], NucleobaseSequenceType.STOP),
  AminoAcid('dna_aminoacid_cysteine', 'C', 'Cys', ['UGU', 'UGC'], NucleobaseSequenceType.NORMAL),
  AminoAcid('dna_aminoacid_tryptophan', 'W', 'Trp', ['UGG'], NucleobaseSequenceType.NORMAL),
  AminoAcid('dna_aminoacid_proline', 'P', 'Pro', ['CCA', 'CCG', 'CCC', 'CCU'], NucleobaseSequenceType.NORMAL),
  AminoAcid('dna_aminoacid_histidine', 'H', 'His', ['CAU', 'CAC'], NucleobaseSequenceType.NORMAL),
  AminoAcid('dna_aminoacid_glutamine', 'Q', 'Gln', ['CAA', 'CAG'], NucleobaseSequenceType.NORMAL),
  AminoAcid(
      'dna_aminoacid_arginine', 'R', 'Arg', ['CGA', 'CGC', 'CGG', 'CGU', 'AGG', 'AGA'], NucleobaseSequenceType.NORMAL),
  AminoAcid('dna_aminoacid_isoleucine', 'I', 'Ile', ['AUU', 'AUC', 'AUA'], NucleobaseSequenceType.NORMAL),
  AminoAcid('dna_aminoacid_methionine', 'M', 'Met', ['AUG'], NucleobaseSequenceType.START),
  AminoAcid('dna_aminoacid_threonine', 'T', 'Thr', ['ACU', 'ACA', 'ACC', 'ACG'], NucleobaseSequenceType.NORMAL),
  AminoAcid('dna_aminoacid_asparagine', 'N', 'Asn', ['AAU', 'AAC'], NucleobaseSequenceType.NORMAL),
  AminoAcid('dna_aminoacid_lysine', 'K', 'Lys', ['AAA', 'AAG'], NucleobaseSequenceType.NORMAL),
  AminoAcid('dna_aminoacid_valine', 'V', 'Val', ['GUA', 'GUC', 'GUU'], NucleobaseSequenceType.NORMAL),
  AminoAcid(null, null, null, ['GUG'], NucleobaseSequenceType.START),
  AminoAcid('dna_aminoacid_alanine', 'A', 'Ala', ['GCU', 'GCG', 'GCC', 'GCA'], NucleobaseSequenceType.NORMAL),
  AminoAcid('dna_aminoacid_asparticacid', 'D', 'Asp', ['GAU', 'GAC'], NucleobaseSequenceType.NORMAL),
  AminoAcid('dna_aminoacid_glutamicacid', 'E', 'Glu', ['GAA', 'GAG'], NucleobaseSequenceType.NORMAL),
  AminoAcid('dna_aminoacid_glycine', 'G', 'Gly', ['GGU', 'GGG', 'GGA', 'GGC'], NucleobaseSequenceType.NORMAL),
];

AminoAcid aminoAcidBySymbolShort(String symbolShort) {
  return aminoAcids.firstWhere(
      (element) => element.symbolShort != null && element.symbolShort.toUpperCase() == symbolShort.toUpperCase(),
      orElse: () => null);
}

AminoAcid aminoAcidBySymbolLong(String symbolLong) {
  return aminoAcids.firstWhere(
      (element) => element.symbolLong != null && element.symbolLong.toUpperCase() == symbolLong.toUpperCase(),
      orElse: () => null);
}

AminoAcid aminoAcidByNucleobaseSequence(String sequence) {
  return aminoAcids.firstWhere((element) => element.nucleobaseSequences.contains(sequence.toUpperCase()),
      orElse: () => null);
}

String encodeRNANucleobaseSequence(String input) {
  if (input == null || input.length == 0) return '';

  return input.toUpperCase().split('').map((character) {
    var aminoAcid = aminoAcidBySymbolShort(character);
    if (aminoAcid == null) return '';

    return aminoAcid.nucleobaseSequences.first;
  }).join('');
}

String encodeDNANucleobaseSequence(String input) {
  return encodeRNANucleobaseSequence(input).replaceAll('U', 'T');
}

String encodeRNASymbolLong(String input) {
  if (input == null || input.length == 0) return '';

  return input.toUpperCase().split('').map((character) {
    var aminoAcid = aminoAcidBySymbolShort(character);
    if (aminoAcid == null) return '';

    return aminoAcid.symbolLong.toUpperCase();
  }).join('');
}

List<AminoAcid> decodeDNANucleobaseSequence(String input) {
  if (input == null || input.length == 0) return [];

  return decodeRNANucleobaseSequence(input.toUpperCase().replaceAll(RegExp(r'[^ATCG]'), '').replaceAll('T', 'U'));
}

List<AminoAcid> decodeRNANucleobaseSequence(String input) {
  if (input == null || input.length < 3) return [];

  input = input.toUpperCase().replaceAll(RegExp(r'[^AUCG]'), '');

  while (input.length % 3 != 0) input = input.substring(0, input.length - 1);

  if (input.length == 0) return [];

  var out = <AminoAcid>[];
  for (int i = 0; i < input.length; i = i + 3) {
    var sequence = input.substring(i, i + 3);
    var aminoAcid = aminoAcidByNucleobaseSequence(sequence);
    out.add(aminoAcid);
  }

  return out;
}

String decodeRNASymbolLong(String input) {
  if (input == null || input.length < 3) return '';

  input = input.toUpperCase();

  var out = '';
  while (input.length >= 3) {
    var symbol = input.substring(0, 3);
    var aminoAcid = aminoAcidBySymbolLong(symbol);
    if (aminoAcid == null) {
      input = input.substring(1, input.length);
      continue;
    }

    out += aminoAcid.symbolShort;
    input = input.substring(3, input.length);
  }

  return out;
}
