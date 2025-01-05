import 'dart:convert';
import 'dart:math';

import 'package:gc_wizard/utils/alphabets.dart';
import 'package:gc_wizard/utils/data_type_utils/object_type_utils.dart';
import 'package:gc_wizard/utils/json_utils.dart';

const int maxCategoriesCount = 26;
const int minItemCount = 2;

enum LogicalFillType { USER_FILLED, CALCULATED }

enum LogicalState {
	Ok, // no data errors
	InvalidData, // data errors
	InvalidItemData // Items data errors
}

class LogicalValue {
	LogicalFillType type;
	int? value;

	LogicalValue(this.value, this.type);
}

class _LogicalBlock {
	late List<List<LogicalValue?>> block;
	int itemsCount;

	_LogicalBlock(this.itemsCount) {
		block = List<List<LogicalValue?>>.generate(
				itemsCount, (index) => List<LogicalValue?>.generate(itemsCount, (index) => null));
	}

	int? getValue(int x, int y) {
		return block[y][x]?.value;
	}

	LogicalFillType? getFillType(int x, int y) {
		return block[y][x]?.type;
	}

	_setValueResult setValue(int x, int y, int? value, LogicalFillType type) {
		var orgValue = getValue(x, y);
		var orgType = getFillType(x, y);
		var result = _setValueResult(valueChanged: orgValue != value);
		if (value == null || orgValue == null) {
			block[y][x] = value == null ? null : LogicalValue(value, type);
			return result;
		} else if (!result.valueChanged) {
			if (orgType == LogicalFillType.CALCULATED) {
				block[y][x] = LogicalValue(value, type);
			}
			return result;
		} else if (orgType == LogicalFillType.USER_FILLED && type == LogicalFillType.USER_FILLED) {
			if (value == Logical.plusValue ) {
				if (_ckeckPlusPossible(x, y)) {
					block[y][x] = LogicalValue(value, type);
				} else {
					return _setValueResult(validChange: false);
				}
			}
			return result;
		} else {
			return _setValueResult(validChange: false);
		}
	}

	_setValueResult setPlusValue(int xPlus, int yPlus, LogicalFillType type) {
		var result = _setValueResult();
		// row
		for (var i = 0; i < itemsCount; i++) {
			if (i == xPlus) {
				result &= setValue(i, yPlus, Logical.plusValue, type);
			} else {
				result &= setValue(i, yPlus, Logical.minusValue, LogicalFillType.CALCULATED);
			}
		}
		// column
		for (var i = 0; i < itemsCount; i++) {
			if (i == yPlus) {
				result &= setValue(xPlus, i, Logical.plusValue, type);
			} else {
				result &= setValue(xPlus, i, Logical.minusValue, LogicalFillType.CALCULATED);
			}
		}
		return result;
	}

	_setValueResult setValueAndCalculated(int x, int y, int? value,
			{LogicalFillType type = LogicalFillType.CALCULATED}) {
		if (value == Logical.plusValue) {
			if (_ckeckPlusPossible(x, y)) {
				return setPlusValue(x, y, type);
			} else {
				return _setValueResult(validChange: false, valueChanged: false);
			}
		} else {
			return setValue(x, y, value, type) & _checkAndSetCalculatedFullRow(x) & _checkAndSetCalculatedFullColumn(y);
		}
	}

	bool _ckeckPlusPossible(int xPlus, int yPlus) {
		return _checkPlusPossibleRow(xPlus, yPlus) && _checkPlusPossibleColumn(xPlus, yPlus);
	}

	bool _checkPlusPossibleRow(int x, int y) {
		var count = 0;
		int? value;

		for (var _y = 0; _y < itemsCount; _y++) {
			if (_y == y) continue;
			value = getValue(x, _y);
			if (value == Logical.plusValue) {
				return false;
			} else {
				count += (value == Logical.minusValue) ? 1 : 0;
			}
		}
		return (count <= itemsCount - 1);
	}

	bool _checkPlusPossibleColumn(int x, int y) {
		var count = 0;
		int? value;

		for (var _x = 0; _x < itemsCount; _x++) {
			if (_x == x) continue;
			value = getValue(_x, y);
			if (value == Logical.plusValue) {
				return false;
			} else {
				count += (value == Logical.minusValue) ? 1 : 0;
			}
		}
		return (count <= itemsCount - 1);
	}

