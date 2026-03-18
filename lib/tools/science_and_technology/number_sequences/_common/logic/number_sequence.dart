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

import 'package:gc_wizard/common_widgets/async_executer/gcw_async_executer_parameters.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/bell/logic/bell.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/busybeaver/logic/busybeaver.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/carmichael/logic/carmichael_numbers.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/catalan/catalan/catalan.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/factorial/logic/factorial.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/fermat/logic/fermat.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/fibonacci/logic/fibonacci.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/happy_numbers/logic/happy_numbers.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/harshad/logic/harshad_numbers.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/jacobsthal/logic/jacobsthal.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/jacobsthal_lucas/logic/jacobsthal_lucas.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/jacobsthal_oblong/logic/jacobsthal_oblong.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/lonely_numbers/logic/lonely_numbers.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/look_and_say/logic/look_and_say.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/lucas/logic/lucas.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/lucky_numbers/logic/lucky_numbers.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/lychrel/logic/lychrel.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/memorable_primes/logic/memorable_primes.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/memorable_primes/logic/memorable_primes_indexes.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/mersenne/logic/mersenne.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/mersenne_exponents/logic/mersenne_exponents.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/mersenne_primes/logic/mersenne_primes.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/mersennefermat/logic/mersennefermat.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/palindrome_primes/logic/palindrome_primes.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/pell/logic/pell.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/pell_lucas/logic/pell_lucas.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/perfect_numbers/logic/perfect_numbers.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/permutable_primes/logic/permutable_primes.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/primarypseudoperfect_numbers/logic/primarypseudoperfect_numbers.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/primes/logic/primes.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/recaman/logic/recaman.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/sphenic_numbers/logic/sphenic_numbers.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/sublime_numbers/logic/sublime_numbers.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/suitable_numbers/logic/suitable_numbers.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/superperfect_numbers/logic/superperfect_numbers.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/taxicab/logic/taxicab_numbers.dart';
import 'package:gc_wizard/tools/science_and_technology/number_sequences/weird_numbers/logic/weird_numbers.dart';

part 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence_checknumber.dart';
part 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence_containsdigits.dart';
part 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence_digits.dart';
part 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence_nthnumber.dart';
part 'package:gc_wizard/tools/science_and_technology/number_sequences/_common/logic/number_sequence_range.dart';

