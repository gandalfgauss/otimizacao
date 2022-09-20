\* Problem: transporte *\

Minimize
 custo: + 600 UiCj(1,1) + 700 UiCj(1,2) + 450 UiCj(1,3) + 320 UiCj(2,1)
 + 300 UiCj(2,2) + 350 UiCj(2,3) + 5000 ArtUCj(1) + 5000 ArtUCj(2)

Subject To
 ofertas(1): + UiCj(1,1) + UiCj(1,2) + UiCj(1,3) = 45
 ofertas(2): + UiCj(2,1) + UiCj(2,2) + UiCj(2,3) = 36
 oferta_artificial: + ArtUCj(1) + ArtUCj(2) = 9
 demandas(1): + UiCj(1,1) + UiCj(2,1) + ArtUCj(1) = 30
 demandas(2): + UiCj(1,2) + UiCj(2,2) + ArtUCj(2) = 30
 demandas(3): + UiCj(1,3) + UiCj(2,3) = 30

Generals
 UiCj(1,1)
 UiCj(1,2)
 UiCj(1,3)
 UiCj(2,1)
 UiCj(2,2)
 UiCj(2,3)
 ArtUCj(1)
 ArtUCj(2)

End
