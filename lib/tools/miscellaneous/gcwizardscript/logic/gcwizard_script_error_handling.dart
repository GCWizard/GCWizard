part of 'package:gc_wizard/tools/miscellaneous/gcwizardscript/logic/gcwizard_script.dart';

// internal representation of the GCW Script error types
const _SYNTAXERROR = 0;
const _UNBALANCEDPARENTHESES = 1;
const _NOEXPRESSION = 2;
const _DIVISIONBYZERO = 3;
const _EQUALEXPECTED = 4;
const _NOTAVARIABLE = 5;
const _LABELTABLEFULL = 6;
const _DUPLICATEABEL = 7;
const _LABELNOTDEFINED = 8;
const _THENEXPECTED = 9;
const _TOEXPECTED = 10;
const _NEXTWITHOUTFOR = 11;
const _RETURNWITHOUTGOSUB = 12;
const _MISSINGQUOTE = 13;
const _FILENOTFOUND = 14;
const _FILEIOERROR = 15;
const _INPUTIOERROR = 16;
const _SYNTAX_VARIABLE = 17;
const _INPUTMISSING = 18;
const _INVALIDTYPECAST = 19;
const _INVALIDSTRINGOPERATION = 20;
const _UNTILWITHOUTREPEAT = 21;
const _WENDWITHOUTWHILE = 22;
const _WHILEWITHOUTWEND = 23;
const _MISSINGPARAMETER = 24;
const _LOCATIONPERMISSIONDENIED = 25;
const _DATAOUTOFRANGE = 26;
const _INVALIDSCREEN = 27;
const _INFINITELOOP = 28;
const _INVALIDLATITUDE = 29;
const _INVALIDLONGITUDE = 30;
const _RANGEERROR = 31;
const _INVALIDBASETYPE = 32;
const _INVALIDHASHTYPE = 33;
const _INVALIDHASHBITRATE = 34;
const _MISSINGENDIF = 35;
const _SWITCHWITHOUTEND = 36;
const _REPEATWITHOUTUNTIL = 37;
const _FORWITHOUTNEXT = 38;
const _PRINTERROR = 39;
const _INVALIDCOORDINATEFORMAT = 40;
const _LISTNOTDEFINED = 41;
const _INVALIDNUMBEROFPARAMETER = 42;
const _RUNTIMEERROREOFEXCEEDED = 43;
const _IOERRORFILENOTOPEN = 44;
const _FILEMISSING = 45;
const _FILESAVING = 46;
const _INVALIDTARGETVALUE = 47;

Map<int, String> _errorMessages = {
  _SYNTAXERROR: "gcwizard_script_syntax_error",
  _UNBALANCEDPARENTHESES: "gcwizard_script_unbalanced_parentheses",
  _NOEXPRESSION: "gcwizard_script_no_expression_present",
  _DIVISIONBYZERO: "gcwizard_script_division_by_zero",
  _EQUALEXPECTED: "gcwizard_script_equal_sign_expected",
  _NOTAVARIABLE: "gcwizard_script_not_a_variable",
  _LABELTABLEFULL: "gcwizard_script_label_table_full",
  _DUPLICATEABEL: "gcwizard_script_duplicate_label",
  _LABELNOTDEFINED: "gcwizard_script_undefined_label",
  _THENEXPECTED: "gcwizard_script_then_expected",
  _TOEXPECTED: "gcwizard_script_to expected",
  _NEXTWITHOUTFOR: "gcwizard_script_next_without_for",
  _RETURNWITHOUTGOSUB: "gcwizard_script_return_without_gosub",
  _MISSINGQUOTE: "gcwizard_script_closing_quotes_needed",
  _FILENOTFOUND: "gcwizard_script_file_not_found",
  _FILEIOERROR: "gcwizard_script_io_error_while_loading_file",
  _INPUTIOERROR: "gcwizard_script_io_error_on_input_statement",
  _SYNTAX_VARIABLE: "gcwizard_script_syntax_error_on_input_statement",
  _INPUTMISSING: "gcwizard_script_io_error_input_missing",
  _INVALIDTYPECAST: "gcwizard_script_casting_error",
  _INVALIDSTRINGOPERATION: "gcwizard_script_invalid_string_operation",
  _UNTILWITHOUTREPEAT: "gcwizard_script_until_without_repeat",
  _WENDWITHOUTWHILE: "gcwizard_script_wend_without_while",
  _WHILEWITHOUTWEND: "gcwizard_script_while_without_wend",
  _MISSINGPARAMETER: "gcwizard_script_parameter_missing",
  _LOCATIONPERMISSIONDENIED: "gcwizard_script_location_permission_denied",
  _DATAOUTOFRANGE: "gcwizard_script_data_outofrange",
  _INVALIDSCREEN: "gcwizard_script_invalidscreen",
  _INFINITELOOP: "gcwizard_script_infiniteloop",
  _INVALIDLATITUDE: "gcwizard_script_invalid_lat",
  _INVALIDLONGITUDE: "gcwizard_script_invalid_lon",
  _RANGEERROR: "gcwizard_script_range_error",
  _INVALIDBASETYPE: "gcwizard_script_invalid_basetype",
  _INVALIDHASHTYPE: "gcwizard_script_invalid_hashtype",
  _INVALIDHASHBITRATE: "gcwizard_script_invalid_hashbitrate",
  _MISSINGENDIF: "gcwizard_script_syntax_error_missing_endif",
  _SWITCHWITHOUTEND: "gcwizard_script_syntax_error_missing_endswitch",
  _REPEATWITHOUTUNTIL: "gcwizard_script_syntax_error_repeat_without_until",
  _FORWITHOUTNEXT: "gcwizard_script_syntax_error_for_without_next",
  _INVALIDCOORDINATEFORMAT: "gcwizard_script_syntax_error_invalid_coordinate_format",
  _LISTNOTDEFINED: "gcwizard_script_syntax_error_list_not_defined",
  _INVALIDNUMBEROFPARAMETER: "gcwizard_script_syntax_error_invalid_number_of_parameters",
  _RUNTIMEERROREOFEXCEEDED: "gcwizard_script_runtime_error_eof_exceeded",
  _IOERRORFILENOTOPEN: "gcwizard_script_io_error_on_openfile_statement",
  _FILEMISSING: "gcwizard_script_io_error_file_missing",
  _FILESAVING: "gcwizard_script_io_error_file_saving",
  _INVALIDTARGETVALUE: "gcwizard_script_for_loop_invalid_target_value",
};

void _resetErrors() {
  _state.halt = false;
  _state.errorMessage = '';
  _state.errorPosition = 0;
}

void _handleError(int error) {
  _state.halt = true;
  _state.errorMessage = _errorMessages[error] ?? '';
  _state.errorPosition = _state.scriptIndex;
  _state.scriptIndex = _state.script.length - 1;
}
