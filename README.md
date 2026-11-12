# Kit de Pega Tátil para Corrimão

![Kit montado num tubo](imagens/capa_kit_4x3.png)

Capas impressas em 3D que você encaixa em qualquer corrimão redondo, sem obra e sem ferramenta. Com elas, a mão firma no tubo, e quem não enxerga sente pelo tato onde a escada começa e termina: seta, número de degraus e braille nas medidas da NBR 9050.

Projeto da disciplina **Project-Based Maker Lab**, FIAP Global Solution 2026.2, "CitizenTech: Cidade remodelada".

- **MakerWorld (kit, com Customizer):** https://makerworld.com/en/models/3593710-parametric-handrail-tactile-grip-kit
- **MakerWorld (gabarito, corte a laser):** https://makerworld.com/en/models/3593670-handrail-diameter-gauge

## O problema

O corrimão central da escada maior da Praça Piemonte, no Cipava, em Osasco (SP), é um tubo de ferro liso de 50 mm, sem nenhuma sinalização. Com chuva, a mão escorrega. Quem não enxerga não sabe onde a escada começa nem onde termina. A escada tem 12 degraus, e quem mais a usa são moradores idosos do bairro.

![Escada inteira, original e com o kit](imagens/lado_a_lado.png)

![Ponta do corrimão, antes e depois](imagens/close_ponta.png)

![Meio do corrimão, antes e depois](imagens/close_meio.png)

## As peças

| Peça | Função | Arquivo para imprimir |
|---|---|---|
| **Terminal** | Vai nas duas pontas do corrimão. A mesma peça serve em cima e embaixo. | `stl/terminal.stl` |
| **Plaquinha tátil** | Seta, número de degraus em relevo e em braille. Você desliza a plaquinha no trilho do terminal, e a abraçadeira a trava. | `stl/placa_tatil.stl` |
| **Pega de meio** | Anéis de textura para dar atrito entre os postes. Repita quantas precisar. | `stl/pega_meio.stl` |
| **Gabarito de diâmetro** | Placa com um "V" e escala de 20 a 60 mm, para medir o tubo antes de imprimir. | `laser/gabarito_laser.svg` ou `stl/gabarito_diametro_3d.stl` |
| **Fatias de teste** | Abraço de 200°, 220° e 240°. Imprima antes do kit e veja qual encaixa melhor no seu tubo. | `stl/teste_encaixe_*.stl` |

Os STLs prontos são para tubo de 50 mm e escada de 12 degraus. Para outro corrimão, use o Customizer.

![Terminal com a plaquinha](imagens/terminal_vista.png)

## Como usar

1. **Meça o tubo** com o gabarito: encoste o "V" no corrimão e leia o número onde ele toca.
2. **Gere as peças:** no Customizer do MakerWorld, ou abrindo `cad/kit_pega_tatil.scad` no [OpenSCAD](https://openscad.org), digite o diâmetro e o número de degraus.
3. **Teste o encaixe:** imprima uma fatia de teste. Se ficar frouxa, aumente o `abraco`. Se rachar ao encaixar, diminua.
4. **Imprima** o kit e as abraçadeiras.
5. **Instale:** encaixe cada capa com a abertura para baixo, passe as abraçadeiras pelos canais com a cabeça embaixo do tubo, aperte e corte a sobra.

## Impressão

| Peça | Posição | Material | Camada |
|---|---|---|---|
| Terminal e pega de meio | em pé (tubo na vertical), com brim | PETG | 0,2 mm |
| Plaquinha | deitada, braille para cima | PETG | 0,12 mm |
| Abraçadeira | como o autor indica | PETG | 0,2 mm |

Para instalação definitiva ao ar livre, use ASA: o PETG amolece no sol forte.

**Gabarito a laser:** MDF ou acrílico de 3 mm. No `gabarito_laser.svg`, vermelho é corte e preto é gravação. A pasta `laser/` traz os mesmos traços
