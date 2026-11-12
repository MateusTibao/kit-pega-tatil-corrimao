// =====================================================
// KIT DE PEGA TÁTIL PARA CORRIMÃO
// Capas impressas em 3D que encaixam por pressão (formato "C")
// em qualquer corrimão redondo, sem obra e sem ferramenta.
//   - Terminal: vai nas duas pontas. Tem a plaquinha tátil com
//     seta, número de degraus em relevo e em braille (NBR 9050).
//   - Pega de meio: atrito e apoio ao longo do corrimão.
// Cada peça é presa por 2 abraçadeiras, que impedem o giro.
// Meça o tubo (gabarito de diâmetro) e digite o valor abaixo.
//
// Projeto: FIAP Global Solution 2026.2, Maker Lab
// Abraçadeira recomendada (não incluída, baixar à parte):
//   "Improved Reusable Zip Ties", Doug Joseph (design8studio)
//   printables.com/model/935485 - CC BY-NC 4.0 - versão de 252 mm
// Todas as medidas em milímetros.
// =====================================================

/* [O que gerar] */

// kit = tudo montado (para ver); terminal, placa e pega = para imprimir
parte = "kit"; // [kit, terminal, placa, pega]

/* [Tubo do corrimão] */

// Diâmetro do tubo, em mm (meça com o gabarito de diâmetro)
diametro_tubo = 50; // [25:0.5:70]

// Folga entre a peça e o tubo, em mm
folga = 0.5; // [0.2:0.1:1.5]

// Espessura da parede da capa, em mm
parede = 2; // [1.6:0.2:4]

// Quanto a peça abraça o tubo, em graus (ajuste depois do teste de encaixe)
abraco = 220; // [190:5:250]

/* [Plaquinha tátil] */

// Número de degraus da escada (aparece em relevo e em braille)
numero_degraus = 12; // [1:1:99]

// Fonte do número em relevo
fonte = "Roboto:style=Bold"; // font

// Folga do trilho da plaquinha, em mm (aumente se ficar justo)
folga_trilho = 0.25; // [0.1:0.05:0.6]

/* [Pega de meio] */

// Comprimento da pega de meio, em mm (menor que o vão entre os postes)
comprimento_pega = 150; // [80:5:300]

/* [Abraçadeira] */

// Largura do canal, em mm. Padrão: abraçadeira reutilizável de 8,3 mm + folga. Aceita nylon comum de até 8,5 mm.
largura_abracadeira = 8.8; // [3:0.1:12]

// Profundidade do canal, em mm
profundidade_canal = 1.2; // [0.6:0.1:2]

// Mostrar as abraçadeiras na vista "kit" (só ilustração, não vai para o STL)
mostrar_abracadeiras = true;

/* [Hidden] */

// ---------- MEDIDAS FIXAS ----------

chanfro = 5;             // borda com rampa nas duas pontas de cada peça
zona_abracadeira = 13;   // trecho de cada canal de abraçadeira
passo_textura = 4;       // distância entre um anel e o próximo
altura_textura = 1;      // quanto cada anel salta (igual em todo o kit)

comprimento_placa = 58;  // trecho do trilho com a plaquinha (terminal)
comprimento_textura = 33;// trecho com anéis no terminal

placa_base = 28;         // largura embaixo (encaixe)
placa_topo = 24;         // largura em cima
placa_espessura = 3;     // altura do encaixe
relevo = 1.2;            // altura do número e da seta
braille_diametro = 1.5;  // NBR 9050: 1,2 a 2,0 mm
braille_altura = 0.7;    // NBR 9050: 0,6 a 0,8 mm
braille_ponto = 2.5;     // distância entre pontos da mesma cela
braille_cela = 6.5;      // distância entre uma cela e a próxima

// ---------- CÁLCULOS ----------

r_int = (diametro_tubo + folga) / 2;
r_ext = r_int + parede;
inicio = 270 + (360 - abraco) / 2;   // abertura do "C" para baixo (-Y)

// Terminal, da ponta do tubo para a escada:
// borda | abraçadeira 1 | plaquinha | textura | abraçadeira 2 | borda
t_abracadeira1 = chanfro;
t_trilho0 = t_abracadeira1 + zona_abracadeira;
t_trilho1 = t_trilho0 + comprimento_placa + 1;
t_textura0 = t_trilho1 + 3;
t_textura1 = t_textura0 + comprimento_textura;
t_abracadeira2 = t_textura1;
comprimento_terminal = t_abracadeira2 + zona_abracadeira + chanfro;