	_setValueResult _checkAndSetCalculatedFullRow(int x) {
		var count = 0;
		var emptyIndex = -1;
		int? value;

		for (var _y = 0; _y < itemsCount; _y++) {
			value = getValue(x, _y);
			if (value == null) {
				emptyIndex = _y;
			} else {
				count += (value == Logical.minusValue) ? 1 : 0;
			}
		}

		if (count == itemsCount - 1 && emptyIndex >= 0) {
			return setValueAndCalculated(x, emptyIndex, Logical.plusValue);
		} else if (count == itemsCount) {
			return _setValueResult(validChange: false);
		} else {
			return _setValueResult();
		}
	}

	_setValueResult _checkAndSetCalculatedFullColumn(int y) {
		var count = 0;
		var emptyIndex = -1;
		int? value;

		for (var _x = 0; _x < itemsCount; _x++) {
			value = getValue(_x, y);
			if (value == null) {
				emptyIndex = _x;
			} else {
				count += (value == Logical.minusValue) ? 1 : 0;
			}
		}

		if (count == itemsCount - 1 && emptyIndex >= 0) {
			return setValueAndCalculated(emptyIndex, y, Logical.plusValue);
		} else if (count == itemsCount) {
			return _setValueResult(validChange: false);
		} else {
			return _setValueResult();
		}
	}

	void removeCalculatedValues() {
		for (var x = 0; x < itemsCount; x++) {
			for (var y = 0; y < itemsCount; y++) {
				if (getFillType(x, y) == LogicalFillType.CALCULATED) {
					setValue(x, y, null, LogicalFillType.CALCULATED);
				}
			}
		}
	}

	@override
	String toString() {
		var output = '';
		for (var row in block) {
			output += '[';
			for (var value in row) {
				output += value?.value.toString() ?? '' + ',';
			}
			output += ']';
		}
		return output;
	}
}


class Logical {
	late List<List<_LogicalBlock>> blocks;
	late List<List<String>> logicalItems;
	List<_LogicalSupporterSolution>? solutions;
	int categoriesCount = 4;
	int itemsCount = 5;
	LogicalState state = LogicalState.Ok;

	static const plusValue = 1;
	static const minusValue = -1;

	Logical(this.categoriesCount, this.itemsCount, {Logical? logical}) {
		categoriesCount = max(minItemCount, categoriesCount);
		itemsCount = max(minItemCount, itemsCount);

		_generateBlocks();
		_generateItems();

		if (logical != null) {
			for (var yBlock = 0; yBlock < min(logical._getMaxBlockLength(), _getMaxBlockLength()); yBlock++) {
				for (var xBlock = 0; xBlock < min(logical._getBlockLength(yBlock), _getBlockLength(yBlock)); xBlock++) {
					for (var y = 0; y < min(logical.itemsCount, itemsCount); y++) {
						for (var x = 0; x < min(logical.itemsCount, itemsCount); x++) {
							var value = logical.blocks[yBlock][xBlock].getValue(x, y);
							if (value != null) {
								blocks[yBlock][xBlock].setValueAndCalculated(x, y, value,
										type: logical.blocks[yBlock][xBlock].getFillType(x, y) ?? LogicalFillType.CALCULATED);
							}
						}
					}
				}
			}
			for (var itemBlock = 0; itemBlock < min(logical.logicalItems.length, logicalItems.length); itemBlock++) {
				for (var item = 0; item < min(logical.logicalItems[itemBlock].length, logicalItems[itemBlock].length); item++) {
					logicalItems[itemBlock][item] = logical.logicalItems[itemBlock][item];
				}
			}
		} else {
			_initExampleItems();
		}
	}

