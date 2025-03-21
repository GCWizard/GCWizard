/*  KMOBNEMA                                              DATUM: November 04
    Virtuelle Chiffriermaschine NEMA (K-Mob)
    Vorhandene Fortschaltwalzen: 12 - 13 - 14 - 15 - 17 - 18 (22/1)
    Vorhandene Kontaktwalzen: A - B - C - D - E - F
    Innerer und äusserer Schlüssel kann eingestellt werden
    innerer Schlüssel kann angezeigt werden (Schalter on/off)
    Klar-/Chiffriertext werden auf einem Laufband angezeigt.
    Taste Backstep für einen Schritt zurück, mehrfach verwendbar
    Taste Automatischer Vorschub für +100 und +1000 Schritte (Testzwecke)
    Laufband verfügt über einen Speicher von 1600 Zeichen
*/


#include <bios.h>
#include <conio.h>
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <dos.h>
#include <time.h>

void maske(void);		
/* Aufbau der Hauptmaske */

void vorschub(void);            
/* Vorschub der Walzen um einen Schritt */

void backstep(void);		
/* Walzen einen Schritt zurück */

void anzeige(int,int);		
/* Anzeige auf Lampenfeld, eintrag im Laufband */

void rotoren_anzeigen(void);	
/* neu berechnete Walzenstellungen anzeigen */

void aussen(void);		
/* äusseren Schlüssel einstellen */

void innen_wahl(void);          
/* inneren Schlüssel wählen */

void is_anzeigen(int);		
/* inneren Schlüssel anzeigen on/off */

void is_einstellen(void);	
/* Informationen für IS übernehmen */

void reset_zaehler(void);	
/* Reset Schrittzähler */

void cursor(int);		
/* Cursor ein/aus */

void fragen(void);	        
/* Fragen, ob Programm wirklich verlassen */

void ende(void);                
/* Standardeinstellungen, Programm verlassen */

void laufband(void);		
/* Laufband Klar-Chiffrat */

void zaehler_anpassen(int);     
/* Zähler um (int) korrigieren und anzeigen */

void lampe_aus(void);		
/* Buchstabe an Lampenfeld ausschalten */

char chiffrieren(int);		
/* Taste in Chiffrat umsetzen */

void autovorschub(int);         
/* Vorschub um wählbare Anzahl Steps */



/* hier die vorrätigen Walzen, 6 Fortschaltwalzen und 6 Kontaktwalzen */

const int v[12][26]=
{{0,1,1,1,1,1,1,1,1,1,1,1,0,0,0,1,1,1,1,0,1,1,1,1,1,1},    
/* 12 */

{1,1,0,1,1,1,1,0,0,1,1,0,1,1,0,1,1,1,0,1,1,1,1,1,1,0},    
/* 13 */

{0,0,1,0,1,1,1,1,0,1,1,1,1,1,1,1,1,0,1,0,0,1,0,1,0,1},    
/* 14 */

{1,0,0,1,1,0,1,0,0,0,0,0,1,0,1,1,1,1,1,1,0,1,0,1,1,1},    
/* 15 */

{0,1,0,0,0,0,0,1,1,1,1,0,0,0,0,0,1,0,1,0,1,1,0,1,1,0},
/* 17 */

{1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,0,1,1,1,1,1,1,1,0,1,1},
/* 18 */

{13,17,8,5,15,23,8,17,4,12,12,15,8,22,15,2,21,8,5,14,11,21,8,9,17,2},
/* A */

{10,8,22,10,15,7,24,0,3,5,15,5,15,9,1,3,7,17,25,12,6,11,24,6,23,3},
/* B */

{15,12,3,17,15,25,23,1,17,15,16,22,9,4,8,25,19,1,14,8,22,17,14,5,25,12},
/* C */

{22,8,25,1,20,0,14,21,4,20,9,15,13,23,9,0,18,25,15,25,1,16,10,17,15,18},
/* D */

{7,16,14,16,20,16,17,5,5,17,18,20,8,22,16,3,6,20,7,15,12,8,19,17,12,2},
/* E */

{25,20,4,1,12,7,14,12,14,2,3,7,21,2,0,11,15,7,16,4,16,6,7,20,11,3}};     */
/* F */



