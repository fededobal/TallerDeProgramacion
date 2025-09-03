program BibliotecaPrestamos;

type
    prestamo = record // dato del nodo del árbol I
        ISBN: integer;
        numSocio: integer;
        dia: integer; 
        mes: integer;
        diasPrestado: integer;
    end;
    
    arbolPrestamos = ^nodoArbolPrestamo;
    nodoArbolPrestamo = record
        dato: prestamo;
        HI: arbolPrestamos;
        HD: arbolPrestamos;
    end;

    prestamo2 = record // dato para el tratamiento de repetidos (lista) del árbol II
        numSocio: integer;
        dia: integer; 
        mes: integer;
        diasPrestado: integer;
    end;
    
    listaPrestamos = ^nodoLista;
    nodoLista = record
        dato: prestamo2;
        sig: listaPrestamos;
    end;

    prestamoPorISBN = record
        ISBN: integer;
        prestamos: listaPrestamos;
    end;
    
    arbolPorISBN = ^nodoArbolPorISBN;
    nodoArbolPorISBN = record
        dato: prestamoPorISBN;
        HI: arbolPorISBN;
        HD: arbolPorISBN;
    end;

    resumen = record
        ISBN: integer;
        cantidadPrestamos: integer;
    end;
    
    arbolResumen = ^nodoArbolResumen;
    nodoArbolResumen = record
        dato: resumen;
        HI: arbolResumen;
        HD: arbolResumen;
    end;

procedure LeerYGenerarEstructuras(var aPrestamos: arbolPrestamos; var aPorISBN: arbolPorISBN);
    procedure LeerPrestamo(var p: prestamo);
    begin
        write('Ingrese ISBN (0 para finalizar): ');
        readln(p.ISBN);
        if (p.ISBN <> 0) then
        begin
            write('Numero de socio: '); readln(p.numSocio);
            p.dia := 1; 
            p.mes := 1; 
            p.diasPrestado := 15;
        end;
    end;
    
    procedure InsertarEnArbolPrestamos(var a: arbolPrestamos; p: prestamo);
    begin
        if (a = nil) then begin
            new(a); 
            a^.dato := p; 
            a^.HI := nil; 
            a^.HD := nil;
        end else if (p.ISBN < a^.dato.ISBN) then
            InsertarEnArbolPrestamos(a^.HI, p)
        else
            InsertarEnArbolPrestamos(a^.HD, p);
    end;
    
    procedure AgregarAdelante(var L: listaPrestamos; p: prestamo2);
    var 
        nue: listaPrestamos;
    begin
        new(nue); 
        nue^.dato := p; 
        nue^.sig := L; 
        L := nue;
    end;

    procedure InsertarEnArbolPorISBN(var a: arbolPorISBN; p: prestamo2; isbnAct: integer);
    begin
        if (a = nil) then begin
            new(a); 
            a^.dato.ISBN := isbnAct;
            a^.dato.prestamos := nil;
            AgregarAdelante(a^.dato.prestamos, p);
            a^.HI := nil; 
            a^.HD := nil;
        end else if (isbnAct = a^.dato.ISBN) then
            AgregarAdelante(a^.dato.prestamos, p)
        else if (isbnAct < a^.dato.ISBN) then
            InsertarEnArbolPorISBN(a^.HI, p, isbnAct)
        else
            InsertarEnArbolPorISBN(a^.HD, p, isbnAct);
    end;

var p: prestamo; p2: prestamo2;
begin
    LeerPrestamo(p);
    while (p.ISBN <> 0) do begin
        p2.numSocio := p.numSocio;
        p2.dia := p.dia;
        p2.mes := p.mes;
        p2.diasPrestado := p.diasPrestado;
        
        InsertarEnArbolPrestamos(aPrestamos, p);
        InsertarEnArbolPorISBN(aPorISBN, p2, p.ISBN);
        LeerPrestamo(p);
    end;
end;

function ISBNMasGrande_Arbol1(a: arbolPrestamos): integer;
begin
    if (a = nil) then ISBNMasGrande_Arbol1 := -1
    else if (a^.HD = nil) then ISBNMasGrande_Arbol1 := a^.dato.ISBN
    else ISBNMasGrande_Arbol1 := ISBNMasGrande_Arbol1(a^.HD);
