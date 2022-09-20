#Halliday Gauss Costa dos Santos
#18.1.4093

#conjuntos
set Plantas := {1..2};
set Revendas := {1..3};

#parametros
param lucro_PR {i in Plantas, j in Revendas}; # lucro ap�s produzir um ve�culo da planta i e levar para a revenda J

param demanda_minima {i in Revendas}; #demanda minima de ve�culos na revenda i

param capacidade {i in Plantas}; #capacidade maxima de ve�culos na planta i

param custo_planta {i in Plantas}; # custo de se produzir algum ve�culo a partir da planta i

#variaveis
var PR {i in Plantas, j in Revendas} >=0, integer; #quantidade de ve�culos produzidos na planta i e entregue para a revenda J

var Y {i in Plantas}  >=0, binary; # 0 se nada foi prouzido a partir da planta i e 1 se algum ve�culo foi produzido a partir da planta i


maximize lucro : sum {i in Plantas} (sum {j in Revendas} lucro_PR[i,j]*PR[i,j]-custo_planta[i]*Y[i]);

#restricoes

capacidade_plantas {i in Plantas}: sum{j in Revendas} PR[i, j] <= capacidade[i];
demanda_revendas{j in Revendas}: sum {i in Plantas} PR[i,j] >= demanda_minima[j];


resticao_y {i in Plantas}: sum{j in Revendas} PR[i, j] <= 99999*Y[i];


solve;

data;


param  lucro_PR:
	1 	2 		3:=
1 100	180		150
2 120	90		130;


param demanda_minima :=
1 55
2 70
3 65;

param capacidade :=
1 120
2 150;

param custo_planta :=
1 1200
2 1500;


/*
param  lucro_PR:
	1 	2 		3:=
1 100	180		150
2 120	90		130;


param demanda_minima :=
1 55
2 70
3 65;

param capacidade :=
1 200
2 150;

param custo_planta :=
1 100
2 40000;
*/


