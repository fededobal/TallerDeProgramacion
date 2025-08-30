program Libreria;

const
    cantRubros = 6;
    maxRubro3 = 20;

type
    producto = record
        codigo: integer;
        rubro: 1..cantRubros;
        precio: real;
    end;
    
    lista = ^nodo;
    nodo = record
        dato: producto;
        sig: lista;
    end;
    
    estructuraRubros = array[1..cantRubros] of lista;
    
    vectorProductos = array[1..maxRubro3] of producto;

procedure InicializarEstructura(var rubros: estructuraRubros);
var
    i: integer;
begin
    for i := 1 to cantRubros do
        rubros[i] := nil;
end;

procedure InsertarOrdenado(var L: lista; p: producto);
var
    nue, ant, act: lista;
begin
    new(nue);
    nue^.dato := p;
    act := L;
    ant := L;
    while (act <> nil) and (act^.dato.codigo < p.codigo) do
    begin
        ant := act;
        act := act^.sig;
    end;
    
    if (ant = act) then
        L := nue
    else
        ant^.sig := nue;
    
    nue^.sig := act;
end;

procedure LeerYAlmacenar(var rubros: estructuraRubros);
var
    p: producto;
begin
    writeln('Ingrese el precio del producto (-1 para finalizar):');
    readln(p.precio);
    while (p.precio <> -1) do
    begin
        writeln('Ingrese el codigo del producto:');
        readln(p.codigo);
        writeln('Ingrese el codigo de rubro (1..6):');
        readln(p.rubro);
        
        InsertarOrdenado(rubros[p.rubro], p);
        
        writeln('Ingrese el precio del proximo producto (-1 para finalizar):');
        readln(p.precio);
    end;
end;

procedure MostrarProductosPorRubro(rubros: estructuraRubros);
var
    i: integer;
    aux: lista;
begin
    for i := 1 to cantRubros do
    begin
        writeln;
        writeln('--- Productos del Rubro ', i, ' ---');
        aux := rubros[i];
        if (aux = nil) then
            writeln('Sin productos en este rubro.')
        else
            while (aux <> nil) do
            begin
                writeln('Codigo: ', aux^.dato.codigo, ' | Precio: ', aux^.dato.precio:2:2);
                aux := aux^.sig;
            end;
    end;
end;

procedure GenerarVectorRubro3(listaRubro3: lista; var v: vectorProductos; var dimL: integer);
var
    aux: lista;
begin
    dimL := 0;
    aux := listaRubro3;
    while (aux <> nil) and (dimL < maxRubro3) do
    begin
        dimL := dimL + 1;
        v[dimL] := aux^.dato;
        aux := aux^.sig;
    end;
end;

procedure OrdenarVectorPorPrecio(var v: vectorProductos; dimL: integer);
var
    i, j, pos: integer;
    item: producto;
begin
    for i := 1 to dimL - 1 do
    begin
        pos := i;
        for j := i + 1 to dimL do
            if (v[j].precio < v[pos].precio) then
                pos := j;
        
        item := v[pos];
        v[pos] := v[i];
        v[i] := item;
    end;
end;

procedure MostrarPrecios(v: vectorProductos; dimL: integer);
var
    i: integer;
begin
    writeln;
    writeln('--- Precios de productos del Rubro 3 (ordenados) ---');
    for i := 1 to dimL do
        writeln('Precio: ', v[i].precio:2:2);
end;

procedure CalcularPromedio(v: vectorProductos; dimL: integer);
var
    i: integer;
    total: real;
begin
    if (dimL > 0) then
    begin
        total := 0;
        for i := 1 to dimL do
            total := total + v[i].precio;
        writeln;
        writeln('El promedio de precios del Rubro 3 es: ', (total / dimL):2:2);
    end;
end;

var
    rubros: estructuraRubros;
    vRubro3: vectorProductos;
    dimL: integer;

begin
    InicializarEstructura(rubros);
    LeerYAlmacenar(rubros);
    MostrarProductosPorRubro(rubros);
    
    GenerarVectorRubro3(rubros[3], vRubro3, dimL);
    if (dimL > 0) then
    begin
        OrdenarVectorPorPrecio(vRubro3, dimL);
        MostrarPrecios(vRubro3, dimL);
        CalcularPromedio(vRubro3, dimL);
    end
    else
        writeln('No se encontraron productos del rubro 3.');
end.