end;

function ISBNMasPequeno_Arbol2(a: arbolPorISBN): integer;
begin
    if (a = nil) then ISBNMasPequeno_Arbol2 := -1
    else if (a^.HI = nil) then ISBNMasPequeno_Arbol2 := a^.dato.ISBN
    else ISBNMasPequeno_Arbol2 := ISBNMasPequeno_Arbol2(a^.HI);
end;

function CantidadPrestamosSocio_Arbol1(a: arbolPrestamos; socio: integer): integer;
var 
    cant: integer;
begin
    if (a = nil) then CantidadPrestamosSocio_Arbol1 := 0
    else begin
        if (a^.dato.numSocio = socio) then cant := 1 else cant := 0;
        CantidadPrestamosSocio_Arbol1 := cant + CantidadPrestamosSocio_Arbol1(a^.HI, socio) + CantidadPrestamosSocio_Arbol1(a^.HD, socio);
    end;
end;

function CantidadPrestamosSocio_Arbol2(a: arbolPorISBN; socio: integer): integer;
    function ContarEnLista(L: listaPrestamos; soc: integer): integer;
    begin
        if (L = nil) then ContarEnLista := 0
        else if (L^.dato.numSocio = soc) then ContarEnLista := 1 + ContarEnLista(L^.sig, soc)
        else ContarEnLista := ContarEnLista(L^.sig, soc);
    end;
begin
    if (a = nil) then CantidadPrestamosSocio_Arbol2 := 0
    else CantidadPrestamosSocio_Arbol2 := ContarEnLista(a^.dato.prestamos, socio) + CantidadPrestamosSocio_Arbol2(a^.HI, socio) + CantidadPrestamosSocio_Arbol2(a^.HD, socio);
end;

procedure InsertarOIncrementar(var a: arbolResumen; isbn: integer);
begin
    if (a = nil) then begin
        new(a); 
        a^.dato.ISBN := isbn; 
        a^.dato.cantidadPrestamos := 1;
        a^.HI := nil; 
        a^.HD := nil;
    end else if (isbn = a^.dato.ISBN) then
        a^.dato.cantidadPrestamos := a^.dato.cantidadPrestamos + 1
    else if (isbn < a^.dato.ISBN) then
        InsertarOIncrementar(a^.HI, isbn)
    else
        InsertarOIncrementar(a^.HD, isbn);
end;

procedure GenerarResumenDesdeArbol1(a: arbolPrestamos; 
var 
    aResumen: arbolResumen);
begin
    if (a <> nil) then begin
        InsertarOIncrementar(aResumen, a^.dato.ISBN);
        GenerarResumenDesdeArbol1(a^.HI, aResumen);
        GenerarResumenDesdeArbol1(a^.HD, aResumen);
    end;
end;

procedure GenerarResumenDesdeArbol2(a: arbolPorISBN; var aResumen: arbolResumen);
    function ContarNodosLista(L: listaPrestamos): integer;
    begin
        if (L = nil) then ContarNodosLista := 0 else ContarNodosLista := 1 + ContarNodosLista(L^.sig);
    end;
    procedure InsertarResumen(var a: arbolResumen; r: resumen);
    begin
        if (a=nil) then begin
            new(a); a^.dato := r; a^.HI := nil; a^.HD := nil;
        end else if (r.ISBN < a^.dato.ISBN) then
            InsertarResumen(a^.HI, r)
        else
            InsertarResumen(a^.HD, r);
    end;
var 
    r: resumen;
begin
    if (a <> nil) then begin
        r.ISBN := a^.dato.ISBN;
        r.cantidadPrestamos := ContarNodosLista(a^.dato.prestamos);
        InsertarResumen(aResumen, r);
        GenerarResumenDesdeArbol2(a^.HI, aResumen);
        GenerarResumenDesdeArbol2(a^.HD, aResumen);
    end;
end;

procedure MostrarArbolResumen(a: arbolResumen);
begin
    if (a <> nil) then begin
        MostrarArbolResumen(a^.HI);
        writeln('ISBN: ', a^.dato.ISBN, ' | Cantidad de Prestamos: ', a^.dato.cantidadPrestamos);
        MostrarArbolResumen(a^.HD);
    end;
