var PHONEMODEL_SONYERICSSON_T300_STATES = '''

'PlantUML

@startuml
'https://plantuml.com/state-diagram
[*] --> Abc

Abc --> Abc: _
Abc --> abc_e: ?
Abc --> abc_s: *
Abc --> abc: x

abc_s --> Abc: _*
abc_s --> abc: x
abc_s --> abc_e: ?

abc --> abc: x_
abc --> abc_e: ?
abc --> ABC: *

ABC --> ABC: x_?
ABC --> abc: *

abc_e --> abc_e: ?
abc_e --> Abc: _
abc_e --> abc: x
abc_e --> ABC_e: *

ABC_e --> ABC: x
ABC_e --> ABC_e: ?
ABC_e --> ABC_e_: _
ABC_e --> abc_e: *

ABC_e_ --> ABC_e_: _
ABC_e_ --> abc_E : *
ABC_e_ --> ABC: x
ABC_e_ --> ABC_e: ?

abc_E --> ABC: _
abc_E --> abc: x
abc_E --> ABC_e: ?
abc_E --> ABC_e_: *

@enduml

''';
