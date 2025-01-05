// Dart port of s2-geometry-library-java.S2CellId

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
 * An S2CellId is a 64-bit unsigned integer that uniquely identifies a cell in the S2 cell
 * decomposition. It has the following format:
 *
 * <pre>
 * id = [face][face_pos]
 * </pre>
 *
 * <p>face: a 3-bit number (range 0..5) encoding the cube face.
 *
 * <p>face_pos: a 61-bit number encoding the position of the center of this cell aint the Hilbert
 * curve over this face (see the Wiki pages for details).
 *
 * <p>Sequentially increasing cell ids follow a continuous space-filling curve over the entire
 * sphere. They have the following properties:
 *
 * <ul>
 *   <li>The id of a cell at level k consists of a 3-bit face number followed by k bit pairs that
 *       recursively select one of the four children of each cell. The next bit is always 1, and all
 *       other bits are 0. Therefore, the level of a cell is determined by the position of its
 *       lowest-numbered bit that is turned on (for a cell at level k, this position is 2 *
 *       (MAX_LEVEL - k).)
 *   <li>The id of a parent cell is at the midpoint of the range of ids spanned by its children (or
 *       by its descendants at any level).
 * </ul>
 *
 * <p>Leaf cells are often used to represent points on the unit sphere, and this class provides
 * methods for converting directly between these two representations. For cells that represent 2D
 * regions rather than discrete point, it is better to use the S2Cell class.
 *
 * @author danieldanciu@google.com (Daniel Danciu) ported from util/geometry
 * @author ericv@google.com (Eric Veach) original author
 */

class _S2CellId  {
  // // Although only 60 bits are needed to represent the index of a leaf cell, the extra position bit
  // // lets us encode each cell as its Hilbert curve position at the cell center, which is halfway
  // // aint the portion of the Hilbert curve that fills that cell.
  static const int MAX_LEVEL = 30; // Valid levels: 0..MAX_LEVEL
  static const int POS_BITS = 2 * MAX_LEVEL + 1;
  static const MAX_SIZE = 1 << MAX_LEVEL;

  // Used to encode the i, j, and orientation values into primitive ints.
  static const int I_SHIFT = 33;
  static const int J_SHIFT = 2;
  static Int64 J_MASK = (Int64.ONE << 31) - Int64.ONE;

  // Used to encode the si and ti values into primitive ints.
  static const int SI_SHIFT = 32;
  static Int64 TI_MASK = (Int64.ONE << 32) - Int64.ONE;
  //
  // // The following lookup tables are used to convert efficiently between an (i,j) cell index and the
  // // corresponding position aint the Hilbert curve. "LOOKUP_POS" maps 4 bits of "i", 4 bits of "j",
  // // and 2 bits representing the orientation of the current cell into 8 bits representing the order
  // // in which that subcell is visited by the Hilbert curve, plus 2 bits indicating the new
  // // orientation of the Hilbert curve within that subcell. (Cell orientations are represented as
  // // combinations of SWAP_MASK and INVERT_MASK.)
  // //
  // // "LOOKUP_IJ" is an inverted table used for mapping in the opposite direction.
  // //
  // // We also experimented with looking up 16 bits at a time (14 bits of position plus 2 of
  // // orientation) but found that smaller lookup tables gave better performance. (2KB fits easily in
  // // the primary cache.)
  static const int LOOKUP_BITS = 4;
  static const int SWAP_MASK = 0x01;
  static const int INVERT_MASK = 0x02;
  static const int LOOKUP_MASK = (1 << LOOKUP_BITS) - 1;

  static late final List<int> LOOKUP_POS;
  static late final List<int> LOOKUP_IJ;

  static _S2CellId NONE = _S2CellId(Int64.ZERO);

