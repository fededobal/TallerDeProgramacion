program RecursionConListas;

type
    lista = ^nodo;
    nodo = record
        dato: integer;
        sig: lista;
    end;

procedure GenerarLista(var L: lista);

    procedure CargarRecursivo(var L: lista; valor: integer);
    var
        nue: lista;
    begin
        if (valor <> 100) then
        begin
            new(nue);
            nue^.dato := valor;
            nue^.sig := L;
            L := nue;
            CargarRecursivo(L, random(101) + 100);
        end;
    end;

begin
    L := nil;
    randomize;
    CargarRecursivo(L, random(101) + 100);
end;

procedure ImprimirLista(L: lista);
begin
    if (L <> nil) then
    begin
        write(L^.dato, ' -> ');
        ImprimirLista(L^.sig);
    end;
end;

procedure ImprimirInverso(L: lista);
begin
    if (L <> nil) then
    begin
        ImprimirInverso(L^.sig);
        write(L^.dato, ' -> ');
    end;
end;

function MinimoDeLista(L: lista): integer;
var
    minResto: integer;
begin
    if (L^.sig = nil) then
        MinimoDeLista := L^.dato
    else
    begin
        minResto := MinimoDeLista(L^.sig);
        if (L^.dato < minResto) then
            MinimoDeLista := L^.dato
        else
            MinimoDeLista := minResto;
    end;
end;

function BuscarEnLista(L: lista; valor: integer): boolean;
begin
    if (L = nil) then
        BuscarEnLista := false
    else if (L^.dato = valor) then
        BuscarEnLista := true
    else
        BuscarEnLista := BuscarEnLista(L^.sig, valor);
end;

var
    miLista: lista;
    minimo, valorABuscar: integer;
begin
    GenerarLista(miLista);
    if (miLista <> nil) then
    begin
        writeln('--- Lista generada ---');
        ImprimirLista(miLista);
        writeln;
        
        writeln('--- Lista en orden inverso ---');
        ImprimirInverso(miLista);
        writeln;

        minimo := MinimoDeLista(miLista);
        writeln('El minimo valor de la lista es: ', minimo);
        writeln;

        write('Ingrese un valor a buscar en la lista: ');
        readln(valorABuscar);
        if (BuscarEnLista(miLista, valorABuscar)) then
            writeln('El valor ', valorABuscar, ' se encuentra en la lista.')
        else
            writeln('El valor ', valorABuscar, ' NO se encuentra en la lista.');
    end
    else
        writeln('La lista generada esta vacia.');

end.
