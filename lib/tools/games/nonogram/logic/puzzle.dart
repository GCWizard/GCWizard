// const assert = require('assert');
// const clone = require('./util').clone;
// const ascii = require('./serializers/ascii');
// const svg = require('./serializers/svg');

class Puzzle {
  var rowHints = <List<int>>[];
  var columnHints = <List<int>>[];
  int height = 0;
  int width = 0;
  // var rows = <List<int>>[];
  // var columns = <List<int>>[];
  var state = <int>[];

  Puzzle(this.rowHints, this.columnHints) {}
  // constructor(data) {
  //   if (typeof data === 'string') {
  //     data = JSON.parse(data);
  //   }
  //   let initialState = this.mapData(data);
  //   this.initAccessors(initialState);
  // }
  int mapData(Puzzle data) {
    rowHints = cleanClone(data.rowHints);
    columnHints = cleanClone(data.columnHints);
    height = rowHints.length;
    width = columnHints.length;
    // rows = List<List<int>>.filled(height, List<int>.filled(width, 0));
    // columns = List<List<int>>.filled(width, List<int>.filled(height, 0));
    state = List<int>.filled(width * height, 0);

    return checkConsistency(data);
    // if (data.content) {
    //   this.originalContent = clone(data.content);
    //   return clone(data.content);
    // }
    // return List<int>.filled(width * height, 0);
  }

  List<List<int>> cleanClone(List<List<int>> hints) {
    return hints.map((h) {
      if (h.length == 1 && h[0] == 0) {
        return <int>[];
      }
      return h; //clone(h)
    }).toList();

  }

  List<List<int>> get rows {
    var _rows = <List<int>>[];
    for(var index = 0; index < height; index++) {
      _rows.add(state.sublist(index * width, (index + 1) * width));
    }
    return _rows;
  }

  // List<int> get rows {
  //   return state;
  // }

   set rows (List<List<int>> newRows) {
    for(var index = 0; index < height; index++) {
      state.setRange(index * width, (index + 1) * width, newRows[index]);
    }
  }

  List<List<int>> get columns {
    var _columns = <List<int>>[];
    for(var x = 0; x < width; x++) {
      _columns.add([]);
      for(var y = 0; y < height; y++) {
        _columns[x].add(state[y * width + x]);
      }
    }
    return _columns;
  }

  set columns (List<List<int>> newColumns) {
    for(var x = 0; x < width; x++) {
      for(var y = 0; y < height; y++) {
        state[y * width + x] = newColumns[x][y];
      }
    }
  }

  void setRow (List<int> newRow, int index) {
    state.setRange(index * width, (index + width) * width, newRow);
  }

  bool get isFinished {
    return state.every((item) => item != 0);
  }

  // bool get isSolved {
  //   var isOk = (line, hints) {
  //     var actual = line.join('').split(/(?:-1)+/g).map(x => x.length).filter(x => x);
  //     return actual.length === hints.length && actual.every((x, i) => x === hints[i]);
  //   };
  //   return (
  //     isFinished &&
  //     columns.every((col, i) => isOk(col, columnHints[i])) &&
  //     rows.every((row, i) => isOk(row, rowHints[i]))
  //   );
  // }

  // void initAccessors(state) {
  //
  //   var rows = Array(height);
  //   var makeRow = (rowIndex) => {
  //   var row = Array(width).fill(0);
  //     row.forEach((_, colIndex) => {
  //       Object.defineProperty(row, colIndex, {
  //         get() {
  //           return state[rowIndex * width + colIndex];
  //         },
  //         set(el) {
  //           state[rowIndex * width + colIndex] = el;
  //         }
  //       });
  //     });
  //     return row;
  //   };
  //   for (var rowIndex = 0; rowIndex < height; rowIndex++) {
  //     var row = makeRow(rowIndex);
  //     Object.defineProperty(rows, rowIndex, {
  //       get() {
  //         return row;
  //       },
  //       set(newRow) {
  //         newRow.forEach((el, x) => state[rowIndex * width + x] = el);
  //       }
  //     });
  //   }
  //
  //   var columns = Array(width);
  //   var makeColumn = (colIndex) => {
  //     var column = Array(height).fill(0);
  //     column.forEach((_, rowIndex) => {
  //       Object.defineProperty(column, rowIndex, {
  //         get() {
  //           return state[rowIndex * width + colIndex];
  //         },
  //         set(el) {
  //           state[rowIndex * width + colIndex] = el;
  //         }
  //       });
  //     });
  //     return column;
  //   };
  //   for (var colIndex = 0; colIndex < width; colIndex++) {
  //     var column = makeColumn(colIndex);
  //     Object.defineProperty(columns, colIndex, {
  //       get() {
  //         return column;
  //       },
  //       set(newCol) {
  //         newCol.forEach((el, y) => state[y * width + colIndex] = el);
  //       }
  //     });
  //   }
  //
  //   Object.defineProperties(this, {
  //     rows: {
  //       get() {
  //         return rows;
  //       },
  //       set(newRows) {
  //         newRows.forEach((el, i) => {
  //           rows[i] = el;
  //         });
  //       }
  //     },
  //     columns: {
  //       get() {
  //         return columns;
  //       },
  //       set(cols) {
  //         cols.forEach((el, i) => {
  //           columns[i] = el;
  //         });
  //       }
  //     },
  //     isFinished: {
  //       get() {
  //         return state.every(item => item !== 0);
  //       }
  //     },
  //     snapshot: {
  //       get() {
  //         return clone(state);
  //       }
  //     },
  //     isSolved: {
  //       get() {
  //         let isOk = (line, hints) => {
  //           let actual = line.join('').split(/(?:-1)+/g).map(x => x.length).filter(x => x);
  //           return actual.length === hints.length && actual.every((x, i) => x === hints[i]);
  //         };
  //         return (
  //           this.isFinished &&
  //           columns.every((col, i) => isOk(col, this.columnHints[i])) &&
  //           rows.every((row, i) => isOk(row, this.rowHints[i]))
  //         );
  //       }
  //     }
  //   });
  //
  //   this.import = function(puzzle) {
  //     state = clone(puzzle.snapshot);
  //   };
  //
  //   this.toJSON = function() {
  //     return {
  //       columns: this.columnHints,
  //       rows: this.rowHints,
  //       content: state
  //     }
  //   };
  //
  // }

  int checkConsistency(Puzzle data) {
    // if (content) {
    //   var invalid = !content || !Array.isArray(content);
    //   invalid = invalid || (content.length != this.height * this.width);
    //   invalid = invalid || !content.every(i => i === -1 || i === 0 || i === 1);
    //   assert(!invalid, 'Invalid content data');
    // }

    if (data.rowHints.isEmpty || data.columnHints.isEmpty ||
        data.height == 0 || data.width == 0) {
      return -1; //'Invalid content data'
    }

    //var sum = a => a.reduce((x, y) => x + y, 0);
    var rowSum = _sum(data.rowHints.map((l) => _sum(l)));
    var columnSum = _sum(data.columnHints.map((l) => _sum(l)));
    return (rowSum == columnSum) ? 0 : -2; //'Invalid hint data'
  }

  int _sum(Iterable<int> list) {
    if (list.isEmpty) return 0;
    return list.reduce((x, y) => x + y);
  }

  // inspect() { // called by console.log
  //   return ascii(this);
  // }


  // get svg() {
  //   return svg(this);
  // }
}

// module.exports = Puzzle;