/* hier die Inversionen der obigen Kontaktwalzen */

const int iv[12][26]=
{{0},{0},{0},{0},{0},{0},
/* Platzhalter für die Nockenscheiben */

{11,24,3,11,18,15,17,12,21,4,18,5,22,13,18,9,5,24,9,11,18,14,14,21,9,18},
{20,11,23,20,2,14,15,0,9,18,16,23,19,16,21,25,21,1,23,11,2,3,17,19,4,11},
{10,18,21,3,1,23,12,4,25,7,12,14,9,14,1,11,4,22,25,11,9,17,18,1,11,9},
{11,1,5,6,25,0,16,11,8,18,3,10,22,11,9,0,1,8,1,17,12,25,4,17,6,13},
{9,24,8,18,10,6,14,19,11,4,14,6,21,21,9,7,12,10,23,10,18,10,20,9,6,19},
{15,20,23,19,25,11,22,5,10,15,10,24,19,23,0,24,14,6,19,14,12,6,12,12,19,1}};


/* Die Bezeichnung der obigen Walzen */

const char auswahl[]={"121314151718A B C D E F"};

/*   ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ */



/* Spezialfälle, s0 und s10 sind die Steuerscheiben an der Walze 10, 'um'
   ist die Umkehrwalze, 'in' gibt den Zusammenhang Taste -> Position der
   Anschlusskontakte, 'ini' denjenigen Position -> Taste */

const int s10[]={1,1,0,0,1,0,1,1,0,0,1,0,1,1,0,1,1,1,1,0,0,1,1,1,0,0}; */
/* 22*/

const int s0[]= {0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,1,1};
/* 1 */

const int um[]= {10,21,13,10,2,2,24,24,13,10,16,14,8,16,10,13,7,1,25,16,18,13,5,19,16,12};
const int in[]= {14,1,3,12,22,11,10,9,17,8,7,6,25,0,16,15,24,21,13,20,18,2,23,4,5,19,};
const char ini[]= {"NBVCXYLKJHGFDSAPOIUZTREWQM"};


/* Die momentan eingestellten Steuerscheiben s, Kontaktwalzen r und deren
   Inversion ir. Die Zahlen beziehen sich auf die Walzennummer. */

int s2[26], s4[26], s6[26], s8[26];
int r3[26], r5[26], r7[26], r9[26];
int ir3[26], ir5[26], ir7[26], ir9[26];


/* Die Stellung der Walzen 1 ... 10  (0 wird nicht benötigt) */

int rotor[11];


/* 1600 Klar- und Geheimtextzeichen werden gespeichert */

int klar[1600], chiff[1600], zeiger = 0;


/* Die Reihenfolge der Walzen 2 .. 9, 1 ist Umkehrwalze, 10 feste Walze.
   der Default-Schlüssel ist: 12-A 13-B 14-C 15-D. Die Zahl entspricht der
   Position in der Liste 'v' */


int einstellung[]={0,6,1,7,2,8,3,9};
/* Auswahl aus der Liste */

int j;
int lampe_ein, vorherig_x, vorherig_y;
long beginn, zaehler = 100000, display;
FILE *fp;

