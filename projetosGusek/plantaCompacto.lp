\* Problem: plantaCompacto *\

Maximize
 lucro: + 100 PR(1,1) + 180 PR(1,2) + 150 PR(1,3) + 120 PR(2,1)
 + 90 PR(2,2) + 130 PR(2,3) - 1200 Y(1) - 1500 Y(2)

Subject To
 capacidade_plantas(1): + PR(1,1) + PR(1,2) + PR(1,3) <= 120
 capacidade_plantas(2): + PR(2,1) + PR(2,2) + PR(2,3) <= 150
 demanda_revendas(1): + PR(1,1) + PR(2,1) >= 55
 demanda_revendas(2): + PR(1,2) + PR(2,2) >= 70
 demanda_revendas(3): + PR(1,3) + PR(2,3) >= 65
 resticao_y(1): + PR(1,1) + PR(1,2) + PR(1,3) - 99999 Y(1) <= -0
 resticao_y(2): + PR(2,1) + PR(2,2) + PR(2,3) - 99999 Y(2) <= -0

Bounds
 0 <= Y(1) <= 1
 0 <= Y(2) <= 1

Generals
 PR(1,1)
 PR(1,2)
 PR(1,3)
 PR(2,1)
 PR(2,2)
 PR(2,3)
 Y(1)
 Y(2)

End
