var PHONEMODEL_SAMSUNG_GTE1170_STATES = '''

'PlantUML

@startuml
'https://plantuml.com/state-diagram
[*] --> Abc

Abc --> ABC_s: #
Abc --> abc: x_
Abc --> abc_e: ?

abc --> abc: x_
abc --> abc_e: ?
abc --> 123: #

abc_e --> abc_e: ?
abc_e --> Abc: _
abc_e --> abc: x
abc_e --> 123_e: #

' _ not possible
123_e --> 123: x
123_e --> ABC_e: #
123_e --> 123_e: ?

ABC_e --> ABC_s: _
ABC_e --> ABC: x
ABC_e --> abc_e: #
ABC_e --> ABC_e: ?

ABC_s --> abc_s: #
ABC_s --> ABC: x_
ABC_s --> ABC_e: ?

ABC --> ABC: x_
ABC --> abc: #
ABC --> ABC_e: ?

abc_s --> abc: x_
abc_s --> 123_s: #
abc_s --> abc_e: ?

'_ not possible
123_s --> 123: x
123_s --> 123_e: ?
123_s --> Abc: #

'_ not possible
123 --> 123: x
123 --> ABC: #
123 --> 123_e: ?
@enduml

''';
