program LibreriaVentas;

type
    venta = record
        codigoVenta: integer;
        codigoProducto: integer;
        cantidad: integer;
        precioUnitario: real;
    end;

    producto = record
        codigo: integer;
        totalUnidades: integer;
        montoTotal: real;
    end;

    arbol = ^nodoArbol;
    nodoArbol = record
        dato: producto;
        HI: arbol;
        HD: arbol;
    end;

procedure AlmacenarProductos(var a: arbol);
    procedure LeerVenta(var v: venta);
    begin
        write('Ingrese codigo de venta (-1 para finalizar): ');
        readln(v.codigoVenta);
        if (v.codigoVenta <> -1) then
        begin
            write('Ingrese codigo de producto: ');
            readln(v.codigoProducto);
            write('Ingrese cantidad de unidades: ');
            readln(v.cantidad);
            write('Ingrese precio unitario: ');
            readln(v.precioUnitario);
        end;
    end;

    procedure InsertarOActualizar(var a: arbol; v: venta);
    begin
        if (a = nil) then
        begin
            new(a);
            a^.dato.codigo := v.codigoProducto;
            a^.dato.totalUnidades := v.cantidad;
            a^.dato.montoTotal := v.cantidad * v.precioUnitario;
            a^.HI := nil;
            a^.HD := nil;
        end
        else if (v.codigoProducto = a^.dato.codigo) then
        begin
            a^.dato.totalUnidades := a^.dato.totalUnidades + v.cantidad;
            a^.dato.montoTotal := a^.dato.montoTotal + (v.cantidad * v.precioUnitario);
        end
        else if (v.codigoProducto < a^.dato.codigo) then
            InsertarOActualizar(a^.HI, v)
        else
            InsertarOActualizar(a^.HD, v);
    end;

var v: venta;
begin
    a := nil;
    LeerVenta(v);
    while (v.codigoVenta <> -1) do
    begin
        InsertarOActualizar(a, v);
        LeerVenta(v);
    end;
end;

procedure ImprimirArbolOrdenado(a: arbol);
begin
    if (a <> nil) then
    begin
        ImprimirArbolOrdenado(a^.HI);
        writeln('Codigo: ', a^.dato.codigo, ' | Unidades Vendidas: ', a^.dato.totalUnidades, ' | Monto Total: ', a^.dato.montoTotal:2:2);
        ImprimirArbolOrdenado(a^.HD);
    end;
end;

function ProductoMasVendido(a: arbol): integer;
    procedure BuscarMax(a: arbol; var maxCant: integer; var maxCod: integer);
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
var maxUnidades, maxCodigo: integer;
begin
    maxUnidades := -1;
    maxCodigo := -1;
    BuscarMax(a, maxUnidades, maxCodigo);
    ProductoMasVendido := maxCodigo;
end;

function CantidadCodigosMenores(a: arbol; valor: integer): integer;
begin
    if (a = nil) then
        CantidadCodigosMenores := 0
    else if (a^.dato.codigo < valor) then
        CantidadCodigosMenores := 1 + CantidadCodigosMenores(a^.HI, valor) + CantidadCodigosMenores(a^.HD, valor)
    else
        CantidadCodigosMenores := CantidadCodigosMenores(a^.HI, valor);
end;

function MontoTotalEntreCodigos(a: arbol; v1, v2: integer): real;
begin
    if (a = nil) then
        MontoTotalEntreCodigos := 0.0
    else if (a^.dato.codigo <= v1) then
        MontoTotalEntreCodigos := MontoTotalEntreCodigos(a^.HD, v1, v2)
    else if (a^.dato.codigo >= v2) then
        MontoTotalEntreCodigos := MontoTotalEntreCodigos(a^.HI, v1, v2)
    else
        MontoTotalEntreCodigos := a^.dato.montoTotal + MontoTotalEntreCodigos(a^.HI, v1, v2) + MontoTotalEntreCodigos(a^.HD, v1, v2);
end;

var
    arbolProductos: arbol;
    codigoMaxUnidades, valor, val1, val2, cant: integer;
    monto: real;

begin
    AlmacenarProductos(arbolProductos);

    writeln('----- Listado de productos ordenado por codigo -----');
    ImprimirArbolOrdenado(arbolProductos);
    
    codigoMaxUnidades := ProductoMasVendido(arbolProductos);
    writeln('----- Producto con mayor cantidad de unidades vendidas -----');
    writeln('Codigo de producto: ', codigoMaxUnidades);
    
    writeln('----- Cantidad de codigos menores a un valor -----');
    write('Ingrese un valor: ');
    readln(valor);
    cant := CantidadCodigosMenores(arbolProductos, valor);
    writeln('Cantidad de codigos menores a ', valor, ': ', cant);
    
    writeln('----- Monto total entre dos codigos (sin incluir) -----');
    write('Ingrese el codigo inferior: ');
    readln(val1);
    write('Ingrese el codigo superior: ');
    readln(val2);
    monto := MontoTotalEntreCodigos(arbolProductos, val1, val2);
    writeln('El monto total entre ', val1, ' y ', val2, ' es: ', monto:2:2);
end.
