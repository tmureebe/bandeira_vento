// Bandeira giratória com seis fixações internas. Dimensões em mm.
// F5 para visualizar. O ângulo gira o mastro e o painel sobre a base fixa.
// O corte mostra a carcaça, o lastro e o encaixe do pivô em seção longitudinal.
// Desenho conceitual. Espessuras, folgas e encaixes ilustram o funcionamento.

/* [Visualização] */
vista = "comparacao"; // [comparacao:Frente e verso, frente:Conjunto, verso:Verso, planta:Vista superior, pivo:Corte do pivô e da base, detalhe:Fixação lateral]
angulo = 0; // [0:1:360]
mostrar_impressao = true;

/* [Tecido (mm)] */
largura = 600; // [420:10:900]
altura = 1400; // [800:10:1800]
recuo = 60; // [50:5:90]
eixo_da_borda = 40; // [15:5:80]

/* [Reservatório] */
litros_de_agua = 20; // [0:0.5:24.5]

/* [Hidden] */
$fn = 52;
meia_largura = largura/2;
meia_altura = altura/2;
fix_x = meia_largura-recuo;
fix_z = meia_altura-recuo;
z_centro = 300+meia_altura;
espessura = 2;
// No referencial do pivô, o centro do pano está em [ex,-90,z_centro].
ex = meia_largura-eixo_da_borda;
azul=[0.15,0.48,0.54]; metal=[0.17,0.22,0.25];
reforco=[0.62,0.83,0.80]; elastico=[1,0.47,0.09];
carcaca=[0.34,0.44,0.47]; agua=[0.18,0.65,0.81]; bronze=[0.85,0.56,0.22];
function gira(p,a)=[p.x*cos(a)-p.y*sin(a),p.x*sin(a)+p.y*cos(a),p.z];
foco_detalhe = gira([ex+fix_x,-80,z_centro],angulo);
dist_vistas=max(800,2*(ex+meia_largura)+160);
$vpr = vista=="planta" ? [0,0,0] : vista=="pivo" ? [84,0,0] :
       vista=="detalhe" ? [80,0,180+angulo] : [86,0,6];
$vpt = vista=="pivo" ? [0,0,130] : vista=="detalhe" ? foco_detalhe :
       vista=="planta" ? [0,0,z_centro] : [0,0,(300+altura)/2];
$vpd = vista=="pivo" ? 1600 : vista=="detalhe" ? 300 : vista=="planta" ? 2350 :
       3.3*max(300+altura,vista=="comparacao" ? dist_vistas+950 : 1100);
module barra(a,b,r) {
    d = b-a;
    translate(a)
        rotate([0,acos(d.z/norm(d)),atan2(d.y,d.x)])
            cylinder(h=norm(d),r=r);
}

// Superfície plana na área entre os quatro reforços e ondulação suave nas bordas.
function onda(x,z) = 7 * pow(max(0,(abs(x)-fix_x)/recuo,
                                     (abs(z)-fix_z)/recuo),2)
                       * sin(0.62*z+0.32*x);

module pano() {
    nx = 24; nz = 56;
    n = (nx+1)*(nz+1);
    function idx(i,j) = i + j*(nx+1);
    pontos = [for (lado=[0,1], j=[0:nz], i=[0:nx])
        let(x=largura*(i/nx-0.5), z=altura*(j/nz-0.5))
        [x,onda(x,z)+(lado-0.5)*espessura,z]];
    faces = [for(j=[0:nz-1],i=[0:nx-1])
        let(a=idx(i,j), b=idx(i+1,j), c=idx(i+1,j+1), d=idx(i,j+1))
        each [[a,c,b],[a,d,c],[n+a,n+b,n+c],[n+a,n+c,n+d]]];
    contorno = concat([for(i=[0:nx-1]) idx(i,0)],
                      [for(j=[0:nz-1]) idx(nx,j)],
                      [for(i=[nx:-1:1]) idx(i,nz)],
                      [for(j=[nz:-1:1]) idx(0,j)]);
    lados = [for(k=[0:len(contorno)-1])
        let(a=contorno[k], b=contorno[(k+1)%len(contorno)])
        [a,b,b+n,a+n]];
    color(azul) polyhedron(pontos,concat(faces,lados),convexity=6);
}

