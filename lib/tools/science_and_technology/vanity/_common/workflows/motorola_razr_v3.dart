var PHONEMODEL_MOTOROLA_RAZRV3_STATES = '''

'PlantUML

@startuml
'https://plantuml.com/state-diagram
[*] --> Abc

Abc --> Abc: _
Abc --> ABC: 0
Abc --> abc: x
Abc --> abc_e: ?
Abc --> 123_e: #

ABC --> ABC: x_
ABC --> ABC_e: ?
ABC --> abc: 0
ABC --> 123: #

abc --> Abc: 0
abc --> abc: x_
abc --> abc_e: ?
abc --> 123: #

abc_e --> abc_e: ?
abc_e --> Abc: _0
abc_e --> abc: x
abc_e --> 123_pe: #

ABC_e --> ABC_e: ?_
ABC_e --> ABC: x
ABC_e --> abc_e: 0
ABC_e --> 123_pe: #

'0? not possible
123_pe --> 123: x
123_pe --> 123_e: _
123_pe --> char_pe: #

'0? not possible
123 --> 123: x_
123 --> char: #

'0? not possible
123_e --> 123: x
123_e --> 123_e: _
123_e --> char_e: #

'0 not possible
char --> abc: #
char --> char: x_
char --> char_pe: ?

'0 not possible
char_pe --> abc_e: #
char_pe --> char_e: _
char_pe --> char: x
char_pe --> char_pe: ?

'0 not possible
char_e --> char_e: _
char_e --> char: x
char_e --> char_pe: ?
char_e --> Abc: #

@enduml

''';
