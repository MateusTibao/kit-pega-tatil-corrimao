// =====================================================
// CORRIMÃO ORIGINAL - Praça Piemonte, Cipava, Osasco
// Modelo simplificado ao que importa para o problema:
// tubo, inclinação, postes, vãos e pontas.
// Todas as medidas em milímetros.
// =====================================================

// ---------- PARÂMETROS DO CORRIMÃO ----------

// Diâmetro do tubo (medido: 50 mm; a NBR 9050 aceita até 45 mm)
diametro_tubo = 50;

// Distância entre um poste e o próximo, ao longo do tubo
vao = 2300;

// Quanto o tubo passa do primeiro e do último poste
prolongamento = 200;

// Diâmetro dos postes (ESTIMADO, não medido)
diametro_poste = 38;

// Altura do topo do tubo acima do degrau onde o poste está
altura_corrimao = 900;

// ---------- PARÂMETROS DA ESCADA ----------

// Número de degraus
num_degraus = 12;

// Altura de cada degrau (média medida)
degrau_altura = 250;

// Largura da escada
largura_escada = 2000;

// ---------- O QUE MOSTRAR ----------

// Mostrar a escada (só contexto, não faz parte do objeto)
mostrar_escada = true;

// Mostrar o kit instalado (entra na etapa do redesign)
mostrar_kit = false;

// ---------- CÁLCULOS (não precisa mexer) ----------

// O primeiro poste fica no 1º degrau e o último no patamar de cima.
// Entre eles há 2 vãos e (num_degraus - 1) degraus de subida.
distancia_postes = 2 * vao;
subida = (num_degraus - 1) * degrau_altura;

// Inclinação e profundidade dos degraus saem dessas medidas
inclinacao = asin(subida / distancia_postes);
degrau_profundidade = distancia_postes * cos(inclinacao) / (num_degraus - 1);

// Posição do primeiro poste: sobre o 1º degrau, perto da quina
x_poste1 = degrau_profundidade * 0.3;
z_eixo_poste1 = degrau_altura + altura_corrimao - diametro_tubo / 2;

// Ponto do eixo do tubo a uma distância s do primeiro poste
function ponto_tubo(s) = [
    x_poste1 + s * cos(inclinacao),
    0,
    z_eixo_poste1 + s * sin(inclinacao)
];

// Altura do piso embaixo de um ponto x
function altura_piso(x) =
    x < 0 ? 0 :
    min(num_degraus, floor(x / degrau_profundidade) + 1) * degrau_altura;

// Posição dos 3 postes ao longo do tubo
postes = [0, vao, 2 * vao];

// Comprimento total do tubo
comprimento_tubo = 2 * vao + 2 * prolongamento;

echo(str("Inclinação calculada: ", inclinacao, " graus"));
echo(str("Profundidade do degrau calculada: ", degrau_profundidade, " mm"));
echo(str("Comprimento do tubo: ", comprimento_tubo, " mm"));

$fn = 64;

// ---------- MODELO ----------

module tubo() {
    color([0.25, 0.42, 0.30])
        translate(ponto_tubo(-prolongamento))
            rotate([0, 90 - inclinacao, 0])
                cylinder(d = diametro_tubo, h = comprimento_tubo);
}

module poste(s) {
    topo = ponto_tubo(s);
    base = altura_piso(topo[0]);
    color([0.25, 0.42, 0.30])
        translate([topo[0], 0, base])
            cylinder(d = diametro_poste, h = topo[2] - base);
}

module escada() {
    color([0.88, 0.86, 0.82])
    for (k = [1 : num_degraus])
        translate([(k - 1) * degrau_profundidade,
                   -largura_escada / 2,
                   (k - 1) * degrau_altura])
            cube([(num_degraus - k + 1) * degrau_profundidade + 1500,
                  largura_escada,
                  degrau_altura]);
    // piso de baixo
    color([0.55, 0.55, 0.55])
        translate([-1500, -largura_escada / 2 - 500, -20])
            cube([1500, largura_escada + 1000, 20]);
}

module corrimao() {
    tubo();
    for (s = postes) poste(s);
}

// ---------- KIT (redesign) ----------

use <kit_pega_tatil.scad>

// Coloca uma peça do kit no tubo.
// s = posição ao longo do tubo; sentido = +1 (peça olhando
// para cima da escada) ou -1 (olhando para baixo)
module no_tubo(s, sentido) {
    a = inclinacao;
    p = ponto_tubo(s);
    translate(p)
        multmatrix([[0, -sin(a), sentido * cos(a), 0],
                    [sentido, 0, 0, 0],
                    [0, cos(a), sentido * sin(a), 0]])
            children();
}


// Pegas de meio: 3 por vão, fora dos postes (posições = início da peça)
comprimento_pega = 150;
pegas_por_vao = 3;

module kit() {
    // terminal de baixo: começa na ponta de baixo e olha para cima
    no_tubo(-prolongamento, 1) terminal_montado();
    // terminal de cima: começa na ponta de cima e olha para baixo
    no_tubo(2 * vao + prolongamento, -1) terminal_montado();
    // pegas distribuídas igualmente dentro de cada vão
    for (v = [0 : 1], k = [1 : pegas_por_vao]) {
        centro = v * vao + k * vao / (pegas_por_vao + 1);
        no_tubo(centro - comprimento_pega / 2, 1) pega_montada();
    }
}

// Mostrar original e redesign lado a lado (ignora mostrar_kit)
lado_a_lado = false;

// Distância entre as duas escadas no lado a lado
afastamento = 3200;

module cena(com_kit) {
    corrimao();
    if (mostrar_escada) escada();
    if (com_kit) kit();
}

if (lado_a_lado) {
    translate([0, afastamento / 2, 0]) cena(false);   // esquerda: original
    translate([0, -afastamento / 2, 0]) cena(true);   // direita: com o kit
} else {
    cena(mostrar_kit);
}
