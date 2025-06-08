import 'dart:core';
import 'dart:ui';

class BingoCall {
  final int number;
  final List<String> title;
  final String description;

  const BingoCall({
    required this.number,
    required this.title,
    required this.description,
  });
}

enum BINGOCALLS_LANGUAGES { DE, EN }

const Map<BINGOCALLS_LANGUAGES, String> BINGOCALLS_LANGUAGE_LIST = {
  BINGOCALLS_LANGUAGES.DE: "common_language_german",
  BINGOCALLS_LANGUAGES.EN: "common_language_english",
};

final Map<Locale, BINGOCALLS_LANGUAGES> SUPPORTED_SPELLING_LOCALES = {
  const Locale('de'): BINGOCALLS_LANGUAGES.DE,
  const Locale('en'): BINGOCALLS_LANGUAGES.EN,
};

const Map<BINGOCALLS_LANGUAGES, Map<String, BingoCall>> BINGO_CALLS = {
  BINGOCALLS_LANGUAGES.DE: BINGO_CALLS_DE,
  BINGOCALLS_LANGUAGES.EN: BINGO_CALLS_EN,
};

const Map<String, BingoCall> BINGO_CALLS_EN = {
  // https://blog.meccabingo.com/bingo-calls-complete-list/
  '1': BingoCall(
      number: 1,
      title: ['Kelly’s eye'],
      description:
          'This bingo saying could be a reference to Ned Kelly, one of Australia’s greatest folk heroes – but many think it’s just military slang.'),
  '2': BingoCall(
    number: 2,
    title: ['One little duck'],
    description: 'The number 2 looks just like a little duckling!',
  ),
  '3': BingoCall(
    number: 3,
    title: ['Cup of tea'],
    description:
        'Because the British are particularly fond of tea and purely because it rhymes. Put the kettle on then!',
  ),
  '4': BingoCall(
    number: 4,
    title: ['Knock at the door'],
    description: 'Who’s there?! This phrase rhymes with the number 4.',
  ),
  '5': BingoCall(
    number: 5,
    title: ['Man alive'],
    description: 'Another great bingo calling sheet rhyme.',
  ),
  '6': BingoCall(
    number: 6,
    title: ['Tom Mix', 'Half a dozen'],
    description:
        'Tom Mix was America’s first Western Star, appearing in 291 films. His legend lives on in this rhyming bingo call. A dozen is 12 and half of 12 is 6, which is the alternative bingo saying the caller could choose.',
  ),
  '7': BingoCall(
    number: 7,
    title: ['Lucky seven'],
    description:
        'The number 7 is considered lucky in many cultures. There are 7 days of the week, 7 colours of the rainbow and 7 notes on a musical scale.',
  ),
  '8': BingoCall(
    number: 8,
    title: ['Garden gate'],
    description:
        'This saying rhymes with the number 8, but there’s said to be something more about the history of this call. Legend has it that the ‘garden gate’ was a code for a secret meeting or drop off point.',
  ),
  '9': BingoCall(
    number: 9,
    title: ['Doctor’s orders'],
    description:
        'During World War II, Number 9 was the name of a pill given out by army doctors to solidiers who were a little bit poorly. This powerful laxative was said to clear the system of all ills!',
  ),
};

const Map<String, BingoCall> BINGO_CALLS_DE = {};

const BINGO_CALLS = {
  'common_language_english': BINGO_CALLS_EN,
  'common_language_german': BINGO_CALLS_DE,
};