end;

function ContarPrestamosEnRango_Arbol1(a: arbolPrestamos; isbn1, isbn2: integer): integer;
begin
    if (a = nil) then ContarPrestamosEnRango_Arbol1 := 0
    else if (a^.dato.ISBN < isbn1) then ContarPrestamosEnRango_Arbol1 := ContarPrestamosEnRango_Arbol1(a^.HD, isbn1, isbn2)
    else if (a^.dato.ISBN > isbn2) then ContarPrestamosEnRango_Arbol1 := ContarPrestamosEnRango_Arbol1(a^.HI, isbn1, isbn2)
    else ContarPrestamosEnRango_Arbol1 := 1 + ContarPrestamosEnRango_Arbol1(a^.HI, isbn1, isbn2) + ContarPrestamosEnRango_Arbol1(a^.HD, isbn1, isbn2);
end;

function ContarPrestamosEnRango_Arbol2(a: arbolPorISBN; isbn1, isbn2: integer): integer;
    function ContarNodosLista(L: listaPrestamos): integer;
    begin
        if L = nil then ContarNodosLista := 0 else ContarNodosLista := 1 + ContarNodosLista(L^.sig);
    end;
begin
    if (a = nil) then ContarPrestamosEnRango_Arbol2 := 0
    else if (a^.dato.ISBN < isbn1) then ContarPrestamosEnRango_Arbol2 := ContarPrestamosEnRango_Arbol2(a^.HD, isbn1, isbn2)
    else if (a^.dato.ISBN > isbn2) then ContarPrestamosEnRango_Arbol2 := ContarPrestamosEnRango_Arbol2(a^.HI, isbn1, isbn2)
    else ContarPrestamosEnRango_Arbol2 := ContarNodosLista(a^.dato.prestamos) + ContarPrestamosEnRango_Arbol2(a^.HI, isbn1, isbn2) + ContarPrestamosEnRango_Arbol2(a^.HD, isbn1, isbn2);
end;

var
    arbolDePrestamos: arbolPrestamos;
    arbolISBN: arbolPorISBN;
    arbolDeResumen1, arbolDeResumen2: arbolResumen;
    socio, isbn_1, isbn_2, cant: integer;
begin
    arbolDePrestamos := nil;
    arbolISBN := nil;
    LeerYGenerarEstructuras(arbolDePrestamos, arbolISBN);
    
    writeln('ISBN mas grande (Arbol 1): ', ISBNMasGrande_Arbol1(arbolDePrestamos));
    writeln('ISBN mas pequeno (Arbol 2): ', ISBNMasPequeno_Arbol2(arbolISBN));
    
    write('Ingrese numero de socio a buscar: '); readln(socio);
    writeln('Cantidad de prestamos al socio (Arbol 1): ', CantidadPrestamosSocio_Arbol1(arbolDePrestamos, socio));
    writeln('Cantidad de prestamos al socio (Arbol 2): ', CantidadPrestamosSocio_Arbol2(arbolISBN, socio));
    
    arbolDeResumen1 := nil;
    GenerarResumenDesdeArbol1(arbolDePrestamos, arbolDeResumen1);
    writeln('----- Arbol Resumen generado desde Arbol 1 -----');
    MostrarArbolResumen(arbolDeResumen1);
    
    arbolDeResumen2 := nil;
    GenerarResumenDesdeArbol2(arbolISBN, arbolDeResumen2);
    writeln('----- Arbol Resumen generado desde Arbol 2 -----');
    MostrarArbolResumen(arbolDeResumen2);

    write('Ingrese ISBN inicial del rango: '); readln(isbn_1);
    write('Ingrese ISBN final del rango: '); readln(isbn_2);
    cant := ContarPrestamosEnRango_Arbol1(arbolDePrestamos, isbn_1, isbn_2);
    writeln('Total de prestamos en rango (Arbol 1): ', cant);
    cant := ContarPrestamosEnRango_Arbol2(arbolISBN, isbn_1, isbn_2);
    writeln('Total de prestamos en rango (Arbol 2): ', cant);
end.