final Map<NumberSequencesMode, ({String title, BaseNumberSequence sequence})> NUMBERSEQUENCES = {
  NumberSequencesMode.LUCAS: (title: 'numbersequence_lucas_title', sequence: LucasNumberSequence()),
  NumberSequencesMode.FIBONACCI: (title: 'numbersequence_fibonacci_title', sequence: FibonacciNumberSequence()),
  NumberSequencesMode.PRIMES: (title: 'numbersequence_primes_title', sequence: PrimesNumberSequence()),
  NumberSequencesMode.MERSENNE: (title: 'numbersequence_mersenne_title', sequence: MersenneNumberSequence()),
  NumberSequencesMode.MERSENNE_FERMAT: (title: 'numbersequence_mersennefermat_title', sequence: MersenneFermatNumberSequence()),
  NumberSequencesMode.FERMAT: (title: 'numbersequence_fermat_title', sequence: FermatNumberSequence()),
  NumberSequencesMode.JACOBSTAHL: (title: 'numbersequence_jacobsthal_title', sequence: JacobsthalNumberSequence()),
  NumberSequencesMode.JACOBSTHAL_LUCAS: (title: 'numbersequence_jacobsthallucas_title', sequence: JacobsthalLocasNumberSequence()),
  NumberSequencesMode.JACOBSTHAL_OBLONG: (title: 'numbersequence_jacobsthaloblong_title', sequence: JacobsthalOblongNumberSequence()),
  NumberSequencesMode.PELL: (title: 'numbersequence_pell_title', sequence: PellNumberSequence()),
  NumberSequencesMode.PELL_LUCAS: (title: 'numbersequence_pelllucas_title', sequence: PellLucasNumberSequence()),
  NumberSequencesMode.CATALAN: (title: 'numbersequence_catalan_title', sequence: CatalanNumberSequence()),
  NumberSequencesMode.RECAMAN: (title: 'numbersequence_recaman_title', sequence: RecamanNumberSequence()),
  NumberSequencesMode.BELL: (title: 'numbersequence_bell_title', sequence: BellNumberSequence()),
  NumberSequencesMode.FACTORIAL: (title: 'numbersequence_factorial_title', sequence: FactorialNumberSequence()),
  NumberSequencesMode.MERSENNE_PRIMES: (title: 'numbersequence_mersenneprimes_title', sequence: MersennePrimesNumberSequence()),
  NumberSequencesMode.MERSENNE_EXPONENTS: (title: 'numbersequence_mersenneexponents_title', sequence: MersenneExponentsNumberSequence()),
  NumberSequencesMode.PERFECT_NUMBERS: (title: 'numbersequence_perfectnumbers_title', sequence: PerfectNumbersNumberSequence()),
  NumberSequencesMode.SUPERPERFECT_NUMBERS: (title: 'numbersequence_superperfectnumbers_title', sequence: SuperPerfectNumberSequence()),
  NumberSequencesMode.PRIMARY_PSEUDOPERFECT_NUMBERS: (title: 'numbersequence_primarypseudoperfectnumbers_title', sequence: PrimaryPseudoPerfectNumbersNumberSequence()),
  NumberSequencesMode.WEIRD_NUMBERS: (title: 'numbersequence_weirdnumbers_title', sequence: WeirdNumberSequence()),
  NumberSequencesMode.SUBLIME_NUMBERS: (title: 'numbersequence_sublimenumbers_title', sequence: SublimeNumbersNumberSequence()),
  NumberSequencesMode.LYCHREL: (title: 'numbersequence_lychrel_title', sequence: LychrelNumberSequence()),
  NumberSequencesMode.PERMUTABLE_PRIMES: (title: 'numbersequence_permutableprimes_title', sequence: PermutablePrimesNumberSequence()),
  NumberSequencesMode.MEMORABLE_PRIMES: (title: 'numbersequence_memorableprimes_title', sequence: MemorablePrimesNumberSequence()),
  NumberSequencesMode.MEMORABLE_PRIMES_INDEXES: (title: 'numbersequence_memorableprimesindexes_title', sequence: MemorablePrimesIndexesNumberSequence()),
  NumberSequencesMode.LUCKY_NUMBERS: (title: 'numbersequence_luckynumbers_title', sequence: LuckyNumberSequence()),
  NumberSequencesMode.HAPPY_NUMBERS: (title: 'numbersequence_happynumbers_title', sequence: HappyNumbersNumberSequence()),
  NumberSequencesMode.BUSY_BEAVER: (title: 'numbersequence_busy_beaver_title', sequence: BusyBeaverNumberSequence()),
  NumberSequencesMode.CARMICHAEL: (title: 'numbersequence_carmichaelnumbers_title', sequence: CarmichaelNumberSequence()),
  NumberSequencesMode.SPHENIC: (title: 'numbersequence_sphenicnumbers_title', sequence: SphenicNumberSequence()),
  NumberSequencesMode.HARSHAD: (title: 'numbersequence_harshadnumbers_title', sequence: HarshadNumberSequence()),
  NumberSequencesMode.TAXICAB: (title: 'numbersequence_taxicabnumbers_title', sequence: TaxicabNumberSequence()),
  NumberSequencesMode.LONELY: (title: 'numbersequence_lonelynumbers_title', sequence: LonelyNumberSequence()),
  NumberSequencesMode.PALINDROME_PRIMES: (title: 'numbersequence_palindromeprimes_title', sequence: PalindromePrimesNumberSequence()),
  NumberSequencesMode.SUITABLE_NUMBERS: (title: 'numbersequence_suitablenumbers_title', sequence: SuitableNumberSequence()),
  NumberSequencesMode.LOOK_AND_SAY: (title: 'numbersequence_look_and_saynumbers_title', sequence: LookAndSayNumberSequence()),
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
  MEMORABLE_PRIMES,
  MEMORABLE_PRIMES_INDEXES,
  LUCKY_NUMBERS,
  HAPPY_NUMBERS,
  BUSY_BEAVER,
  SPHENIC,
  CARMICHAEL,
  HARSHAD,
  TAXICAB,
  LONELY,
  PALINDROME_PRIMES,
  SUITABLE_NUMBERS,
  LOOK_AND_SAY
}

