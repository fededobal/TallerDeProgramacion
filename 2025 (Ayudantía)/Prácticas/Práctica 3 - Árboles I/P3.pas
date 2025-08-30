program FinalesAlumnos;

type
    fecha = record
        dia: integer;
        mes: integer;
        anio: integer;
    end;

    final = record
        codMateria: integer;
        fechaFinal: fecha;
        nota: real;
    end;
    
    listaFinales = ^nodoLista;
    nodoLista = record
        dato: final;
        sig: listaFinales;
    end;
    
    alumno = record
        legajo: integer;
        finales: listaFinales;
    end;
    
    arbolAlumnos = ^nodoArbol;
    nodoArbol = record
        dato: alumno;
        HI: arbolAlumnos;
        HD: arbolAlumnos;
    end;

procedure LeerYAlmacenar(var a: arbolAlumnos);

    procedure AgregarAdelante(var L: listaFinales; f: final);
    var nue: listaFinales;
    begin
        new(nue);
        nue^.dato := f;
        nue^.sig := L;
        L := nue;
    end;
    
    procedure InsertarOActualizar(var a: arbolAlumnos; leg: integer; f: final);
    begin
        if (a = nil) then
        begin
            new(a);
            a^.dato.legajo := leg;
            a^.dato.finales := nil;
            AgregarAdelante(a^.dato.finales, f);
            a^.HI := nil;
            a^.HD := nil;
        end
        else if (leg = a^.dato.legajo) then
            AgregarAdelante(a^.dato.finales, f)
        else if (leg < a^.dato.legajo) then
            InsertarOActualizar(a^.HI, leg, f)
        else
            InsertarOActualizar(a^.HD, leg, f);
    end;
    
var
    leg: integer;
    fin: final;
begin
    a := nil;
    write('Ingrese legajo (0 para finalizar): ');
    readln(leg);
    while (leg <> 0) do
    begin
        write('Cod. Materia: '); readln(fin.codMateria);
        write('Nota: '); readln(fin.nota);
        fin.fechaFinal.dia := 1; fin.fechaFinal.mes := 1; fin.fechaFinal.anio := 2025;
        
        InsertarOActualizar(a, leg, fin);
        
        write('Ingrese legajo (0 para finalizar): ');
        readln(leg);
    end;
end;

function CantidadLegajosImpares(a: arbolAlumnos): integer;
var
    cant: integer;
begin
    if (a = nil) then
        CantidadLegajosImpares := 0
    else
    begin
        if (a^.dato.legajo mod 2 <> 0) then
            cant := 1
        else
            cant := 0;
        CantidadLegajosImpares := cant + CantidadLegajosImpares(a^.HI) + CantidadLegajosImpares(a^.HD);
    end;
end;

procedure InformarFinalesAprobados(a: arbolAlumnos);

    function ContarAprobados(L: listaFinales): integer;
    var cant: integer;
    begin
        cant := 0;
        while (L <> nil) do
        begin
            if (L^.dato.nota >= 4) then
                cant := cant + 1;
            L := L^.sig;
        end;
        ContarAprobados := cant;
    end;
    
begin
    if (a <> nil) then
    begin
        InformarFinalesAprobados(a^.HI);
        writeln('Legajo: ', a^.dato.legajo, ' - Cant. Aprobados: ', ContarAprobados(a^.dato.finales));
        InformarFinalesAprobados(a^.HD);
    end;
end;

procedure InformarAlumnosSuperanPromedio(a: arbolAlumnos; valor: real);

    procedure CalcularPromedio(L: listaFinales; var prom: real);
    var suma: real;
        cant: integer;
    begin
        suma := 0;
        cant := 0;
        while(L <> nil) do
        begin
            suma := suma + L^.dato.nota;
            cant := cant + 1;
            L := L^.sig;
        end;
        if (cant > 0) then
            prom := suma / cant
        else
            prom := 0;
    end;
    
var
    promedioActual: real;
begin
    if (a <> nil) then
    begin
        InformarAlumnosSuperanPromedio(a^.HI, valor);
        CalcularPromedio(a^.dato.finales, promedioActual);
        if (promedioActual > valor) then
            writeln('Legajo: ', a^.dato.legajo, ' - Promedio: ', promedioActual:2:2);
        InformarAlumnosSuperanPromedio(a^.HD, valor);
    end;
end;

var
    arbolDeAlumnos: arbolAlumnos;
    valorPromedio: real;

begin
    LeerYAlmacenar(arbolDeAlumnos);
    writeln;
    writeln('--------------------------------------------------');
    writeln('Cantidad de alumnos con legajo impar: ', CantidadLegajosImpares(arbolDeAlumnos));
    writeln('--------------------------------------------------');
    
    writeln('Cantidad de finales aprobados por alumno:');
    InformarFinalesAprobados(arbolDeAlumnos);
    writeln('--------------------------------------------------');
    
    write('Ingrese un valor de promedio para filtrar: ');
    readln(valorPromedio);
    writeln('Alumnos cuyo promedio supera ', valorPromedio:2:2, ':');
    InformarAlumnosSuperanPromedio(arbolDeAlumnos, valorPromedio);
    writeln('--------------------------------------------------');
end.
