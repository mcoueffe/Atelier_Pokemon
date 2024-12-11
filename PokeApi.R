# ---------------------- Atelier récapitulatif - Pokémon ------------------------

library(tidyverse)
library(rvest)
library(jsonlite)

load("pokemon_tb.Rdata")

# ------- PokéAPI
# On récupère • les capacités de chaque Pokémon (abilities),
#             • les statistiques de base (hp, attack, defense, speed),
#             • les types du Pokémon (types).

# On crée de nouvelles colonnes dans pokemon_tb
pokemon_tb <- pokemon_tb %>% 
  mutate(capacites = NA,
         HP = as.numeric(NA),
         Attaque = as.numeric(NA),
         Defense = as.numeric(NA),
         Vitesse = as.numeric(NA),
         Types = NA)

# On récupère les infos sur l'API

Get_info_pokemon <- function(nom_pokemon){
  pokemon_js <- fromJSON(paste0("https://pokeapi.co/api/v2/pokemon/", nom_pokemon))
  
  # On crée un vecteur de ses capacité
  abilities <- pokemon_js$abilities$ability$name
  
  # Statistiques de base
  statistiques <- tibble(pokemon_js$stats$base_stat, pokemon_js$stats$stat$name) %>% 
    filter(`pokemon_js$stats$stat$name` %in% c("hp", "attack", "defense", "speed")) %>% 
    pivot_wider(names_from = `pokemon_js$stats$stat$name`, values_from = `pokemon_js$stats$base_stat`)
  
  # Type des Pokémons
  types <- pokemon_js$types$type$name
  
  return(tibble(capacites = list(abilities),
         HP = as.numeric(statistiques[1]),
         Attaque = as.numeric(statistiques[2]),
         Defense = as.numeric(statistiques[3]),
         Vitesse = as.numeric(statistiques[4]),
         Types = list(types)))

}
  
# On renseigne le tibble
for (i in 1:dim(pokemon_tb)[1]){
  nom_pokemon <- tolower(pokemon_tb$nom[i])
  result_function <- Get_info_pokemon(nom_pokemon)
  pokemon_tb <- pokemon_tb %>% rowwise() %>% 
    mutate(capacites = result_function[[1]],
           HP = result_function[[2]],
           Attaque = result_function[[3]],
           Defense = result_function[[4]],
           Vitesse = result_function[[5]],
           Types = result_function[[6]])

}
head(pokemon_tb)
