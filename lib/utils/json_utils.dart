enum JsonType {MAP, ARRAY, SIMPLE_TYPE}

JsonType? getJsonType(Object? decodedJson) {
  if (decodedJson == null) {
    return null;
  }

  if (isJsonMap(decodedJson)) {
    return JsonType.MAP;
  }

  if (isJsonArray(decodedJson)){
    return JsonType.ARRAY;
  }

  return JsonType.SIMPLE_TYPE;
}

bool isJsonMap(Object? decodedJson) {
  if (decodedJson == null) return false;

  return decodedJson is Map<String, Object?>;
}

Map<String, Object?>? asJsonMapOrNull(Object? decoded) {
  if (decoded == null || !(isJsonMap(decoded))) {
    return null;
  }

  return decoded as Map<String, Object?>;
}

Map<String, Object?> asJsonMap(Object? decoded) {
  if (decoded == null || !(isJsonMap(decoded))) {
    return <String, Object?>{};
  }

  return decoded as Map<String, Object?>;
}

bool isJsonArray(Object? decodedJson) {
  if (decodedJson == null) return false;

  return decodedJson is List<Object?>;
}