var PHONEMODEL_SONYERICSSON_K700I_STATES = '''

'PlantUML

@startuml
'https://plantuml.com/state-diagram
[*] --> Abc_s

Abc_s --> Abc_s: _
Abc_s --> abc_s: *
Abc_s --> abc: x
Abc_s --> abc_e: ?

abc_s --> ABC_s: *
abc_s --> abc: x
abc_s --> abc_e: ?
abc_s --> Abc_s: _

ABC_s --> Abc_s: *_
ABC_s --> ABC_e: ?
ABC_s --> ABC: x

abc --> abc: x_
abc --> abc_e: ?
abc --> Abc: *

Abc --> abc: x_
Abc --> ABC: *
Abc --> abc_e: ?

ABC --> ABC: x_
ABC --> ABC_e: ?
ABC --> abc: *

ABC_e --> ABC_e: ?
ABC_e --> Abc_s: _
ABC_e --> abc_e: *
ABC_e --> ABC: x

abc_e --> abc_e: ?
abc_e --> Abc_s: _
abc_e --> abc: x
abc_e --> Abc_e: *

Abc_e --> Abc_s: _
Abc_e --> ABC_e: *
Abc_e --> abc: x
Abc_e --> abc_e: ?

@enduml

''';
