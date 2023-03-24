import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/karol_robot/logic/karol_robot.dart';

void main() {
  group("KarolRobot.interpret:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      // {'code' : null, 'expectedOutput' : ''},
      {'code' : '', 'expectedOutput' : ''},

      // https://www.geocaching.com/geocache/GC4ZE0V_sauerbrunnen-ii
      {'code' : 'Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Linksdrehen Linksdrehen Schritt Schritt Schritt Schritt Schritt Rechtsdrehen Hinlegen Schritt Rechtsdrehen Hinlegen Schritt Linksdrehen Schritt Rechtsdrehen Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Linksdrehen Schritt Rechtsdrehen Hinlegen Schritt Hinlegen Schritt Schritt Linksdrehen Schritt Linksdrehen Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Rechtsdrehen Schritt Schritt Schritt Schritt Hinlegen Schritt Rechtsdrehen Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Linksdrehen Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Linksdrehen Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Linksdrehen Linksdrehen Schritt Schritt Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Linksdrehen Schritt Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Linksdrehen Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Linksdrehen Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Linksdrehen Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Linksdrehen Hinlegen Schritt Hinlegen Schritt Schritt Linksdrehen Schritt Rechtsdrehen Schritt Schritt Hinlegen Schritt Hinlegen Schritt Linksdrehen Hinlegen Schritt Hinlegen Schritt Linksdrehen Hinlegen Schritt Hinlegen Schritt Linksdrehen Hinlegen Schritt Hinlegen Schritt Linksdrehen Linksdrehen Schritt Schritt Rechtsdrehen Schritt Schritt Schritt Hinlegen Schritt Rechtsdrehen Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Linksdrehen Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Linksdrehen Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Linksdrehen Linksdrehen Schritt Schritt Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Linksdrehen Schritt Schritt Schritt Linksdrehen Schritt Schritt Schritt Hinlegen Schritt Rechtsdrehen Schritt Linksdrehen Hinlegen Schritt Rechtsdrehen Schritt Linksdrehen Hinlegen Schritt Rechtsdrehen Rechtsdrehen Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Linksdrehen Schritt Hinlegen Schritt Schritt Linksdrehen Schritt Schritt Schritt Schritt Schritt Schritt Rechtsdrehen Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Rechtsdrehen Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Rechtsdrehen Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Linksdrehen Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Linksdrehen Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Schritt Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Linksdrehen Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt linksdrehen Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Linksdrehen Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Linksdrehen Schritt Schritt Schritt Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Linksdrehen Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Linksdrehen Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Rechtsdrehen Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Rechtsdrehen Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Rechtsdrehen Schritt Schritt Schritt Schritt Schritt Schritt Schritt Rechtsdrehen Schritt Schritt Schritt Schritt Schritt Schritt Schritt Schritt Schritt Schritt Schritt Schritt Schritt Schritt Schritt Schritt Schritt Schritt Schritt Schritt Schritt Schritt Schritt Schritt Schritt Schritt Schritt Schritt Schritt Schritt Schritt Schritt Schritt Schritt Schritt Schritt Schritt Schritt Schritt Schritt Schritt Schritt Schritt Schritt Schritt Schritt Schritt Schritt Schritt Linksdrehen Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Linksdrehen Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Linksdrehen Schritt Schritt Schritt Linksdrehen Hinlegen Schritt Hinlegen Schritt Rechtsdrehen Schritt Schritt Hinlegen Schritt Rechtsdrehen Hinlegen Schritt Hinlegen Schritt Schritt Rechtsdrehen Schritt Schritt Schritt Schritt Schritt Schritt Linksdrehen Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Linksdrehen Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt linksdrehen Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Linksdrehen Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Linksdrehen Schritt Schritt Schritt Schritt Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Linksdrehen Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt linksdrehen Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Linksdrehen Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Linksdrehen Schritt Schritt Schritt Schritt Schritt Hinlegen Schritt Linksdrehen Hinlegen Schritt Hinlegen Schritt Rechtsdrehen Schritt Linksdrehen Hinlegen Schritt Hinlegen Schritt Rechtsdrehen Schritt Linksdrehen Hinlegen Schritt Hinlegen Schritt Linksdrehen Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Linksdrehen Schritt Schritt Schritt Linksdrehen Schritt Schritt Schritt Linksdrehen Schritt Rechtsdrehen Schritt Schritt Hinlegen Schritt Hinlegen Schritt Linksdrehen Hinlegen Schritt Hinlegen Schritt Linksdrehen Hinlegen Schritt Hinlegen Schritt Linksdrehen Hinlegen Schritt Hinlegen Schritt Linksdrehen Linksdrehen Schritt Schritt Rechtsdrehen Schritt Schritt Schritt Rechtsdrehen Schritt Schritt Schritt Schritt Schritt Schritt Linksdrehen Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Linksdrehen Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt linksdrehen Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Linksdrehen Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Linksdrehen Schritt Schritt Schritt Schritt Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Linksdrehen Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt linksdrehen Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Linksdrehen Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Linksdrehen Schritt Schritt Schritt Schritt Linksdrehen Schritt Schritt Schritt Linksdrehen Schritt Hinlegen Schritt Hinlegen Linksdrehen Linksdrehen Schritt Schritt Rechtsdrehen Schritt Schritt Schritt Linksdrehen Hinlegen Schritt Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Linksdrehen Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Linksdrehen Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Rechtsdrehen Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Rechtsdrehen Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Rechtsdrehen Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Rechtsdrehen Hinlegen Schritt Hinlegen Schritt Rechtsdrehen Rechtsdrehen Schritt Schritt Rechtsdrehen Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Rechtsdrehen Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Linksdrehen Linksdrehen Schritt Schritt Schritt Schritt Schritt Linksdrehen Schritt Schritt Schritt Linksdrehen Linksdrehen Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Linksdrehen Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Linksdrehen Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Linksdrehen Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Rechtsdrehen Hinlegen Schritt Hinlegen Schritt Hinlegen Schritt Rechtsdrehen Hinlegen Schritt Hinlegen Schritt Hinlegen',
        'expectedOutput' :
            '######################################################\n'
            '######################################################\n'
            '######################################################\n'
            '##88##8####8##8##8888#888#8##8####8###8888#8888#8888##\n'
            '##88##8####8##8##8##8#8#8#8##8###88######8#8##8#8#####\n'
            '##8#8#8####8##8##8##8#888#8##8##8#8######8#8##8#8#####\n'
            '##8#8#8####88888#8888#####88888###8###8888#8##8#8888##\n'
            '##8#8#8#######8#####8########8####8###8####8##8####8##\n'
            '##8##88#######8#####8########8####8###8####8##8####8##\n'
            '##8##88#######8##8888########8####8#8#8888#8888#8888##\n'
            '######################################################\n'
            '######################################################\n'
            '##8888#8888#8888#8888#888#8888#8888###8888#8888#8888##\n'
            '##8####8##8#8##8####8#8#8#8##8#8##8###8#######8#8#####\n'
            '##8####8##8#8##8###8##888#8##8#8##8###8#######8#8#####\n'
            '##888##8##8#8##8###8######8##8#8888###8888##888#8888##\n'
            '##8####8##8#8##8##8#######8##8#8##8######8####8#8##8##\n'
            '##8####8##8#8##8##8#######8##8#8##8######8####8#8##8##\n'
            '##8888#8888#8888##8#######8888#8888#8#8888#8888#8888##\n'
            '######################################################\n'
            '######################################################'
            ''},
      // generated
      {'code' : 'schritt(2) linksdrehen schritt(4) markesetzen linksdrehen schritt linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt linksdrehen schritt markesetzen schritt(6) rechtsdrehen schritt(3) rechtsdrehen schritt(3) markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen rechtsdrehen rechtsdrehen schritt(3) rechtsdrehen schritt markesetzen linksdrehen schritt schritt markesetzen rechtsdrehen schritt linksdrehen schritt markesetzen rechtsdrehen schritt rechtsdrehen schritt markesetzen schritt schritt markesetzen rechtsdrehen schritt markesetzen linksdrehen schritt(3) linksdrehen schritt(2) linksdrehen markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt(3) rechtsdrehen schritt(3) rechtsdrehen schritt(2) linksdrehen schritt(4) markesetzen linksdrehen schritt linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt linksdrehen schritt markesetzen schritt(6) rechtsdrehen schritt(3) rechtsdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen rechtsdrehen rechtsdrehen schritt(3) rechtsdrehen schritt markesetzen schritt markesetzen schritt markesetzen  schritt rechtsdrehen markesetzen schritt markesetzen schritt markesetzen schritt markesetzen rechtsdrehen rechtsdrehen schritt(4) markesetzen schritt markesetzen schritt markesetzen schritt rechtsdrehen schritt(3) rechtsdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen linksdrehen schritt(3) linksdrehen schritt(2) markesetzen schritt markesetzen rechtsdrehen schritt(3) rechtsdrehen markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt(3) linksdrehen schritt linksdrehen linksdrehen rechtsdrehen schritt(35) linksdrehen schritt(9)',
        'expectedOutput' :
            '########################################\n'
            '########################################\n'
            '###999#####9#####999###9###9##99999#####\n'
            '##9###9###9#9###9###9##9###9##9#########\n'
            '##9######9###9##9######9###9##9#########\n'
            '##9######99999##9######999#9##999#######\n'
            '##9######9###9##9######9###9##9#########\n'
            '##9###9##9###9##9###9##9###9##9#########\n'
            '###999###9###9###999###9###9##99999#####\n'
            '########################################\n'
            '########################################\n'
            '########################################\n'
            '########################################'
      },
      {'code' : 'move(2) turnleft move(4) putbeeper turnleft move turnleft move putbeeper move putbeeper move putbeeper move turnleft move putbeeper move putbeeper move putbeeper move putbeeper move putbeeper move turnleft move putbeeper move putbeeper move putbeeper move turnleft move putbeeper move(6) turnright move(3) turnright move(3) putbeeper move putbeeper move putbeeper move putbeeper move putbeeper turnright turnright move(3) turnright move putbeeper turnleft move move putbeeper turnright move turnleft move putbeeper turnright move turnright move putbeeper move move putbeeper turnright move putbeeper turnleft move(3) turnleft move(2) turnleft putbeeper move putbeeper move putbeeper move putbeeper move putbeeper move(3) turnright move(3) turnright move(2) turnleft move(4) putbeeper turnleft move turnleft move putbeeper move putbeeper move putbeeper move turnleft move putbeeper move putbeeper move putbeeper move putbeeper move putbeeper move turnleft move putbeeper move putbeeper move putbeeper move turnleft move putbeeper move(6) turnright move(3) turnright move putbeeper move putbeeper move putbeeper move putbeeper move putbeeper move putbeeper move putbeeper turnright turnright move(3) turnright move putbeeper move putbeeper move putbeeper  move turnright putbeeper move putbeeper move putbeeper move putbeeper turnright turnright move(4) putbeeper move putbeeper move putbeeper move turnright move(3) turnright move putbeeper move putbeeper move putbeeper move putbeeper move putbeeper move putbeeper move putbeeper turnleft move putbeeper move putbeeper move putbeeper move putbeeper turnleft move(3) turnleft move(2) putbeeper move putbeeper turnright move(3) turnright putbeeper move putbeeper move putbeeper move putbeeper move(3) turnleft move turnleft turnleft turnright move(35) turnleft move(9)',
        'expectedOutput' :
            '########################################\n'
            '########################################\n'
            '###999#####9#####999###9###9##99999#####\n'
            '##9###9###9#9###9###9##9###9##9#########\n'
            '##9######9###9##9######9###9##9#########\n'
            '##9######99999##9######999#9##999#######\n'
            '##9######9###9##9######9###9##9#########\n'
            '##9###9##9###9##9###9##9###9##9#########\n'
            '###999###9###9###999###9###9##99999#####\n'
            '########################################\n'
            '########################################\n'
            '########################################\n'
            '########################################'
      },
      {'code' : 'move move turnleft move move move move putbeeper turnleft move turnleft move putbeeper move putbeeper move putbeeper move turnleft move putbeeper move putbeeper move putbeeper move putbeeper move putbeeper move turnleft move putbeeper move putbeeper move putbeeper move turnleft move putbeeper move move move move move move turnright move move move turnright move move move putbeeper move putbeeper move putbeeper move putbeeper move putbeeper turnright turnright move move move turnright move putbeeper turnleft move move putbeeper turnright move turnleft move putbeeper turnright move turnright move putbeeper move move putbeeper turnright move putbeeper turnleft move move move turnleft move move turnleft putbeeper move putbeeper move putbeeper move putbeeper move putbeeper move move move turnright move move move turnright move move turnleft move move move move putbeeper turnleft move turnleft move putbeeper move putbeeper move putbeeper move turnleft move putbeeper move putbeeper move putbeeper move putbeeper move putbeeper move turnleft move putbeeper move putbeeper move putbeeper move turnleft move putbeeper move move move turnright move move move turnright move putbeeper move putbeeper move putbeeper move putbeeper move putbeeper move putbeeper move putbeeper turnright turnright move move move turnright move putbeeper move putbeeper move putbeeper  move turnright putbeeper move putbeeper move putbeeper move putbeeper turnright turnright move move move putbeeper move putbeeper move putbeeper move turnright move move move turnright move putbeeper move putbeeper move putbeeper move putbeeper move putbeeper move putbeeper move putbeeper turnleft move putbeeper move putbeeper move putbeeper move putbeeper turnleft move(3) turnleft move move move putbeeper move putbeeper turnright move move move turnright putbeeper move putbeeper move putbeeper move putbeeper move move move turnleft move turnleft turnleft turnright move move move move move move move move move move move move move move move move move move move move move move move move move move move move move move move move move move move turnleft move move move move move move move move move',
        'expectedOutput' :
            '#######################################\n'
            '#######################################\n'
            '###999#####9#####999###################\n'
            '##9###9###9#9###9###9##################\n'
            '##9######9###9##9######################\n'
            '##9######99999##9######9###############\n'
            '##9######9###9##9######9###9##9999#####\n'
            '##9###9##9###9##9###9##9###9##9########\n'
            '###999###9###9###999###999#9##9########\n'
            '#######################9###9##99#######\n'
            '#######################9###9##9########\n'
            '#######################9###9##9########\n'
            '##############################99999####\n'
            '#######################################\n'
            '#######################################\n'
            '#######################################\n'
            '#######################################'
      },
      {'code' : 'schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen linksdrehen schritt linksdrehen schritt(3) rechtsdrehen markesetzen schritt markesetzen linksdrehen schritt(3) linksdrehen schritt linksdrehen linksdrehen markesetzen schritt markesetzen schritt markesetzen schritt markesetzen linksdrehen schritt rechtsdrehen schritt(3) rechtsdrehen schritt linksdrehen markesetzen schritt rechtsdrehen markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen rechtsdrehen schritt markesetzen rechtsdrehen rechtsdrehen schritt(2) markesetzen linksdrehen schritt(6) markesetzen schritt(1) rechtsdrehen schritt(3) rechtsdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen rechtsdrehen rechtsdrehen schritt(6) rechtsdrehen schritt rechtsdrehen schritt markesetzen linksdrehen schritt rechtsdrehen schritt markesetzen schritt markesetzen schritt markesetzen linksdrehen schritt rechtsdrehen schritt markesetzen schritt linksdrehen schritt linksdrehen markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt rechtsdrehen schritt(3) rechtsdrehen schritt(3) markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen rechtsdrehen rechtsdrehen schritt(3) rechtsdrehen schritt markesetzen linksdrehen schritt schritt markesetzen rechtsdrehen schritt linksdrehen schritt markesetzen rechtsdrehen schritt rechtsdrehen schritt markesetzen schritt schritt markesetzen rechtsdrehen schritt markesetzen linksdrehen schritt(3) linksdrehen schritt(2) linksdrehen markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt(3) rechtsdrehen schritt(3) rechtsdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt(3) linksdrehen schritt(7) linksdrehen linksdrehen rechtsdrehen schritt(33) linksdrehen schritt(9) schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen rechtsdrehen rechtsdrehen schritt(6) rechtsdrehen schritt rechtsdrehen schritt markesetzen linksdrehen schritt rechtsdrehen schritt markesetzen schritt markesetzen schritt markesetzen linksdrehen schritt rechtsdrehen schritt markesetzen schritt linksdrehen schritt linksdrehen markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt rechtsdrehen schritt(3) rechtsdrehen linksdrehen schritt(7) rechtsdrehen linksdrehen schritt rechtsdrehen schritt markesetzen schritt markesetzen rechtsdrehen schritt linksdrehen schritt markesetzen schritt markesetzen linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen linksdrehen schritt(3) linksdrehen schritt linksdrehen schritt markesetzen schritt markesetzen schritt(2) markesetzen schritt markesetzen schritt markesetzen linksdrehen schritt(4) linksdrehen schritt(7) rechtsdrehen rechtsdrehen linksdrehen schritt(4) rechtsdrehen schritt markesetzen rechtsdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt rechtsdrehen schritt markesetzen schritt markesetzen schritt rechtsdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt rechtsdrehen schritt markesetzen schritt(6) rechtsdrehen schritt(7) rechtsdrehen linksdrehen schritt(4) rechtsdrehen schritt(2) markesetzen rechtsdrehen schritt rechtsdrehen schritt markesetzen linksdrehen schritt markesetzen schritt markesetzen schritt linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt rechtsdrehen schritt markesetzen schritt markesetzen schritt rechtsdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt rechtsdrehen schritt markesetzen schritt markesetzen schritt(5) rechtsdrehen schritt(7) rechtsdrehen rechtsdrehen schritt(35) linksdrehen schritt(9) schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen linksdrehen schritt(3) linksdrehen schritt(2) markesetzen schritt markesetzen rechtsdrehen schritt(3) rechtsdrehen markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt(3) linksdrehen schritt linksdrehen linksdrehen linksdrehen schritt(7) rechtsdrehen schritt markesetzen linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen rechtsdrehen schritt markesetzen schritt markesetzen rechtsdrehen schritt linksdrehen schritt markesetzen schritt markesetzen rechtsdrehen schritt linksdrehen schritt markesetzen schritt markesetzen linksdrehen schritt(5) linksdrehen schritt(7) rechtsdrehen rechtsdrehen schritt(3) linksdrehen linksdrehen markesetzen schritt markesetzen schritt rechtsdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt rechtsdrehen schritt markesetzen schritt markesetzen schritt rechtsdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt linksdrehen schritt markesetzen schritt markesetzen schritt linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt linksdrehen schritt markesetzen schritt markesetzen schritt(5) rechtsdrehen schritt(3) rechtsdrehen schritt schritt schritt markesetzen linksdrehen schritt linksdrehen schritt markesetzen rechtsdrehen schritt linksdrehen schritt markesetzen rechtsdrehen rechtsdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen rechtsdrehen rechtsdrehen schritt(7) rechtsdrehen schritt(3) rechtsdrehen rechtsdrehen schritt(33) linksdrehen schritt(9)',
        'expectedOutput' :
            '########################################\n'
            '########################################\n'
            '##99999##999##9###9####9####9###########\n'
            '##9#######9###99##9###9#9###9###########\n'
            '##9#######9###9#9#9##9###9##9###########\n'
            '##999#####9###9#9#9##99999##9###########\n'
            '##9#######9###9#9#9##9###9##9###########\n'
            '##9#######9###9##99##9###9##9###########\n'
            '##9######999##9###9##9###9##99999#######\n'
            '########################################\n'
            '########################################\n'
            '##9###9##########9#####99999###999######\n'
            '##99##9##########9#9###9######9###9#####\n'
            '##9#9#9#########9##9###9######9#########\n'
            '##9#9#9#########99999##9999###9999######\n'
            '##9#9#9############9#######9##9###9#####\n'
            '##9##99############9###9###9##9###9#####\n'
            '##9###9############9####999####999######\n'
            '########################################\n'
            '########################################\n'
            '##99999#########99999###999#####9#######\n'
            '##9#################9##9###9###99#######\n'
            '##9#################9##9###9##9#9#######\n'
            '##999##############9####999#####9#######\n'
            '##9################9###9###9####9#######\n'
            '##9###############9####9###9####9#######\n'
            '##99999###########9#####999#####9#######\n'
            '########################################\n'
            '########################################\n'
            '########################################\n'
            '########################################'
      },

      // showing all colors
      {'code' : 'hinlegen(schwarz) schritt hinlegen(weiss) schritt hinlegen(hellrot) schritt hinlegen(hellgelb) schritt hinlegen(hellgrün) schritt hinlegen(hellcyan) schritt hinlegen(hellblau) schritt hinlegen(hellmagenta) schritt hinlegen(rot) schritt hinlegen(gelb) schritt hinlegen(blau) schritt hinlegen(grün) schritt hinlegen(cyan) schritt hinlegen(magenta) schritt hinlegen(dunkelrot) schritt hinlegen(dunkelgelb) schritt hinlegen(dunkelgrün) schritt hinlegen(dunkelcyan) schritt hinlegen(dunkelblau) schritt hinlegen(dunkelmagenta) schritt hinlegen(orange) schritt hinlegen(hellorange) schritt hinlegen(dunkelorange) schritt hinlegen(braun) schritt hinlegen(dunkelbraun)',
        'expectedOutput' :
            '#####\n'
            '#####\n'
            '##1##\n'
            '##0##\n'
            '##2##\n'
            '##3##\n'
            '##4##\n'
            '##5##\n'
            '##6##\n'
            '##7##\n'
            '##8##\n'
            '##9##\n'
            '##C##\n'
            '##A##\n'
            '##B##\n'
            '##D##\n'
            '##E##\n'
            '##F##\n'
            '##G##\n'
            '##H##\n'
            '##I##\n'
            '##J##\n'
            '##K##\n'
            '##L##\n'
            '##M##\n'
            '##N##\n'
            '##O##\n'
            '#####'},
      {'code' : 'putbrick(black) move putbrick(white) move putbrick(light red) move putbrick(light yellow) move putbrick(light green) move putbrick(light cyan) move putbrick(light blue) move putbrick(light magenta) schritt putbrick(red) schritt putbrick(yellow) schritt putbrick(blue) move putbrick(green) move putbrick(cyan) move putbrick(magenta) move putbrick(dark red) move putbrick(dark yellow) move hinlegen(dark green) move putbrick(dark cyan) move putbrick(dark blue) move putbrick(dark magenta) move putbrick(orange) move putbrick(light orange) move putbrick(dark orange) move putbrick(brown) move putbrick(dark brown)',
        'expectedOutput' :
            '#####\n'
            '#####\n'
            '##1##\n'
            '##0##\n'
            '##2##\n'
            '##3##\n'
            '##4##\n'
            '##5##\n'
            '##6##\n'
            '##7##\n'
            '##8##\n'
            '##9##\n'
            '##C##\n'
            '##A##\n'
            '##B##\n'
            '##D##\n'
            '##E##\n'
            '##F##\n'
            '##8##\n'
            '##H##\n'
            '##I##\n'
            '##J##\n'
            '##K##\n'
            '##M##\n'
            '##L##\n'
            '##N##\n'
            '##O##\n'
            '#####'},
      {'code' : 'allonger(noir) etape allonger(blanc) etape allonger(rouge clair) etape allonger(jaune clair) etape allonger(vert clair) etape allonger(cyan clair) etape allonger(bleu clair) etape allonger(magenta clair) etape allonger(rouge) etape allonger(jaune) etape allonger(bleu) etape allonger(vert) etape allonger(cyan) etape allonger(magenta) etape allonger(rouge foncé) etape allonger(jaune foncé) etape allonger(vert foncé) etape allonger(cyan foncé) etape allonger(bleu foncé) etape allonger(magenta foncé) etape allonger(orange) etape allonger(orange clair) etape allonger(orange foncé) etape allonger(brun) etape allonger(brun foncé)',
        'expectedOutput' :
            '#####\n'
            '#####\n'
            '##1##\n'
            '##0##\n'
            '##2##\n'
            '##3##\n'
            '##4##\n'
            '##5##\n'
            '##6##\n'
            '##7##\n'
            '##8##\n'
            '##9##\n'
            '##C##\n'
            '##A##\n'
            '##B##\n'
            '##D##\n'
            '##8##\n'
            '##8##\n'
            '##8##\n'
            '##8##\n'
            '##8##\n'
            '##8##\n'
            '##K##\n'
            '##L##\n'
            '##8##\n'
            '##N##\n'
            '##8##\n'
            '#####'},
    ];

    for (var elem in _inputsToExpected) {
      test('code: ${elem['code']}', () {
        var _actual = KarolRobotOutputDecode(elem['code'] as String);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });

  group("KarolRobot.generate:", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'language' : KAREL_LANGUAGES.DEU, 'text' : '', 'expectedOutput' : ''},
      {'language' : KAREL_LANGUAGES.ENG, 'text' : '', 'expectedOutput' : ''},
      {'language' : KAREL_LANGUAGES.FRA, 'text' : '', 'expectedOutput' : ''},
      {'language' : KAREL_LANGUAGES.DEU, 'text' : 'cache', 'expectedOutput' : 'schritt(2) linksdrehen schritt(4) markesetzen linksdrehen schritt linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt linksdrehen schritt markesetzen schritt(6) rechtsdrehen schritt(3) rechtsdrehen schritt(3) markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen rechtsdrehen rechtsdrehen schritt(3) rechtsdrehen schritt markesetzen linksdrehen schritt schritt markesetzen rechtsdrehen schritt linksdrehen schritt markesetzen rechtsdrehen schritt rechtsdrehen schritt markesetzen schritt schritt markesetzen rechtsdrehen schritt markesetzen linksdrehen schritt(3) linksdrehen schritt(2) linksdrehen markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt(3) rechtsdrehen schritt(3) rechtsdrehen schritt(2) linksdrehen schritt(4) markesetzen linksdrehen schritt linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt linksdrehen schritt markesetzen schritt(6) rechtsdrehen schritt(3) rechtsdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen rechtsdrehen rechtsdrehen schritt(3) rechtsdrehen schritt markesetzen schritt markesetzen schritt markesetzen  schritt rechtsdrehen markesetzen schritt markesetzen schritt markesetzen schritt markesetzen rechtsdrehen rechtsdrehen schritt(4) markesetzen schritt markesetzen schritt markesetzen schritt rechtsdrehen schritt(3) rechtsdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen linksdrehen schritt(3) linksdrehen schritt(2) markesetzen schritt markesetzen rechtsdrehen schritt(3) rechtsdrehen markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt(3) linksdrehen schritt linksdrehen linksdrehen rechtsdrehen schritt(35) linksdrehen schritt(9) '},
      {'language' : KAREL_LANGUAGES.ENG, 'text' : 'cache', 'expectedOutput' : 'move move turnleft move move move move putbeeper turnleft move turnleft move putbeeper move putbeeper move putbeeper move turnleft move putbeeper move putbeeper move putbeeper move putbeeper move putbeeper move turnleft move putbeeper move putbeeper move putbeeper move turnleft move putbeeper move move move move move move turnright move move move turnright move move move putbeeper move putbeeper move putbeeper move putbeeper move putbeeper turnright turnright move move move turnright move putbeeper turnleft move move putbeeper turnright move turnleft move putbeeper turnright move turnright move putbeeper move move putbeeper turnright move putbeeper turnleft move move move turnleft move move turnleft putbeeper move putbeeper move putbeeper move putbeeper move putbeeper move move move turnright move move move turnright move move turnleft move move move move putbeeper turnleft move turnleft move putbeeper move putbeeper move putbeeper move turnleft move putbeeper move putbeeper move putbeeper move putbeeper move putbeeper move turnleft move putbeeper move putbeeper move putbeeper move turnleft move putbeeper move move move move move move turnright move move move turnright move putbeeper move putbeeper move putbeeper move putbeeper move putbeeper move putbeeper move putbeeper turnright turnright move move move turnright move putbeeper move putbeeper move putbeeper  move turnright putbeeper move putbeeper move putbeeper move putbeeper turnright turnright move move move move putbeeper move putbeeper move putbeeper move turnright move move move turnright move putbeeper move putbeeper move putbeeper move putbeeper move putbeeper move putbeeper move putbeeper turnleft move putbeeper move putbeeper move putbeeper move putbeeper turnleft move move move turnleft move move putbeeper move putbeeper turnright move move move turnright putbeeper move putbeeper move putbeeper move putbeeper move move move turnleft move turnleft turnleft turnright move move move move move move move move move move move move move move move move move move move move move move move move move move move move move move move move move move move turnleft move move move move move move move move move '},
      {'language' : KAREL_LANGUAGES.FRA, 'text' : 'cache', 'expectedOutput' : 'etape(2) tournergauche etape(4) marqueetablie tournergauche etape tournergauche etape marqueetablie etape marqueetablie etape marqueetablie etape tournergauche etape marqueetablie etape marqueetablie etape marqueetablie etape marqueetablie etape marqueetablie etape tournergauche etape marqueetablie etape marqueetablie etape marqueetablie etape tournergauche etape marqueetablie etape(6) tournerdroit etape(3) tournerdroit etape(3) marqueetablie etape marqueetablie etape marqueetablie etape marqueetablie etape marqueetablie tournerdroit tournerdroit etape(3) tournerdroit etape marqueetablie tournergauche etape etape marqueetablie tournerdroit etape tournergauche etape marqueetablie tournerdroit etape tournerdroit etape marqueetablie etape etape marqueetablie tournerdroit etape marqueetablie tournergauche etape(3) tournergauche etape(2) tournergauche marqueetablie etape marqueetablie etape marqueetablie etape marqueetablie etape marqueetablie etape(3) tournerdroit etape(3) tournerdroit etape(2) tournergauche etape(4) marqueetablie tournergauche etape tournergauche etape marqueetablie etape marqueetablie etape marqueetablie etape tournergauche etape marqueetablie etape marqueetablie etape marqueetablie etape marqueetablie etape marqueetablie etape tournergauche etape marqueetablie etape marqueetablie etape marqueetablie etape tournergauche etape marqueetablie etape(6) tournerdroit etape(3) tournerdroit etape marqueetablie etape marqueetablie etape marqueetablie etape marqueetablie etape marqueetablie etape marqueetablie etape marqueetablie tournerdroit tournerdroit etape(3) tournerdroit etape marqueetablie etape marqueetablie etape marqueetablie  etape tournerdroit marqueetablie etape marqueetablie etape marqueetablie etape marqueetablie tournerdroit tournerdroit etape(4) marqueetablie etape marqueetablie etape marqueetablie etape tournerdroit etape(3) tournerdroit etape marqueetablie etape marqueetablie etape marqueetablie etape marqueetablie etape marqueetablie etape marqueetablie etape marqueetablie tournergauche etape marqueetablie etape marqueetablie etape marqueetablie etape marqueetablie tournergauche etape(3) tournergauche etape(2) marqueetablie etape marqueetablie tournerdroit etape(3) tournerdroit marqueetablie etape marqueetablie etape marqueetablie etape marqueetablie etape(3) tournergauche etape tournergauche tournergauche tournerdroit etape(35) tournergauche etape(9) '},
      {'language' : KAREL_LANGUAGES.DEU, 'text' : 'FINAL\nN 456\nE 781', 'expectedOutput' : 'schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen linksdrehen schritt linksdrehen schritt(3) rechtsdrehen markesetzen schritt markesetzen linksdrehen schritt(3) linksdrehen schritt linksdrehen linksdrehen markesetzen schritt markesetzen schritt markesetzen schritt markesetzen linksdrehen schritt rechtsdrehen schritt(3) rechtsdrehen schritt linksdrehen markesetzen schritt rechtsdrehen markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen rechtsdrehen schritt markesetzen rechtsdrehen rechtsdrehen schritt(2) markesetzen linksdrehen schritt(6) markesetzen schritt(1) rechtsdrehen schritt(3) rechtsdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen rechtsdrehen rechtsdrehen schritt(6) rechtsdrehen schritt rechtsdrehen schritt markesetzen linksdrehen schritt rechtsdrehen schritt markesetzen schritt markesetzen schritt markesetzen linksdrehen schritt rechtsdrehen schritt markesetzen schritt linksdrehen schritt linksdrehen markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt rechtsdrehen schritt(3) rechtsdrehen schritt(3) markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen rechtsdrehen rechtsdrehen schritt(3) rechtsdrehen schritt markesetzen linksdrehen schritt schritt markesetzen rechtsdrehen schritt linksdrehen schritt markesetzen rechtsdrehen schritt rechtsdrehen schritt markesetzen schritt schritt markesetzen rechtsdrehen schritt markesetzen linksdrehen schritt(3) linksdrehen schritt(2) linksdrehen markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt(3) rechtsdrehen schritt(3) rechtsdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt(3) linksdrehen schritt(7) linksdrehen linksdrehen rechtsdrehen schritt(33) linksdrehen schritt(9) schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen rechtsdrehen rechtsdrehen schritt(6) rechtsdrehen schritt rechtsdrehen schritt markesetzen linksdrehen schritt rechtsdrehen schritt markesetzen schritt markesetzen schritt markesetzen linksdrehen schritt rechtsdrehen schritt markesetzen schritt linksdrehen schritt linksdrehen markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt rechtsdrehen schritt(3) rechtsdrehen linksdrehen schritt(7) rechtsdrehen linksdrehen schritt rechtsdrehen schritt markesetzen schritt markesetzen rechtsdrehen schritt linksdrehen schritt markesetzen schritt markesetzen linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen linksdrehen schritt(3) linksdrehen schritt linksdrehen schritt markesetzen schritt markesetzen schritt(2) markesetzen schritt markesetzen schritt markesetzen linksdrehen schritt(4) linksdrehen schritt(7) rechtsdrehen rechtsdrehen linksdrehen schritt(4) rechtsdrehen schritt markesetzen rechtsdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt rechtsdrehen schritt markesetzen schritt markesetzen schritt rechtsdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt rechtsdrehen schritt markesetzen schritt(6) rechtsdrehen schritt(7) rechtsdrehen linksdrehen schritt(4) rechtsdrehen schritt(2) markesetzen rechtsdrehen schritt rechtsdrehen schritt markesetzen linksdrehen schritt markesetzen schritt markesetzen schritt linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt rechtsdrehen schritt markesetzen schritt markesetzen schritt rechtsdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt rechtsdrehen schritt markesetzen schritt markesetzen schritt(5) rechtsdrehen schritt(7) rechtsdrehen rechtsdrehen schritt(35) linksdrehen schritt(9) schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen linksdrehen schritt(3) linksdrehen schritt(2) markesetzen schritt markesetzen rechtsdrehen schritt(3) rechtsdrehen markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt(3) linksdrehen schritt linksdrehen linksdrehen linksdrehen schritt(7) rechtsdrehen schritt markesetzen linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen rechtsdrehen schritt markesetzen schritt markesetzen rechtsdrehen schritt linksdrehen schritt markesetzen schritt markesetzen rechtsdrehen schritt linksdrehen schritt markesetzen schritt markesetzen linksdrehen schritt(5) linksdrehen schritt(7) rechtsdrehen rechtsdrehen schritt(3) linksdrehen linksdrehen markesetzen schritt markesetzen schritt rechtsdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt rechtsdrehen schritt markesetzen schritt markesetzen schritt rechtsdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt linksdrehen schritt markesetzen schritt markesetzen schritt linksdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt linksdrehen schritt markesetzen schritt markesetzen schritt(5) rechtsdrehen schritt(3) rechtsdrehen schritt schritt schritt markesetzen linksdrehen schritt linksdrehen schritt markesetzen rechtsdrehen schritt linksdrehen schritt markesetzen rechtsdrehen rechtsdrehen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen schritt markesetzen rechtsdrehen rechtsdrehen schritt(7) rechtsdrehen schritt(3) rechtsdrehen rechtsdrehen schritt(33) linksdrehen schritt(9) '},
    ];

    for (var elem in _inputsToExpected) {
      test('text: ${elem['text']}', () {
        var _actual = KarolRobotOutputEncode(elem['text'] as String, elem['language'] as KAREL_LANGUAGES);
        expect(_actual, elem['expectedOutput']);
      });
    }
  });
}