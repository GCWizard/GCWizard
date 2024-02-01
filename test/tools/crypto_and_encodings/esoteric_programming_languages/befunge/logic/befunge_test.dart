import "package:flutter_test/flutter_test.dart";
import 'package:gc_wizard/tools/crypto_and_encodings/esoteric_programming_languages/befunge/logic/befunge.dart';

void main() {
  group("Befunge.interpretBefunge", () {
    List<Map<String, Object?>> _inputsToExpected = [

/*
>              v\n' +
v  ,,,,,"Hello"<
>48*,          v
v,,,,,,"World!"<
>25*,@'
*/
      {'code' : '>              v\n' 'v  ,,,,,"Hello"<\n' '>48*,          v\n' 'v,,,,,,"World!"<\n' '>25*,@',
        'input' : '',
        'expectedOutput' :
        BefungeOutput(
            Output: 'Hello World!',
            Error: '', Iteration: '', curPosX: '', curPosY: '',
            BefungeStack: [], PC: [], Command: [], Mnemonic: [])},

/*
 >25*"!dlrow ,olleH":v
                  v:,_@
                  >  ^
*/
      {'code' : ' >25*"!dlrow ,olleH":v\n' '                  v:,_@\n' '                  >  ^\n',
        'input' : '',
        'expectedOutput' :
        BefungeOutput(
            Output: 'Hello, world!',
            Error: '', Iteration: '', curPosX: '', curPosY: '',
            BefungeStack: [], PC: [], Command: [], Mnemonic: [])},

      // random number generator - does not work as a testcase
      //  {'code' : ' v>>>>>v\n' +
      //            '  12345\n' +
      //            '  ^?^\n' +
      //            ' > ? ?^\n' +
      //            '  v?v\n' +
      //            '  6789\n' +
      //            '  >>>> v\n' +
      //            ' ^    .<\n',
      //            'input' : '',
      //            'expectedOutput' :
      //            BefungeOutput(
      //            Output: '',
      //            Error: '',
      //            BefungeStack: [], PC: [], Command: [], Mnemonic: [])},


      {'code' : '4 3 + . @',
        'input' : '',
        'expectedOutput' :
        BefungeOutput(Output: '7', Error: '', Iteration: '', curPosX: '', curPosY: '', BefungeStack: [], PC: [], Command: [], Mnemonic: [])},

/*
*/
      {'code' : 'v   > . v\n' '         \n' '4   +   @\n' '         \n' '> 3 ^',
        'input' : '',
        'expectedOutput' :
        BefungeOutput(
            Output: '7',
            Error: '', Iteration: '', curPosX: '', curPosY: '',
            BefungeStack: [], PC: [], Command: [], Mnemonic: [])},

/*
*/
      {'code' : 'v*>.v\n' '4*+*@\n' '>3^**',
        'input' : '',
        'expectedOutput' :
        BefungeOutput(
            Output: '7',
            Error: '', Iteration: '', curPosX: '', curPosY: '',
            BefungeStack: [], PC: [], Command: [], Mnemonic: [])},

/*
*/
      {'code' : '"!dlroW olleH"v\n' '@,,,,,,,,,,,,,<',
        'input' : '',
        'expectedOutput' :
        BefungeOutput(
            Output: 'Hello World!\x00',
            Error: '', Iteration: '', curPosX: '', curPosY: '',
            BefungeStack: [], PC: [], Command: [], Mnemonic: [])},

/*
*/
      {'code' : '"!dlrow olleH">:#,_@',
        'input' : '',
        'expectedOutput' :
        BefungeOutput(
            Output: 'Hello world!',
            Error: '', Iteration: '', curPosX: '', curPosY: '',
            BefungeStack: [], PC: [], Command: [], Mnemonic: [])},

      // https://github.com/catseye/Befunge-93/blob/master/eg/befunge2.bf
/*
<>: #+1 #:+ 3 : *6+ $#2 9v#
v 7 :   +   8 \ + + 5   <
>-  :2  -:  " " 1 + \ v ^<
2 + :   7   + : 7 + v > :
:1- :3- >   :#, _ @ >:3 5*-
*/
      {'code' : '<>: #+1 #:+ 3 : *6+ \$#2 9v#\n' 'v 7 :   +   8 \\ + + 5   <\n' '>-  :2  -:  " " 1 + \\ v ^<\n' '2 + :   7   + : 7 + v > :\n' ':1- :3- >   :#, _ @ >:3 5*-',
        'input' : '',
        'expectedOutput' :
        BefungeOutput(
            Output: 'BEFUNGE!EGNUFEB',
            Error: '', Iteration: '', curPosX: '', curPosY: '',
            BefungeStack: [], PC: [], Command: [], Mnemonic: [])},


      // https://github.com/catseye/Befunge-93/blob/master/eg/fact2.bf
/*
vv    <>v *<
&>:1-:|\$>\\:|
>^    >^@.\$<
*/
      {'code' : 'vv    <>v *<\n' '&>:1-:|\$>\\:|\n' '>^    >^@.\$<',
        'input' : '7',
        'expectedOutput' :
        BefungeOutput(
            Output: '5040',
            Error: '', Iteration: '', curPosX: '', curPosY: '',
            BefungeStack: [], PC: [], Command: [], Mnemonic: [])},

  // https://github.com/catseye/Befunge-93/blob/master/eg/numer.bf
/*
000p>~:25*-!#v_"a"-1+00g+00p> 00g9`#v_v
        @.g00<  vp00+%*52g00 /*52g00<
    ^           >#          ^#        <
*/*/
      {'code' : '000p>~:25*-!#v_"a"-1+00g+00p> 00g9`#v_v\n' '        @.g00<  vp00+%*52g00 /*52g00<  \n' '    ^           >#          ^#        <',
        'input' : 'test',
        'expectedOutput' :
        BefungeOutput(
            Output: '',
            Error: 'befunge_error_infinite_loop', Iteration: '', curPosX: '', curPosY: '',
            BefungeStack: [], PC: [], Command: [], Mnemonic: [])},

      // https://esolangs.org/w/index.php?title=Talk:Befunge&oldid=38327
/*
00:.1:.>:"@"8**++\1+:67+`#@_v
       ^ .:\/*8"@"\%*8"@":\ <
*/*/
      {'code' : '00:.1:.>:"@"8**++\\1+:67+`#@_v\n' '       ^ .:\\/*8"@"\\%*8"@":\\ <\n',
        'input' : '',
        'expectedOutput' :
        BefungeOutput(
            Output: '0 1 1 2 3 5 8 13 21 34 55 89 144 233 377',
            Error: '', Iteration: '', curPosX: '', curPosY: '',
            BefungeStack: [], PC: [], Command: [], Mnemonic: [])},


      // https://github.com/catseye/Befunge-93/blob/master/eg/ea.bf
/*
   100p            v
    v"love"0     <
    v"power"0   <
    v"strength"0?^#<            <
    v"success"0 ?v
    v"agony"0   <
    >v"beauty"0   <>025*"." 1v v_^
    ,:      >00g2- |        v< #:
    ^_,00g1-|      >0" fo "3>00p^<
    >0" eht si "2   ^  >,^
*/
/*  // Does not work as a Testcase because of the random Element
      {'code' : '100p            v\n' +
               ' v"love"0     <\n' +
               ' v"power"0   <\n' +
               ' v"strength"0?^#<            <\n' +
               ' v"success"0 ?v\n' +
               ' v"agony"0   <\n' +
               ' >v"beauty"0   <>025*"." 1v v_^\n' +
               ' ,:      >00g2- |        v< #:\n' +
               ' ^_,00g1-|      >0" fo "3>00p^<\n' +
               ' >0" eht si "2   ^  >,^',
        'input' : '',
        'expectedOutput' :
        BefungeOutput(
            Output: '',
            Error: '',
            BefungeStack: [], PC: [], Command: [], Mnemonic: [])},
*/

      // self generated
/*
>43*7+3*87*83+5*69*68*5+94+2*2*98+3*55+5*77*86*v
v                                              >
>52*52**0*52*1*0++1+>1-:v
                    ^,\ _@
*/
    {'code' : '>43*7+3*87*83+5*69*68*5+94+2*2*98+3*55+5*77*86*v\n' 'v                                              >\n' '>52*52**0*52*1*0++1+>1-:v\n' '                    ^,\\ _@',
      'input' : '',
      'expectedOutput' :
      BefungeOutput(
          Output: '0123456789',
          Error: '', Iteration: '', curPosX: '', curPosY: '',
          BefungeStack: [], PC: [], Command: [], Mnemonic: [])},

/*
>47+3*47+3*47+3*335*9:*+4++3:+5+25**535*9:*+4++8:*4+4:*2*53:+5+25**+253:***7+35v
v7:42*2*:4*3*83+**52+5+:31-2**52+5+:3*2*:4+4*:8++4+*:9*535-6*5**:26*2*:4+4+*:9*<
>+*+83+5*86*86*24:7+*+43*7+3*68*5+4:*2*2:3:**5**4-98+3*7:*86*4:*2*64*1-3*4:*2*3v
v**:3:2*2*:4*2*2+49*5+38+*+7:42*96*2*2+49*3+89*2*:4+**52+5+:37**52+5+:3+4+*:9*5<
>5**4-5:+5*68*5+4:*2*9:*3-4:*2*535*9:*+4++135*9:*+4++483+8*6++4:*2*62:**5*4-335v
v1+4+*:9*53-6**52+5+:3++4+*:9*531*2*:4-2**52+5+:3++4+*:9*535++4+*:9*531++4+*:9*<
>-253:***7+67+5*2+4:*2*62:**5*6-135*9:*+4++8:*4+4:*2*24:7+*+3:+5+25**2-3:+5+25*v
                                     v+4*2*57+7***:352+**52+5+:39+**52+5+:31-6*<
v                                    >
>52*52**0*52*7*9++1+>1-:v
                    ^,\ _@
 */
      {'code' : '>47+3*47+3*47+3*335*9:*+4++3:+5+25**535*9:*+4++8:*4+4:*2*53:+5+25**+253:***7+35v\n' 'v7:42*2*:4*3*83+**52+5+:31-2**52+5+:3*2*:4+4*:8++4+*:9*535-6*5**:26*2*:4+4+*:9*<\n' '>+*+83+5*86*86*24:7+*+43*7+3*68*5+4:*2*2:3:**5**4-98+3*7:*86*4:*2*64*1-3*4:*2*3v\n' 'v**:3:2*2*:4*2*2+49*5+38+*+7:42*96*2*2+49*3+89*2*:4+**52+5+:37**52+5+:3+4+*:9*5<\n' '>5**4-5:+5*68*5+4:*2*9:*3-4:*2*535*9:*+4++135*9:*+4++483+8*6++4:*2*62:**5*4-335v\n' 'v1+4+*:9*53-6**52+5+:3++4+*:9*531*2*:4-2**52+5+:3++4+*:9*535++4+*:9*531++4+*:9*<\n' '>-253:***7+67+5*2+4:*2*62:**5*6-135*9:*+4++8:*4+4:*2*24:7+*+3:+5+25**2-3:+5+25*v\n' '                                     v+4*2*57+7***:352+**52+5+:39+**52+5+:31-6*<\n' 'v                                    >\n' '>52*52**0*52*7*9++1+>1-:v\n' '                    ^,\\ _@',
        'input' : '',
        'expectedOutput' :
        BefungeOutput(
            Output: 'Jawohl. Der Cache liegt bei N 52° 47.643 und E 013° 59.007. Hol Dir das Ding!!!',
            Error: '', Iteration: '', curPosX: '', curPosY: '',
            BefungeStack: [], PC: [], Command: [], Mnemonic: [])},

    // prints UNICODE Table from 32 .. 47
/*
*/
    {'code' : 'v   v               <\n' '>84*>::.,5:+,1+:77*-|\n' '@                   <',
      'input' : '',
      'expectedOutput' :
      BefungeOutput(
          Output: '32  \n33 !\n34 "\n35 #\n36 \$\n37 %\n38 &\n39 \'\n40 (\n41 )\n42 *\n43 +\n44 ,\n45 -\n46 .\n47 /\n48 0',
        //Output: '',
          Error: '', Iteration: '', curPosX: '', curPosY: '',
          BefungeStack: [], PC: [], Command: [], Mnemonic: [])},

      // http://www.quirkster.com/iano/js/befunge.html
/* Quine
:0g,:93+`#@_1+
*/
      {'code' : ':0g,:93+`#@_1+',
        'input' : '',
        'expectedOutput' :
        BefungeOutput(
            Output: ':0g,:93+`#@_1+',
            //Output: '',
            Error: '', Iteration: '', curPosX: '', curPosY: '',
            BefungeStack: [], PC: [], Command: [], Mnemonic: [])},

/* Random number between 1 .. 32
1248::+1> #+?\# _.@
*/
/*      Does not work in the test environment because of random
        {'code' : '1248::+1> #+?\\# _.@',
        'input' : '',
        'expectedOutput' :
        BefungeOutput(
            Output: '',
            //Output: '',
            Error: '',
            BefungeStack: [], PC: [], Command: [], Mnemonic: [])},*/

    ];

    for (var elem in _inputsToExpected) {
      test('code: ${elem['code']}, input: ${elem['input']}', () {
        var _actual = interpretBefunge(elem['code'] as String, input: elem['input'] as String);
        expect(_actual.Output, (elem['expectedOutput']as BefungeOutput).Output);
        expect(_actual.Error, (elem['expectedOutput']as BefungeOutput).Error);
      });
    }
  });

  group("Befunge.interpretBefunge.Error", () {
    List<Map<String, Object?>> _inputsToExpected = [
      {'code' : '', 'input' : '', 'expectedOutput' : BefungeOutput(Output: '', Error: '', BefungeStack: [], PC: [], Command: [], Mnemonic: [], Iteration: '', curPosX: '', curPosY: '',)},
      {'code' : 'ABC123;', 'input' : '', 'expectedOutput' : BefungeOutput(Output: '', Error: 'befunge_error_invalid_command', BefungeStack: [], PC: [], Command: [], Mnemonic: [], Iteration: '', curPosX: '', curPosY: '')},

      // https://en.wikipedia.org/wiki/Befunge
      // Source code is faulty - works only with swappeg d-method
      //{'code' : '>:# 0# \\# g# ,# 1# +# :# 5# 9# *# -# _@ Quine',
      //  'input' : '',
      //  'expectedOutput' :
      //  BefungeOutput(
      //      Output: '>:# 0# \\# g# ,# 1# +# :# 5# 9# *# -# _@ Quine',
      //      Error: '',
      //      BefungeStack: [], PC: [], Command: [], Mnemonic: [])},


      // https://de.wikipedia.org/wiki/Befunge
      {'code' : '0.1>:#.#g:#00#00#+p# <',
        'input' : '',
        'expectedOutput' :
        BefungeOutput(
            Output: '0',
            Error: 'befunge_error_infinite_loop',
            Iteration: '', curPosX: '', curPosY: '',
            BefungeStack: [], PC: [], Command: [], Mnemonic: [])},

      {'code' : '0.1> #<:#<.#<:#<0#<0#<p#<+#<0#<0#<g#<\\# <',
        'input' : '',
        'expectedOutput' :
        BefungeOutput(
            Output: '0 1 1 2 3 5 8 13 21 34 55 89 144 233 377 610 987 1597 2584 4181 6765 10946 17711 28657 46368 75025 121393 196418 317811 514229 832040 1346269 2178309 3524578 5702887 9227465 14930352 24157817 39088169 63245986 102334155 165580141 267914296 433494437 701408733 1134903170 1836311903 2971215073 4807526976 7778742049 12586269025 20365011074 32951280099 53316291173 86267571272 139583862445 225851433717 365435296162 591286729879 956722026041 1548008755920 2504730781961 4052739537881 6557470319842 10610209857723 17167680177565 27777890035288 44945570212853 72723460248141 117669030460994 190392490709135 308061521170129 498454011879264 806515533049393 1304969544928657 2111485077978050 3416454622906707 5527939700884757 8944394323791464 14472334024676221 23416728348467685 37889062373143906 61305790721611591 99194853094755497 160500643816367088 259695496911122585 420196140727489673 679891637638612258 1100087778366101931 1779979416004714189 2880067194370816120 4660046610375530309 7540113804746346429 12200160415121876738 19740274219868223167 31940434634990099905 51680708854858323072 83621143489848422977 135301852344706746049 218922995834555169026 354224848179261915075 573147844013817084101 927372692193078999176 1500520536206896083277 2427893228399975082453 3928413764606871165730 6356306993006846248183 10284720757613717413913 16641027750620563662096 26925748508234281076009 43566776258854844738105 70492524767089125814114 114059301025943970552219 184551825793033096366333 298611126818977066918552 483162952612010163284885 781774079430987230203437 1264937032042997393488322 2046711111473984623691759 3311648143516982017180081 5358359254990966640871840 8670007398507948658051921 14028366653498915298923761 22698374052006863956975682 36726740705505779255899443 59425114757512643212875125 96151855463018422468774568 155576970220531065681649693 251728825683549488150424261 407305795904080553832073954 659034621587630041982498215 1066340417491710595814572169 1725375039079340637797070384 2791715456571051233611642553 4517090495650391871408712937 7308805952221443105020355490 11825896447871834976429068427 19134702400093278081449423917 30960598847965113057878492344 50095301248058391139327916261 81055900096023504197206408605 131151201344081895336534324866 212207101440105399533740733471 343358302784187294870275058337 555565404224292694404015791808 898923707008479989274290850145 1454489111232772683678306641953 2353412818241252672952597492098 3807901929474025356630904134051 6161314747715278029583501626149 9969216677189303386214405760200 16130531424904581415797907386349 26099748102093884802012313146549 42230279526998466217810220532898 68330027629092351019822533679447 110560307156090817237632754212345 178890334785183168257455287891792 289450641941273985495088042104137 468340976726457153752543329995929 757791618667731139247631372100066 1226132595394188293000174702095995 1983924214061919432247806074196061 3210056809456107725247980776292056 5193981023518027157495786850488117 8404037832974134882743767626780173 13598018856492162040239554477268290 22002056689466296922983322104048463 35600075545958458963222876581316753 57602132235424755886206198685365216 93202207781383214849429075266681969 150804340016807970735635273952047185 244006547798191185585064349218729154 394810887814999156320699623170776339 638817435613190341905763972389505493 1033628323428189498226463595560281832 1672445759041379840132227567949787325 2706074082469569338358691163510069157 4378519841510949178490918731459856482 7084593923980518516849609894969925639 11463113765491467695340528626429782121 18547707689471986212190138521399707760 30010821454963453907530667147829489881 48558529144435440119720805669229197641 78569350599398894027251472817058687522 127127879743834334146972278486287885163 205697230343233228174223751303346572685 332825110087067562321196029789634457848 538522340430300790495419781092981030533 871347450517368352816615810882615488381 1409869790947669143312035591975596518914 2281217241465037496128651402858212007295 3691087032412706639440686994833808526209 5972304273877744135569338397692020533504 9663391306290450775010025392525829059713 15635695580168194910579363790217849593217 25299086886458645685589389182743678652930 40934782466626840596168752972961528246147 66233869353085486281758142155705206899077 107168651819712326877926895128666735145224 173402521172797813159685037284371942044301 280571172992510140037611932413038677189525',
            Error: 'befunge_error_infinite_loop',
            Iteration: '', curPosX: '', curPosY: '',
            BefungeStack: [], PC: [], Command: [], Mnemonic: [])},

/*
0.1>:.:00p+00g\v
   ^           <
*/
      {'code' : '0.1>:.:00p+00g\\v\n' '^           <',
        'input' : '',
        'expectedOutput' :
        BefungeOutput(
            Output: '0 1',
            Error: 'befunge_error_infinite_loop',
            Iteration: '', curPosX: '', curPosY: '',
            BefungeStack: [], PC: [], Command: [], Mnemonic: [])},


       // https://github.com/catseye/Befunge-93/blob/master/eg/chars.bf
/*
25*3*4+>:."=",:,25*,1+:88*2*-#v_@\n
       ^                      <
*/
      {'code' : '25*3*4+>:."=",:,25*,1+:88*2*-#v_@\n' '^                             <',
        'input' : '',
        'expectedOutput' :
        BefungeOutput(
          //Output: '34 ="\n35 =#\n36 =\$\n37 =%\n38 =&\n39 =\'\n40 =(\n41 =)\n42 =*\n43 =+\n44 =,\n45 =-\n46 =.\n47 =/\n48 =0\n49 =1\n50 =2\n51 =3\n52 =4\n53 =5\n54 =6\n55 =7\n56 =8\n57 =9\n58 =:\n59 =;\n60 =<\n61 ==\n62 =>\n63 =?\n64 =@\n65 =A\n66 =B\n67 =C\n68 =D\n69 =E\n70 =F\n71 =G\n72 =H\n73 =I\n74 =J\n75 =K\n76 =L\n77 =M\n78 =N\n79 =O\n80 =P\n81 =Q\n82 =R\n83 =S\n84 =T\n85 =U\n86 =V\n87 =W\n88 =X\n89 =Y\n90 =Z\n91 =[\n92 =\\\n93 =]\n94 =^\n95 =_\n96 =`\n97 =a\n98 =b\n99 =c\n100 =d\n101 =e\n102 =f\n103 =g\n104 =h\n105 =i\n106 =j\n107 =k\n108 =l\n109 =m\n110 =n\n111 =o\n112 =p\n113 =q\n114 =r\n115 =s\n116 =t\n117 =u\n118 =v\n119 =w\n120 =x\n121 =y\n122 =z\n123 ={\n124 =|\n125 =}\n126 =~\n127 =',
            Output: '34 ="',
            Error: 'befunge_error_infinite_loop', Iteration: '', curPosX: '', curPosY: '',
            BefungeStack: [], PC: [], Command: [], Mnemonic: [])},


/* Sieve of Eratosthenes
2>:3g" "-!v\  g30          <
 |!`"O":+1_:.:03p>03g+:"O"`|
 @               ^  p3\" ":<
2 234567890123456789012345678901234567890123456789012345678901234567890123456789
*/
      {'code' : '2>:3g" "-!v\\  g30          <\n' '|!`"O":+1_:.:03p>03g+:"O"`|\n' '@               ^  p3\\" ":<\n' '2 234567890123456789012345678901234567890123456789012345678901234567890123456789',
        'input' : '',
        'expectedOutput' :
        BefungeOutput(
            Output: '', Iteration: '', curPosX: '', curPosY: '',
            Error: 'befunge_error_infinite_loop',
            BefungeStack: [], PC: [], Command: [], Mnemonic: [])},

    ];

    for (var elem in _inputsToExpected) {
      test('code: ${elem['code']}, input: ${elem['input']}', () {
        var _actual = interpretBefunge(elem['code'] as String, input: elem['input'] as String);
        expect(_actual.Output, (elem['expectedOutput']as BefungeOutput).Output);
        expect(_actual.Error, (elem['expectedOutput']as BefungeOutput).Error);
      });
    }
  });

}