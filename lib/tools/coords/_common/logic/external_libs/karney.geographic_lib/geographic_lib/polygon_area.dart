/**
* \file PolygonArea.hpp
* \brief Header for GeographicLib::PolygonAreaT class
*
* Copyright (c) Charles Karney (2010-2023) <karney@alum.mit.edu> and licensed
* under the MIT/X11 License.  For more information, see
* https://geographiclib.sourceforge.io/
**********************************************************************/

// taken from official Java port https://github.com/geographiclib/geographiclib-java/blob/main/src/main/java/net/sf/geographiclib/PolygonArea.java

part of 'package:gc_wizard/tools/coords/_common/logic/external_libs/karney.geographic_lib/geographic_lib.dart';

 /**
  * \brief Polygon areas
  *
  * This computes the area of a polygon whose edges are geodesics using the
  * method given in Section 6 of
  * - C. F. F. Karney,
  *   <a href="https://doi.org/10.1007/s00190-012-0578-z">
  *   Algorithms for geodesics</a>,
  *   J. Geodesy <b>87</b>, 43--55 (2013);
  *   DOI: <a href="https://doi.org/10.1007/s00190-012-0578-z">
  *   10.1007/s00190-012-0578-z</a>;
  *   addenda:
  *   <a href="https://geographiclib.sourceforge.io/geod-addenda.html">
  *   geod-addenda.html</a>.
  *
  * Arbitrarily complex polygons are allowed.  In the case self-intersecting
  * of polygons the area is accumulated "algebraically", e.g., the areas of
  * the 2 loops in a figure-8 polygon will partially cancel.
  *
  * This class lets you add vertices and edges one at a time to the polygon.
  * The sequence must start with a vertex and thereafter vertices and edges
  * can be added in any order.  Any vertex after the first creates a new edge
  * which is the \e shortest geodesic from the previous vertex.  In some
  * cases there may be two or many such shortest geodesics and the area is
  * then not uniquely defined.  In this case, either add an intermediate
  * vertex or add the edge \e as an edge (by defining its direction and
  * length).
  *
  * The area and perimeter are accumulated at two times the standard floating
  * point precision to guard against the loss of accuracy with many-sided
  * polygons.  At any point you can ask for the perimeter and area so far.
  * There's an option to treat the points as defining a polyline instead of a
  * polygon; in that case, only the perimeter is computed.
  *
  * This is a templated class to allow it to be used with Geodesic,
  * GeodesicExact, and Rhumb.  GeographicLib::PolygonArea,
  * GeographicLib::PolygonAreaExact, and GeographicLib::PolygonAreaRhumb are
  * typedefs for these cases.
  *
  * For GeographicLib::PolygonArea (edges defined by Geodesic), an upper bound
  * on the error is about 0.1 m<sup>2</sup> per vertex.  However this is a
  * wildly pessimistic estimate in most cases.  A more realistic estimate of
  * the error is given by a test involving 10<sup>7</sup> approximately
  * regular polygons on the WGS84 ellipsoid.  The centers and the orientations
  * of the polygons were uniformly distributed, the number of vertices was
  * log-uniformly distributed in [3, 300], and the center to vertex distance
  * log-uniformly distributed in [0.1 m, 9000 km].
  *
  * Using double precision (the standard precision for GeographicLib), the
  * maximum error in the perimeter was 200 nm, and the maximum error in the
  * area was<pre>
  *     0.0013 m^2 for perimeter < 10 km
  *     0.0070 m^2 for perimeter < 100 km
  *     0.070 m^2 for perimeter < 1000 km
  *     0.11 m^2 for all perimeters
  * </pre>
  * The errors are given in terms of the perimeter, because it is expected
  * that the errors depend mainly on the number of edges and the edge lengths.
  *
  * Using long doubles (GEOGRPAHICLIB_PRECISION = 3), the maximum error in the
  * perimeter was 200 pm, and the maximum error in the area was<pre>
  *     0.7 mm^2 for perim < 10 km
  *     3.2 mm^2 for perimeter < 100 km
  *     21 mm^2 for perimeter < 1000 km
  *     45 mm^2 for all perimeters
  * </pre>
  *
  * @tparam GeodType the geodesic class to use.
  *
  * Example of use:
  * \include example-PolygonArea.cpp
  *
  * <a href="Planimeter.1.html">Planimeter</a> is a command-line utility
  * providing access to the functionality of PolygonAreaT.
  **********************************************************************/