	void _initExampleItems() {
		if (categoriesCount == 4 && itemsCount == 5) {
			logicalItems[0][0] = 'Steffi';
			logicalItems[0][1] = 'George';
			logicalItems[0][2] = 'Barack';
			logicalItems[0][3] = 'Carla';
			logicalItems[0][4] = 'Roger';

			logicalItems[1][0] = 'Cambridge';
			logicalItems[1][1] = 'Obama';
			logicalItems[1][2] = 'Graf';
			logicalItems[1][3] = 'Federer';
			logicalItems[1][4] = 'Bruni';

			logicalItems[2][0] = '1969';
			logicalItems[2][1] = '2013';
			logicalItems[2][2] = '1961';
			logicalItems[2][3] = '1967';
			logicalItems[2][4] = '1981';

			logicalItems[3][0] = 'CH';
			logicalItems[3][1] = 'UK';
			logicalItems[3][2] = 'D';
			logicalItems[3][3] = 'USA';
			logicalItems[3][4] = 'F';
		}
	}

	int getMaxLineLength() {
		return (categoriesCount - 1) * itemsCount;
	}

	int getLineLength(int line) {
		return (categoriesCount - 1 - (line / itemsCount).floor()) * itemsCount;
	}

	int _getMaxBlockLength() {
		return categoriesCount - 1;
	}

	int _getBlockLength(int block) {
		return categoriesCount - 1 - block;
	}

	/// map row block index to column block index
	////@block block index
	int _mapRowToColumnBlockIndex(int block) {
		return block < 1 ? 0 : categoriesCount - 1 - block;
	}

	/// map column block index to row block index
	////@block block index
	int mapColumnToRowBlockIndex(int block) {
		return block < 1 ? 0 : categoriesCount - block;
	}

	int blockIndex(int line) {
		return (line / itemsCount).floor();
	}

	int blockLine(int value) {
		return value % itemsCount;
	}

	int fullLine(int block, int line) {
		return block * itemsCount + line;
	}

	int? getValue(int x, int y) {
		if (!_validPosition(x, y)) {
			return null;
		}
		return blocks[blockIndex(y)][blockIndex(x)].getValue(blockLine(x), blockLine(y));
	}

	/// return valid change
	bool setValue(int x, int y, int? value, LogicalFillType type) {
		if (!_validPosition(x, y)) return false;
		var block = blocks[blockIndex(y)][blockIndex(x)];
		var xL = blockLine(x);
		var yL = blockLine(y);
		var valueTmp = block.getValue(xL, yL);
		var typeTmp = block.getFillType(xL, yL);

		if (valueTmp == value && typeTmp == type) return true;

		_removeCalculatedValues();
		var result = block.setValueAndCalculated(xL, yL, value, type: type);
		if (result.validChange && result.valueChanged) {
			int loopCounter = 0;

			do {
				result.valueChanged = false;
				result &= _setCalculatedValues();
				loopCounter++;
			} while (result.validChange && result.valueChanged && loopCounter < 100);
			result.valueChanged = true;
		}

		if (!result.validChange && result.valueChanged) {
			setValue(x, y, valueTmp, typeTmp ?? LogicalFillType.CALCULATED);
		}
		return result.validChange;
	}

	LogicalFillType? getFillType(int x, int y) {
		if (!_validPosition(x, y)) return null;

		return blocks[blockIndex(y)][blockIndex(x)].getFillType(blockLine(x), blockLine(y));
	}

	List<List<String>> getSolution() {
		List<List<String>> solution = List<List<String>>.generate(
				itemsCount, (index) => List<String>.generate(
				categoriesCount, (index) => ''));

		for (var y = 0; y < getMaxLineLength(); y++) {
			for (var x = 0; x < getLineLength(y); x++) {
				if (getValue(x, y) == plusValue) {
					var yB = blockIndex(y);
					var yL = blockLine(y);
					var xB = blockIndex(x);
					var xL = blockLine(x);
					var ys1 = mapColumnToRowBlockIndex(xB);
					var ys2 = yB + 1;
					var xt2 = yB + 1;
					var solution1 = fullLine(ys1, xL).toString();
					var solution2 = fullLine(ys2, yL).toString();

					var tL = 0;
					while(!(solution[tL].every((element) => element == '') ||
							solution[tL][ys1] == solution1 || solution[tL][xt2] == solution2 )) {
						tL++;
						if (tL >= solution.length) {
							solution.add(List<String>.generate(categoriesCount, (index) => ''));
						}
					}

					if (tL < solution.length) {
						solution[tL][ys1] = solution1;
						solution[tL][xt2] = solution2;
					}
				}
			}
		}
		solution.removeWhere((line) => line.every((element) => element == ''));

		for (var y = 0; y < solution.length; y++) {
			for (var x = 0; x < solution[y].length; x++) {
				if (solution[y][x].isNotEmpty) {
					var value = int.tryParse(solution[y][x]);
					if (value != null) {
						solution[y][x] = logicalItems[blockIndex(value)][blockLine(value)];
					}
				}
			}
		}
		return solution;
	}

