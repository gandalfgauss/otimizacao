#Halliday Gauss Costa dos Santos 18.1.4093
#Emanuel Jesus Xavier 18.1.4148


#conjuntos
set I := {1..12}; # -> Conjunto de Clientes.
set D := {13..14}; #  -> Conjunto de Depósitos.
set F := {15}; #  -> Conjunto de postos de abastecimentos.
set V := I union D union F ; # -> Conjunto de Depósitos, Cliente, e postos de abastecimento {V= I U D U F}.
set F_ := F union {16}; # -> Conjunto de todos os postos de abastecimentos incluindo os fictícios.
set R := I union F_; # -> Conjunto de todos os clientes e postos de abastecimentos. {R = I U F’}
set V_ := R union D ; # -> Conjunto de todos os vértices {V’ = R U D}


#parametros
param d {i in V_, j in V_}; # -> Distância do nó i para o nó j.

param t {i in V_, j in V_}; # -> Tempo de viagem do nó i para o nó j.

param Q; # -> Capacidade do tanque de combustível dos veículos.

param r; # ->Taxa de consumo de combustível do veículo..

param S {i in V_}; # -> Tempo de descarga ou abastecimento no nó i.

param TMax; # -> Duração máxima da viagem.

param M; # -> Constante grande.



#variaveis
var X {i in V_, j in V_} =1, binary; #-> 1 se nó j é visitado por um veículo após passar pelo nó i. 0 caso contrário.

var Z {i in R, j in D} >=0, binary; #-> 1 se nó i é visitado por um veículo responsável pelo depósito j. 0 caso contrário

var Y {i in V_}  >=0; # -> Combustível do veículo após chegar no nó i. Obs : (Yi = Q, se i está em F’)


var T {i in V_}  >=0; # -> Hora de chegada no nó i. 


#funcao objetiva
# -> O objetivo é minimizar a distância percorrida pelos veículos

minimize distancia : sum {i in V_} (sum {j in V_} if i != j then d[i,j]*X[i,j]);

#restricoes

# > O objetivo dessa restrição é garantir que apenas um nó j seja visitado a partir de um nó i que é um cliente.
r1 {i in I}: sum{j in V_} if i != j then X[i, j] = 1;

#-> O objetivo dessa restrição é garantir que um cliente i seja visitado a partir de um único nó j.
r2 {i in I}: sum{j in V_} if i != j then X[j, i] = 1;
#-> Juntas essas restrições (r1 e r2)  garantem que cada cliente seja visitado uma única vez.

# -> O objetivo dessa restrição é garantir que um cliente i esteja associado a um único depósito j.
r3 {i in I}: sum{j in D} Z[i, j] = 1;

#-> O objetivo dessa função é garantir que um posto  i seja visitado no máximo uma vez. Obs: Como o somatório é <= 1, então não é obrigatório passar em um posto.
r4 {i in F_}: sum{j in V_} if i != j then X[i, j] <= 1;


# -> O objetivo dessa restrição é garantir o controle de fluxo, ou seja, todo nó deve ter uma aresta de entrada e uma de saída.

r5 {j in V_}: (sum{i in V_} if i != j then X[i, j]) - (sum{i in V_} if i != j then X[j, i]) = 0;

#-> O objetivo dessas restrições  (r6 e r7) é garantir que um veículo  viaje  a partir de um nó i para um depósito j ou um de depósito j para o nó i somente se esse o nó i estiver associado com o depósito j.

r6 {i in R, j in D}: X[i,j] <= Z[i,j];

r7 {i in R, j in D}: X[j,i] <= Z[i,j];


# -> O objetivo dessas restrições (r8 e r9) é garantir que dois nós (Cliente ou Posto), que foram visitados consecutivamente pelo mesmo veículo, devem ser atribuídos a uma mesmo depósito.

r8 {i in R, k in R, j in D}: if i != k then X[i,k] + Z[i,j] - Z[k,j] <=1;
r9 {i in R, k in R, j in D}: if i != k then X[i,k] + Z[k,j] - Z[i,j] <=1;

# O objetivo dessas restrições (r10 r11) é garantir que, se existir a aresta de i para j, sendo i e j pertencentes aos clientes ou postos, então a Hora de Chegada na cidade j tem que ser exatamente a Hora de chegada na cidade i somado com o tempo gasto para fazer o abastecimento ou descarga, mais o tempo de viagem da cidade i para a cidade j.

r10 {i in V_, j in R}: if i != j then T[j] >= T[i] + S[i] +t[i,j]-M*(1- X[i,j]);
r11 {i in V_, j in R}: if i != j then T[j] <= T[i] + S[i] +t[i,j]+M*(1- X[i,j]);


#-> O objetivo dessa restrição é garantir o tempo gasto no procedimento de rota não seja maior que o tempo TMax estipulado.


r12 {i in R, j in D}: T[i] + S[i] +t[i,j]*X[i,j] <= TMax;


#-> O objetivo dessa restrição é garantir que o controle do combustível do tanque em cada Cliente. Ou seja, o combustível até a cidade j, dado que tem aresta escolhida de i para j, tem que ser menor ou igual ao combustível que o veículo tinha na cidade i menos o combustível gasto para chegar na cidade j.


r13 {i in V_, j in I}: if i != j then Y[j] <= Y[i] - (r*d[i,j])*X[i,j] + Q*(1-X[i,j]);

#-> O objetivo dessa restrição é garantir que o veículo nunca fique sem combustível. Ou seja, a gasolina em um nó Cliente i, tem que ser maior ou igual ao gasto que se terá ao ir para uma cidade j.


r14 {i in I}:  Y[i] >= sum {j in V_} if i != j then r*d[i,j]*X[i,j];


#-> O objetivo dessa restrição é garantir que o veículo fique de tanque cheio ao visitar um posto de abastecimento.

r15 {i in F_}: Y[i] = Q;



solve;

data;

param M := 999999; # -> Constante grande.


#parametros
# -> Distância do nó i para o nó j,
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


# -> Tempo de viagem do nó i para o nó j.
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


param Q := 100; # -> Capacidade do tanque de combustível dos veículos.

param r := 1; # ->Taxa de consumo de combustível do veículo.

param TMax := 2000; # -> Duração máxima da viagem.


# -> Tempo de descarga ou abastecimento no nó i.
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