abstract class BaseNumberSequence {
  static var Zero = BigInt.zero;
  static var One = BigInt.one;
  static var Two = BigInt.two;
  static var Three = BigInt.from(3);

  PositionOfSequenceOutput getFirstPositionOfSequence(String check, int maxIndex, RegExp expr) {
    return PositionOfSequenceOutput('-1', 0, 0);
  }

  List<BigInt> getNumbersWithNDigits(int digits) {
    return <BigInt>[];
  }

  BigInt calculateNumberAt(NumberSequencesMode sequence, int n) {
    List<BigInt> result = calculateRange(n, n);

    return result.isEmpty ? BigInt.from(-1): result[0];
  }

  List<BigInt> calculateRange(int start, int stop) {
    return <BigInt>[];
  }

  static List<BigInt> getNumbersWithNDigitsBase(int digits, List<String> sequenceList) {
    var numberList = <BigInt>[];

    for (int i = 0; i < sequenceList.length; i++) {
      if (sequenceList[i].length == digits) {
        var value = BigInt.tryParse(sequenceList[i]);
        if (value != null) numberList.add(value);
      }
    }
    return numberList;
  }

  static List<BigInt> getNumbersWithNDigitsBaseFunction(int digits, BigInt Function(int) numberSequenceFunction) {
    var numberList = <BigInt>[];
    BigInt number;

    int index = 0;
    number = Two;
    while (number.toString().length < digits + 1) {
      number = numberSequenceFunction(index);
      if (number.toString().length == digits) numberList.add(number);
      index = index + 1;
    }
    return numberList;
  }

  static PositionOfSequenceOutput getFirstPositionOfSequenceBase(String check, RegExp expr, List<String> sequenceList) {
    for (int i = 0; i < sequenceList.length; i++) {
      if (expr.hasMatch(sequenceList[i])) {
        int j = 0;
        while (!sequenceList[i].substring(j).startsWith(check)) {
          j++;
        }
        return PositionOfSequenceOutput(sequenceList[i], i + 1, j + 1);
      }
    }
    return PositionOfSequenceOutput('-1', 0, 0);
  }

  static PositionOfSequenceOutput getFirstPositionOfSequenceBaseFunction(String check, int maxIndex,
      BigInt Function(int) numberSequenceFunction) {
    BigInt number;
    int index = 0;
    String numberString = '';

    while (index <= maxIndex) {
      number = numberSequenceFunction(index);
      numberString = number.toString();
      if (numberString.contains(check)) {
        int j = 0;
        while (!numberString.substring(j).startsWith(check)) {
          j++;
        }
        return PositionOfSequenceOutput(numberString, index + 1, (j + 1));
      }
      index++;
    }
    return PositionOfSequenceOutput('-1', 0, 0);
  }

  static List<BigInt> calculateRangeBase(int start, int stop, List<String> sequenceList) {
    var numberList = <BigInt>[];

    for (int i = start; i <= stop; i++) {
      numberList.add(BigInt.parse(sequenceList[i]));
    }
    return numberList;
  }

  static List<BigInt> calculateRangeBaseFunction(int start, int stop, BigInt Function(int) numberSequenceFunction) {
    var numberList = <BigInt>[];

    for (int i = start; i <= stop; i++) {
      numberList.add(numberSequenceFunction(i));
    }
    return numberList;
  }
}