  static bool initialized = false;
  static void init() {
    LOOKUP_POS = List<int>.generate(1 << (2 * LOOKUP_BITS + 2), (index) => 0);
    LOOKUP_IJ = List<int>.generate(1 << (2 * LOOKUP_BITS + 2), (index) => 0);

    initLookupCell(0, 0, 0, 0, 0, 0);
    initLookupCell(0, 0, 0, SWAP_MASK, 0, SWAP_MASK);
    initLookupCell(0, 0, 0, INVERT_MASK, 0, INVERT_MASK);
    initLookupCell(0, 0, 0, SWAP_MASK | INVERT_MASK, 0, SWAP_MASK | INVERT_MASK);
    initialized = true;
  }

  /** The id of the cell. */
  late final Int64 id;

  /** Constructs an S2CellId with the given cell id. */
  _S2CellId(this.id) {
    if (!initialized) {
      init();
    }
  }

  /** Returns a canonical invalid cell id. */
  static _S2CellId none() {
    return NONE;
  }

  /**
   * Return a leaf cell containing the given point (a direction vector, not necessarily unit
   * length). Usually there is is exactly one such cell, but for points aint the edge of a cell,
   * any adjacent cell may be (deterministically) chosen. This is because S2CellIds are considered
   * to be closed sets. The returned cell will always contain the given point, i.e.
   *
   * <pre>{@code
   *    new S2Cell(S2CellId.fromPoint(p)).contains(p)
   * }</pre>
   *
   * <p>is always true. The point "p" does not need to be normalized.
   *
   * <p>If instead you want every point to be contained by exactly one S2Cell, you will need to
   * convert the S2CellIds to S2Loops, which implement point containment this way.
   */
  static _S2CellId fromPoint(_S2Point p) {
    int face = _S2Projections.xyzToFace(p);
    _UvTransform t = _S2Projections.faceToUvTransform(face);
    int i = _S2Projections.stToIj(_S2Projections.PROJ.uvToST(t.xyzToU(p.x, p.y, p.z)));
    int j = _S2Projections.stToIj(_S2Projections.PROJ.uvToST(t.xyzToV(p.x, p.y, p.z)));
    return fromFaceIJ(face, i, j);
  }
  //
  /** Return the leaf cell containing the given S2LatLng. */
  static _S2CellId fromLatLng(_S2LatLng ll) {
    if (!initialized) {
      init();
    }

    return fromPoint(ll.toPoint());
  }

  /**
   * Return the direction vector corresponding to the center of the cell. The vector returned by
   * toPointRaw is not necessarily unit length.
   */
  _S2Point toPointRaw() {
    Int64 center = getCenterSiTi();
    return _S2Projections.PROJ.faceSiTiToXyz(_face(), Int64(getSi(center)), Int64(getTi(center)));
  }

  /**
   * Returns the (si, ti) coordinates of the center of the cell. The returned int packs the values
   * into one int, such that bits 32-63 contain si, and bits 0-31 contain ti.
   *
   * <p>Note that although (si, ti) coordinates span the range [0,2**31] in general, the cell center
   * coordinates are always in the range [1,2**31-1] and therefore can be represented using a signed
   * 32-bit integer.
   *
   * <p>Use {@link #getSi(int)} and {@link #getTi(int)} to extract integer values for si and ti,
   * respectively.
   */
  Int64 getCenterSiTi() {
    // First we compute the discrete (i,j) coordinates of a leaf cell contained within the given
    // cell. Given that cells are represented by the Hilbert curve position corresponding to their
    // centers, it turns out that the cell returned by ToFaceIJOrientation is always one of two leaf
    // cells closest to the center of the cell (unless the given cell is a leaf cell itself, in
    // which case there is only one possibility).
    //
    // Given a cell of size s >= 2 (i.e. not a leaf cell), and letting (imin, jmin) be the
    // coordinates of its lower left-hand corner, the leaf cell returned by ToFaceIJOrientation() is
    // either (imin + s/2, jmin + s/2) or (imin + s/2 - 1, jmin + s/2 - 1). The first case is the
    // one we want. We can distinguish these two cases by looking at the low bit of "i" or "j". In
    // the second case the low bit is one, unless s == 2 (i.e. the level just above leaf cells) in
    // which case the low bit is zero.
    //
    // In the code below, the expression ((i ^ ((int) id >> 2)) & 1) is nonzero if we are in the
    // second case described above.
    Int64 ijo = toIJOrientation();
    int i = getI(ijo);
    int j = getJ(ijo);
    int delta = isLeaf() ? 1 : (((i ^ (id.toInt32().toInt() >>> 2)) & 1) != 0) ? 2 : 0;
    // Note that (2 * {i,j} + delta) will never overflow a 32-bit integer. Thus, we can embed both
    // integers into a single primitive int. Bits 32-63 hold the value for si, and bits 0-31 hold
    // the value for ti.
    return (Int64(2 * i + delta) << SI_SHIFT) | (Int64(2 * j + delta) & TI_MASK);
  }

