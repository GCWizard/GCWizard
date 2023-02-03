var PHONEMODEL_NOKIA_1650_STATES = '''

'PlantUML

@startuml
'https://plantuml.com/state-diagram
[*] --> Abc_s

Abc_s --> ABC_s: #
Abc_s --> abc_t: _
Abc_s --> abc: ?x

ABC_s --> abc_s: #
ABC_s --> ABC: ?x
ABC_s --> ABC_t: _

abc_s --> Abc_s: #
abc_s --> abc: ?x
abc_s --> abc_t: _

abc --> ABC: #
abc --> abc: x_
abc --> abc_e: ?

ABC --> abc: #
ABC --> ABC: x_
ABC --> ABC_e: ?

abc_t --> Abc_t: #
abc_t --> abc: x
abc_t --> abc_t: _
abc_t --> abc_e: ?

Abc_t --> ABC_t: #
Abc_t --> abc_t: _
Abc_t --> abc_e: ?
Abc_t --> abc: x

ABC_t --> abc_t: #
ABC_t --> ABC_t: _
ABC_t --> ABC: x
ABC_t --> ABC_e: ?

abc_e --> Abc_e: _
abc_e --> ABC_e: #
abc_e --> abc_e: ?
abc_e --> abc: x

Abc_e --> abc_t: _#
Abc_e --> abc_e: ?
Abc_e --> abc: x

ABC_e --> abc_e: #
ABC_e --> ABC_e: ?
ABC_e --> ABC: x_
@enduml

''';