main()
{
int taste;
char resultat;
maske();
/* Maske aufbauen */

is_einstellen();
/* Default IS übernehmen */

cursor(0);
/* Cursor ausschalten */

for (j=0;j<1600;j++)
/* Speicherbereich mit Blanks belegen */

{
klar[j]=32;  chiff[j]=32;
}
while(1)
/* Beginn Hauptloop, verlassen mit Taste ESC */

{
if (kbhit())
/* Taste gedrückt? */

{
taste = getch();
if (taste == 0)
/* Spezialtaste, zweistellig? */

{
if (lampe_ein) lampe_aus();
switch (getch())
/* Ja */

{
case 68: aussen(); break;
/* F10 äusserer Schlüssel einst. */

case 67: innen_wahl(); break;
/* F9 innerer Schlüssel einst. */

case 66: is_anzeigen(1); break;
/* F8 inneren Schlüssel anzeigen */

case 104: reset_zaehler(); break;
/* ALT-F1 Reset Counter */

case 106: autovorschub(100); break;
/* ALT-F3 Autovorschub +100 */

case 107: autovorschub(1000);
/* ALT-F4 Autovorschub +1000 */

}
}
if (taste == 27)
/* Programmabbruch mit ESC */

{
if (lampe_ein) lampe_aus();
fragen();
}
if (taste == 8)
/* Taste Backstep */

{
if (lampe_ein) lampe_aus();
backstep();
rotoren_anzeigen();
}
if(isalpha(taste))
/* Nur Alpha-Tasten werden chiffriert */

{
vorschub();
/* zuerst Vorschub */

rotoren_anzeigen();
/* dann neue Walzenlage anzeigen */

taste = tolower(taste);
/* Tastendruck in Kleinbuchstaben */

resultat = chiffrieren(taste);
/* dann chiffrieren */

anzeige(taste,resultat);
/* und auf dem Tastenfeld anzeigen */

}
}
if (lampe_ein && (clock()-beginn > 40)) lampe_aus();
/* letzte Taste löschen */

}
/* Ende Hauptloop */

}
/* Ende main */


void lampe_aus(void)
{
textcolor(DARKGRAY);
gotoxy(vorherig_x,vorherig_y); cprintf("%c",lampe_ein);
lampe_ein = 0;
}

void zaehler_anpassen(int schritt)
{
zaehler = zaehler + schritt;
display = zaehler%100000;
textcolor(WHITE);
gotoxy(62,7); cprintf("%05ld",display);
}

void autovorschub(int anzahl)
{
while (anzahl != 0)
/* verweilen bis die mit 'anzahl' vorgegebenen */

{
/* Tastendrucke ausgeführt sind */

vorschub();
--anzahl;
rotoren_anzeigen();
/* könnte auch ausserhalb der Klammer sein */

}
for (j=0;j<1600;++j)
/* Laufband und Speicher löschen */

{
klar[j] = 32; chiff[j] = 32;
}
zeiger = 0;
laufband();
/* Laufband löschen, ist jetzt blank */

}

void vorschub(void)
/* Tastendruck auf Walzen übertragen */

{
zaehler_anpassen(1);
/* Zähler, 5-stellig nachführen */


/* die Rotoren 3 und 7 haben doppelte Abhängigkeit */


/* die Rotoren 4 und 8 haben einfache Abhängigkeit von s0 */

if (s0[((rotor[10]+17)%26)])
{
if (s4[((rotor[4]+16)%26)]) rotor[3] = (rotor[3]+25)%26;
rotor[4] = (rotor[4]+25)%26;
if (s8[((rotor[8]+16)%26)]) rotor[7] = (rotor[7]+25)%26;
rotor[8] = (rotor[8]+25)%26;
}

/* die Rotoren 1, 5 und 9 haben einfache Abhängigkeit */

if (s2[((rotor[2]+16)%26)])  rotor[1] = (rotor[1]+25)%26;
if (s6[((rotor[6]+16)%26)])  rotor[5] = (rotor[5]+25)%26;
if (s10[((rotor[10]+16)%26)]) rotor[9] = (rotor[9]+25)%26;

/* die Rotoren 2, 6 und 10 werden bei jedem Tastendruck bewegt */

rotor[2] = (rotor[2]+25)%26;
/* direkt angetrieben */

rotor[6] = (rotor[6]+25)%26;
/* direkt angetrieben */

rotor[10]= (rotor[10]+25)%26;
/* direkt angetrieben */

}

