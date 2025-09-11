program ProcesamientoVentas;

type
    venta = record
        codigo: integer;
        fecha: integer; 
        cantidad: integer;
    end;
    
    arbolVentas = ^nodoVentas;
    nodoVentas = record
        dato: venta;
        HI: arbolVentas;
        HD: arbolVentas;
    end;

    productoTotal = record
        codigo: integer;
        totalUnidades: integer;
    end;
    
    arbolTotalizado = ^nodoTotalizado;
    nodoTotalizado = record
        dato: productoTotal;
        HI: arbolTotalizado;
        HD: arbolTotalizado;
    end;
    
    productoFechaCant = record
        fecha:integer;
        cantidad:integer;
    end;

    listaVentas = ^nodoLista;
    nodoLista = record
        dato: productoFechaCant;
        sig: listaVentas;
    end;

    productoConLista = record
        codigo: integer;
        ventas: listaVentas;
    end;

    arbolConLista = ^nodoConLista;
    nodoConLista = record
        dato: productoConLista;
        HI: arbolConLista;
        HD: arbolConLista;
    end;

procedure GenerarDatosYArboles(var aVentas: arbolVentas; var aTotal: arbolTotalizado; var aLista: arbolConLista);

    procedure InsertarVenta(var a: arbolVentas; v: venta);
    begin
        if (a = nil) then
        begin
            new(a);
            a^.dato := v;
            a^.HI := nil;
            a^.HD := nil;
        end
        else if (v.codigo < a^.dato.codigo) then
            InsertarVenta(a^.HI, v)
        else
            InsertarVenta(a^.HD, v);
    end;

    procedure InsertarOActualizarTotal(var a: arbolTotalizado; v: venta);
    begin
        if (a = nil) then
        begin
            new(a);
            a^.dato.codigo := v.codigo;
            a^.dato.totalUnidades := v.cantidad;
            a^.HI := nil;
            a^.HD := nil;
        end
        else if (v.codigo = a^.dato.codigo) then
            a^.dato.totalUnidades := a^.dato.totalUnidades + v.cantidad
        else if (v.codigo < a^.dato.codigo) then
            InsertarOActualizarTotal(a^.HI, v)
        else
            InsertarOActualizarTotal(a^.HD, v);
    end;

    procedure AgregarAdelante(var L: listaVentas; v: productoFechaCant);
    var nue: listaVentas;
    begin
        new(nue);
        nue^.dato := v;
        nue^.sig := L;
        L := nue;
    end;
    
    procedure InsertarOActualizarLista(var a: arbolConLista; v: productoFechaCant; codigo:integer);
    begin
        if (a = nil) then
        begin
            new(a);
            a^.dato.codigo := codigo;
            a^.dato.ventas := nil;
            AgregarAdelante(a^.dato.ventas, v);
            a^.HI := nil;
            a^.HD := nil;
        end
        else if (codigo = a^.dato.codigo) then
            AgregarAdelante(a^.dato.ventas, v)
        else if (codigo < a^.dato.codigo) then
            InsertarOActualizarLista(a^.HI, v, codigo)
        else
            InsertarOActualizarLista(a^.HD, v, codigo);
    end;

var
    v: venta;
    v3: productoFechaCant;
begin
    aVentas := nil;
    aTotal := nil;
    aLista := nil;
    randomize;
    v.codigo := random(20);
    while (v.codigo <> 0) do
    begin
        v.fecha := 1 + random(31); 
        v.cantidad := 1 + random(50);
        writeln('Venta generada - Codigo: ', v.codigo, ' Fecha: ', v.fecha, ' Cant: ', v.cantidad);

        InsertarVenta(aVentas, v);
        InsertarOActualizarTotal(aTotal, v);
        v3.fecha := v.fecha;
        v3.cantidad := v.cantidad;
        InsertarOActualizarLista(aLista, v3, v.codigo);
        
        v.codigo := random(20)
    end;
end;

function TotalVendidoEnFecha(a: arbolVentas; f: integer): integer;
var
    cantActual: integer;
begin
    if (a = nil) then
        TotalVendidoEnFecha := 0
    else
    begin
        if (a^.dato.fecha = f) then
            cantActual := a^.dato.cantidad
        else
            cantActual := 0;
        TotalVendidoEnFecha := cantActual + TotalVendidoEnFecha(a^.HI, f) + TotalVendidoEnFecha(a^.HD, f);
    end;
end;

function ProductoConMayorVentaTotal(a: arbolTotalizado): integer;
    
    procedure BuscarMax(a: arbolTotalizado; var maxCant: integer; var maxCod: integer);
    begin
        if (a <> nil) then
        begin
            if (a^.dato.totalUnidades > maxCant) then
            begin
                maxCant := a^.dato.totalUnidades;
                maxCod := a^.dato.codigo;
            end;
            BuscarMax(a^.HI, maxCant, maxCod);
            BuscarMax(a^.HD, maxCant, maxCod);
        end;
    end;

var
    maxCantidad, maxCodigo: integer;
begin
    maxCantidad := -1;
    maxCodigo := -1;
    BuscarMax(a, maxCantidad, maxCodigo);
    ProductoConMayorVentaTotal := maxCodigo;
end;

function ProductoConMasCantidadDeVentas(a: arbolConLista): integer;

    function ContarNodosLista(L: listaVentas): integer;
    var cant: integer;
    begin
        cant := 0;
        while (L <> nil) do
        begin
            cant := cant + 1;
            L := L^.sig;
        end;
        ContarNodosLista := cant;
    end;

    procedure BuscarMaxVentas(a: arbolConLista; var maxCantVentas: integer; var maxCod: integer);
    var cantActual: integer;
    begin
        if (a <> nil) then
        begin
            cantActual := ContarNodosLista(a^.dato.ventas);
            if (cantActual > maxCantVentas) then
            begin
                maxCantVentas := cantActual;
                maxCod := a^.dato.codigo;
            end;
            BuscarMaxVentas(a^.HI, maxCantVentas, maxCod);
            BuscarMaxVentas(a^.HD, maxCantVentas, maxCod);
        end;
    end;
    
var
    maxVentas, maxCodigo: integer;
begin
    maxVentas := -1;
    maxCodigo := -1;
    BuscarMaxVentas(a, maxVentas, maxCodigo);
    ProductoConMasCantidadDeVentas := maxCodigo;
end;


var
    arbolDeVentas: arbolVentas;
    arbolDeTotales: arbolTotalizado;
    arbolDeListas: arbolConLista;
    fechaBuscada, total, codMaxTotal, codMasVentas: integer;

begin
    GenerarDatosYArboles(arbolDeVentas, arbolDeTotales, arbolDeListas);
    writeln;
    
    write('Ingrese una fecha (1-31) para buscar el total de productos vendidos: ');
    readln(fechaBuscada);
    total := TotalVendidoEnFecha(arbolDeVentas, fechaBuscada);
    writeln('El total de productos vendidos en la fecha ', fechaBuscada, ' fue: ', total);
    writeln('--------------------------------------------------');

    codMaxTotal := ProductoConMayorVentaTotal(arbolDeTotales);
    writeln('El codigo de producto con mayor cantidad total de unidades vendidas es: ', codMaxTotal);
    writeln('--------------------------------------------------');
    
    codMasVentas := ProductoConMasCantidadDeVentas(arbolDeListas);
    writeln('El codigo de producto con mayor cantidad de ventas es: ', codMasVentas);
    writeln('--------------------------------------------------');
end.