topo_apoio = r_ext + 2.5;            // topo plano do apoio da plaquinha
fundo_trilho = topo_apoio - placa_espessura;
largura_apoio = placa_base + 6;

// Pega de meio: borda | abraçadeira | textura | abraçadeira | borda
p_abracadeira1 = chanfro;
p_textura0 = p_abracadeira1 + zona_abracadeira;
p_abracadeira2 = comprimento_pega - chanfro - zona_abracadeira;
p_textura1 = p_abracadeira2;

echo(str("Comprimento do terminal: ", comprimento_terminal, " mm"));
echo(str("Comprimento da pega de meio: ", comprimento_pega, " mm"));

// A NBR 9050 (4.6.5) pede corrimão com 30 a 45 mm de diâmetro.
// O kit é uma capa fina: em tubos grossos ele passa desse limite.
diametro_externo = 2 * (r_ext + altura_textura);
echo(str("Diâmetro externo com o kit: ", diametro_externo, " mm"));
if (diametro_externo > 45)
    echo(str("ATENÇÃO: ", diametro_externo, " mm passa do máximo de 45 mm da NBR 9050. ",
             "O kit melhora atrito e sinalização, mas não corrige o diâmetro do tubo."));

$fn = 96;

// ---------- BASE COMUM ÀS DUAS PEÇAS ----------

module em_c() {
    rotate([0, 0, inicio])
        rotate_extrude(angle = abraco)
            children();
}

// Parede reta no meio e uma rampa igual em cada ponta
module parede_c(L) {
    em_c() polygon([
        [r_int, 0], [r_int + 0.6, 0], [r_ext, chanfro],
        [r_ext, L - chanfro], [r_int + 0.6, L], [r_int, L]
    ]);
}

module anel(z) {
    translate([0, 0, z])
        em_c()
            translate([r_ext - 0.2, 0])
                scale([altura_textura + 0.2, 1])
                    circle(r = 1, $fn = 24);
}

module canal_abracadeira(z_zona) {
    z0 = z_zona + (zona_abracadeira - largura_abracadeira) / 2;
    translate([0, 0, z0])
        difference() {
            cylinder(r = r_ext + 5, h = largura_abracadeira);
            translate([0, 0, -1])
                cylinder(r = r_ext - profundidade_canal, h = largura_abracadeira + 2);
        }
}

// Furo do tubo e abertura do "C" livre embaixo
module furo_e_abertura(L) {
    cylinder(r = r_int, h = 3 * L, center = true);
    rotate([0, 0, inicio + abraco])
        rotate_extrude(angle = 360 - abraco)
            translate([0, -1]) square([r_ext + 10, L + 2]);
}

// ---------- TERMINAL ----------

module terminal() {
    difference() {
        union() {
            parede_c(comprimento_terminal);
            for (z = [t_textura0 + passo_textura / 2 : passo_textura : t_textura1 - 0.1])
                anel(z);
            // apoio da plaquinha (começa abaixo da parede para se fundir com ela)
            translate([-largura_apoio / 2, r_int - 12, t_trilho0])
                cube([largura_apoio, topo_apoio - r_int + 12, t_trilho1 - t_trilho0 + 3]);
        }
        furo_e_abertura(comprimento_terminal);
        trilho();
        canal_abracadeira(t_abracadeira1);  // também trava a plaquinha
        canal_abracadeira(t_abracadeira2);
    }
}

// Rabo de andorinha onde a plaquinha desliza
module trilho() {
    a = placa_base / 2 + folga_trilho;
    b = placa_topo / 2 + folga_trilho;
    translate([0, 0, t_trilho0 - 1])
        linear_extrude(t_trilho1 - t_trilho0 + 1)
            polygon([[-a, fundo_trilho], [a, fundo_trilho],
                     [b, topo_apoio + 0.01], [-b, topo_apoio + 0.01]]);
}

// ---------- PLAQUINHA ----------
// Desenhada deitada, como vai para a impressora.
// X = ao longo do tubo (+X aponta para a escada)

// Pontos de cada caractere em braille: sinal de número + dígitos
function celas(n) = concat([[3, 4, 5, 6]], [for (c = str(n)) digito(c)]);
function digito(c) =
    c == "1" ? [1] :        c == "2" ? [1, 2] :
    c == "3" ? [1, 4] :     c == "4" ? [1, 4, 5] :
    c == "5" ? [1, 5] :     c == "6" ? [1, 2, 4] :
    c == "7" ? [1, 2, 4, 5] : c == "8" ? [1, 2, 5] :
    c == "9" ? [2, 4] :     [2, 4, 5];

