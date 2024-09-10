// https://de.wikipedia.org/wiki/Lucas-Folge
// could build not recursive
// https://oeis.org/A000225   Mersenne
// https://oeis.org/A000051   Mersenne-like with Fermat-numbers
// https://oeis.org/A000251   Fermat
// https://oeis.org/A000108   Catalan
// https://oeis.org/A001045   Jacobsthal
// https://oeis.org/A014551   Jacobsthal-Lucas
// https://oeis.org/A084175   Jacobsthal-Oblong
// should be build recursive
// https://oeis.org/A000032   Lucas
// https://oeis.org/A000045   Fibonacci
// https://oeis.org/A000129   Pell
// https://oeis.org/A002203   Pell-Lucas
//
// https://oeis.org/A000040   Prime Numbers
//
// recursive sequences
// https://oeis.org/A005132   Recamán
// https://oeis.org/A000142   Factorial
// https://oeis.org/A000110   Bell                B(n) = summe von (n-1 über k)*B8k) für k = 0 bis n-1
//
// https://oeis.org/A081357   Sublime numbers
// https://oeis.org/A000396   Perfect numbers
// https://oeis.org/A019279   Superperfect numbers
// https://oeis.org/A054377   Pseudoperfect numbers
// https://oeis.org/A258706   Permuable primes
// https://oeis.org/A006037   Weird numbers
// https://oeis.org/A000959   Lucky numbers
// https://oeis.org/A007770   Happy numbers
// https://oeis.org/A000668   Mersenne primes
// https://oeis.org/A000043   Mersenne exponents
// https://oeis.org/A023108   Lychrel numbers
// https://oeis.org/A060843   Busy Beaver
//
// suggestions - https://en.wikipedia.org/wiki/List_of_integer_sequences
// https://oeis.org/A008336   RecamánII           a(n+1) = a(n)/n if n|a(n) else a(n)*n, a(1) = 1.
// https://oeis.org/A000058   Sylvester           a(n) = 1 + a(0)*a(1)*...*a(n-1)

import 'dart:isolate';
import 'dart:math';

import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer_parameters.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/busybeaver/logic/list_busy_beaver_numbers.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/happy_numbers/logic/list_happy_numbers.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/lucky_numbers/logic/list_lucky_numbers.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/lychrel/logic/list_lychrel_numbers.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/mersenne_exponents/logic/list_mersenne_exponents.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/mersenne_primes/logic/list_mersenne_primes.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/perfect_numbers/logic/list_perfect_numbers.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/permutable_primes/logic/list_permutable_primes.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/primarypseudoperfect_numbers/logic/list_primary_pseudo_perfect_numbers.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/primes/logic/list_primes.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/sublime_numbers/logic/list_sublime_numbers.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/superperfect_numbers/logic/list_super_perfect_numbers.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/weird_numbers/logic/list_weird_numbers.dart';

part 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence_checknumber.dart';
part 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence_containsdigits.dart';
part 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence_digits.dart';
part 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence_nthnumber.dart';
part 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence_range.dart';

const Map<NumberSequencesMode, String> NUMBERSEQUENCE_TITLE = {
  NumberSequencesMode.LUCAS: 'numbersequence_lucas_title',
  NumberSequencesMode.FIBONACCI: 'numbersequence_fibonacci_title',
  NumberSequencesMode.PRIMES: 'numbersequence_primes_title',
  NumberSequencesMode.MERSENNE: 'numbersequence_mersenne_title',
  NumberSequencesMode.MERSENNE_FERMAT: 'numbersequence_mersennefermat_title',
  NumberSequencesMode.FERMAT: 'numbersequence_fermat_title',
  NumberSequencesMode.JACOBSTAHL: 'numbersequence_jacobsthal_title',
  NumberSequencesMode.JACOBSTHAL_LUCAS: 'numbersequence_jacobsthallucas_title',
  NumberSequencesMode.JACOBSTHAL_OBLONG: 'numbersequence_jacobsthaloblong_title',
  NumberSequencesMode.PELL: 'numbersequence_pell_title',
  NumberSequencesMode.PELL_LUCAS: 'numbersequence_pelllucas_title',
  NumberSequencesMode.CATALAN: 'numbersequence_catalan_title',
  NumberSequencesMode.RECAMAN: 'numbersequence_recaman_title',
  NumberSequencesMode.BELL: 'numbersequence_bell_title',
  NumberSequencesMode.FACTORIAL: 'numbersequence_factorial_title',
  NumberSequencesMode.MERSENNE_PRIMES: 'numbersequence_mersenneprimes_title',
  NumberSequencesMode.MERSENNE_EXPONENTS: 'numbersequence_mersenneexponents_title',
  NumberSequencesMode.PERFECT_NUMBERS: 'numbersequence_perfectnumbers_title',
  NumberSequencesMode.SUPERPERFECT_NUMBERS: 'numbersequence_superperfectnumbers_title',
  NumberSequencesMode.PRIMARY_PSEUDOPERFECT_NUMBERS: 'numbersequence_primarypseudoperfectnumbers_title',
  NumberSequencesMode.WEIRD_NUMBERS: 'numbersequence_weirdnumbers_title',
  NumberSequencesMode.SUBLIME_NUMBERS: 'numbersequence_sublimenumbers_title',
  NumberSequencesMode.LYCHREL: 'numbersequence_lychrel_title',
  NumberSequencesMode.PERMUTABLE_PRIMES: 'numbersequence_permutableprimes_title',
  NumberSequencesMode.LUCKY_NUMBERS: 'numbersequence_luckynumbers_title',
  NumberSequencesMode.HAPPY_NUMBERS: 'numbersequence_happynumbers_title',
  NumberSequencesMode.BUSY_BEAVER: 'numbersequence_busy_beaver_title',
};

class PositionOfSequenceOutput {
  final String number;
  final int positionSequence;
  final int positionDigits;
  PositionOfSequenceOutput(this.number, this.positionSequence, this.positionDigits);
}

enum NumberSequencesMode {
  LUCAS,
  FIBONACCI,
  PRIMES,
  MERSENNE,
  MERSENNE_FERMAT,
  FERMAT,
  JACOBSTAHL,
  JACOBSTHAL_LUCAS,
  JACOBSTHAL_OBLONG,
  PELL,
  PELL_LUCAS,
  CATALAN,
  RECAMAN,
  BELL,
  FACTORIAL,
  MERSENNE_PRIMES,
  MERSENNE_EXPONENTS,
  PERFECT_NUMBERS,
  SUPERPERFECT_NUMBERS,
  PRIMARY_PSEUDOPERFECT_NUMBERS,
  WEIRD_NUMBERS,
  SUBLIME_NUMBERS,
  LYCHREL,
  PERMUTABLE_PRIMES,
  LUCKY_NUMBERS,
  HAPPY_NUMBERS,
  BUSY_BEAVER,
}

final Zero = BigInt.zero;
final One = BigInt.one;
final Two = BigInt.two;
final Three = BigInt.from(3);
final sqrt5 = sqrt(5);
final sqrt2 = sqrt(2);