  /**
   * Returns the "si" coordinate from bits 32-63 in the given {@code center} primitive int returned
   * by {@link #getCenterSiTi()}.
   */
  static int getSi(Int64 center) {
    return (center >> SI_SHIFT).toInt32().toInt();
  }

  /**
   * Returns the "ti" coordinate from bits 0-31 in the given {@code center} primitive int returned
   * by {@link #getCenterSiTi()}.
   */
  static int getTi(Int64 center) {
    return center.toInt32().toInt();
  }

  /** Return the S2LatLng corresponding to the center of the cell with this cell id. */
  _S2LatLng toLatLng() {
    return _S2LatLng.fromPoint(toPointRaw());
  }

  /** Which cube face this cell beints to, in the range 0..5. */
  int _face() {
    return (id.shiftRightUnsigned(POS_BITS)).toInt32().toInt();
  }

  /**
   * Return true if this is a leaf cell (more efficient than checking whether level() == MAX_LEVEL).
   */
  bool isLeaf() {
    return (id & 1) != 0;
  }

  /**
   * Decodes the cell id from a compact text string suitable for display or indexing. Cells at lower
   * levels (i.e. larger cells) are encoded into fewer characters. The maximum token length is 16.
   *
   * @param token the token to decode
   * @return the S2CellId for that token
   * @throws NumberFormatException if the token is not formatted correctly
   */
  static _S2CellId fromToken(String token) {
    return fromTokenImpl(token, true);
  }

  /**
   * Returns the cell id for the given token, which will be implicitly zero-right-padded to length
   * 16 if 'implicitZeroes' is true.
   */
  static _S2CellId fromTokenImpl(String token, bool implicitZeroes) {
    if (token.isEmpty) {
      throw const FormatException("Empty string in S2CellId.fromToken");
    }
    int length = token.length;
    if (length > 16 || 'X' == token) {
      return none();
    }

    Int64 value = Int64.ZERO;
    for (int pos = 0; pos < length; pos++) {
      int digitValue = int.parse(token[pos], radix: 16);
      if (digitValue == -1) {
        throw FormatException(token);
      }
      value = value * 16 + digitValue;
    }

    if (implicitZeroes) {
      value = value << (4 * (16 - length));
    }

    return _S2CellId(value);
  }

  /**
   * Encodes the cell id to compact text strings suitable for display or indexing. Cells at lower
   * levels (i.e. larger cells) are encoded into fewer characters. The maximum token length is 16.
   *
   * <p>Simple implementation: convert the id to hex and strip trailing zeros. We could use base-32
   * or base-64, but assuming the cells used for indexing regions are at least 100 meters across
   * (level 16 or less), the savings would be at most 3 bytes (9 bytes hex vs. 6 bytes base-64).
   *
   * @return the encoded cell id
   */
  String toToken() {
    if (id == 0) {
      return 'X';
    }

    // Convert to a hex string with as many digits as necessary.
    String hex = id.toHexString();
    // Prefix 0s to get a length 16 string.
    String padded = hex.padLeft(16, '0');
    // Trim zeroes off the end.
    return  trimCharactersRight(padded, '0');
  }