	void removeRelations() {
		_generateBlocks();
	}

	void removeItems() {
		_generateItems();
	}

	_setValueResult _setBlockPlusValue(int xPlus, int yPlus) {
		return blocks[blockIndex(yPlus)][blockIndex(xPlus)].setPlusValue(blockLine(xPlus), blockLine(yPlus),
				LogicalFillType.CALCULATED);
	}

	void _removeCalculatedValues() {
		for (var y = 0; y < blocks.length; y++) {
			for (var x = 0; x < blocks[y].length; x++) {
				blocks[y][x].removeCalculatedValues();
			}
		}
	}

	_setValueResult _setCalculatedValues() {
		var result = _setValueResult();

		for (var y = 0; y < getMaxLineLength(); y++) {
			for (var x = 0; x < getLineLength(y); x++) {
				if (getValue(x, y) == plusValue) {
					result &= _setBlockPlusValue(x, y);
					result &= _setCalculatedBlocks(x, y);
				}
			}
		}

		for (var yBlock = 0; yBlock < _getMaxBlockLength(); yBlock++) {
			for (var xBlock = 0; xBlock < _getBlockLength(yBlock); xBlock++) {
				for (var i = 0; i < itemsCount; i++) {
					result &= blocks[yBlock][xBlock]._checkAndSetCalculatedFullRow(i);
					result &= blocks[yBlock][xBlock]._checkAndSetCalculatedFullColumn(i);
				}
			}
		}
		return result;
	}

	_setValueResult _setCalculatedBlocks(int xPlus, int yPlus) {
		var xBlockIndex = blockIndex(xPlus);
		var yBlockIndex = blockIndex(yPlus);
		var xBlockLine = blockLine(xPlus);
		var yBlockLine = blockLine(yPlus);
		var result = _setValueResult();

		for (var blockRow = 0; blockRow < _getBlockLength(xBlockIndex); blockRow++) {
			if (blockRow != yBlockIndex) {
				if (blockRow < yBlockIndex) {
					result &= _setCalculatedVericalBlockValues(xBlockLine, yBlockLine,
							blocks[blockRow][xBlockIndex], blocks[blockRow][_mapRowToColumnBlockIndex(yBlockIndex)], false);
				} else {
					result &= _setCalculatedVericalBlockValues(xBlockLine, yBlockLine,
							blocks[blockRow][xBlockIndex], blocks[yBlockIndex][_mapRowToColumnBlockIndex(blockRow)], true);
				}
			}
		}
		for (var blockColumn = 0; blockColumn < _getBlockLength(yBlockIndex); blockColumn++) {
			if (blockColumn != xBlockIndex) {
				if (blockColumn < xBlockIndex) {
					result &= _setCalculatedHorizontalBlockValues(xBlockLine, yBlockLine,
							blocks[_mapRowToColumnBlockIndex(xBlockIndex)][blockColumn], blocks[yBlockIndex][blockColumn], false);
				} else {
					result &= _setCalculatedHorizontalBlockValues(xBlockLine, yBlockLine,
							blocks[_mapRowToColumnBlockIndex(blockColumn)][xBlockIndex], blocks[yBlockIndex][blockColumn], true);
				}
			}
		}
		return result;
	}

