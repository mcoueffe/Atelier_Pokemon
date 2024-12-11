# ---------------------- Atelier récapitulatif - Pokémon ------------------------

library(tidyverse)
library(rvest)
library(jsonlite)
library(mongolite)
library(ggplot2)

# ------ MongoDB

m <- mongo("pokemon_tb")
if(m$count() > 0) m$drop()
m$count()
m$import(file("pokemon_tb.json"))

# Pipeline d’agrégation qui calculera les valeurs moyennes du prix, du poids 
# et des statistiques de base en fonction de chaque capacité, version ou type

# En fonction des capacités
stats_par_capacites <- m$aggregate('[
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
stats_par_types <- m$aggregate('[
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

# ------------- Graphiques
colnames(stats_par_types)[1] <- "id"
colnames(stats_par_capacites)[1] <- "id"

# *** Sur les type des Pokémon
# Attaque et défense
ggplot(stats_par_types, aes(x=Attaque_moy, y=Defense_moy, color = Vitesse_moy)) +
  geom_text(label=stats_par_types$id,  aes(size = HP_moy))

# Prix et poids
ggplot(stats_par_types, aes(x=Prix_moy, y=Poids_moy)) +
  geom_point() +
  geom_text(label=stats_par_types$id)


# *** Sur les capacités des Pokémon
ggplot(stats_par_capacites, aes(x=Attaque_moy, y=Defense_moy, color = Vitesse_moy)) +
  geom_text(label=stats_par_capacites$id,  aes(size = HP_moy))
