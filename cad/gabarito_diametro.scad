// =====================================================
// KIT DE PEGA TÁTIL - GABARITO DE DIÂMETRO (corte a laser)
// Placa com um "V". Encoste o V no tubo do corrimão: o
// tubo toca as duas bordas, e o número no ponto de contato
// é o diâmetro. Esse valor vai no parâmetro diametro_tubo
// do terminal e da pega de meio.
// Material: MDF ou acrílico de 3 mm. Medidas em milímetros.
// =====================================================

/* [O que gerar] */

// corte = contorno (DXF/SVG para o laser); gravacao = escala e textos; peca3d = versão para imprimir em 3D; vista = as duas camadas juntas
parte = "vista"; // [vista, corte, gravacao, peca3d]

/* [Escala] */

// Menor diâmetro da escala, em mm
d_min = 20; // [10:1:40]

// Maior diâmetro da escala, em mm
d_max = 60; // [40:1:80]

// Metade do ângulo do V, em graus (menor = escala mais espaçada)
meio_angulo = 20; // [15:1:30]

/* [Placa] */

// Espessura do material, em mm (só para a versão 3D)
espessura = 3; // [2:0.5:6]

/* [Hidden] */

largura = 130;
altura = 135;
raio_canto = 6;
margem_baixo = 40;          // faixa de baixo, com título e instruções
profundidade_v = altura - margem_baixo;
y_vertice = margem_baixo;   // ponta do V
traco = 0.4;                // largura das linhas gravadas
fonte = "Liberation Sans:style=Bold";

// Distância da ponta do V até o ponto onde um tubo de diâmetro d
// encosta na borda, medida ao longo da borda.
function contato(d) = (d / 2) / tan(meio_angulo);

$fn = 64;

// ---------- CORTE ----------

module contorno() {
    difference() {
        offset(r = raio_canto) offset(delta = -raio_canto)
            square([largura, altura]);
        // o V, aberto para cima
        polygon([
            [largura / 2, y_vertice],
            [largura / 2 + (profundidade_v + 1) * tan(meio_angulo), altura + 1],
            [largura / 2 - (profundidade_v + 1) * tan(meio_angulo), altura + 1]
        ]);
        // furo para pendurar
        translate([12, 12]) circle(d = 6);
    }
}

// ---------- GRAVAÇÃO ----------

// Escala ao longo de uma borda do V. lado = +1 (direita) ou -1 (esquerda)
module escala(lado) {
    for (d = [d_min : 1 : d_max]) {
        t = contato(d);
        comprido = (d % 5 == 0);
        // ponto de contato na borda
        translate([largura / 2 + lado * t * sin(meio_angulo), y_vertice + t * cos(meio_angulo)])
            rotate([0, 0, lado * -meio_angulo])
                union() {
                    // traço perpendicular à borda, para fora do V
                    translate([lado > 0 ? 0.6 : -0.6 - (comprido ? 7 : 4), -traco / 2])
                        square([comprido ? 7 : 4, traco]);
                    if (comprido)
                        translate([lado * 13, 0])
                            rotate([0, 0, lado * meio_angulo])
                                text(str(d), size = 4, font = fonte,
                                     halign = "center", valign = "center");
                }
    }
}

module textos() {
    translate([largura / 2, 27])
        text("GABARITO DE DIÂMETRO (mm)", size = 5, font = fonte, halign = "center");
    translate([largura / 2, 18])
        text("Encoste o V no tubo e leia onde ele toca", size = 3.4,
             font = "Liberation Sans", halign = "center");
    translate([largura / 2, 11])
        text("Kit de Pega Tátil para Corrimão", size = 3.4,
             font = "Liberation Sans", halign = "center");
}

module gravacao() {
    escala(1);
    escala(-1);
    textos();
}

// ---------- SAÍDA ----------

if (parte == "corte") contorno();
if (parte == "gravacao") gravacao();

if (parte == "vista") {
    color([0.80, 0.62, 0.40]) linear_extrude(espessura) contorno();
    color([0.15, 0.12, 0.10]) translate([0, 0, espessura]) linear_extrude(0.2) gravacao();
}

// Sem laser: imprime em 3D com a escala rebaixada 0,6 mm
if (parte == "peca3d")
    difference() {
        linear_extrude(espessura) contorno();
        translate([0, 0, espessura - 0.6]) linear_extrude(1) gravacao();
    }
