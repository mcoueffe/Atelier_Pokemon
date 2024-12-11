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
m$aggregate('[
              {
  "$unwind": "$capacites"
  },
 {
 "$group": {
 "_id": "$capacites",
 "Prix_moy": { "$avg": "$prix" },
 "Poids_moy": {"$avg": "$poids"},
 "HP_moy": {"$avg": "$HP"},
 "Attaque_moy": {"$avg": "$Attaque"},
 "Defense_moy": {"$avg": "$Defense"},
 "Vitesse_moy": {"$avg": "$Vitesse"}
 }
 }
 ]')

# En fonction des types
m$aggregate('[
              {
  "$unwind": "$Types"
  },
 {
 "$group": {
 "_id": "$Types",
 "Prix_moy": { "$avg": "$prix" },
 "Poids_moy": {"$avg": "$poids"},
 "HP_moy": {"$avg": "$HP"},
 "Attaque_moy": {"$avg": "$Attaque"},
 "Defense_moy": {"$avg": "$Defense"},
 "Vitesse_moy": {"$avg": "$Vitesse"}
 }
 }
 ]')



