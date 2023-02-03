var PHONEMODEL_SAMSUNG_E1120_STATES = '''

'PlantUML

@startuml
'https://plantuml.com/state-diagram
[*] --> Abc

Abc --> ABC: *
Abc --> abc_e: ?
Abc --> abc: x_

ABC --> ABC_e: ?
ABC --> abc: *
ABC --> ABC: x_

abc --> abc: x_
abc --> abc_e: ?
abc --> 123: *

'? not possible
123 --> 123: x_
123 --> Abc: *

abc_e --> Abc: _
abc_e --> abc: x
abc_e --> abc_e: ?
abc_e --> 123_e: *

'? not possible
123_e --> Abc_e: *
123_e --> 123: x_

Abc_e --> ABC_e: *
Abc_e --> abc: x
Abc_e --> abc_e: ?

ABC_e --> ABC: x_
ABC_e --> abc_e: *
ABC_e --> ABC_e: ?
@enduml

''';
