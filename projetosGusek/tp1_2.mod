#Halliday Gauss Costa dos Santos 18.1.4093
#Emanuel Jesus Xavier 18.1.4148


#conjuntos
set I := {1..12}; # -> Conjunto de Clientes.
set D := {13..14}; #  -> Conjunto de Dep�sitos.
set F := {15}; #  -> Conjunto de postos de abastecimentos.
set V := I union D union F ; # -> Conjunto de Dep�sitos, Cliente, e postos de abastecimento {V= I U D U F}.
set F_ := F union {16}; # -> Conjunto de todos os postos de abastecimentos incluindo os fict�cios.
set R := I union F_; # -> Conjunto de todos os clientes e postos de abastecimentos. {R = I U F�}
set V_ := R union D ; # -> Conjunto de todos os v�rtices {V� = R U D}


#parametros
param d {i in V_, j in V_}; # -> Dist�ncia do n� i para o n� j.

param t {i in V_, j in V_}; # -> Tempo de viagem do n� i para o n� j.

param Q; # -> Capacidade do tanque de combust�vel dos ve�culos.

param r; # ->Taxa de consumo de combust�vel do ve�culo..

param S {i in V_}; # -> Tempo de descarga ou abastecimento no n� i.

param TMax; # -> Dura��o m�xima da viagem.

param M; # -> Constante grande.



#variaveis
var X {i in V_, j in V_} =1, binary; #-> 1 se n� j � visitado por um ve�culo ap�s passar pelo n� i. 0 caso contr�rio.

var Z {i in R, j in D} >=0, binary; #-> 1 se n� i � visitado por um ve�culo respons�vel pelo dep�sito j. 0 caso contr�rio

var Y {i in V_}  >=0; # -> Combust�vel do ve�culo ap�s chegar no n� i. Obs : (Yi = Q, se i est� em F�)


var T {i in V_}  >=0; # -> Hora de chegada no n� i. 


#funcao objetiva
# -> O objetivo � minimizar a dist�ncia percorrida pelos ve�culos

minimize distancia : sum {i in V_} (sum {j in V_} if i != j then d[i,j]*X[i,j]);

#restricoes

# > O objetivo dessa restri��o � garantir que apenas um n� j seja visitado a partir de um n� i que � um cliente.
r1 {i in I}: sum{j in V_} if i != j then X[i, j] = 1;

#-> O objetivo dessa restri��o � garantir que um cliente i seja visitado a partir de um �nico n� j.
r2 {i in I}: sum{j in V_} if i != j then X[j, i] = 1;
#-> Juntas essas restri��es (r1 e r2)  garantem que cada cliente seja visitado uma �nica vez.

# -> O objetivo dessa restri��o � garantir que um cliente i esteja associado a um �nico dep�sito j.
r3 {i in I}: sum{j in D} Z[i, j] = 1;

#-> O objetivo dessa fun��o � garantir que um posto  i seja visitado no m�ximo uma vez. Obs: Como o somat�rio � <= 1, ent�o n�o � obrigat�rio passar em um posto.
r4 {i in F_}: sum{j in V_} if i != j then X[i, j] <= 1;


# -> O objetivo dessa restri��o � garantir o controle de fluxo, ou seja, todo n� deve ter uma aresta de entrada e uma de sa�da.

r5 {j in V_}: (sum{i in V_} if i != j then X[i, j]) - (sum{i in V_} if i != j then X[j, i]) = 0;

#-> O objetivo dessas restri��es  (r6 e r7) � garantir que um ve�culo  viaje  a partir de um n� i para um dep�sito j ou um de dep�sito j para o n� i somente se esse o n� i estiver associado com o dep�sito j.

r6 {i in R, j in D}: X[i,j] <= Z[i,j];

r7 {i in R, j in D}: X[j,i] <= Z[i,j];


# -> O objetivo dessas restri��es (r8 e r9) � garantir que dois n�s (Cliente ou Posto), que foram visitados consecutivamente pelo mesmo ve�culo, devem ser atribu�dos a uma mesmo dep�sito.

r8 {i in R, k in R, j in D}: if i != k then X[i,k] + Z[i,j] - Z[k,j] <=1;
r9 {i in R, k in R, j in D}: if i != k then X[i,k] + Z[k,j] - Z[i,j] <=1;

# O objetivo dessas restri��es (r10 r11) � garantir que, se existir a aresta de i para j, sendo i e j pertencentes aos clientes ou postos, ent�o a Hora de Chegada na cidade j tem que ser exatamente a Hora de chegada na cidade i somado com o tempo gasto para fazer o abastecimento ou descarga, mais o tempo de viagem da cidade i para a cidade j.

r10 {i in V_, j in R}: if i != j then T[j] >= T[i] + S[i] +t[i,j]-M*(1- X[i,j]);
r11 {i in V_, j in R}: if i != j then T[j] <= T[i] + S[i] +t[i,j]+M*(1- X[i,j]);


#-> O objetivo dessa restri��o � garantir o tempo gasto no procedimento de rota n�o seja maior que o tempo TMax estipulado.


r12 {i in R, j in D}: T[i] + S[i] +t[i,j]*X[i,j] <= TMax;


#-> O objetivo dessa restri��o � garantir que o controle do combust�vel do tanque em cada Cliente. Ou seja, o combust�vel at� a cidade j, dado que tem aresta escolhida de i para j, tem que ser menor ou igual ao combust�vel que o ve�culo tinha na cidade i menos o combust�vel gasto para chegar na cidade j.


r13 {i in V_, j in I}: if i != j then Y[j] <= Y[i] - (r*d[i,j])*X[i,j] + Q*(1-X[i,j]);

