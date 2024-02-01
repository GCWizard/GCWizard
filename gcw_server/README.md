
# start

-> Terminal
cd gcw_server
cd GCWServer
dart run

# parameter

input
mode
parameter1
parameter2
fromformat
toformat

# syntax

toolname?input=xxx&parameter1=xxx&parameter2=xxx

# example

/Morse?input=Test%20String&mode=encode
/Morse?input=...%20---%20...
/Morse?input=test&mode=encode
/alphabetvalues?input=Test
/alphabetvalues?input=Test&mode=encode
/alphabetvalues?input=Test12&mode=encode
/alphabetvalues?input=1%202%203%204&mode=encode
/coords_formatconverter?input=N48%C2%B023.123%20E9%C2%B012.456&
/coords_formatconverter?input=N48%C2%B023.123%20E9%C2%B012.456&toformat=coords_utm
/coords_formatconverter?input=N48%C2%B023.123%20E9%C2%B012.456&toformat=coords_all
/rotate?input=test&parameter1=4
/reverse?input=test
