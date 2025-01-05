// Dart port of s2-geometry-library-java.S2Projections

/*
 * Copyright 2005 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

part of 'package:gc_wizard/tools/coords/_common/formats/s2cells_hilbert/logic/s2cells_hilbert.dart';

/**
 * This class specifies the coordinate systems and transforms used to project points from the sphere
 * to the unit cube to an {@link S2CellId}.
 *
 * <p>In the process of converting a latitude-longitude pair to a 64-bit cell id, the following
 * coordinate systems are used:
 *
 * <ul>
 *   <li>(id): An S2CellId is a 64-bit encoding of a face and a Hilbert curve position on that face.
 *       The Hilbert curve position implicitly encodes both the position of a cell and its
 *       subdivision level (see s2cellid.h).
 *   <li>(face, i, j): Leaf-cell coordinates. "i" and "j" are integers in the range [0,(2**30)-1]
 *       that identify a particular leaf cell on the given face. The (i, j) coordinate system is
 *       right-handed on each face, and the faces are oriented such that Hilbert curves connect
 *       continuously from one face to the next.
 *   <li>(face, s, t): Cell-space coordinates. "s" and "t" are real numbers in the range [0,1] that
 *       identify a point on the given face. For example, the point (s, t) = (0.5, 0.5) corresponds
 *       to the center of the top-level face cell. This point is also a vertex of exactly four cells
 *       at each subdivision level greater than zero.
 *   <li>(face, si, ti): Discrete cell-space coordinates. These are obtained by multiplying "s" and
 *       "t" by 2**31 and rounding to the nearest unsigned integer. Discrete coordinates lie in the
 *       range [0,2**31]. This coordinate system can represent the edge and center positions of all
 *       cells with no loss of precision (including non-leaf cells). In binary, each coordinate of a
 *       level-k cell center ends with a 1 followed by (30 - k) 0s. The coordinates of its edges end
 *       with (at least) (31 - k) 0s.
 *   <li>(face, u, v): Cube-space coordinates. To make the cells at each level more uniform in size
 *       after they are projected onto the sphere, we apply a nonlinear transformation of the form
 *       u=f(s), v=f(t). The (u, v) coordinates after this transformation give the actual
 *       coordinates on the cube face (modulo some 90 degree rotations) before it is projected onto
 *       the unit sphere.
 *   <li>(face, u, v, w): Per-face coordinate frame. This is an extension of the (face, u, v)
 *       cube-space coordinates that adds a third axis "w" in the direction of the face normal. It
 *       is always a right-handed 3D coordinate system. Cube-space coordinates can be converted to
 *       this frame by setting w=1, while (u,v,w) coordinates can be projected onto the cube face by
 *       dividing by w, i.e. (face, u/w, v/w).
 *   <li>(x, y, z): Direction vector (S2Point). Direction vectors are not necessarily unit length,
 *       and are often chosen to be points on the biunit cube [-1,+1]x[-1,+1]x[-1,+1]. They can be
 *       normalized to obtain the corresponding point on the unit sphere.
 *   <li>(lat, lng): Latitude and longitude (S2LatLng). Latitudes must be between -90 and 90 degrees
 *       inclusive, and longitudes must be between -180 and 180 degrees inclusive.
 * </ul>
 *
 * <p>Note that the (i, j), (s, t), (si, ti), and (u, v) coordinate systems are right-handed on all
 * six faces.
 *
 * <p>We have implemented three different projections from cell-space (s,t) to cube-space (u,v):
 * {S2Projections#S2_LINEAR_PROJECTION}, {@link S2Projections#S2_TAN_PROJECTION}, and {@link
 * S2Projections#S2_QUADRATIC_PROJECTION}. The default is in {@link S2Projections#PROJ}, and uses
 * the quadratic projection since it has the best overall behavior.
 *
 * <p>Here is a table comparing the cell uniformity using each projection. "Area Ratio" is the
 * maximum ratio over all subdivision levels of the largest cell area to the smallest cell area at
 * that level, "Edge Ratio" is the maximum ratio of the longest edge of any cell to the shortest
 * edge of any cell at the same level, and "Diag Ratio" is the ratio of the longest diagonal of any
 * cell to the shortest diagonal of any cell at the same level. "ToPoint" and "FromPoint" are the
 * times in microseconds required to convert cell IDs to and from points (unit vectors)
 * respectively. "ToPointRaw" is the time to convert to a non-unit-length vector, which is all that
 * is needed for some purposes.
 *
 * <table>
 * <caption>Cell Metrics</caption>
 * <tr>
 * <th>Projection</th>
 * <th>Area Ratio</th>
 * <th>Edge Ratio</th>
 * <th>Diag Ratio</th>
 * <th>ToPointRaw (microseconds)</th>
 * <th>ToPoint (microseconds)</th>
 * <th>FromPoint (microseconds)</th>
 * </tr>
 * <tr>
 * <td>Linear</td>
 * <td>5.200</td>
 * <td>2.117</td>
 * <td>2.959</td>
 * <td>0.020</td>
 * <td>0.087</td>
 * <td>0.085</td>
 * </tr>
 * <tr>
 * <td>Tangent</td>
 * <td>1.414</td>
 * <td>1.414</td>
 * <td>1.704</td>
 * <td>0.237</td>
 * <td>0.299</td>
 * <td>0.258</td>
 * </tr>
 * <tr>
 * <td>Quadratic</td>
 * <td>2.082</td>
 * <td>1.802</td>
 * <td>1.932</td>
 * <td>0.033</td>
 * <td>0.096</td>
 * <td>0.108</td>
 * </tr>
 * </table>
 *
 * <p>The worst-case cell aspect ratios are about the same with all three projections. The maximum
 * ratio of the longest edge to the shortest edge within the same cell is about 1.4 and the maximum
 * ratio of the diagonals within the same cell is about 1.7.
 *
 * <p>This data was produced using {@code S2CellTest} and {@code S2CellIdTest}.
 *
 * @author eengle@google.com (Eric Engle) ported from util/geometry
 * @author ericv@google.com (Eric Veach) original author
 */