module braille(n, x0) {
    cs = celas(n);
    largura = (len(cs) - 1) * braille_cela + braille_ponto;
    for (i = [0 : len(cs) - 1])
        for (p = cs[i]) {
            col = p <= 3 ? 0 : 1;
            lin = p <= 3 ? p - 1 : p - 4;
            translate([x0 + (2 - lin) * braille_ponto,
                       largura / 2 - i * braille_cela - col * braille_ponto,
                       placa_espessura])
                scale([braille_diametro / 2, braille_diametro / 2, braille_altura])
                    sphere(r = 1, $fn = 24);
        }
}

module placa() {
    a = placa_base / 2;
    b = placa_topo / 2;
    // corpo em trapézio: é ele que trava no trilho
    rotate([90, 0, 90])
        linear_extrude(comprimento_placa)
            polygon([[-a, 0], [a, 0], [b, placa_espessura], [-b, placa_espessura]]);
    braille(numero_degraus, 5);
    // número em relevo
    translate([27, 0, placa_espessura])
        linear_extrude(relevo)
            rotate([0, 0, -90])
                text(str(numero_degraus), size = 12, font = fonte,
                     halign = "center", valign = "center");
    // seta: aponta da ponta do tubo para a escada
    translate([38, 0, placa_espessura])
        linear_extrude(relevo)
            polygon([[0, -2.5], [8, -2.5], [8, -7], [16, 0],
                     [8, 7], [8, 2.5], [0, 2.5]]);
}

// ---------- PEGA DE MEIO ----------

module pega() {
    n = floor((p_textura1 - p_textura0) / passo_textura);
    sobra = (p_textura1 - p_textura0) - n * passo_textura;
    difference() {
        union() {
            parede_c(comprimento_pega);
            for (i = [0 : n - 1])
                anel(p_textura0 + sobra / 2 + passo_textura / 2 + i * passo_textura);
        }
        furo_e_abertura(comprimento_pega);
        canal_abracadeira(p_abracadeira1);
        canal_abracadeira(p_abracadeira2);
    }
}

// ---------- MONTAGENS (só para ver) ----------

// Abraçadeira ilustrativa: tira de 8,3 x 1,0 mm no canal, cabeça embaixo do tubo
module abracadeira(z_zona) {
    zc = z_zona + zona_abracadeira / 2;
    color([0.20, 0.55, 0.85]) translate([0, 0, zc]) {
        rotate([0, 0, inicio])
            rotate_extrude(angle = abraco)
                translate([r_ext - profundidade_canal, -4.15]) square([1.0, 8.3]);
        rotate([0, 0, inicio + abraco])
            rotate_extrude(angle = 360 - abraco)
                translate([diametro_tubo / 2, -4.15]) square([1.0, 8.3]);
        translate([-15, -diametro_tubo / 2 - 7, -7.35]) cube([30, 7, 14.7]);
    }
}

module terminal_montado() {
    color([0.95, 0.75, 0.10]) terminal();
    color([0.15, 0.15, 0.15])
        translate([0, fundo_trilho, t_trilho0])
            multmatrix([[0, 1, 0, 0], [0, 0, 1, 0], [1, 0, 0, 0]])
                placa();
    if (mostrar_abracadeiras) {
        abracadeira(t_abracadeira1);
        abracadeira(t_abracadeira2);
    }
}

module pega_montada() {
    color([0.95, 0.75, 0.10]) pega();
    if (mostrar_abracadeiras) {
        abracadeira(p_abracadeira1);
        abracadeira(p_abracadeira2);
    }
}

// Terminal, pega de meio e terminal num pedaço de tubo, deitados
module kit() {
    vao = 40;
    multmatrix([[0, 0, 1, 0], [1, 0, 0, 0], [0, 1, 0, 0]]) {
        terminal_montado();
        translate([0, 0, comprimento_terminal + vao]) pega_montada();
        // terminal da outra ponta, virado (a seta aponta para a escada)
        translate([0, 0, 2 * comprimento_terminal + comprimento_pega + 2 * vao])
            rotate([0, 180, 0]) terminal_montado();
        color([0.25, 0.42, 0.30])
            translate([0, 0, -20])
                cylinder(d = diametro_tubo,
                         h = 2 * comprimento_terminal + comprimento_pega + 2 * vao + 40);
    }
}

// ---------- SAÍDA ----------

if (parte == "kit") kit();
if (parte == "terminal") terminal();
if (parte == "placa") placa();
if (parte == "pega") pega();

// MakerWorld (Parametric Model Maker): uma mesa por peça
module mw_plate_1() terminal();
module mw_plate_2() placa();
module mw_plate_3() pega();
module mw_assembly_view() kit();
