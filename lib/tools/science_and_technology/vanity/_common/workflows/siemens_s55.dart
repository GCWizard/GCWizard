var PHONEMODEL_SIEMENS_S55_STATES = '''

'PlantUML

@startuml
'https://plantuml.com/state-diagram
[*] --> Abc_s1

Abc_s1 --> Abc_s1: _
Abc_s1 --> Abc_s2: #
Abc_s1 --> abc_p: x
Abc_s1 --> abc_e: ?

Abc_s2 --> Abc_s1: _
Abc_s2 --> abc_s: #
Abc_s2 --> abc_p: x
Abc_s2 --> abc_e: ?

abc_s --> abc: x
abc_s --> Abc: #
abc_s --> Abc_s1: _
abc_s --> abc_e: ?

Abc --> abc_p: x
Abc --> 123: #
Abc --> Abc_s1: _
Abc --> abc_e: ?

123 --> 123: x?_
123 --> abc_s: #

abc_p --> ABC: #
abc_p --> abc: x_
abc_p --> abc_e: ?

ABC --> ABC: x_
ABC --> ABC_e: ?
ABC --> abc_t: #

abc_t --> abc: x_
abc_t --> ABC_t: #
abc_t --> abc_e: ?

ABC_t --> 123_t: #
ABC_t --> ABC: x
ABC_t --> ABC_e: ?_

123_t --> 123: x?_
123_t --> abc_t: #

abc --> abc: x_
abc --> Abc_s2: #
abc --> abc_e: ?

ABC_e --> ABC: x
ABC_e --> ABC_e: _
ABC_e --> abc_s: #
ABC_e --> abc: ?

abc_e --> Abc_s1: _
abc_e --> Abc_s2: #
abc_e --> abc_e: ?
abc_e --> abc: x
@enduml

''';