abstract class _S2Projections {
  /**
   * The maximum value of an si- or ti-coordinate. The range of valid (si,ti) values is
   * [0..MAX_SiTi].
   */
  static Int64 MAX_SITI = Int64.ONE << (_S2CellId.MAX_LEVEL + 1);

  /** Minimum area of a cell at level k. */
  late final _Metric minArea;

  /** Maximum area of a cell at level k. */
  late final _Metric maxArea;

  /** Average area of a cell at level k. */
  late final _Metric avgArea;

  /**
   * Minimum angular separation between opposite edges of a cell at level k. Each cell is bounded by
   * four planes passing through its four edges and the center of the sphere. The angle span metrics
   * relate to the angle between each pair of opposite bounding planes, or equivalently, between the
   * planes corresponding to two different s-values or two different t-values.
   */
  late final _Metric minAngleSpan;

  /** Maximum angular separation between opposite edges of a cell at level k. */
  late final _Metric maxAngleSpan;

  /** Average angular separation between opposite edges of a cell at level k. */
  late final _Metric avgAngleSpan;

  /**
   * Minimum perpendicular angular separation between opposite edges of a cell at level k.
   *
   * <p>The width of a geometric figure is defined as the distance between two parallel bounding
   * lines in a given direction. For cells, the minimum width is always attained between two
   * opposite edges, and the maximum width is attained between two opposite vertices. However, for
   * our purposes we redefine the width of a cell as the perpendicular distance between a pair of
   * opposite edges. A cell therefore has two widths, one in each direction. The minimum width
   * according to this definition agrees with the classic geometric one, but the maximum width is
   * different. (The maximum geometric width corresponds to {@link #maxDiag}.)
   *
   * <p>This is useful for bounding the minimum or maximum distance from a point on one edge of a
   * cell to the closest point on the opposite edge. For example, this is useful when "growing"
   * regions by a fixed distance.
   */
  late final _Metric minWidth;

  /** Maximum perpendicular angular separation between opposite edges of a cell at level k. */
  late final _Metric maxWidth;

  /** Average perpendicular angular separation between opposite edges of a cell at level k. */
  late final _Metric avgWidth;

