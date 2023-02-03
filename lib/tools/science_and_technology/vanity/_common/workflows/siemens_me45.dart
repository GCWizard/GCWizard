var PHONEMODEL_SIEMENS_ME45_STATES = '''

'PlantUML

@startuml
'https://plantuml.com/state-diagram
[*] --> Abc

Abc --> Abc: _
Abc --> 123: *
Abc --> abc_e: ?
Abc --> abc: x

'?_ not possible
123 --> 123: x
123 --> abc: *

abc --> abc: x_
abc --> abc_e: ?
abc --> Abc: *

abc_e --> abc_e: ?
abc_e --> Abc: _
abc_e --> abc: x
abc_e --> Abc_e: *

Abc_e --> Abc: _
Abc_e --> 123_e: *
Abc_e --> abc: x
Abc_e --> abc_e: ?

'?_ not possible
123_e --> 123: x
123_e --> abc_e: *
@enduml

''';
