// Dart port of s2-geometry-library-java.S2Point

/*
 * Copyright 2006 Google Inc.
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
 * An S2Point represents a point on the unit sphere as a 3D vector. Usually points are normalized to
 * be unit length, but some methods do not require this.
 *
 * @author danieldanciu@google.com (Daniel Danciu) ported from util/geometry
 * @author ericv@google.com (Eric Veach) original author
 */
class _S2Point {
  // Coordinates of the point.
  late final double x;
  late final double y;
  late final double z;

  /** Constructs an S2Point from the given coordinates. */
  _S2Point(this.x, this.y, this.z);

  /** Return the index of the largest of x, y, or z by absolute value, as 0, 1 or 2 respectively. */
  static int largestAbsComponent(double x, double y, double z) {
    final double absX = x.abs();
    final double absY = y.abs();
    final double absZ = z.abs();
    return (absX > absY) ? ((absX > absZ) ? 0 : 2) : ((absY > absZ) ? 1 : 2);
  }
}