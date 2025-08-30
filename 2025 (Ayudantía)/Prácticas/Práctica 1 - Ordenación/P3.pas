program NetflixPeliculas;

const
    cantGeneros = 8;

type
    pelicula = record
        codigo: integer;
        genero: 1..cantGeneros;
        puntaje: real;
    end;
    
    lista = ^nodo;
    nodo = record
        dato: pelicula;
        sig: lista;
    end;
    
    estructuraGeneros = array[1..cantGeneros] of lista;
    
    vectorMejores = array[1..cantGeneros] of pelicula;

procedure InicializarEstructura(var generos: estructuraGeneros);
var
    i: integer;
begin
    for i := 1 to cantGeneros do
        generos[i] := nil;
end;

procedure AgregarAdelante(var L: lista; p: pelicula);
var
    nue: lista;
begin
    new(nue);
    nue^.dato := p;
    nue^.sig := L;
    L := nue;
end;

procedure LeerYAlmacenar(var generos: estructuraGeneros);
var
    p: pelicula;
begin
    writeln('Ingrese el codigo de la pelicula (-1 para finalizar):');
    readln(p.codigo);
    while (p.codigo <> -1) do
    begin
        writeln('Ingrese el codigo de genero (1..8):');
        readln(p.genero);
        writeln('Ingrese el puntaje promedio:');
        readln(p.puntaje);
        
        AgregarAdelante(generos[p.genero], p);
        
        writeln('Ingrese el codigo de la proxima pelicula (-1 para finalizar):');
        readln(p.codigo);
    end;
end;

procedure GenerarVectorMejores(generos: estructuraGeneros; var vMejores: vectorMejores; var dimL: integer);
var
    i: integer;
    maxPuntaje: real;
    mejorPelicula: pelicula;
    aux: lista;
begin
    dimL := 0;
    for i := 1 to cantGeneros do
    begin
        aux := generos[i];
        if (aux <> nil) then
        begin
            maxPuntaje := -1;
            while (aux <> nil) do
            begin
                if (aux^.dato.puntaje > maxPuntaje) then
                begin
                    maxPuntaje := aux^.dato.puntaje;
                    mejorPelicula := aux^.dato;
                end;
                aux := aux^.sig;
            end;
            dimL := dimL + 1;
            vMejores[dimL] := mejorPelicula;
        end;
    end;
end;

procedure OrdenarVectorPorPuntaje(var v: vectorMejores; dimL: integer);
var
    i, j: integer;
    actual: pelicula;
begin
    for i := 2 to dimL do
    begin
        actual := v[i];
        j := i - 1;
        while (j > 0) and (v[j].puntaje > actual.puntaje) do
        begin
            v[j + 1] := v[j];
            j := j - 1;
        end;
        v[j + 1] := actual;
    end;
end;

procedure MostrarExtremos(v: vectorMejores; dimL: integer);
begin
    if (dimL > 0) then
    begin
        writeln('Pelicula con MENOR puntaje (de las mejores por genero): Codigo ', v[1].codigo, ' | Puntaje: ', v[1].puntaje:2:2);
        writeln('Pelicula con MAYOR puntaje (de las mejores por genero): Codigo ', v[dimL].codigo, ' | Puntaje: ', v[dimL].puntaje:2:2);
    end
    else
        writeln('No hay peliculas para mostrar.');
end;

var
    generos: estructuraGeneros;
    vMejores: vectorMejores;
    dimL: integer;
    
begin
    InicializarEstructura(generos);
    LeerYAlmacenar(generos);
    GenerarVectorMejores(generos, vMejores, dimL);
    
    if (dimL > 0) then
    begin
        writeln;
        writeln('--- Vector de mejores peliculas por genero (ordenado por puntaje) ---');
        OrdenarVectorPorPuntaje(vMejores, dimL);
        MostrarExtremos(vMejores, dimL);
    end
    else
        writeln('No se ingresaron peliculas.');
end.