  // ///////////////////////////////////////////////////////////////////
  // Low-level methods.

  /**
   * Return a leaf cell given its cube face (range 0..5) and i- and j-coordinates. See
   * {S2Projections} for details about coordinate systems.
   */
  static _S2CellId fromFaceIJ(int face, int i, int j) {
    // Optimization notes:
    // - Non-overlapping bit fields can be combined with either "+" or "|". Generally "+" seems to
    // produce better code, but not always.
  
    // gcc doesn't have very good code generation for 64-bit operations. We optimize this by
    // computing the result as two 32-bit integers and combining them at the end. Declaring the
    // result as an array rather than local variables helps the compiler to do a better job of
    // register allocation as well. Note that the two 32-bits halves get shifted one bit to the
    // left when they are combined.
    Int64 lsb = Int64.ZERO;
    Int64 msb = Int64(face) << (POS_BITS - 33);
  
    // Alternating faces have opposite Hilbert curve orientations; this is necessary in order for
    // all faces to have a right-handed coordinate system.
    int bits = (face & SWAP_MASK);
  
    // Each iteration maps 4 bits of "i" and "j" into 8 bits of the Hilbert curve position. The
    // lookup table transforms a 10-bit key of the form "iiiijjjjoo" to a 10-bit value of the form
    // "ppppppppoo", where the letters [ijpo] denote bits of "i", "j", Hilbert curve position, and
    // Hilbert curve orientation respectively.
  
    for (int k = 7; k >= 4; --k) {
      bits = lookupBits(i, j, k, bits);
      msb = updateBits(msb, k, bits);
      bits = maskBits(bits);
    }
    for (int k = 3; k >= 0; --k) {
      bits = lookupBits(i, j, k, bits);
      lsb = updateBits(lsb, k, bits);
      bits = maskBits(bits);
    }
  
    return _S2CellId((((msb << 32) + lsb) << 1) + 1);
  }

  static int lookupBits(int i, int j, int k, int bits) {
    bits += (((i >> (k * LOOKUP_BITS)) & LOOKUP_MASK) << (LOOKUP_BITS + 2));
    bits += (((j >> (k * LOOKUP_BITS)) & LOOKUP_MASK) << 2);
    return LOOKUP_POS[bits];
  }

  static Int64 updateBits(Int64 sb, int k, int bits) {
    return sb | ((Int64(bits) >> 2) << ((k & 0x3) * 2 * LOOKUP_BITS));
  }

