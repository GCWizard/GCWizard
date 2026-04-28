/*
    Dart port of Java implementation of
    ======================
    GeographicLib
    ======================

 * Copyright (c) Charles Karney (2013-2021) <charles@karney.com> and licensed
 * under the MIT/X11 License.  For more information, see
 * https://geographiclib.sourceforge.io/
 * https://sourceforge.net/projects/geographiclib/
*/
part of 'package:gc_wizard/tools/coords/_common/logic/external_libs/karney.geographic_lib/geographic_lib.dart';

/*
 * The results of geodesic calculations.
 *
 * This is used to return the results for a geodesic between point 1
 * (<i>lat1</i>, <i>lon1</i>) and point 2 (<i>lat2</i>, <i>lon2</i>).  Fields
 * that have not been set will be filled with Double.NaN.  The returned
 * GeodesicData objects always include the parameters provided to {@link
 * Geodesic#Direct(double, double, double, double) Geodesic.Direct} and {@link
 * Geodesic#Inverse(double, double, double, double) Geodesic.Inverse} and it
 * always includes the field <i>a12</i>.
*/
class GeodesicData {
  /*
   * latitude of point 1 (degrees).
   **********************************************************************/
  double lat1 = double.nan;
  /*
   * longitude of point 1 (degrees).
   **********************************************************************/
  double lon1 = double.nan;
  /*
   * azimuth at point 1 (degrees).
   **********************************************************************/
  double azi1 = double.nan;
  /*
   * latitude of point 2 (degrees).
   **********************************************************************/
  double lat2 = double.nan;
  /*
   * longitude of point 2 (degrees).
   **********************************************************************/
  double lon2 = double.nan;
  /*
   * azimuth at point 2 (degrees).
   **********************************************************************/
  double azi2 = double.nan;
  /*
   * distance between point 1 and point 2 (meters).
   **********************************************************************/
  double s12 = double.nan;
  /*
   * arc length on the auxiliary sphere between point 1 and point 2
   *   (degrees).
   **********************************************************************/
  double a12 = double.nan;
  /*
   * reduced length of geodesic (meters).
   **********************************************************************/
  double m12 = double.nan;
  /*
   * geodesic scale of point 2 relative to point 1 (dimensionless).
   **********************************************************************/
  double M12 = double.nan;
  /*
   * geodesic scale of point 1 relative to point 2 (dimensionless).
   **********************************************************************/
  double M21 = double.nan;
  /*
   * area under the geodesic (meters<sup>2</sup>).
   **********************************************************************/
  double S12 = double.nan;
}
