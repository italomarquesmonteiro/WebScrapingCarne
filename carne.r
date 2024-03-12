library(tidyverse)

url_carne <- "https://pt.wikipedia.org/wiki/Carne"
carne <- rvest::read_html(url_carne) |>
  rvest::html_node(xpath = '//*[@id="mw-content-text"]/div[1]/table[2]') |>
  rvest::html_table() |>
  janitor::clean_names("snake")

carne <- carne |>
  dplyr::mutate(
    conteudo_energetico = stringr::str_replace_all(conteudo_energetico, " Kcal", ""), # nolint
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

meat <- carne |>
    dplyr::filter(
        !Especie == "Gordura Suino" &
        !Especie == "Gordura Bovino") |>
    dplyr::arrange(desc(Proteina))


meat <- meat |>
    dplyr::mutate(
        color = case_when(
          row_number() == 1 ~ "#033146",
          row_number() == 2 ~ "#003f5c",
          row_number() == 3 ~ "#665191",
          row_number() == 4 ~ "#2f4b7c", #"#665191"
          row_number() == 5 ~ "#a05195",
          row_number() == 6 ~ "#d45087",
          row_number() == 7 ~ "#f95d6a",
          row_number() == 8 ~ "#ff7c43",
          row_number() == 9 ~ "#ffa600",
          row_number() == 10 ~ "#c9880f",
          ## all others should be gray
          TRUE ~ "gray70"
        )
  )

# Name of the fonts we need
font <- "Josefin Sans"
font2 <- "Open Sans"

# Use the font_add_google() function to load fonts from the web
sysfonts::font_add_google(family=font, font, db_cache = FALSE)
sysfonts::font_add_google(family=font2, font2, db_cache = FALSE)

fa_path <- systemfonts::font_info(family = "Font Awesome 6 Brands")[["path"]]
sysfonts::font_add(family = "fa-brands", regular = fa_path)

theme_set(theme_minimal(base_family = font2, base_size = 3))

bg <- "white"
txt_col <- "black"

showtext_auto(enable = TRUE)


colors <- "goldenrod2"
title_text <- glue::glue('Composição química da carne: <span style="color:{colors}">**Proteína**</span>') # nolint
subtitle_text <- glue::glue("")
caption_text  <- stringr::str_glue("**Dados:**  Wikipédia, a enciclopédia livre(2024)<br>",
                          "**Plot:** Ítalo Marques-Monteiro <br><br>",
                          "<span style='font-family: \"fa-brands\"; color: black;'>&#xf09b;</span> italomarquesmonteiro<br>",
                          "<span style='font-family: \"fa-brands\"; color: steelblue;'>&#xf099;</span> italommonteiro<br>",
                          "<span style='font-family: \"fa-brands\"; color: red;'>&#xf16d;</span> italo.m.m"
)


protein <- meat |>
    #dplyr::select(Especie, Proteina) |>
    ggplot(
        aes(x = Proteina, y = reorder(
            Especie, Proteina), fill = color
             )
        ) +
    geom_col() +
    scale_fill_identity(guide = "none") +
    geom_text(mapping = aes(label = Proteina),
             position = position_dodge(1),
             vjust = 0, size = 5, hjust = 1,
             color = "black"
    ) +
    labs(
        title = title_text,
        caption = caption_text
    ) +
    theme(
        legend.position = "none",
        plot.title = ggtext::element_markdown(face = "bold", family = "Source Sans Pro", size = 35, hjust = 0, color = "gray40",), # nolint
        plot.subtitle = ggtext::element_markdown(face = "bold", family = "Fira Sans Pro", size = 15, color = "gray50", hjust = 0.1), # nolint
        #plot.caption = ggtext::element_markdown(face = "italic", family = "Fira Sans Pro", size = 15, color = "gray50"), # nolint
        plot.caption = ggtext::element_markdown(hjust=0, margin=margin(10,0,0,0), size=8, color=txt_col, lineheight = 1.2),

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
protein
ggsave(".github/.vscode/Image/protein.png", plot = protein, dpi = 600)
