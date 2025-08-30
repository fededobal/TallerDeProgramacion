program BusquedaDicotomicaRecursiva;

const
    dimF = 20;

type
    vector = array [1..dimF] of integer;
    indice = 1..dimF;

procedure CargarVector(var v: vector);
var
    i: integer;
begin
    randomize;
    for i := 1 to dimF do
        v[i] := 300 + random(1251);
end;

procedure OrdenarVector(var v: vector);
var
    i, j, pos: integer;
    item: integer;
begin
    for i := 1 to dimF - 1 do
    begin
        pos := i;
        for j := i + 1 to dimF do
            if (v[j] < v[pos]) then
                pos := j;
        item := v[pos];
        v[pos] := v[i];
        v[i] := item;
    end;
end;

procedure ImprimirVector(v: vector);
var
    i: integer;
begin
    for i := 1 to dimF do
        write(v[i], ' | ');
    writeln;
end;

procedure busquedaDicotomica (v: vector; ini, fin: integer; dato: integer; var pos: integer);
var
    medio: integer;
begin
    if (ini > fin) then
        pos := -1
    else
    begin
        medio := (ini + fin) div 2;
        if (v[medio] = dato) then
            pos := medio
        else if (dato < v[medio]) then
            busquedaDicotomica(v, ini, medio - 1, dato, pos)
        else
            busquedaDicotomica(v, medio + 1, fin, dato, pos);
    end;
end;

var
    v: vector;
    dato, posicion: integer;

begin
    CargarVector(v);
    writeln('--- Vector original ---');
    ImprimirVector(v);
    
    OrdenarVector(v);
    writeln('--- Vector ordenado ---');
    ImprimirVector(v);
    
    writeln;
    write('Ingrese el numero a buscar: ');
    readln(dato);
    
    busquedaDicotomica(v, 1, dimF, dato, posicion);
    
    if (posicion = -1) then
        writeln('El dato ', dato, ' no se encuentra en el vector.')
    else
        writeln('El dato ', dato, ' se encuentra en la posicion: ', posicion);
end.