  /**
   * Minimum angular length of any cell edge at level k. The edge length metrics can also be used to
   * bound the minimum, maximum, or average distance from the center of one cell to the center of
   * one of its edge neighbors. In particular, it can be used to bound the distance between adjacent
   * cell centers along the space-filling Hilbert curve for cells at any given level.
   */
  late final _Metric minEdge;

  /** Maximum angular length of any cell edge at level k. */
  late final _Metric maxEdge;

  /** Average angular length of any cell edge at level k. */
  late final _Metric avgEdge;

  /** Minimum diagonal size of cells at level k. */
  late final _Metric minDiag;

  /**
   * Maximum diagonal size of cells at level k. The maximum diagonal also happens to be the maximum
   * diameter of any cell, and also the maximum geometric width. So for example, the distance from
   * an arbitrary point to the closest cell center at a given level is at most half the maximum
   * diagonal length.
   */
  late final _Metric maxDiag;

  /** Average diagonal size of cells at level k. */
  late final _Metric avgDiag;

  /**
   * Maximum edge aspect ratio over all cells at any level, where the edge aspect ratio of a cell is
   * defined as the ratio of its longest edge length to its shortest edge length.
   */
  late final double maxEdgeAspect;

  /**
   * This is the maximum diagonal aspect ratio over all cells at any level, where the diagonal
   * aspect ratio of a cell is defined as the ratio of its longest diagonal length to its shortest
   * diagonal length.
   */
  final double maxDiagAspect = sqrt(3); // 1.732

  _S2Projections(double minAreaDeriv,
      double maxAreaDeriv,
      double minAngleSpanDeriv,
      double maxAngleSpanDeriv,
      double minWidthDeriv,
      double avgWidthDeriv,
      double minEdgeDeriv,
      double avgEdgeDeriv,
      double minDiagDeriv,
      double maxDiagDeriv,
      double avgDiagDeriv,
      this.maxEdgeAspect){
    minArea = _Metric(2, minAreaDeriv);
    maxArea = _Metric(2, maxAreaDeriv);
    avgArea = _Metric(2, 4 * pi / 6); // ~2.094
    minAngleSpan = _Metric(1, minAngleSpanDeriv);
    maxAngleSpan = _Metric(1, maxAngleSpanDeriv);
    avgAngleSpan = _Metric(1, pi / 2); // ~1.571
    minWidth = _Metric(1, minWidthDeriv);
    maxWidth = _Metric(1, maxAngleSpanDeriv);
    avgWidth = _Metric(1, avgWidthDeriv);
    minEdge = _Metric(1, minEdgeDeriv);
    maxEdge = _Metric(1, maxAngleSpanDeriv);
    avgEdge = _Metric(1, avgEdgeDeriv);
    minDiag = _Metric(1, minDiagDeriv);
    maxDiag = _Metric(1, maxDiagDeriv);
    avgDiag = _Metric(1, avgDiagDeriv);
  }

  /**
   * Convert an s- or t-value to the corresponding u- or v-value. This is a non-linear
   * transformation from [0,1] to [-1,1] that attempts to make the cell sizes more uniform.
   */
  double stToUV(double s);

  /**
   * Returns the i- or j-index of the leaf cell containing the given s- or t-value. If the argument
   * is outside the range spanned by valid leaf cell indices, return the index of the closest valid
   * leaf cell (i.e., return values are clamped to the range of valid leaf cell indices).
   */
  static int stToIj(double s) {
    return max(0, min(_S2CellId.MAX_SIZE - 1, (_S2CellId.MAX_SIZE * s - 0.5).round()));
  }

  /** Returns the s- or t-value corresponding to the given si- or ti-value. */
  static double siTiToSt(Int64 si) {
    // assert si >= 0 && si <= MAX_SITI;
    return (1.0 / MAX_SITI.toDouble()) * si.toDouble();
  }

  /**
   * The inverse of {@link #stToUV(double)}. Note that it is not always true that {@code
   * uvToST(stToUV(x)) == x} due to numerical errors.
   */
  double uvToST(double u);

  /**
   * Convert (face, u, v) coordinates to a direction vector (not necessarily unit length).
   *
   * <p>Requires that the face is between 0 and 5, inclusive.
   */
  static _S2Point faceUvToXyz(int face, double u, double v) {
    _XyzTransform t = faceToXyzTransform(face);
    return _S2Point(t.uvToX(u, v), t.uvToY(u, v), t.uvToZ(u, v));
  }

