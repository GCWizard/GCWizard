var PHONEMODEL_SIEMENS_S35_STATES = '''

'PlantUML

@startuml
'https://plantuml.com/state-diagram
[*] --> Abc

Abc --> abc: ?_x*
Abc --> 123_Abc: #

abc --> abc: ?_x
abc --> Abc: *
abc --> 123_abc: #

'_? not possible
123_Abc --> Abc: #
123_Abc --> 123_abc: x
123_Abc --> abc: *

'_? not possible
123_abc --> abc: #
123_abc --> 123_abc: x
123_abc --> Abc: *
@enduml

''';
