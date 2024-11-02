import requests
from bs4 import BeautifulSoup
import pandas as pd
import re
import matplotlib.pyplot as plt
import seaborn as sns
from io import StringIO

# Configurações para gráficos
plt.rcParams.update({'font.size': 12})

# 1. Obtenção e processamento dos dados
url_carne = "https://pt.wikipedia.org/wiki/Carne"
response = requests.get(url_carne)
soup = BeautifulSoup(response.content, 'html.parser')

# Extração da tabela específica
table = soup.select_one('#mw-content-text > div > table:nth-of-type(2)')
carne = pd.read_html(StringIO(str(table)))[0]

# Limpeza de dados
carne.columns = [col.lower().replace(" ", "_") for col in carne.columns]  # Normaliza os nomes das colunas
carne['conteudo_energetico'] = carne['conteudo_energetico'].str.replace(" Kcal", "").str.replace(",", ".").astype(float)
carne['agua'] = carne['agua'].str.replace(" g", "").str.replace(",", ".").astype(float)
carne['proteina'] = carne['proteina'].str.replace(" g", "").str.replace(",", ".").astype(float)
carne['gordura'] = carne['gordura'].str.replace(" g", "").str.replace(",", ".").astype(float)
carne['minerais'] = carne['minerais'].str.replace(" g", "").str.replace(",", ".").astype(float)

# Renomeação e categorização
rename_map = {
    "Suína": "Suina",
    "de vitelo": "Vitelo",
    "de cervo": "Cervo",
    "de frango (peito)": "Frango-peito",
    "de frango (coxa)": "Frango-coxa",
    "de peru (peito)": "Peru-peito",
    "de peru (coxa)": "Peru-coxa",
    "pato": "Pato",
    "ganso": "Ganso",
    "Gordura de suíno": "Gordura Suino",
    "Gordura de Bovino": "Gordura Bovino"
}
carne['tipo_de_carne'] = carne['tipo_de_carne'].replace(rename_map)
carne = carne.rename(columns={
    'tipo_de_carne': 'especie',
    'agua': 'agua',
    'proteina': 'proteina',
    'gordura': 'gordura',
    'minerais': 'minerais',
    'conteudo_energetico': 'kcal'
})

# Filtro e ordenação
meat = carne[~carne['especie'].isin(["Gordura Suino", "Gordura Bovino"])].sort_values(by='proteina', ascending=False)

# 2. Visualização dos dados
colors = ["#033146", "#003f5c", "#665191", "#2f4b7c", "#a05195", "#d45087", "#f95d6a", "#ff7c43", "#ffa600", "#c9880f"]
meat['color'] = colors + ["gray70"] * (len(meat) - len(colors))  # Colore os 10 primeiros, restantes em cinza

plt.figure(figsize=(10, 8))
sns.barplot(
    x='proteina', y='especie', data=meat, palette=meat['color']
)
for i, (value, specie) in enumerate(zip(meat['proteina'], meat['especie'])):
    plt.text(value + 0.1, i, f'{value}', color='black', va='center')

# Configurações de texto e estilo do gráfico
title_text = 'Composição química da carne: Proteína'
caption_text = "Dados: Wikipédia (2024)\nPlot: Ítalo Marques-Monteiro"
plt.title(title_text, fontsize=20, color="goldenrod")
plt.xlabel("")
plt.ylabel("")
plt.text(0.95, -0.2, caption_text, ha="center", va="top", transform=plt.gca().transAxes, color="gray")

plt.tight_layout()
plt.show()