  /** Returns the {@link XyzTransform} for the specified face. */
  static _XyzTransform faceToXyzTransform(int face) {
  // We map illegal face indices to the largest face index to preserve legacy behavior, i.e., we
  // do not (yet) want to throw an index out of bounds exception. Note that S2CellId.face() is
  // guaranteed to return a non-negative face index even for invalid S2 cells, so it is sufficient
  // to just map all face indices greater than 5 to a face index of 5.
  //
  return XYZ_TRANSFORMS(min(5, face));
  }

  /**
   * The transforms to convert (x, y, z) coordinates to u and v coordinates on a specific face,
   * indexed by face.
   */
  static _UvTransform UV_TRANSFORMS (int index) {
    switch (index) {
      case 0: return _UvTransform0();
      case 1: return _UvTransform1();
      case 2: return _UvTransform2();
      case 3: return _UvTransform3();
      case 4: return _UvTransform4();
      case 5: return _UvTransform5();
      default: return _UvTransform0();
    }
  }

  /**
   * The transforms to convert (x, y, z) coordinates to u and v coordinates on a specific face,
   * indexed by face.
   */
  static _XyzTransform XYZ_TRANSFORMS  (int index) {
    switch (index) {
      case 0: return _XyzTransform0();
      case 1: return _XyzTransform1();
      case 2: return _XyzTransform2();
      case 3: return _XyzTransform3();
      case 4: return _XyzTransform4();
      case 5: return _XyzTransform5();
      default: return _XyzTransform0();
    }
  }

  /** Returns the {@link UvTransform} for the specified face. */
  static _UvTransform faceToUvTransform(int face) {
    return UV_TRANSFORMS(face);
  }

  /** Convert (face, si, ti) coordinates to a direction vector (not necessarily unit length.) */
  _S2Point faceSiTiToXyz(int face, Int64 si, Int64 ti) {
    double u = stToUV(siTiToSt(si));
    double v = stToUV(siTiToSt(ti));
    return faceUvToXyz(face, u, v);
  }

  /**
   * Returns the face containing the given direction vector (for points on the boundary between
   * faces, the result is arbitrary but repeatable.)
   */
  static int xyzToFace(_S2Point p) {
    return _xyzToFaceCoords(p.x, p.y, p.z);
  }

  /**
   * As {@link #xyzToFace(S2Point)}, but accepts the coordinates as primitive doubles instead.
   * Useful when the caller has coordinates and doesn't want to allocate an S2Point.
   */
  static int _xyzToFaceCoords(double x, double y, double z) {
    switch (_S2Point.largestAbsComponent(x, y, z)) {
      case 0:
      return (x < 0) ? 3 : 0;
      case 1:
      return (y < 0) ? 4 : 1;
      default:
      return (z < 0) ? 5 : 2;
    }
  }

  static _S2Projections PROJ = _S2_QUADRATIC_PROJECTION();
}

void _setS2Projection(_S2Projections proj) {
  /** The default transformation between ST and UV coordinates. */
  _S2Projections.PROJ = proj;
}

/**
 * A transform from 3D cartesian coordinates to the 2D coordinates of a face. For (x, y, z)
 * coordinates within the face, the resulting UV coordinates should each lie in the inclusive
 * range [-1,1], with the center of the face along that axis at 0.
 */
abstract class _UvTransform {
  /**
   * Returns the 'u' coordinate of the [u, v] point projected onto a cube face from the given [x,
   * y, z] position.
   */
  double xyzToU(double x, double y, double z);

  /**
   * Returns the 'v' coordinate of the [u, v] point projected onto a cube face from the given [x,
   * y, z] position.
   */
  double xyzToV(double x, double y, double z);
}

/**
 * The transforms to convert (x, y, z) coordinates to u and v coordinates on a specific face,
 * indexed by face.
 */
class _UvTransform0 extends _UvTransform {
  @override
  double xyzToU(double x, double y, double z) {
    return y / x;
  }
  
