
var P1R1 >=0, integer;
var P1R2 >=0, integer;
var P1R3 >=0, integer;
var P2R1 >=0, integer;
var P2R2 >=0, integer;
var P2R3 >=0, integer;

var Y1 >=0, binary;
var Y2 >=0, binary;


maximize lucro: 100*P1R1 + 180*P1R2+150*P1R3 +120*P2R1 + 90*P2R2 + 130*P2R3 - 1200*Y1 - 1500*Y2 ;


capacidade_planta1: P1R1 + P1R2 + P1R3 <= 120;
capacidade_planta2: P2R1 + P2R2 + P2R3 <= 150;

demanda_revenda1: P1R1 + P2R1 >= 55;
demanda_revenda2: P1R2 + P2R2 >= 70;
demanda_revenda3: P1R3 + P2R3 >= 65;

resticao_y1 : P1R1 + P1R2 + P1R3 <= 99999999*Y1;
resticao_y2 : P2R1 + P2R2 + P2R3 <= 99999999*Y2;


solve;