class _PolygonArea {

  late _Geodesic _earth = _Geodesic(Ellipsoid.WGS84.a, Ellipsoid.WGS84.f);
  late double _area0;  // Full ellipsoid area
  late bool _polyline; // Assume polyline (don't close and skip area)
  late int _mask;
  late int _num;
  late int _crossings;
  late _Accumulator _areasum, _perimetersum;
  late double _lat0, _lon0, _lat1, _lon1;
  /**
   * Constructor for PolygonAreaT.
   *
   * @param[in] earth the Geodesic object to use for geodesic calculations.
   * @param[in] polyline if true that treat the points as defining a polyline
   *   instead of a polygon (default = false).
   **********************************************************************/
  _PolygonArea({required _Geodesic earth, bool polyline = false}) {
    _earth = earth;
    _area0 = _earth.ellipsoidArea();
    _polyline = polyline;
    _mask = _GeodesicMask.LATITUDE | _GeodesicMask.LONGITUDE | _GeodesicMask.DISTANCE |
       (_polyline ? _GeodesicMask.NONE : _GeodesicMask.AREA | _GeodesicMask.LONG_UNROLL);

    _perimetersum = _Accumulator(0);
    if (!_polyline) {
      _areasum = _Accumulator(0);
    }

    _Clear();
  }

  /**
   * Clear PolygonAreaT, allowing a new polygon to be started.
   **********************************************************************/
  void _Clear() {
   _num = 0;
   _crossings = 0;
   _perimetersum._Set(0);
   if (!_polyline) {
     _areasum._Set(0);
   }
   _lat0 = _lon0 = _lat1 = _lon1 = double.nan;
  }

  /**
   * Add a point to the polygon or polyline.
   *
   * @param[in] lat the latitude of the point (degrees).
   * @param[in] lon the longitude of the point (degrees).
   *
   * \e lat should be in the range [&minus;90&deg;, 90&deg;].
   **********************************************************************/
  void _AddPoint(double lat, double lon) {
    if (_num == 0) {
      _lat0 = _lat1 = lat;
      _lon0 = _lon1 = lon;
    } else {
      var geodesicData = _earth.inverse(_lat1, _lon1, lat, lon, outmask: _mask);
      _perimetersum._Add(geodesicData.s12);
      if (!_polyline) {
        _areasum._Add(geodesicData.S12);
        _crossings += _transit(_lon1, lon);
      }
      _lat1 = lat; _lon1 = lon;
    }
    ++_num;
  }

  /**
   * Add an edge to the polygon or polyline.
   * <p>
   * @param azi azimuth at current point (degrees).
   * @param s distance from current point to next point (meters).
   * <p>
   * This does nothing if no points have been added yet.  Use
   * PolygonArea.CurrentPoint to determine the position of the new vertex.
   **********************************************************************/
  void _AddEdge(double azi, double s) {
    if (_num > 0) {             // Do nothing if _num is zero
      GeodesicData g = _earth.direct(_lat1, _lon1, azi, false, s, outmask: _mask);
      _perimetersum._Add(g.s12);
      if (!_polyline) {
        _areasum._Add(g.S12);
        _crossings += _transitdirect(_lon1, g.lon2);
      }
      _lat1 = g.lat2; _lon1 = g.lon2;
      ++_num;
    }
  }

  int _transit(double lon1, double lon2) {
    // Return 1 or -1 if crossing prime meridian in east or west direction.
    // Otherwise return zero.  longitude = +/-0 considered to be positive.
    // This is (should be?) compatible with transitdirect which computes
    // exactly the parity of
    //   int(floor((lon1 + lon12) / 360)) - int(floor(lon1 / 360)))
    double lon12 = _GeoMath.AngDiff(lon1, lon2);
    lon1 = _GeoMath.AngNormalize(lon1);
    lon2 = _GeoMath.AngNormalize(lon2);
    // N.B. lon12 == 0 gives cross = 0
    return
    // edge case lon1 = 180, lon2 = 360->0, lon12 = 180 to give 1
    lon12 > 0 && ((lon1 < 0 && lon2 >= 0) ||
    // lon12 > 0 && lon1 > 0 && lon2 == 0 implies lon1 == 180
    (lon1 > 0 && lon2 == 0)) ? 1 :
    // non edge case lon1 = -180, lon2 = -360->-0, lon12 = -180
    (lon12 < 0 && lon1 >= 0 && lon2 < 0 ? -1 : 0);
    // This was the old method (treating +/- 0 as negative).  However, with the
    // new scheme for handling longitude differences this fails on:
    // lon1 = -180, lon2 = -360->-0, lon12 = -180 gives 0 not -1.
    //    return
    //      lon1 <= 0 && lon2 > 0 && lon12 > 0 ? 1 :
    //      (lon2 <= 0 && lon1 > 0 && lon12 < 0 ? -1 : 0);
  }

