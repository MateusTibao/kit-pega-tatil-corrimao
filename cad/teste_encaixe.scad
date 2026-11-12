// =============================================
// Kit de Pega Tátil para Corrimão
// PEÇA DE TESTE: fatia da pega de meio
// Serve para testar o encaixe em "C", o giro e o atrito
// =============================================

// ---------- PARÂMETROS (mude só aqui) ----------

// Diâmetro do tubo do corrimão, em mm
diametro_tubo = 50;

// Folga entre a peça e o tubo, em mm
folga = 0.5;

// Espessura da parede da capa, em mm
parede = 2;

// Quanto a peça abraça o tubo, em graus (teste 200, 220 e 240)
abraco = 220;

// Comprimento da fatia, em mm
comprimento = 30;

// Altura das saliências da textura, em mm
altura_textura = 1;

// Distância entre uma saliência e a próxima, em mm
passo_textura = 4;

// ---------- CÁLCULOS (não precisa mexer) ----------

raio_interno = (diametro_tubo + folga) / 2;
raio_externo = raio_interno + parede;
abertura = 360 - abraco;          // tamanho da abertura do "C"
inicio = 270 + abertura / 2;      // gira para a abertura ficar para baixo
$fn = 96;                         // suavidade das curvas

// ---------- MODELO ----------

// O tubo fica em pé (eixo Z), que é como a peça vai ser impressa.
// A abertura do "C" fica virada para -Y (para baixo, no corrimão).

module corpo_c() {
    rotate([0, 0, inicio])
        rotate_extrude(angle = abraco)
            translate([raio_interno, 0])
                square([parede, comprimento]);
}

// Anéis arredondados por fora: são o relevo "positivo".
// Os espaços entre eles são sulcos "negativos" que terminam
// na abertura de baixo, por onde a água escorre.
module textura() {
    for (z = [passo_textura / 2 : passo_textura : comprimento - passo_textura / 2])
        translate([0, 0, z])
            rotate([0, 0, inicio])
                rotate_extrude(angle = abraco)
                    translate([raio_externo - 0.2, 0])
                        scale([altura_textura + 0.2, 1])
                            circle(r = 1, $fn = 24);
}

corpo_c();
textura();