module marca_frontal() {
    // Marcas de registro indicam a área compreendida entre as fixações.
    color("ivory") translate([0,-espessura/2+0.1,0]) rotate([90,0,0])
        linear_extrude(0.6) {
            for(sx=[-1,1],sz=[-1,1])
                scale([sx,sz]) translate([fix_x,fix_z]) {
                    translate([-30,-3]) square([30,3]);
                    translate([-3,-30]) square([3,30]);
                }
            text("Área de impressão",size=largura/18,halign="center",
                 valign="center",font="DejaVu Sans");
        }
}


module anel(ri,re,h) {
    difference() {
        cylinder(r=re,h=h);
        translate([0,0,-1]) cylinder(r=ri,h=h+2);
    }
}

module base_fixa() {
    // Cavidade anular (raios 40 e 280 mm). O núcleo seco recebe o pino.
    color(carcaca) difference() {
        union() {
            cylinder(r=300,h=105);
            translate([0,0,105]) cylinder(r1=300,r2=289,h=15);
        }
        translate([0,0,8]) anel(40,280,104);
        translate([-160,0,110]) cylinder(r=21,h=15);
    }
    color(metal) translate([-160,0,119]) cylinder(r=26,h=8);
    if (litros_de_agua>0)
        color(agua) translate([0,0,8.2])
            anel(40.3,279.7,litros_de_agua*1000000/(PI*(279.7*279.7-40.3*40.3)));
    color(metal) {
        translate([0,0,119]) cylinder(r1=37,r2=23,h=24);
        translate([0,0,142]) cylinder(r=12,h=114.5);
        // Batente axial superior preso ao pino, acima da bucha superior.
        translate([0,0,255.5]) cylinder(r=14.8,h=2);
    }
    color(bronze) translate([0,0,143]) anel(12.25,23,4);
}

module luva_giratoria() {
    // Dois mancais lisos radiais e arruela axial separada na base fixa.
    color(carcaca) translate([0,0,147]) anel(16,22,112);
    for(z=[150,239]) color(bronze) translate([0,0,z]) anel(12.25,16,15);
    color(carcaca) translate([0,0,258]) cylinder(r=22,h=5);
}

module braco_com_alca(sx,sz) {
    // sz=0 corresponde à travessa. Centro do pano como origem local.
    x=sx*fix_x; z=sz*fix_z;
    ponta=[x+sx*(sz==0 ? 40 : 20),28,z+sz*30];
    color(metal) barra([0,50,0],ponta,6);
    color(metal) translate(ponta) sphere(r=8);
    color(reforco) translate([x,2.3,z]) cube([38,3,36],center=true);
    for (dx=[-7,7]) color(metal) barra([x+dx,3,z],[x+dx,10,z],2);
    color(metal) barra([x-7,10,z],[x+7,10,z],2);
    for (dx=[-5,5]) color(elastico) barra([x+dx,10,z],ponta,2.8);
}

module rotor() {
    luva_giratoria();
    color(metal) {
        translate([0,0,261]) cylinder(r=14,h=z_centro-261+16);
        // Console entre o mastro lateral e o cubo central; escora inferior.
        barra([0,0,z_centro],[ex,-40,z_centro],11);
        barra([0,0,z_centro-145],[ex,-40,z_centro],8);
    }
    translate([ex,-90,z_centro]) {
        pano();
        if(mostrar_impressao) marca_frontal();
        color(carcaca) translate([0,50,0]) cube([60,44,64],center=true);
        for(sx=[-1,1],sz=[-1,0,1]) braco_com_alca(sx,sz);
    }
}
module conjunto() {
    base_fixa();
    rotate([0,0,angulo]) rotor();
}

module corte() {
    // Corte longitudinal no plano y=0; remove a metade voltada ao observador.
    intersection() {
        union() {
            base_fixa(); luva_giratoria();
            color(metal) translate([0,0,261]) cylinder(r=14,h=40);
        }
        translate([-320,0,-1]) cube([640,340,310]);
    }
}

if(vista=="comparacao") {
    translate([-dist_vistas/2,0,0]) conjunto();
    translate([dist_vistas/2,0,0]) rotate([0,0,180]) conjunto();
} else if(vista=="pivo") {
    corte();
} else if(vista=="verso") {
    rotate([0,0,180]) conjunto();
} else {
    conjunto();
}