  @override
  double xyzToV(double x, double y, double z) {
    return z / x;
  }
}
class _UvTransform1 extends _UvTransform {
  @override
  double xyzToU(double x, double y, double z) {
    return -x / y;
  }
  
  @override
  double xyzToV(double x, double y, double z) {
    return z / y;
  }
}
class _UvTransform2 extends _UvTransform {
  @override
  double xyzToU(double x, double y, double z) {
    return -x / z;
  }

  @override
  double xyzToV(double x, double y, double z) {
    return -y / z;
  }
}
class _UvTransform3 extends _UvTransform {
  @override
  double xyzToU(double x, double y, double z) {
    return z / x;
  }

  @override
  double xyzToV(double x, double y, double z) {
    return y / x;
  }
}
class _UvTransform4 extends _UvTransform {
  @override
  double xyzToU(double x, double y, double z) {
    return z / y;
  }

  @override
  double xyzToV(double x, double y, double z) {
    return -x / y;
  }
}
class _UvTransform5 extends _UvTransform {
  @override
  double xyzToU(double x, double y, double z) {
    return -y / z;
  }
  @override
  double xyzToV(double x, double y, double z) {
    return -x / z;
  }
}

/**
 * A transform from 2D cartesian coordinates of a face to 3D directional vectors. The resulting
 * vectors are not necessarily of unit length.
 */
abstract class _XyzTransform {
  /**
   * Returns the 'x' coordinate for the [x, y, z] point on the unit sphere that projects to the
   * given [u, v] point on a cube face.
   */
  double uvToX(double u, double v);

  /**
   * Returns the 'y' coordinate for the [x, y, z] point on the unit sphere that projects to the
   * given [u, v] point on a cube face.
   */
  double uvToY(double u, double v);

  /**
   * Returns the 'z' coordinate for the [x, y, z] point on the unit sphere that projects to the
   * given [u, v] point on a cube face.
   */
  double uvToZ(double u, double v);
}

/**
 * The transforms to convert (u, v) coordinates on a specific face to x-, y-, and z- coordinates,
 * indexed by face.
 */
class _XyzTransform0 extends _XyzTransform {
  @override
  double uvToX(double u, double v) {
    return 1;
  }

  @override
  double uvToY(double u, double v) {
    return u;
  }

  @override
  double uvToZ(double u, double v) {
    return v;
  }
}
class _XyzTransform1 extends _XyzTransform {
  @override
  double uvToX(double u, double v) {
    return -u;
  }

  @override
  double uvToY(double u, double v) {
    return 1;
  }

  @override
  double uvToZ(double u, double v) {
    return v;
  }
}
class _XyzTransform2 extends _XyzTransform {
  @override
  double uvToX(double u, double v) {
    return -u;
  }

  @override
  double uvToY(double u, double v) {
    return -v;
  }

  @override
  double uvToZ(double u, double v) {
    return 1;
  }
}
class _XyzTransform3 extends _XyzTransform {
  @override
  double uvToX(double u, double v) {
    return -1;
  }

  @override
  double uvToY(double u, double v) {
    return -v;
  }

  @override
  double uvToZ(double u, double v) {
    return -u;
  }
}
class _XyzTransform4 extends _XyzTransform {
  @override
  double uvToX(double u, double v) {
    return v;
  }

  @override
  double uvToY(double u, double v) {
    return -1;
  }

  @override
  double uvToZ(double u, double v) {
    return -u;
  }
}
class _XyzTransform5 extends _XyzTransform {
  @override
  double uvToX(double u, double v) {
    return v;
  }

  @override
  double uvToY(double u, double v) {
    return u;
  }

  @override
  double uvToZ(double u, double v) {
    return -1;
  }
}
/**
 * This is the fastest transformation, but also produces the least uniform cell sizes. Cell areas
 * vary by a factor of about 5.2, with the largest cells at the center of each face and the
 * smallest cells in the corners.
 */
class _S2_LINEAR_PROJECTION extends _S2Projections {

