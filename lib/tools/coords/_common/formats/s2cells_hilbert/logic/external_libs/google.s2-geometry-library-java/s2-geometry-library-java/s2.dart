// Dart port of s2-geometry-library-java.S2

part of 'package:gc_wizard/tools/coords/_common/formats/s2cells_hilbert/logic/s2cells_hilbert.dart';

class _S2 {
  static const double M_PI = pi;
  static const double M_1_PI = 1.0 / pi;
  static const double M_PI_2 = pi / 2.0;
  static const double M_PI_4 = pi / 4.0;
  /** Inverse of the root of 2. */
  static final double M_SQRT1_2 = 1 / sqrt(2);

  static final double M_SQRT2 = sqrt(2);
  static const double M_E = e;

  /** The smallest floating-point value {@code x} such that {@code (1 + x != 1)}. */
  // static final double DBL_EPSILON;

  // Together these flags define a cell orientation. If SWAP_MASK is true, then canonical traversal
  // order is flipped around the diagonal (i.e. i and j are swapped with each other). If
  // INVERT_MASK is true, then the traversal order is rotated by 180 degrees (i.e. the bits of i and
  // j are inverted, or equivalently, the axis directions are reversed).
  static const int SWAP_MASK = 0x01;
  static const int INVERT_MASK = 0x02;

  /** Mapping Hilbert traversal order to orientation adjustment mask. */
  static final List<int> posToOrientations = [SWAP_MASK, 0, 0, INVERT_MASK + SWAP_MASK];

  /**
   * Returns an XOR bit mask indicating how the orientation of a child subcell is related to the
   * orientation of its parent cell. The returned value can be XOR'd with the parent cell's
   * orientation to give the orientation of the child cell.
   *
   * @param position the position of the subcell in the Hilbert traversal, in the range [0,3].
   * @return a bit mask containing some combination of {@link #SWAP_MASK} and {@link #INVERT_MASK}.
   * @throws IllegalArgumentException if position is out of bounds.
   */
  static int posToOrientation(int position) {
    if (0 > position || position >= 4) {
      throw Exception('Precondition failed');
    }
    return posToOrientations[position];
  }

    /** Mapping from cell orientation + Hilbert traversal to IJ-index. */
  static List<List<int>> posToIj = [
    // 0 1 2 3
    [0, 1, 3, 2], // canonical order: (0,0), (0,1), (1,1), (1,0)
    [0, 2, 3, 1], // axes swapped: (0,0), (1,0), (1,1), (0,1)
    [3, 2, 0, 1], // bits inverted: (1,1), (1,0), (0,0), (0,1)
    [3, 1, 0, 2], // swapped & inverted: (1,1), (0,1), (0,0), (1,0)
  ];

  /**
   * Return the IJ-index of the subcell at the given position in the Hilbert curve traversal with
   * the given orientation. This is the inverse of {@link #ijToPos}.
   *
   * @param orientation the subcell orientation, in the range [0,3].
   * @param position the position of the subcell in the Hilbert traversal, in the range [0,3].
   * @return the IJ-index where {@code 0->(0,0), 1->(0,1), 2->(1,0), 3->(1,1)}.
   * @throws IllegalArgumentException if either parameter is out of bounds.
   */
  static int posToIJ(int orientation, int position) {
    return posToIj[orientation][position];
  }
}

/** Defines an area or a length cell metric. Immutable after construction. */
final class _Metric {
  // NOTE: This isn't GWT serializable because writing custom field serializers for inner classes
  // is hard.

  /**
   * The "deriv" value of a metric is a derivative, and must be multiplied by a length or area in
   * (s,t)-space to get a useful value.
   */
  late final double deriv;
  late final int dim;

  /** Defines a cell metric of the given dimension (1 == length, 2 == area). */
  _Metric(this.dim, this.deriv);
}