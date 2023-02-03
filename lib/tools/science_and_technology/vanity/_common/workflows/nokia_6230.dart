var PHONEMODEL_NOKIA_6230_STATES = '''

'PlantUML

@startuml
'https://plantuml.com/state-diagram
[*] --> Abc

Abc --> Abc_: _
Abc --> abc: x#
Abc --> abc_e: ?

Abc_ --> abc: x_#
Abc_ --> abc_e: ?

abc --> abc: x_
abc --> abc_e: ?
abc --> ABC: #

ABC --> abc: #
ABC --> ABC_e: ?
ABC --> ABC: x_

ABC_e --> ABC: x
ABC_e --> Abc_: _
ABC_e --> ABC_e: ?
ABC_e --> abc_e: #

abc_e --> Abc_: _
abc_e --> abc: x
abc_e --> abc_e: ?
abc_e --> ABC_e: #
@enduml

''';