  _S2_LINEAR_PROJECTION():super(
      4 / (3 * sqrt(3)),    // minArea 0.770
      4,                    // maxArea 4.000
      1.0,                  // minAngleSpan 1.000
      2,                    // maxAngleSpan 2.000
      sqrt(2.0 / 3),        // minWidth 0.816
      1.411459345844456965, // avgWidth 1.411
      2 * sqrt(2) / 3,      // minEdge 0.943
      1.440034192955603643, // avgEdge 1.440
      2 * sqrt(2) / 3,      // minDiag 0.943
      2 * sqrt(2),          // maxDiag 2.828
      2.031817866418812674, // avgDiag 2.032
      sqrt(2)               // maxEdgeAspect 1.443
  );

  @override
  double stToUV(double s) {
    return 2 * s - 1;
  }

  @override
  double uvToST(double u) {
    return 0.5 * (u + 1);
  }
}
/**
 * Transforming the coordinates via atan() makes the cell sizes more uniform. The areas vary by a
 * maximum ratio of 1.4 as opposed to a maximum ratio of 5.2. However, each call to atan() is
 * about as expensive as all of the other calculations combined when converting from points to
 * cell IDs, i.e. it reduces performance by a factor of 3.
 */
class _S2_TAN_PROJECTION extends _S2Projections {

  _S2_TAN_PROJECTION():super(
      (pi * pi) / (4 * sqrt(2)), // minArea 1.745
      pi * pi / 4,               // maxArea 2.467
      pi / 2,                    // minAngleSpan 1.571
      pi / 2,                    // maxAngleSpan 1.571
      pi / (2 * sqrt(2)),        // minWidth 1.111
      1.437318638925160885,      // avgWidth 1.437
      pi / (2 * sqrt(2)),        // minEdge 1.111
      1.461667032546739266,      // avgEdge 1.462
      pi * sqrt(2) / 3,          // minDiag 1.481
      pi * sqrt(2.0 / 3),        // maxDiag 2.565
      2.063623197195635753,      // avgDiag 2.064
      sqrt(2)                    // maxEdgeAspect 1.443
  );

  @override
  double stToUV(double s) {
    // Unfortunately, tan(M_PI_4) is slightly less than 1.0. This isn't due to a flaw in the
    // implementation of tan(), it's because the derivative of tan(x) at x=pi/4 is 2, and it
    // happens that the two adjacent floating point numbers on either side of the infinite-
    // precision value of pi/4 have tangents that are slightly below and slightly above 1.0 when
    // rounded to the nearest double-precision result.
    s = tan(_S2.M_PI_2 * s - _S2.M_PI_4);
    return s + (1.0 / (Int64.ONE << 53).toDouble()) * s;
  }

  @override
  double uvToST(double u) {
    return (2 * _S2.M_1_PI) * (atan(u) + _S2.M_PI_4);
  }
}
/**
 * This is an approximation of the tangent projection that is much faster and produces cells that
 * are almost as uniform in size. It is about 3 times faster than the tangent projection for
 * converting cell IDs to points or vice versa. Cell areas vary by a maximum ratio of about 2.1.
 */
class _S2_QUADRATIC_PROJECTION extends _S2Projections {

  _S2_QUADRATIC_PROJECTION():super(
      8 * sqrt(2) / 9,        // minArea 1.257
      2.635799256963161491,   // maxArea 2.636
      4.0 / 3,                 // minAngleSpan 1.333
      1.704897179199218452,   // maxAngleSpan 1.705
      2 * sqrt(2) / 3,        // minWidth 0.943
      1.434523672886099389,   // avgWidth 1.435
      2 * sqrt(2) / 3,        // minEdge 0.943
      1.459213746386106062,   // avgEdge 1.459
      8 * sqrt(2) / 9,        // minDiag 1.257
      2.438654594434021032,   // maxDiag 2.439
      2.060422738998471683,   // avgDiag 2.060
      1.442615274452682920 // maxEdgeAspect 1.443
  );

  @override
  double stToUV(double s) {
    if (s >= 0.5) {
    return (1 / 3.0) * (4 * s * s - 1);
    } else {
    return (1 / 3.0) * (1 - 4 * (1 - s) * (1 - s));
    }
  }

  @override
  double uvToST(double u) {
    if (u >= 0) {
      return 0.5 * sqrt(1 + 3 * u);
    } else {
      return 1 - 0.5 * sqrt(1 - 3 * u);
    }
  }
}