void backstep(void)
{
zaehler_anpassen(-1);
/* Display um 1 zurück */


/* genau umgekehrte Reihenfolge wie beim Schritt vor!!, wichtig!! */

rotor[2] = (rotor[2]+1)%26;
rotor[6] = (rotor[6]+1)%26;
rotor[10]= (rotor[10]+1)%26;
if (s2[((rotor[2]+16)%26)]) rotor[1] = (rotor[1]+1)%26;
if (s6[((rotor[6]+16)%26)]) rotor[5] = (rotor[5]+1)%26;
if (s10[((rotor[10]+16)%26)]) rotor[9] = (rotor[9]+1)%26;
if (s0[((rotor[10]+17)%26)])
{
rotor[4] = (rotor[4]+1)%26;
if (s4[((rotor[4]+16)%26)]) rotor[3] = (rotor[3]+1)%26;
rotor[8] = (rotor[8]+1)%26;
if (s8[((rotor[8]+16)%26)]) rotor[7] = (rotor[7]+1)%26;
}
if (zeiger)
/* bearbeiten nur bis Zeiger auf Null */

{
klar[--zeiger] = 32;
chiff[zeiger] = 32;
laufband();
}
}

char chiffrieren(int klartext)
{
/* Klartext wird als Kleinbuchstabe mitgebracht */

int zwischen;
zwischen = in[klartext-97];
/* Offset weg und Position auf Anschlusskontakten */

zwischen = (zwischen + r9[(zwischen+rotor[9])%26])%26;
zwischen = (zwischen + r7[(zwischen+rotor[7])%26])%26;
zwischen = (zwischen + r5[(zwischen+rotor[5])%26])%26;
zwischen = (zwischen + r3[(zwischen+rotor[3])%26])%26;
zwischen = (zwischen + um[(zwischen+rotor[1])%26])%26;
zwischen = (zwischen + ir3[(zwischen+rotor[3])%26])%26;
zwischen = (zwischen + ir5[(zwischen+rotor[5])%26])%26;
zwischen = (zwischen + ir7[(zwischen+rotor[7])%26])%26;
zwischen = (zwischen + ir9[(zwischen+rotor[9])%26])%26;
return(ini[zwischen]);
/* von Anschlussplatte auf Buchstaben */

}

void rotoren_anzeigen(void)
{
textcolor(YELLOW);
gotoxy(16,7); cprintf("%c",rotor[1]+65);
gotoxy(20,7); cprintf("%c",rotor[2]+65);
gotoxy(24,7); cprintf("%c",rotor[3]+65);
gotoxy(28,7); cprintf("%c",rotor[4]+65);
gotoxy(32,7); cprintf("%c",rotor[5]+65);
gotoxy(36,7); cprintf("%c",rotor[6]+65);
gotoxy(40,7); cprintf("%c",rotor[7]+65);
gotoxy(44,7); cprintf("%c",rotor[8]+65);
gotoxy(48,7); cprintf("%c",rotor[9]+65);
gotoxy(52,7); cprintf("%c",rotor[10]+65);
}

void aussen(void)
/* Žusseren Schlüssel einstellen */

{
int tast, buff[1000],j;
/* Fenster bereitstellen */

gettext(13,9,59,18,&buff);
window(13,9,59,18);
clrscr();
textcolor(WHITE);
/* Maske aufbauen */

gotoxy(1,1);
cputs("                                               "
"                                               "
"   Einstellen des äusseren Schlüssels (AS)     "
"   ---------------------------------------     "
"                                               "
"   mit Pfeiltasten  \033 \032  Walze wählen          "
"   mit Pfeiltasten  \031 \030  Walze einstellen      "
"                                               "
"   Ausführen und zurück mit Enter            ");
textcolor(YELLOW);
gotoxy(1,1);
cputs("   \030");
/* Pfeil einzeichnen */

j=1;
/* bei Walze 1 */

while ((tast = getch()) != 13)
{
if (tast == 0) switch(getch())
/* zweistellig auswerten */

{
case 77:if (j != 10)
{
gotoxy(1,1);
cputs("                                            ");
++j;
gotoxy(j*4,1);
cputs("\030");
}
break;
case 75:if (j != 1)
{
gotoxy(1,1);
cputs("                                            ");
--j;
gotoxy(j*4,1);
cputs("\030");
}
break;
case 72:rotor[j]=(rotor[j]+1)%26; window(1,1,80,25); rotoren_anzeigen();
window(13,9,69,18); break;
case 80:rotor[j]=(rotor[j]+25)%26; window(1,1,80,25); rotoren_anzeigen();
window(13,9,69,18);
}
}
puttext(13,9,59,18,&buff);
window(1,1,80,25);
}