  // an alternate version of transit to deal with longitudes in the direct
  // problem.
  int _transitdirect(double lon1, double lon2) {
    // We want to compute exactly
    //   int(floor(lon2 / 360)) - int(floor(lon1 / 360))
    lon1 = ieeeRemainder(lon1, 720.0).toDouble();
    lon2 = ieeeRemainder(lon2, 720.0).toDouble();
    return ( (lon2 >= 0 && lon2 < 360 ? 0 : 1) -
        (lon1 >= 0 && lon1 < 360 ? 0 : 1) );
  }

  /**
   * Return the results so far.
   *
   * @param[in] reverse if true then clockwise (instead of counterclockwise)
   *   traversal counts as a positive area.
   * @param[in] sign if true then return a signed result for the area if
   *   the polygon is traversed in the "wrong" direction instead of returning
   *   the area for the rest of the earth.
   * @param[out] perimeter the perimeter of the polygon or length of the
   *   polyline (meters).
   * @param[out] area the area of the polygon (meters<sup>2</sup>); only set
   *   if \e polyline is false in the constructor.
   * @return the number of points.
   *
   * More points can be added to the polygon after this call.
   **********************************************************************/
  PolygonResult _Compute({bool reverse = false, bool sign = true}) {
    double perimeter = 0.0;
    double area = 0.0;

    if (_num < 2) {
      return PolygonResult(_num, perimeter, area);
    }
    if (_polyline) {
      perimeter = _perimetersum._Sum();
      return PolygonResult(_num, perimeter, area);
    }
    var g = _earth.inverse(_lat1, _lon1, _lat0, _lon0, outmask: _mask);
    _Accumulator tempsum = _Accumulator.fromAccumulator(_areasum);
    tempsum._Add(g.S12);

    return PolygonResult(_num, _perimetersum._Sum(y: g.s12),
        _AreaReduceA(tempsum, _area0, _crossings + _transit(_lon1, _lon0), reverse, sign));
  }

  // reduce Accumulator area to allowed range
  static double _AreaReduceA(_Accumulator area, double area0, int crossings, bool reverse, bool sign) {
    area._Remainder(area0);
    if ((crossings & 1) != 0) {
      area._Add((area._Sum() < 0 ? 1 : -1) * area0/2);
    }
    // area is with the clockwise sense.  If !reverse convert to
    // counter-clockwise convention.
    if (!reverse) {
      area._Negate();
    }
    // If sign put area in (-area0/2, area0/2], else put area in [0, area0)
    if (sign) {
      if (area._Sum() > area0/2) {
        area._Add(-area0);
      } else if (area._Sum() <= -area0/2) {
        area._Add(area0);
      }
    } else {
      if (area._Sum() >= area0) {
        area._Add(-area0);
      } else if (area._Sum() < 0) {
        area._Add(area0);
      }
    }
    return 0 + area._Sum();
  }
}

/**
 * A container for the results from PolygonArea.
 **********************************************************************/
class PolygonResult {
  /**
   * The number of vertices in the polygon
   **********************************************************************/
  int num;
  /**
   * The perimeter of the polygon or the length of the polyline (meters).
   **********************************************************************/
  double perimeter;
  /**
   * The area of the polygon (meters<sup>2</sup>).
   **********************************************************************/
  double area;
  /**
   * Constructor
   * <p>
   * @param num the number of vertices in the polygon.
   * @param perimeter the perimeter of the polygon or the length of the
   *   polyline (meters).
   * @param area the area of the polygon (meters<sup>2</sup>).
   **********************************************************************/
  PolygonResult(this.num, this.perimeter, this.area);
}