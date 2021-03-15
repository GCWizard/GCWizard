List<MultiDecoderTool> multiDecoderTools = [];

MultiDecoderTool findMultiDecoderToolById(int id) {
  return multiDecoderTools.firstWhere((tool) => tool.id == id);
}

class MultiDecoderTool {
  int id;
  String name;
  String internalToolName;
  List<MultiDecoderToolOption> options;

  MultiDecoderTool(this.name, this.internalToolName, {this.options: const []});

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'decoderFunctionName': internalToolName,
        'options': options.map((formula) => formula.toMap()).toList()
      };

  MultiDecoderTool.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        internalToolName = json['decoderFunctionName'],
        options =
            List<MultiDecoderToolOption>.from(json['options'].map((option) => MultiDecoderToolOption.fromJson(option)));

  @override
  String toString() {
    return toMap().toString();
  }
}

class MultiDecoderToolOption {
  String name;
  dynamic value;

  MultiDecoderToolOption(this.name, this.value);

  Map<String, dynamic> toMap() => {'name': name, 'value': value};

  MultiDecoderToolOption.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        value = json['value'];

  @override
  String toString() {
    return toMap().toString();
  }
}
