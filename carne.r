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


colors <- "mediumpurple"
title_text <- glue::glue('Composição química da carne: <span style="color:{colors}">**Proteína**</span>') # nolint
subtitle_text <- glue::glue("")
caption_text <- glue::glue('**Plot:** **@italo.m.m**<br>**Dados:** Wikepédia(2024)') # nolint


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
    geom_col(fill = "grey70") +
    geom_text(mapping = aes(label = Proteina),
             position = position_dodge(1),
             vjust = 0.5, size = 5, hjust = 1
    ) +
    labs(
        title = title_text,
        caption = caption_text
    ) +
    theme(
        legend.position = "none",
        plot.title = ggtext::element_markdown(face = "bold", family = "Source Sans Pro", size = 35, hjust = 0, color = "gray40",), # nolint
        plot.subtitle = ggtext::element_markdown(face = "bold", family = "Fira Sans Pro", size = 15, color = "gray50", hjust = 0.1), # nolint
        plot.caption = ggtext::element_markdown(face = "italic", family = "Fira Sans Pro", size = 15, color = "gray50"), # nolint
        axis.text.y = ggtext::element_markdown(face = "italic", family = "Fira Sans Pro", size = 12, color = "gray50"), # nolint
        axis.title.y = element_blank(),
        axis.text.x = element_blank(),
        axis.title.x = element_blank(),
        panel.background = element_rect(fill = "white", color = "white"),
        plot.background = element_rect(fill = "white"),
        line = element_blank(),
        #axis.text.x = ggtext::element_markdown(
          #face = "bold", family = "Fira Sans",size = 8, color = "gray50", angle = 0, hjust = 1, vjust = 1) # nolint
    )


colors <- "mediumpurple"
title_text <- glue::glue('Composição química da <span style="color:{colors}">**Carne**</span>') # nolint
subtitle_text <- glue::glue("")
caption_text <- glue::glue('**Plot:** **@italo.m.m**<br>**Dados:** Wikepédia(2024)') # nolint

carne |>
    tidyr::pivot_longer(
        -Especie, names_to = "comp_quimica", values_to = "value") |>
    dplyr::filter(
        !Especie == "Gordura Suino" &
        !Especie == "Gordura Bovino") |>
    ggplot(aes(
        x = comp_quimica, y = value, fill = Especie)
        ) +
    geom_col(position = "dodge", col = "black") +
    #scale_fill_viridis_d(option = "inferno") +
    labs(
        title = title_text,
        fill = "Composição Quimica",
        legend.position = "",
        x = "Espécies",
        y = "Valores de referencia [g, kcal] ",
        caption = caption_text
    ) +
    theme(
        legend.position = "top",
        plot.title = ggtext::element_markdown(face = "bold", family = "Source Sans Pro", size = 35, hjust = 0, color = "gray40",), # nolint
        plot.subtitle = ggtext::element_markdown(face = "bold", family = "Fira Sans Pro", size = 15, color = "gray50", hjust = 0.1), # nolint
        plot.caption = ggtext::element_markdown(face = "italic", family = "Fira Sans Pro", size = 15, color = "gray50"), # nolint
        axis.text.y = ggtext::element_markdown(face = "italic", family = "Fira Sans Pro", size = 12, color = "gray50"), # nolint
        axis.title.y = element_blank(),
        axis.text.x = element_blank(),
        axis.title.x = element_blank(),
        panel.background = element_rect(fill = "white", color = "white"),
        plot.background = element_rect(fill = "white"),
        line = element_blank()
    )