#-> O objetivo dessa restri��o � garantir que o ve�culo nunca fique sem combust�vel. Ou seja, a gasolina em um n� Cliente i, tem que ser maior ou igual ao gasto que se ter� ao ir para uma cidade j.


r14 {i in I}:  Y[i] >= sum {j in V_} if i != j then r*d[i,j]*X[i,j];


#-> O objetivo dessa restri��o � garantir que o ve�culo fique de tanque cheio ao visitar um posto de abastecimento.

r15 {i in F_}: Y[i] = Q;



solve;

data;

param M := 999999; # -> Constante grande.


#parametros
# -> Dist�ncia do n� i para o n� j,
param d:
	1 			2			3			4			5			6			7			8			9			10			11			12			13			14			15	16:=
1 	999999		12.47			999999			999999			999999			999999			999999			999999			999999			999999			999999			999999			8.77		999999			999999	999999
2 	12.47		999999		28.27			999999			999999			999999			999999			999999			999999			999999			999999			999999			999999			999999			999999	999999
3	999999			28.27		999999			999999			999999			999999			999999			999999			999999			999999			999999			999999			35			999999			999999	999999
4	999999			999999			999999			999999			10.97		999999			999999			999999			999999			999999			999999			999999			24.88		999999			999999	999999
5	999999			999999			999999			10.97		999999			29.67		999999			999999			999999			999999			999999			999999			999999			999999			999999	999999
6	999999			999999			999999			999999			29.67		999999			999999			999999			999999			999999			999999			999999			4			999999			999999	999999
7	999999			999999			999999			999999			999999			999999			999999		20.16			999999			999999			999999			999999			999999		11.71			999999	999999
8	999999			999999			999999			999999			999999			999999			20.16		999999		11.16			999999			999999			999999			999999			999999			999999	999999
9	999999			999999			999999			999999			999999			999999			999999			11.16		999999			999999			999999			999999			999999			999999			20	999999
10	999999			999999			999999			999999			999999			999999			999999			999999			999999			999999			999999			999999			999999			45		8.44	999999
11	999999			999999			999999			999999			999999			999999			999999			999999			999999			999999			999999			10.57		999999		12.62			999999	999999
12	999999			999999			999999			999999			999999			999999			999999			999999			999999			999999			10.57		999999			999999			16.55		999999	999999
13	8.77		999999			35			24.88		999999			4			999999			999999			999999			999999			999999			999999			999999			999999			999999	999999
14	999999			999999			999999			999999			999999			999999			11.71		999999			999999			45			12.62		16.55		999999			999999			999999	999999
15	999999			999999			999999			999999			999999			999999			999999			999999			20			8.44		999999			999999			999999			999999			999999	999999
16	999999			999999			999999			999999			999999			999999			999999			999999			999999			999999			999999			999999			999999			999999			999999	999999 ;


# -> Tempo de viagem do n� i para o n� j.
param t:
	1 			2			3			4			5			6			7			8			9			10			11			12			13			14			15	16:=
1 	999999		12.47			999999			999999			999999			999999			999999			999999			999999			999999			999999			999999			8.77		999999			999999	999999
2 	12.47		999999		28.27			999999			999999			999999			999999			999999			999999			999999			999999			999999			999999			999999			999999	999999
3	999999			28.27		999999			999999			999999			999999			999999			999999			999999			999999			999999			999999			35			999999			999999	999999
4	999999			999999			999999			999999			10.97		999999			999999			999999			999999			999999			999999			999999			24.88		999999			999999	999999
5	999999			999999			999999			10.97		999999			29.67		999999			999999			999999			999999			999999			999999			999999			999999			999999	999999
6	999999			999999			999999			999999			29.67		999999			999999			999999			999999			999999			999999			999999			4			999999			999999	999999
7	999999			999999			999999			999999			999999			999999			999999		20.16			999999			999999			999999			999999			999999		11.71			999999	999999
8	999999			999999			999999			999999			999999			999999			20.16		999999		11.16			999999			999999			999999			999999			999999			999999	999999
9	999999			999999			999999			999999			999999			999999			999999			11.16		999999			999999			999999			999999			999999			999999			20	999999
10	999999			999999			999999			999999			999999			999999			999999			999999			999999			999999			999999			999999			999999			45		8.44	999999
11	999999			999999			999999			999999			999999			999999			999999			999999			999999			999999			999999			10.57		999999		12.62			999999	999999
12	999999			999999			999999			999999			999999			999999			999999			999999			999999			999999			10.57		999999			999999			16.55		999999	999999
13	8.77		999999			35			24.88		999999			4			999999			999999			999999			999999			999999			999999			999999			999999			999999	999999
14	999999			999999			999999			999999			999999			999999			11.71		999999			999999			45			12.62		16.55		999999			999999			999999	999999
15	999999			999999			999999			999999			999999			999999			999999			999999			20			8.44		999999			999999			999999			999999			999999	999999
16	999999			999999			999999			999999			999999			999999			999999			999999			999999			999999			999999			999999			999999			999999			999999	999999 ;


param Q := 100; # -> Capacidade do tanque de combust�vel dos ve�culos.

param r := 1; # ->Taxa de consumo de combust�vel do ve�culo.

param TMax := 2000; # -> Dura��o m�xima da viagem.


# -> Tempo de descarga ou abastecimento no n� i.
param S :=
1 10
2 11
3 12
4 13
5 14
6 15
7 16
8 17
9 18
10 19
11 20
12 21
13 10
14 10
15 8
16 8; 

