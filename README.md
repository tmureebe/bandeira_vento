# Bandeira giratória de seis pontos

Modelo alternativo de bandeira de vento com pano de **60 × 140 cm**, mastro lateral e base com **20 L de lastro**. O mastro e a armação giram juntos em torno do pivô vertical, enquanto a base fica apoiada no chão. Uma cruzeta e uma travessa sustentam o pano em seis reforços internos, com todo o perímetro livre.

## Construa o protótipo

Comece pelo [guia ilustrado de construção](Guia%20de%20constru%C3%A7%C3%A3o%20%E2%80%94%20Bandeira%20de%20seis%20pontos.pdf). Ele traz a lista de materiais e ferramentas, os desenhos cotados, a sequência de montagem e um ensaio com ventilador. A versão de oficina usa uma plataforma quadrada com quatro galões fechados de 5 L.

## Veja o mecanismo

- [Modelo paramétrico em OpenSCAD](bandeira_seis_pontos.scad) — abra o arquivo, pressione **F5** e use os parâmetros `vista` e `angulo` para inspecionar o conjunto, o pivô e as alças.
- [Cena animada do Blender](Bandeira%20de%20seis%20pontos.blend) — abra no Blender 5.3 e pressione **Espaço**. O arquivo inclui o cache Cloth e a textura UV da estampa fictícia. A câmera mostra o pano se curvando sob vento frontal e a redução dessa curvatura quando a armação gira 86°, com o vento mantido na mesma direção.
- [Geometria e funcionamento](Bandeira_de_seis_pontos.pdf) — vistas do conjunto, detalhe das fixações e corte do pivô com o reservatório circular do modelo.
- [Estudo de tombamento](Tombamento_bandeira_giratoria.pdf) — comparação por simulação com uma bandeira de vento convencional, com pivô livre e travado.

## Licença

A documentação de hardware do projeto, incluindo o modelo OpenSCAD, a cena Blender, o guia e os dois estudos técnicos, é licenciada sob a **TAPR Noncommercial Hardware License 1.0**. Consulte o [texto integral em inglês](LICENSE.txt) ou o [PDF publicado pela TAPR](https://files.tapr.org/OHL/TAPR_Noncommercial_Hardware_License_v1.0.pdf).

O arquivo `PL-5820-2026.pdf` é um documento da Câmara dos Deputados e fica fora do escopo da licença do projeto.
