# Web Scraping Carne

## Coleta e Transformação de Dados Não Formatados em Tabelas

[![NPM](https://img.shields.io/npm/l/react)](https://github.com/italomarquesmonteiro/web_scraping_carne/blob/main/LICENSE)

##

<img style="width:200px; height:200px;" src="Image/Icon meat.png" alt="Image Meat">

# Contatos do autor

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/italomarquesmonteiro/)
[![Twitter](https://img.shields.io/badge/X-%23000000.svg?style=for-the-badge&logo=X&logoColor=white)](https://twitter.com/italommonteiro)
[![Instagram](https://img.shields.io/badge/Instagram-E4405F?style=for-the-badge&logo=instagram&logoColor=white)](https://instagram.com/italo.m.m)
[![Medium](https://img.shields.io/badge/Medium-12100E?style=for-the-badge&logo=medium&logoColor=white)](https://medium.com/@italomarquesmonteiro)
[![Kaggle](https://img.shields.io/badge/Kaggle-035a7d?style=for-the-badge&logo=kaggle&logoColor=white)](https://www.kaggle.com/talomarquesmonteiro)
![WhatsApp](https://img.shields.io/badge/WhatsApp-25D366?style=for-the-badge&logo=whatsapp&logoColor=white)
[![YouTube](https://img.shields.io/badge/YouTube-FF0000?style=for-the-badge&logo=youtube&logoColor=white)](https://www.youtube.com/channel/UCB_lseG8dAbdjuemJv-nHXw)

## Índice

- <a href="#descricao">Descrição Geral</a>
- <a href="#objetivo">Objetivo</a>
- <a href="#dados">Dados</a>
- <a href="#limpeza">Limpeza</a>


## Descrição Geral


As evidências paleontológicas indicam que a carne desempenhava um papel significativo na dieta dos primeiros seres humanos [McHugo et al.(2019)](https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6889691/). Ao longo dos anos, a adaptação coevolutiva entre o *Homo sapiens* e espécies como o *Bos taurus*, o *Sus scrofa*, o *Bos indicus*, *Gallus gallus*, etc., demonstra que a carne continua sendo um alimento de grande importância para o ser humano, desempenhando papéis essenciais em diferentes aspectos.

A carne é composta principalmente por proteínas, minerais, vitaminas, gorduras e água, cujas proporções variam entre as espécies e desempenham um papel crucial na regulação dos processos fisiológicos do organismo. Dessa forma, a variedade de nutrientes presentes na carne desempenha funções específicas, garantindo uma contribuição significativa para a saúde e o bem-estar. Essa perspectiva ressalta a importância da carne na dieta humana, destacando seus benefícios em diferentes aspectos fisiológicos e nutricionais [FAO](https://www.fao.org/3/y2770e/y2770e07.htm).

## Objetivo

O objetivo deste projeto é realizar [*web scraping*](https://pt.wikipedia.org/wiki/Coleta_de_dados_web) utilizando a [linguagem de programação R](https://www.r-project.org/) para extrair dados relacionados à carne. Esses dados serão obtidos em condições reais do cotidiano de um analista, refletindo alguns dos desafios comuns, como formatos não estruturados, presença de dados duplicados, ausência de padrões e outras condições que demandarão limpeza e tratamento adequados para futuras visualizações e *insights*.

> [!NOTE]
>É fundamental adotar abordagens eficientes e éticas no web scraping, respeitando os termos de serviço dos sites fonte e garantindo a integridade dos dados coletados.

Ao enfrentar essas condições, o foco será aplicar técnicas de manipulação de dados, limpeza e transformação por meio de pacotes e funções disponíveis no universo [*tidyverve*](https://www.tidyverse.org/) do R.

## Dados

Os dados desse projeto provém da página da [Wikipédia-Carne](https://pt.wikipedia.org/wiki/Carne).

>[!CAUTION]
>Ao utilizar dados provenientes da Wikipédia, é importante considerar a natureza colaborativa da plataforma, onde informações podem ser atualizadas e modificadas ao longo do tempo sem validação científica.

A seguir, apresentam-se dados da composição química (g/100g) e conteúdo energético (Kcal/100g) médio da carne magra e da gordura de diversos animais após o abate.

<!--Tabela orginal é de autoria do [Prof. Roberto de Oliveira Roça](https://www.fca.unesp.br/Home/Instituicao/Departamentos/Gestaoetecnologia/Teses/Roca102.pdf) Departamento de Gestão e Tecnologia Agroindustrial da F.C.A. - UNESP - Campus de Botucatu -->

|Tipo de carne     | Água   | Proteína| Gordura| Minerais | Conteúdo energético
| :---             | :---:  | :---:   | :---:  | :---:    | :---:
| Bovina           | 75,0   |  22,3   |  1,8   | 1,2      | 116 Kcal
| de vitelo        | 76,4   |  21,3   |  0,8   | 1,2      | 98 Kcal
| de cervo         | 75,7   |  21,4   |  1,3   | 1,2      | 103 Kcal
| de frango (peito)| 75,0   |  22,8   |  0,9   | 1,2      | 105 Kcal
| de frango (coxa) | 74,7   |  20,6   |  3,1   | ---      | 116 Kcal
| de peru (peito)  | 73,7   |  24,1   |  1,0   | ----     | 112 Kcal
| de peru (coxa)   | 74,7   |  20,5   |  3,6   | ---      | 120 Kcal
| pato             | 73,8   |  18,3   |  6,0   | ---      | 132 Kcal
| ganso            | 68,3   |  22,8   |  7,1   | ---      | 161 Kcal
| Gordura de suíno | 7,7    |  2,9    |  88,7  | 0,7      | 812 Kcal
| Gordura de Bovino| 4,0    |  1,5    |  94,0  | 0,1      | 854 Kcal
| Suína            | 75,1 g |  22,8 g |  1,2 g | 1,0 g    | 112 Kcal

A correção do formato dos dados disponíveis possibilitará a manipulação e compreensão mais abrangente das informações sobre à carne, abrangendo aspectos como classificações e visualização gráfica de informações relevantes presentes na fonte fornecida.

A análise resultante proporcionará insights valiosos sobre à carne, contribuindo para uma compreensão mais aprofundada dos seus componentes químicos.

## Limpeza