# ---------------------- Atelier récapitulatif - Pokémon ------------------------

library(tidyverse)
library(rvest)
library(jsonlite)
library(mongolite)

# ------ MongoDB

m <- mongo("pokemon_tb")
if(m$count() > 0) m$drop()
m$count()
m$import(file("pokemon_tb.json"))

# Pipeline d’agrégation qui calculera les valeurs moyennes du prix, du poids 
# et des statistiques de base en fonction de chaque capacité, version ou type

# En fonction des capacités



