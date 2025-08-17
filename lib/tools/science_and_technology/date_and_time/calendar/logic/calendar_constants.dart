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
  0: 'Muharram',
  1: 'Safar',
  2: 'Rabi al-Awwal',
  3: 'Rabi al-Akhir',
  4: 'Djumada l-Ula',
  5: 'Djumada t-Akhira',
  6: 'Radjab',
  7: 'Shaban',
  8: 'Ramadan',
  9: 'Shawwal',
  10: 'Dhu l-Kada',
  11: 'Dhu l-Hidjdja'
};

const Map<int, String> MONTH_PERSIAN = {
  0: 'Farwardin',
  1: 'Ordibehescht',
  2: 'Chordād',
  3: 'Tir',
  4: 'Mordād',
  5: 'Schahriwar',
  6: 'Mehr',
  7: 'Ābān',
  8: 'Āzar',
  9: 'Déi',
  10: 'Bahman',
  11: 'Esfand'
};

const Map<int, String> MONTH_COPTIC = {
  0: 'Thoth',
  1: 'Paophi',
  2: 'Athyr',
  3: 'Cohiac',
  4: 'Tybi',
  5: 'Mesir',
  6: 'Phamenoth',
  7: 'Pharmouthi',
  8: 'Pachons',
  9: 'Payni',
  10: 'Epiphi',
  11: 'Mesori'
};

const Map<int, String> MONTH_HEBREW = {
  0: 'Tishri',
  1: 'Heshvan',
  2: 'Kislev',
  3: 'Tevet',
  4: 'Shevat',
  5: 'Adar beth',
  6: 'Adar aleph',
  7: 'Nisan',
  8: 'Iyar',
  9: 'Sivan',
  10: 'Tammuz',
  11: 'Av',
  12: 'Elul'
};

const Map<int, String> MONTH_POTRZEBIE = {
  0: 'Tales',
  1: 'Calculated',
  2: 'To',
  3: 'Drive',
  4: 'You',
  5: 'Humor',
  6: 'In',
  7: 'A',
  8: 'Jugular',
  9: 'Vein',
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
