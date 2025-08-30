Program ImperativoClase3_Mejorado;

type rangoEdad = 12..100;
     cadena15 = string [15];
     socio = record
               numero: integer;
               nombre: cadena15;
               edad: rangoEdad;
             end;
     arbol = ^nodoArbol;
     nodoArbol = record
                    dato: socio;
                    HI: arbol;
                    HD: arbol;
                 end;
     
procedure GenerarArbol (var a: arbol);

  Procedure CargarSocio (var s: socio);
  var vNombres:array [0..9] of string= ('Ana', 'Jose', 'Luis', 'Ema', 'Ariel', 'Pedro', 'Lena', 'Lisa', 'Martin', 'Lola'); 
  
  begin
    s.numero:= random (51) * 100;
    If (s.numero <> 0)
    then begin
           s.nombre:= vNombres[random(10)];
           s.edad:= 12 + random (79);
         end;
  end;  
  
  Procedure InsertarElemento (var a: arbol; elem: socio);
  Begin
    if (a = nil) 
    then begin
           new(a);
           a^.dato:= elem; 
           a^.HI:= nil; 
           a^.HD:= nil;
         end
    else if (elem.numero < a^.dato.numero) 
         then InsertarElemento(a^.HI, elem)
         else InsertarElemento(a^.HD, elem); 
  End;

var unSocio: socio;  
Begin
 a:= nil;
 CargarSocio (unSocio);
 while (unSocio.numero <> 0)do
  begin
   InsertarElemento (a, unSocio);
   CargarSocio (unSocio);
  end;
end;

procedure InformarSociosOrdenCreciente (a: arbol);
  
  procedure InformarDatosSociosOrdenCreciente (a: arbol);
  begin
    if (a <> nil) then begin
        InformarDatosSociosOrdenCreciente (a^.HI);
        writeln ('Numero: ', a^.dato.numero, ' Nombre: ', a^.dato.nombre, ' Edad: ', a^.dato.edad);
        InformarDatosSociosOrdenCreciente (a^.HD);
    end;
  end;

Begin
 writeln('----- Socios en orden creciente ----->');
 InformarDatosSociosOrdenCreciente (a);
 writeln('//////////////////////////////////////////////////////////');
end;

procedure InformarSocioMasGrande(a: arbol);
    function ObtenerMaximo(a: arbol): integer;
    begin
        if (a = nil) then
            ObtenerMaximo := -1
        else if (a^.HD = nil) then
            ObtenerMaximo := a^.dato.numero
        else
            ObtenerMaximo := ObtenerMaximo(a^.HD);
    end;
begin
    writeln('----- Numero de socio mas grande ----->');
    writeln('El numero de socio mas grande es: ', ObtenerMaximo(a));
    writeln('//////////////////////////////////////////////////////////');
end;

procedure InformarSocioMasChico(a: arbol);
    function ObtenerSocioMinimo(a: arbol): socio;
    begin
        if (a^.HI = nil) then
            ObtenerSocioMinimo := a^.dato
        else
            ObtenerSocioMinimo := ObtenerSocioMinimo(a^.HI);
    end;
var s: socio;
begin
    writeln('----- Datos del socio con numero mas chico ----->');
    if (a <> nil) then
    begin
        s := ObtenerSocioMinimo(a);
        writeln('Numero: ', s.numero, ' Nombre: ', s.nombre, ' Edad: ', s.edad);
    end
    else
        writeln('Arbol vacio.');
    writeln('//////////////////////////////////////////////////////////');
end;

procedure BuscarSocioPorNumero(a: arbol);
    function ExisteSocio(a: arbol; num: integer): boolean;
    begin
        if (a = nil) then
            ExisteSocio := false
        else if (a^.dato.numero = num) then
            ExisteSocio := true
        else if (num < a^.dato.numero) then
            ExisteSocio := ExisteSocio(a^.HI, num)
        else
            ExisteSocio := ExisteSocio(a^.HD, num);
    end;
var numBuscado: integer;
begin
    writeln('----- Buscar socio por numero ----->');
    write('Ingrese un numero de socio a buscar: ');
    readln(numBuscado);
    if (ExisteSocio(a, numBuscado)) then
        writeln('El socio con numero ', numBuscado, ' EXISTE.')
    else
        writeln('El socio con numero ', numBuscado, ' NO EXISTE.');
    writeln('//////////////////////////////////////////////////////////');
end;

procedure ContarSociosEnRango(a: arbol);
    function ContarEnRango(a: arbol; v1, v2: integer): integer;
    begin
        if (a = nil) then
            ContarEnRango := 0
        else if (a^.dato.numero < v1) then
            ContarEnRango := ContarEnRango(a^.HD, v1, v2)
        else if (a^.dato.numero > v2) then
            ContarEnRango := ContarEnRango(a^.HI, v1, v2)
        else
            ContarEnRango := 1 + ContarEnRango(a^.HI, v1, v2) + ContarEnRango(a^.HD, v1, v2);
    end;
var val1, val2, cant: integer;
begin
    writeln('----- Contar socios en un rango de numeros ----->');
    write('Ingrese el valor inicial del rango: ');
    readln(val1);
    write('Ingrese el valor final del rango: ');
    readln(val2);
    cant := ContarEnRango(a, val1, val2);
    writeln('Hay ', cant, ' socios entre los numeros ', val1, ' y ', val2);
    writeln('//////////////////////////////////////////////////////////');
end;

var a: arbol; 
Begin
  randomize;
  GenerarArbol (a);
  InformarSociosOrdenCreciente (a);
  InformarSocioMasGrande(a);
  InformarSocioMasChico(a);
  BuscarSocioPorNumero(a);
  ContarSociosEnRango(a);
End.