void innen_wahl(void)
/* inneren Schlüssel wählen */

{
int buff[2000], tast, anzahl, pos = 0, rot = 0;
int fehler = 1, i, statuslb;

/*statuslb = lbaktiv;*/


/* if (lbaktiv == 1) laufband();*/

gettext(10,5,80,22,&buff);
window(10,5,80,22);
clrscr();
textcolor(WHITE);
gotoxy(1,1);
cputs("                                                                       "
"Einstellen des inneren Schlüssels (IS)                Walzen           "
"--------------------------------------                ------           "
"                                                                       "
"Paar 1    Paar 2    Paar 3    Paar 4                  > 12             "
"   -         -         -         -                      13             "
"\030                                                       14             "
"                                                        15             "
"Mit Pfeiltasten \033 \032 Position einstellen.                17             "
"Mit Pfeiltasten \031 \030 Walze auswählen.                    18             "
"                                                        A              "
"šbernehmen mit Zwischenraum-Taste                       B              "
"                                                        C              "
"Ausführen und zurück mit Enter                          D              "
"                                                        E              "
"                                                        F              ");
for (j=0;j<8;j++)
{
gotoxy(1+j*5,6);
i=einstellung[j];
cprintf("%c%c",auswahl[i*2],auswahl[i*2+1]);
}
while (fehler == 1)
{
tast = getch();
gotoxy(1,16);  	*/
/* Fehlermeldung löschen */

cputs("                                 ");
if (tast == 0) switch (getch())
{
case 77: if (pos < 7)
{
gotoxy(1,7); cputs("                                     ");
++pos;
gotoxy(1+pos*5,7); cputs("\030");
}
break;
case 75: if (pos != 0)
{
gotoxy(1,7); cputs("                                    ");
--pos;
gotoxy(1+pos*5,7); cputs("\030");
}
break;
case 80: if (rot < 11)
{
gotoxy(55,5+rot);  cputs(" ");
rot++;
gotoxy(55,5+rot);  cputs(">");
}
break;
case 72: if (rot != 0)
{
gotoxy(55,5+rot);  cputs(" ");
rot--;
gotoxy(55,5+rot);  cputs(">");
}
}
if (tast == 32)
/* Blank */

{
if (((pos%2 == 0) && (rot < 6)) || ((pos%2 == 1) && (rot > 5)))
{
gotoxy(1+pos*5,6);
cprintf("%c%c",auswahl[rot*2],auswahl[rot*2+1]);
einstellung[pos]=rot;
}
}
if (tast == 13)
/* Taste Enter, prüfen auf doppelte Belegung */

{
fehler = 0;
for (j=0;j<=6;j++)
{
for (i=j+1;i<=7;i++) if (einstellung[j] == einstellung[i]) fehler=1;
}
if (fehler)
{
textcolor(LIGHTRED);
gotoxy (1,16); cputs("Walzen sind mehrfach verwendet!");
textcolor(WHITE);
}
}
}
is_einstellen();
/* fehlerfrei, Inneren Schlüssel einstellen */

puttext(10,5,80,22,&buff);
window(1,1,80,25);
is_anzeigen(0);
/* bestehender Status ein/aus bleibt bestehen */

}

void is_anzeigen(int umschalt)
{
static int schalter, i;
schalter = (schalter+umschalt)%2;
/* schaltet um, wenn 1 mitgegeben wird */

textcolor(LIGHTGRAY);
if (schalter)
{
gotoxy(16,5);
cprintf("U                                  22/1");
for (j=0;j<=7;j++)
{
i = einstellung[j];
gotoxy(20+j*4,5); cprintf("%c%c",auswahl[i*2],auswahl[i*2+1]);
}
}
else
{
gotoxy(16,5); cputs("                                        ");
/* löschen */

}
}

