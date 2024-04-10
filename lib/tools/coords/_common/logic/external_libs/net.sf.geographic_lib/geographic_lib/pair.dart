/***********************************************************************
    Dart port of Java implementation of
    ======================
    GeographicLib
    ======================

 * Copyright (c) Charles Karney (2013-2021) <charles@karney.com> and licensed
 * under the MIT/X11 License.  For more information, see
 * https://geographiclib.sourceforge.io/
 * https://sourceforge.net/projects/geographiclib/

 **********************************************************************/

part of 'package:gc_wizard/tools/coords/_common/logic/external_libs/net.sf.geographic_lib/geographic_lib.dart';

/*
 * A pair of double precision numbers.
 * <p>
 * This duplicates the C++ class {@code std::pair<double, double>}.
 **********************************************************************/
class _Pair {
  /*
   * The first member of the pair.
   **********************************************************************/
  double first;
  /*
   * The second member of the pair.
   **********************************************************************/
  double second;

  _Pair([this.first = double.nan, this.second = double.nan]);
}
