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
pokemon_tb <- pokemon_tb %>% rowwise() %>% 
    mutate(capacites = Get_info_pokemon(tolower(nom))[[1]],
           HP = Get_info_pokemon(tolower(nom))[[2]],
           Attaque = Get_info_pokemon(tolower(nom))[[3]],
           Defense = Get_info_pokemon(tolower(nom))[[4]],
           Vitesse = Get_info_pokemon(tolower(nom))[[5]],
           Types = Get_info_pokemon(tolower(nom))[[6]])
pokemon_tb


stream_out(pokemon_tb, con = file("pokemon_tb.json"))