	_setValueResult _setCalculatedVericalBlockValues(int xLinePlus, int yLinePlus,
			_LogicalBlock xBlock, _LogicalBlock yBlock, bool afterPlus) {
		var result = _setValueResult();
		// copy from xBlock to yBlock (search in xPlus column)
		for (var _y = 0; _y < itemsCount; _y++) {
			if (afterPlus) {
				// bottom from +
				result &= _checkBlockValue(xBlock, xLinePlus, _y, yBlock, _y, yLinePlus);
			} else {
				// top from +
				result &= _checkBlockValue(xBlock, xLinePlus, _y, yBlock, yLinePlus, _y);
			}
		}
		return result;
	}

	_setValueResult _setCalculatedHorizontalBlockValues(int xLinePlus, int yLinePlus,
			_LogicalBlock xBlock, _LogicalBlock yBlock, bool afterPlus) {
		var result = _setValueResult();
		// copy from yBlock to xBlock (search in yPlus row)
		for (var _x = 0; _x < itemsCount; _x++) {
			if (afterPlus) {
				// right from +
				result &= _checkBlockValue(yBlock, _x, yLinePlus, xBlock, xLinePlus, _x);
			} else {
				// left from +
				result &= _checkBlockValue(yBlock, _x, yLinePlus, xBlock, _x, xLinePlus);
			}
		}
		return result;
	}

	_setValueResult _checkBlockValue(_LogicalBlock sourceBlock, int xSourceLine, int ySourceLine,
			_LogicalBlock targetBlock, int xTargetLine, int yTargetLine) {
		var _value = sourceBlock.getValue(xSourceLine, ySourceLine);
		if (_value != null) {
			return targetBlock.setValueAndCalculated(xTargetLine, yTargetLine, _value);
		} else {
			_value = targetBlock.getValue(xTargetLine, yTargetLine);
			if (_value != null) {
				return sourceBlock.setValueAndCalculated(xSourceLine, ySourceLine, _value);
			}
		}
		return _setValueResult();
	}

	bool _validPosition(int x, int y) {
		return !(y < 0 || y >= getMaxLineLength() || x < 0 || x >= getLineLength(y));
	}

	void _generateBlocks() {
		blocks = List<List<_LogicalBlock>>.generate(
				_getMaxBlockLength(), (index) => List<_LogicalBlock>.generate(
				_getBlockLength(index), (index) => _LogicalBlock(itemsCount)));
	}

	void _generateItems() {
		logicalItems = List<List<String>>.generate(
				categoriesCount, (rowIndex) => List<String>.generate(
				itemsCount, (lineIndex) => rowIndex.toString() + lineIndex.toString()));
	}

	String blocksToString() {
		var output = '';
		for (var blockRow in blocks) {
			output += '[';
			for (var block in blockRow) {
				output += '[';
				output += block.toString();
				output += ']';
			}
			output += ']';
		}

		return output.replaceAll('null', '').replaceAll(' ', '');
	}

	static const String _jsonItems = 'items';
	static const String _jsonDataMinus = 'n';
	static const String _jsonDataPlus = 'p';
	static const String _jsonItemsCount = 'ni';
	static const String _jsonCategoriesCount = 'nc';

	static Logical parseJson(String jsonString) {
		var logical = Logical(minItemCount, minItemCount);
		var jsonMap = asJsonMap(json.decode(jsonString));

		var data = jsonMap[_jsonItemsCount];
		if (getJsonType(data) == JsonType.SIMPLE_TYPE) {
			logical.itemsCount = int.tryParse(data.toString()) ?? minItemCount;
			if (logical.itemsCount > 99) {
				logical.itemsCount = 99;
				logical.state = LogicalState.InvalidData;
			} else if (logical.itemsCount < minItemCount) {
				logical.itemsCount = minItemCount;
				logical.state = LogicalState.InvalidData;
			}
		} else {
			logical.state = LogicalState.InvalidData;
		}

		data = jsonMap[_jsonCategoriesCount];
		if (getJsonType(data) == JsonType.SIMPLE_TYPE) {
			logical.categoriesCount = int.tryParse(data.toString()) ?? minItemCount;
			if (logical.categoriesCount > maxCategoriesCount) {
				logical.categoriesCount = maxCategoriesCount;
				logical.state = LogicalState.InvalidData;
			} else if (logical.categoriesCount < minItemCount) {
				logical.categoriesCount = minItemCount;
				logical.state = LogicalState.InvalidData;
			}
		} else {
			logical.state = LogicalState.InvalidData;
		}

		logical = Logical(logical.categoriesCount, logical.itemsCount);

		var list = asJsonArrayOrNull(jsonMap[_jsonItems]);
		if (list != null) {
			logical.logicalItems = _jsonArrayToArrayList(list);
		} else {
			logical.state = LogicalState.InvalidItemData;
		}

		logical = _jsonImportData(jsonMap[_jsonDataPlus], plusValue, logical);
		logical = _jsonImportData(jsonMap[_jsonDataMinus], minusValue, logical);

		return logical;
	}