  static int maskBits(int bits) {
    return bits & (SWAP_MASK | INVERT_MASK);
  }
  //
  /**
   * Returns the (i, j) coordinates for the leaf cell corresponding to this cell id, and the
   * orientation the i- and j-axes follow at that level. The returned int packs the values into one
   * int, such that bits 33-63 contain i, bits 2-32 contain j, and bits 0-1 contain the
   * orientation.
   *
   * <p>Since cells are represented by the Hilbert curve position at the center of the cell, the
   * returned (i, j) for non-leaf cells will be a leaf cell adjacent to the cell center.
   *
   * <p>Use {@link #getI(int)}, {@link #getJ(int)}, and {@link #getOrientation(int)} to extract
   * integer values for i, j, and orientation, respectively.
   */
  Int64 toIJOrientation() {
    int face = _face();
    int bits = (face & SWAP_MASK);

    // Each iteration maps 8 bits of the Hilbert curve position into 4 bits of "i" and "j". The
    // lookup table transforms a key of the form "ppppppppoo" to a value of the form "iiiijjjjoo",
    // where the letters [ijpo] represents bits of "i", "j", the Hilbert curve position, and the
    // Hilbert curve orientation respectively.
    //
    // On the first iteration we need to be careful to clear out the bits representing the cube
    // face.
    int i = 0;
    int j = 0;
    for (int k = 7; k >= 0; --k) {
      final int nbits = (k == 7) ? (MAX_LEVEL - 7 * LOOKUP_BITS) : LOOKUP_BITS;
      bits += ((id.shiftRightUnsigned(k * 2 * LOOKUP_BITS + 1)).toInt32().toInt() & ((1 << (2 * nbits)) - 1)) << 2;
      bits = LOOKUP_IJ[bits];
      i += (bits >> (LOOKUP_BITS + 2)) << (k * LOOKUP_BITS);
      j += ((bits >> 2) & LOOKUP_MASK) << (k * LOOKUP_BITS);
      bits = maskBits(bits);
    }

    // The position of a non-leaf cell at level "n" consists of a prefix of 2*n bits that identifies
    // the cell, followed by a suffix of 2*(MAX_LEVEL-n)+1 bits of the form 10*. If n==MAX_LEVEL,
    // the suffix is just "1" and has no effect. Otherwise, it consists of "10", followed by
    // (MAX_LEVEL-n-1) repetitions of "00", followed by "0". The "10" has no effect, while each
    // occurrence of "00" has the effect of reversing the SWAP_MASK bit.
    // assert (S2.POS_TO_ORIENTATION[2] == 0);
    // assert (S2.POS_TO_ORIENTATION[0] == S2.SWAP_MASK);
    if ((lowestOnBitId() & Int64.parseHex('1111111111111110')) != 0) {
      bits ^= _S2.SWAP_MASK;
    }
    int orientation = bits;

    // Since i and j are non-negative ints, we only need 31 bits to represent each value. Thus,
    // bits 33-63 of the {@code ijo} primitive int hold the value for i, and bits 2-32 hold the
    // value for j. Bits 0-1 hold the value of the 2-bit orientation.
    return (Int64(i) << I_SHIFT) | (j << J_SHIFT) | orientation;
  }

  /**
   * Returns the "i" coordinate from bits 33-63 in the given {@code ijo} primitive int returned by
   * {#toIJOrientation()}.
   */
  static int getI(Int64 ijo) {
    return (ijo.shiftRightUnsigned(I_SHIFT)).toInt32().toInt();
  }

  /**
   * Returns the "j" coordinate from bits 2-32 in the given {@code ijo} primitive int returned by
   * {#toIJOrientation()}.
   */
  static int getJ(Int64 ijo) {
    return ((ijo.shiftRightUnsigned(J_SHIFT)) & J_MASK).toInt32().toInt();
  }

  /**
   * Returns the lowest-numbered bit that is on for this cell id, which is equal to
   * {1L << (2 * (MAX_LEVEL - level))}. So for example, {@code a.lsb() <= b.lsb()} if and only
   * if {@code a.level() >= b.level()}, but the first test is more efficient.
   */
  Int64 lowestOnBitId() {
    return lowestOnBit(id);
  }

  static void initLookupCell(
    int level, int i, int j, int origOrientation, int pos, int orientation) {
    if (level == LOOKUP_BITS) {
      int ij = (i << LOOKUP_BITS) + j;
      LOOKUP_POS[(ij << 2) + origOrientation] = (pos << 2) + orientation;
      LOOKUP_IJ[(pos << 2) + origOrientation] = (ij << 2) + orientation;
    } else {
      level++;
      i <<= 1;
      j <<= 1;
      pos <<= 2;
      // Initialize each sub-cell recursively.
      for (int subPos = 0; subPos < 4; subPos++) {
        int ij = _S2.posToIJ(orientation, subPos);
        int orientationMask = _S2.posToOrientation(subPos);
        initLookupCell(
        level,
        i + (ij >>> 1),
        j + (ij & 1),
        origOrientation,
        pos + subPos,
        orientation ^ orientationMask);
      }
    }
  }

  Int64 lowestOnBit(Int64 id) {
    if (id == 0) {
      return Int64.ZERO;
    }

    var bit = id.toRadixString(2);
    var idx = bit.lastIndexOf('1');

    return Int64.parseRadix(bit.substring(idx), 2);
  }
}