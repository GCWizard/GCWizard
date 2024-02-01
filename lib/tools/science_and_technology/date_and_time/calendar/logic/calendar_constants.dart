enum CalendarSystem {
  JULIANDATE,
  JULIANCALENDAR,
  MODIFIEDJULIANDATE,
  GREGORIANCALENDAR,
  ISLAMICCALENDAR,
  PERSIANYAZDEGARDCALENDAR,
  HEBREWCALENDAR,
  COPTICCALENDAR,
  POTRZEBIECALENDAR,
  MAYACALENDAR,
  EXCELTIMESTAMP,
  UNIXTIMESTAMP,
}

const JD_UNIX_START = 2440587.5;

const JD_EXCEL_START = 2415020.5;

const Map<CalendarSystem, Map<int, String>> MONTH_NAMES = {
  CalendarSystem.ISLAMICCALENDAR: MONTH_ISLAMIC,
  CalendarSystem.PERSIANYAZDEGARDCALENDAR: MONTH_PERSIAN,
  CalendarSystem.HEBREWCALENDAR: MONTH_HEBREW,
  CalendarSystem.COPTICCALENDAR: MONTH_COPTIC,
  CalendarSystem.POTRZEBIECALENDAR: MONTH_POTRZEBIE,
};

const Map<int, String> MONTH_ISLAMIC = {
  1: 'Muharram',
  2: 'Safar',
  3: 'Rabi al-Awwal',
  4: 'Rabi al-Akhir',
  5: 'Djumada l-Ula',
  6: 'Djumada t-Akhira',
  7: 'Radjab',
  8: 'Shaban',
  9: 'Ramadan',
  10: 'Shawwal',
  11: 'Dhu l-Kada',
  12: 'Dhu l-Hidjdja'
};
const Map<int, String> MONTH_PERSIAN = {
  1: 'Farwardin',
  2: 'Ordibehescht',
  3: 'Chordād',
  4: 'Tir',
  5: 'Mordād',
  6: 'Schahriwar',
  7: 'Mehr',
  8: 'Ābān',
  9: 'Āzar',
  10: 'Déi',
  11: 'Bahman',
  12: 'Esfand'
};
const Map<int, String> MONTH_COPTIC = {
  1: 'Thoth',
  2: 'Paophi',
  3: 'Athyr',
  4: 'Cohiac',
  5: 'Tybi',
  6: 'Mesir',
  7: 'Phamenoth',
  8: 'Pharmouthi',
  9: 'Pachons',
  10: 'Payni',
  11: 'Epiphi',
  12: 'Mesori'
};
const Map<int, String> MONTH_HEBREW = {
  1: 'Tishri',
  2: 'Heshvan',
  3: 'Kislev',
  4: 'Tevet',
  5: 'Shevat',
  6: 'Adar beth',
  7: 'Adar aleph',
  8: 'Nisan',
  9: 'Iyar',
  10: 'Sivan',
  11: 'Tammuz',
  12: 'Av',
  13: 'Elul'
};
const Map<int, String> MONTH_POTRZEBIE = {
  1: 'Tales',
  2: 'Calculated',
  3: 'To',
  4: 'Drive',
  5: 'You',
  6: 'Humor',
  7: 'In',
  8: 'A',
  9: 'Jugular',
  10: 'Vein',
};
const Map<int, String> WEEKDAY_ISLAMIC = {
  1: 'yaum al-ahad',
  2: 'yaum al-ithnayna',
  3: 'yaum ath-thalatha',
  4: 'yaum al-arba`a',
  5: 'yaum al-chamis',
  6: 'yaum al-dschum`a',
  7: 'yaum as-sabt'
};

const Map<int, String> WEEKDAY_PERSIAN = {
  1: 'Schambé',
  2: 'yek – Schambé',
  3: 'do – Schambé',
  4: 'ße – Schambé',
  5: 'tschahár – Schambé',
  6: 'pansch – Schambé',
  7: 'Djomé'
};

const Map<int, String> WEEKDAY_HEBREW = {
  1: 'Jom Rischon',
  2: 'Jom Scheni',
  3: 'Jom Schlischi',
  4: 'Jom Revi’i',
  5: 'Jom Chamischi',
  6: 'Jom Schischi',
  7: 'Schabbat'
};
