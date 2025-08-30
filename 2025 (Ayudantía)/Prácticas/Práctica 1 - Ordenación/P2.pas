program AdministracionEdificio;

const
    dimF = 300;

type
    oficina = record
        codigo: integer;
        dniPropietario: integer;
        valorExpensa: real;
    end;
    
    vectorOficinas = array[1..dimF] of oficina;
    
procedure GenerarVector(var v: vectorOficinas; var dimL: integer);
var
    ofi: oficina;
begin
    dimL := 0;
    writeln('Ingrese el codigo de identificacion de la oficina (-1 para finalizar):');
    readln(ofi.codigo);
    while (ofi.codigo <> -1) and (dimL < dimF) do
    begin
        writeln('Ingrese el DNI del propietario:');
        readln(ofi.dniPropietario);
        writeln('Ingrese el valor de la expensa:');
        readln(ofi.valorExpensa);
        
        dimL := dimL + 1;
        v[dimL] := ofi;
        
        writeln('Ingrese el codigo de identificacion de la proxima oficina (-1 para finalizar):');
        readln(ofi.codigo);
    end;
end;

procedure OrdenarPorInsercion(var v: vectorOficinas; dimL: integer);
var
    i, j: integer;
    actual: oficina;
begin
    for i := 2 to dimL do
    begin
        actual := v[i];
        j := i - 1;
        while (j > 0) and (v[j].codigo > actual.codigo) do
        begin
            v[j + 1] := v[j];
            j := j - 1;
        end;
        v[j + 1] := actual;
    end;
end;

procedure OrdenarPorSeleccion(var v: vectorOficinas; dimL: integer);
var
    i, j, pos: integer;
    item: oficina;
begin
    for i := 1 to dimL - 1 do
    begin
        pos := i;
        for j := i + 1 to dimL do
        begin
            if (v[j].codigo < v[pos].codigo) then
                pos := j;
        end;
        item := v[pos];
        v[pos] := v[i];
        v[i] := item;
    end;
end;

procedure ImprimirVector(v: vectorOficinas; dimL: integer);
var
    i: integer;
begin
    for i := 1 to dimL do
    begin
        writeln('--------------------');
        writeln('Oficina Codigo: ', v[i].codigo);
        writeln('DNI Propietario: ', v[i].dniPropietario);
        writeln('Valor Expensa: ', v[i].valorExpensa:2:2);
    end;
    writeln('--------------------');
end;

var
    v: vectorOficinas;
    dimL: integer;

begin
    GenerarVector(v, dimL);
    if (dimL > 0) then
    begin
        writeln;
        writeln('--- Vector original ---');
        ImprimirVector(v, dimL);
        
        writeln;
        writeln('--- Ordenando por INSERCION ---');
        OrdenarPorInsercion(v, dimL);
        ImprimirVector(v, dimL);
    
        writeln('--- Ordenando por SELECCION ---');
        OrdenarPorSeleccion(v, dimL);
        ImprimirVector(v, dimL);
    end
    else
        writeln('El vector esta vacio.');
end.