	static Logical _jsonImportData(Object? data, int value, Logical logical) {
		var list = asJsonArrayOrNull(data);
		if (list != null) {
			for (var element in list) {
				if (element is String) {
					var entry = _jsonValueFromString(element, logical);
					if (entry != null) {
						if (!logical.setValue(entry.x, entry.y, value, LogicalFillType.USER_FILLED)) {
							logical.state = LogicalState.InvalidData;
							logical.setValue(entry.x, entry.y, null, LogicalFillType.CALCULATED);
						}
					} else {
						logical.state = LogicalState.InvalidData;
					}
				}
			}
		}
		return logical;
	}

	static List<List<String>> _jsonArrayToArrayList(List<Object?> jsonList) {
		var list = <List<String>>[];
		for (var entrys in jsonList) {
			var subList = asJsonArrayOrNull(entrys);
			if (subList != null) {
				list.add(_jsonArrayToList(subList));
			}
		}
		return list;
	}

	static List<String> _jsonArrayToList(List<Object?> jsonList) {
		var list = <String>[];
		for (var entry in jsonList) {
			var value = toStringOrNull(entry);
			if (value != null) list.add(value);
		}
		return list;
	}

	String? toJson() {
		var jsonDataMinus = <String>[];
		var jsonDataPlus = <String>[];
		for (var y = 0; y < getMaxLineLength(); y++) {
			for (var x = 0; x < getLineLength(y); x++) {
				if (getFillType(x, y) == LogicalFillType.USER_FILLED) {
					if (getValue(x, y) == minusValue) {
						jsonDataMinus.add(_jsonValueToString(x, y, this));
					} else {
						jsonDataPlus.add(_jsonValueToString(x, y, this));
					}
				}
			}
		}
		Map<String, Object> list = ({
			_jsonItems: logicalItems,
			_jsonDataMinus: jsonDataMinus,
			_jsonCategoriesCount: categoriesCount,
			_jsonItemsCount: itemsCount,
			_jsonDataPlus: jsonDataPlus
		});

		return jsonEncode(list);
	}

	static String _jsonValueToString(int x, int y, Logical logical) {
		if (!logical._validPosition(x, y)) return '';
		return alphabet_AZIndexes[
		logical.mapColumnToRowBlockIndex(logical.blockIndex(x)) + 1]!.toLowerCase() + logical.blockLine(x).toString() +
				alphabet_AZIndexes[logical.blockIndex(y) + 2]!.toLowerCase() + logical.blockLine(y).toString();
	}

	static Point<int>? _jsonValueFromString(String value, Logical logical) {
		return Point<int>(logical.fullLine(logical._mapRowToColumnBlockIndex(alphabet_AZ[value[0].toUpperCase()]!) - 1,
				int.tryParse(value[1]) ?? 0),
				logical.fullLine(alphabet_AZ[value[2].toUpperCase()]! - 2, int.tryParse(value[3]) ?? 0));
	}
}

class _LogicalSupporterSolution {
	final List<List<int?>> solution;

	_LogicalSupporterSolution(this.solution);

	int? getValue (int x, int y) {
		if (y < 0 || y >= solution.length || x < 0 || x >= solution[y].length) return null;
		return solution[y][x];
	}
}

class _setValueResult {
	bool validChange;
	bool valueChanged;

	_setValueResult({this.validChange = true, this.valueChanged = false});

	_setValueResult operator &(_setValueResult result) {
		validChange &= result.validChange;
		valueChanged |= result.valueChanged;
		return this;
	}
}
