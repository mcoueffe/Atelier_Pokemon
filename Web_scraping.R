# ---------------------- Atelier récapitulatif - Pokémon ------------------------

library(tidyverse)
library(rvest)

# ------- Web Scraping
# On souhaite récupérer le nom, le prix et le poids des Pokémons (premières pages)

# Page principale
url <- "https://scrapeme.live/product-category/pokemon/"
data_html <- read_html(url)

# On récupère les différents blocs de la page
blocs <- data_html %>% html_nodes("li.product") 

# On scrappe le nom, le prix et le poids du Pokemon
blocs_noms <- blocs %>% html_node("h2.woocommerce-loop-product__title") %>% html_text()
blocs_prix <- blocs %>% html_node("span.woocommerce-Price-amount") %>% html_text()
liens <- blocs %>% html_nodes("a.woocommerce-LoopProduct-link") %>% html_attrs()
  
(titres[[num_bloc]] %>% html_attrs())["href"]

Scan <- function(num_bloc){
  # On récupère les infos
  nom <-  blocs_noms[[num_bloc]] # nom
  prix <- blocs_prix[[num_bloc]] # prix
  lien_annonce <- (liens[[num_bloc]])["href"]
  data_annonce <- read_html(lien_annonce)
  poids <- data_annonce %>% html_nodes("td.product_weight") %>% html_text()
  
  # On numérise le prix et le poids
  prix <- as.numeric(sub(x=prix, pattern = "£", replacement =""))
  poids <- as.numeric(sub(x=poids, pattern = " kg", replacement =""))
  
  return(list(titre, prix, poids))
}
