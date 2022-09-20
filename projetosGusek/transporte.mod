#Halliday Gauss Costa dos Santos
#18.1.4093

#conjuntos
set Usinas := {1..2};
set Cidades := {1..3};
set Cidades_Faltantes := {1..2}; #cidades que podem faltar energia eletrica

#parametros
param custo_de_producao {i in Usinas, j in Cidades}; # custo de producao de energia eletrica da usina i para a cidade j em milhoes de kWh

param usina_artificial {j in Cidades_Faltantes};# custo de nao producao de energia eletrica da usina artificial para a cidade j em milhoes de kWh

param producao {i in Usinas}; # quantidade  de  energia eletrica produzida na usina i em milhoes de kWh

param producao_usina_artificial; # quantidade  de  energia eletrica nao produzida na usina artificial em milhoes de kWh

param demanda {i in Cidades}; # quantiade  de  energia eletrica consumida na cidade i em milhoes de kWh


#variaveis
var UiCj {i in Usinas, j in Cidades} >=0, integer; #quantidade de energia eletrica produzida da usina i para a cidade j em milhoes de kWh

var ArtUCj {j in Cidades_Faltantes} >=0, integer; #quantidade de energia eletrica nao produzida da usina artificial para a cidade j em milhoes de kWh


minimize custo : (sum {i in Usinas} (sum {j in Cidades} custo_de_producao[i,j]*UiCj[i,j])) + (sum {j in Cidades_Faltantes} usina_artificial[j]*ArtUCj[j]);


#restricoes

ofertas {i in Usinas}: sum{j in Cidades} UiCj[i, j] = producao[i];

oferta_artificial : sum{j in Cidades_Faltantes} ArtUCj[j] = producao_usina_artificial;

demandas{j in Cidades}: if j != 3 then (sum {i in Usinas} UiCj[i,j]) + ArtUCj[j]
						else (sum {i in Usinas} UiCj[i,j])
							= demanda[j];

solve;

data;


param  custo_de_producao:
	1 	2	3:=
1 	600 700 450
2 	320 300 350;
 


param usina_artificial :=
1 5000
2 5000;

param producao :=
1 45
2 36;

param producao_usina_artificial := 9;

param demanda :=
1 30
2 30
3 30;

# OBS: a solucao eh a mesma mesmo removendo a restricao de integralidade