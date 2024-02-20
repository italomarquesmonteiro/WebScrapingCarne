library(tidyverse)

url_carne <- "https://pt.wikipedia.org/wiki/Carne"
carne <- rvest::read_html(url_carne) |>
    rvest::html_node(xpath = '//*[@id="mw-content-text"]/div[1]/table[2]') |>
    rvest::html_table() |>
    janitor::clean_names("snake")


carne <- carne |>
    dplyr::mutate(
        conteudo_energetico = stringr::str_replace_all(
            conteudo_energetico, " Kcal", ""),
        agua = stringr::str_replace_all(agua, " g", ""),
        proteina = stringr::str_replace_all(proteina, " g", ""),
        gordura = stringr::str_replace_all(gordura, " g", ""),
        minerais = stringr::str_replace_all(minerais, " g", ""),
        agua = gsub(",", ".", agua),
        proteina = gsub(",", ".", proteina),
        gordura = gsub(",", ".", gordura),
        minerais = gsub(",", ".", minerais),
        conteudo_energetico = gsub(",", ".", conteudo_energetico),
        agua = as.numeric(agua),
        proteina = as.numeric(proteina),
        gordura = as.numeric(gordura),
        minerais = as.numeric(minerais),
        conteudo_energetico = as.numeric(conteudo_energetico),
        tipo_de_carne = dplyr::case_when(
            tipo_de_carne == "Suína" ~ "Suina",
            tipo_de_carne == "de vitelo" ~ "Vitelo",
            tipo_de_carne == "de cervo" ~ "Cervo",
            tipo_de_carne == "de frango (peito)" ~ "Frango-peito",
            tipo_de_carne == "de frango (coxa)" ~ "Frango-coxa",
            tipo_de_carne == "de peru (peito)" ~ "Peru-peito",
            tipo_de_carne == "de peru (coxa)" ~ "Peru-coxa",
            tipo_de_carne == "pato" ~ "Pato",
            tipo_de_carne == "ganso" ~ "Ganso",
            tipo_de_carne == "Gordura de suíno" ~ "Gordura Suino",
            tipo_de_carne == "Gordura de Bovino" ~ "Gordura Bovino",
            TRUE ~ tipo_de_carne
        )
    ) |>
    dplyr::rename(
        Especie = tipo_de_carne,
        Agua = agua,
        Proteina = proteina,
        Gordura = gordura,
        Minerais = minerais,
        Kcal = conteudo_energetico
    ) |>
    dplyr::glimpse()




carne |>
    dplyr::select(Especie, Proteina) |>
    dplyr::filter(
        !Especie == "Gordura Suino" &
        !Especie == "Gordura Bovino") |>
    ggplot(
        aes(x = Proteina, y = reorder(
            Especie, Proteina), fill = Especie
             )
        ) +
    geom_col(col = "black") +
    scale_fill_viridis_d(guide = "none") +
    labs(
        title = "Química da carne: Proteína",
        fill = "",
        legend.position = "none",
        x = "Proteína (g)",
        y = "Tipos de Carne (espécies)",
        caption = "By Ítalo Monteiro
        Fonte: https://pt.wikipedia.org/wiki/Carne (nov, 2022)",
        legend.title = element_text(size = 18, color = "black"),
        legend.text = element_text(size = 12, color = "black"),
        axis.title.x = element_text(size = 16, color = "black"),
        axis.title.y = element_text(size = 16, color = "black"),
        axis.text.y = element_text(size = 16, color = "black"),
        axis.text.x = element_text(size = 16, color = "black"),
        axis.line = element_line(colour = "black"),
        panel.border = element_rect(colour = "black", fill = NA, size = 0.5)
    ) +
    theme_bw()