var PHONEMODEL_NOKIA_3330_STATES = '''

'PlantUML

@startuml
'https://plantuml.com/state-diagram
[*] --> Abc

Abc --> abc_s: #
Abc --> abc: x_
Abc --> abc_e: ?

abc_s --> ABC_s: #
abc_s --> abc_s: x_?

ABC_s --> Abc: #
ABC_s --> ABC: x_
ABC_s --> ABC_e: ?

abc --> ABC: #
abc --> abc_e: ?
abc --> abc: x_

ABC --> abc: #
ABC --> ABC: x_
ABC --> ABC_e: ?

abc_e --> abc_e: ?
abc_e --> Abc: _
abc_e --> abc: x
abc_e --> ABC_e: #

ABC_e --> ABC: x
ABC_e --> ABC_e_: _
ABC_e --> ABC_e: ?
ABC_e --> abc_e: #

ABC_e_ --> ABC: x_
ABC_e_ --> Abc: *
ABC_e_ --> ABC_e: ?
@enduml

''';