void is_einstellen(void)
{
for (j=0;j<=25;j++)
/* übernimmt die Werte aus dem Vorrat */

{
s2[j] = v[einstellung[0]][j];
s4[j] = v[einstellung[2]][j];
s6[j] = v[einstellung[4]][j];
s8[j] = v[einstellung[6]][j];
r3[j] = v[einstellung[1]][j];
r5[j] = v[einstellung[3]][j];
r7[j] = v[einstellung[5]][j];
r9[j] = v[einstellung[7]][j];
ir3[j] = iv[einstellung[1]][j];
ir5[j] = iv[einstellung[3]][j];
ir7[j] = iv[einstellung[5]][j];
ir9[j] = iv[einstellung[7]][j];
}
}

void reset_zaehler(void)
{
zaehler = 100000;
zaehler_anpassen(0);
/* bleibt auf 00000 */

for (j=0;j<1600;j++)
/* Laufband löschen */

{
klar[j] = 32;
chiff[j] = 32;
}
zeiger = 0;
laufband();
}

void anzeige(int tast, int chiffrat)
{
int offset;

/* Position der Buchstaben auf dem Lampenfeld */

const int posx[] =
{18,36,28,26,24,30,34,38,44,42,46,50,44,40,48,52,16,28,22,32,40,32,20,24,20,36};
const int posy[] =
{15,17,17,15,13,15,15,15,13,15,15,15,17,17,13,13,13,13,15,13,13,17,13,17,17,13};

/*  a  b  c  d  e  f  g  h  i  j  k  l  m  n  o  p  q  r  s  t  u  v  w  x  y  z   */

beginn = clock();
/* Zeit merken für Autoabschaltung */

if (lampe_ein) lampe_aus();
/* falls altes Zeichen noch leuchtet, löschen */

textcolor(YELLOW);
offset = chiffrat-65;
gotoxy(posx[offset],posy[offset]);
cprintf("%c",chiffrat);
/* neues Zeichen anzeigen */

lampe_ein = chiffrat;
/* markieren, dass und welche Lampe */

vorherig_x=wherex()-1;
vorherig_y=wherey();
if (zeiger < 1595)
{
klar[zeiger]=tast;
chiff[zeiger++]=chiffrat;
/* neue Werte einsetzen */

laufband();
/* Laufband anzeigen */

}
else
{
gotoxy(1,21);
cprintf("    Der Speicher ist voll!                                                   ");
gotoxy(1,22);
cprintf("    Chiffrieren ist weiterhin möglich, aber ohne Anzeige auf dem Laufband.   ");
}
}

void cursor(int ein)
/* Cursor ein/aus, Steuerung mit Parameter */

{
static int alt_cursor_start, alt_cursor_stop;
union REGS in, out;
if(ein)
{
in.h.ah = 1;
in.h.ch = alt_cursor_start;
in.h.cl = alt_cursor_stop;
int86(0x10, &in, &out);
}
else
{
in.h.ah = 3;
in.h.bh = 0;
int86(0x10, &in, &out);
alt_cursor_start = out.h.ch;
alt_cursor_stop = out.h.cl;
in.h.ah = 1;
in.h.ch = 63;
in.h.cl = 63;
int86(0x10, &in, &out);
}
}

void laufband(void)
{
static int offset;
if (zeiger > 64) offset = zeiger - 64;
else offset = 0;
textcolor(LIGHTGRAY);
gotoxy(2,21);
for (j=0;j<= 65;j++)
{
if ((j + offset) %5 == 0) cprintf(" ");
cprintf("%c",klar[offset + j]);
}
textcolor(LIGHTRED);
gotoxy(2,22);
for (j=0;j<=65;j++)
{
if ((j + offset) %5 == 0) cprintf(" ");
cprintf("%c",chiff[offset + j]);
}
}

void fragen(void)
{
int buf[200];
gettext(14,6,68,8,&buf);
/* Fenster sichern */

window(14,6,68,8);
textcolor(BLACK);
textbackground(LIGHTGRAY);
clrscr();
gotoxy(4,2);
cputs("Wollen Sie das Programm wirklich verlassen? (J/N)");
if (toupper(getch()) == 'J') ende();
puttext(14,6,68,8,buf);
window(1,1,80,25);
textbackground(BLACK);
}

void ende(void)
{
cursor(1);
window(1,1,80,25);
normvideo();
clrscr();
exit(0);
}

void maske(void)
{
int pos, i;
const int anfang[] ={'A','A','A','A','A','A','A','A','A','A'}; */
/* Ini-Schlüssel */

const int wert[] = {'1','2','3','4','5','6','7','8','9','0',
/* 1 Zahlenreihe */

'Q','W','E','R','T','Z','U','I','O','P',
/* 3 Buchstaben- */

'A','S','D','F','G','H','J','K','L',
/*   reihen */

'Y','X','C','V','B','N','M'};
const int posx[] = {16,20,24,28,32,36,40,44,48,52,
/* zugehörige Positionen */

16,20,24,28,32,36,40,44,48,52,
18,22,26,30,34,38,42,46,50,
20,24,28,32,36,40,44};
const int posy[] = {12,12,12,12,12,12,12,12,12,12,
13,13,13,13,13,13,13,13,13,13,
15,15,15,15,15,15,15,15,15,
17,17,17,17,17,17,17};
for (i=0;i<10;i++) rotor[i+1] = anfang[i]-65;
clrscr();
textattr(BROWN);
/* Braun auf schwarz */

cputs("      ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿      "
"      ³                                                                  ³      "
"      ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ      "
"                                                                                "
"                                                                                "
"             ÚÄÄÄÂÄÄÄÂÄÄÄÂÄÄÄÂÄÄÄÂÄÄÄÂÄÄÄÂÄÄÄÂÄÄÄÂÄÄÄ¿     ÚÄÄÄÄÄÄÄ¿            "
"             ³   ³   ³   ³   ³   ³   ³   ³   ³   ³   ³     ³       ³            "
"             ÀÄÄÄÁÄÄÄÁÄÄÄÁÄÄÄÁÄÄÄÁÄÄÄÁÄÄÄÁÄÄÄÁÄÄÄÁÄÄÄÙ     ÀÄÄÄÄÄÄÄÙ            "
"                                                                                "
"                                                                                "
"             ÚÄÄÄÂÄÄÄÂÄÄÄÂÄÄÄÂÄÄÄÂÄÄÄÂÄÄÄÂÄÄÄÂÄÄÄÂÄÄÄ¿                          "
"             ³   ³   ³   ³   ³   ³   ³   ³   ³   ³   ³                          "
"             ³   ³   ³   ³   ³   ³   ³   ³   ³   ³   ³                          "
"             ÀÄÂÄÁÄÂÄÁÄÂÄÁÄÂÄÁÄÂÄÁÄÂÄÁÄÂÄÁÄÂÄÁÄÂÄÁÄÂÄÙ                          "
"               ³   ³   ³   ³   ³   ³   ³   ³   ³   ³                            "
"               ÀÄÂÄÁÄÂÄÁÄÂÄÁÄÂÄÁÄÂÄÁÄÂÄÁÄÂÄÁÄÂÄÁÄÄÄÙ                            "
"                 ³   ³   ³   ³   ³   ³   ³   ³                                  "
"                 ÀÄÄÄÁÄÄÄÁÄÄÄÁÄÄÄÁÄÄÄÁÄÄÄÁÄÄÄÙ                                  "
"                                                                                "
"                                                                                "
"                                                                                "
"                                                                                "
" ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ ");
textcolor(GREEN);
cputs(" ESC: Abbruch     F8: IS anzeigen     F9: IS einstellen     F10: AS einstellen  "
" <--: Schritt zurück     Alt-F1: Reset         Alt-F3: +100      Alt-F4: +1000 ");
textcolor(LIGHTGRAY);
for (i=0; i<10; i++)
{
gotoxy(posx[i],posy[i]); cprintf("%c",wert[i]);
}
textcolor(DARKGRAY);
for (i=10; i<36; i++)
{
gotoxy(posx[i],posy[i]); cprintf("%c",wert[i]);
}
textcolor(YELLOW);
for (pos=16,i=0; i <10; pos=pos+4,i++)
{
gotoxy(pos,7); cprintf("%c",anfang[i]);
}
textcolor(WHITE);
gotoxy(10,2);
cputs("C h i f f r i e r m a s c h i n e   N E M A   (K-Mob-Maschine)");
gotoxy(62,7);
cputs("00000");
}

