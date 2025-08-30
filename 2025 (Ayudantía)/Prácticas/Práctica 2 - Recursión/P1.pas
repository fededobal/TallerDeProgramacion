{1.- Implementar un programa que invoque a los siguientes m�dulos.
a. Un m�dulo recursivo que retorne un vector de a lo sumo 15 n�meros enteros �random� mayores a 10 y menores a 155 (incluidos ambos). La carga finaliza con 
el valor 20.
b. Un m�dulo no recursivo que reciba el vector generado en a) e imprima el contenido del vector.
c. Un m�dulo recursivo que reciba el vector generado en a) e imprima el contenido del vector.
d. Un m�dulo recursivo que reciba el vector generado en a) y devuelva la suma de los valores pares contenidos en el vector.
e. Un m�dulo recursivo que reciba el vector generado en a) y devuelva el m�ximo valor del vector.
f. Un m�dulo recursivo que reciba el vector generado en a) y un valor y devuelva verdadero si dicho valor se encuentra en el vector o falso en caso contrario.
g. Un m�dulo que reciba el vector generado en a) e imprima, para cada n�mero contenido en el vector, sus d�gitos en el orden en que aparecen en el n�mero. 
Debe implementarse un m�dulo recursivo que reciba el n�mero e imprima lo pedido. Ejemplo si se lee el valor 142, se debe imprimir 1  4  2
}

Program Clase2MI;
const 
    dimF = 15;
    min = 10;
    max = 155;
type 
    vector = array [1..dimF] of integer;
     

procedure CargarVector (var v: vector; var dimL: integer);

  procedure CargarVectorRecursivo (var v: vector; var dimL: integer);
  var valor: integer;
  begin
    valor:= min + random (max - min + 1);
    if ((valor <> 20 ) and (dimL < dimF)) 
    then begin
          dimL:= dimL + 1;
          v[dimL]:= valor;
          CargarVectorRecursivo (v, dimL);
         end;
  end;
  
begin
  randomize;
  dimL:= 0;
  CargarVectorRecursivo (v, dimL);
end;
 
procedure ImprimirVector (v: vector; dimL: integer);
var
   i: integer;
begin
     for i:= 1 to dimL do
         write ('-----');
     writeln;
     write ('| ');
     for i:= 1 to dimL do begin
        write(v[i], ' | ');
     end;
     writeln;
     for i:= 1 to dimL do
         write ('-----');
     writeln;
     writeln;
End;     

procedure ImprimirVectorRecursivo (v: vector; dimL: integer);

  procedure ImprimirRec(v: vector; pos, dimL: integer);
  begin
    if (pos <= dimL) then
    begin
        write(v[pos], ' | ');
        ImprimirRec(v, pos + 1, dimL);
    end;
  end;

begin
    if (dimL > 0) then
    begin
        writeln('Impresion recursiva:');
        write('| ');
        ImprimirRec(v, 1, dimL);
        writeln;
    end;
end; 
    
function SumarPares (v: vector; dimL: integer): integer; 

  function SumarParesRecursivo (v: vector; pos, dimL: integer): integer;
  Begin
    if (pos <= dimL) then
    begin
        if (v[pos] mod 2 = 0) then
            SumarParesRecursivo := v[pos] + SumarParesRecursivo(v, pos + 1, dimL)
        else
            SumarParesRecursivo := SumarParesRecursivo(v, pos + 1, dimL);
    end
    else
        SumarParesRecursivo := 0;
  End;
 
begin
 SumarPares:= SumarParesRecursivo (v, 1, dimL);
end;

function  ObtenerMaximo (v: vector; dimL: integer): integer;

  function MaximoRecursivo(v: vector; pos, dimL: integer): integer;
  var maxResto: integer;
  begin
    if (pos = dimL) then
        MaximoRecursivo := v[pos]
    else
    begin
        maxResto := MaximoRecursivo(v, pos + 1, dimL);
        if (v[pos] > maxResto) then
            MaximoRecursivo := v[pos]
        else
            MaximoRecursivo := maxResto;
    end;
  end;

begin
  if (dimL > 0) then
    ObtenerMaximo := MaximoRecursivo(v, 1, dimL)
  else
    ObtenerMaximo := -1;
end;     
     
function  BuscarValor (v: vector; dimL, valor: integer): boolean;

  function BuscarRecursivo(v: vector; pos, dimL, valor: integer): boolean;
  begin
    if (pos > dimL) then
        BuscarRecursivo := false
    else if (v[pos] = valor) then
        BuscarRecursivo := true
    else
        BuscarRecursivo := BuscarRecursivo(v, pos + 1, dimL, valor);
  end;

begin
  BuscarValor := BuscarRecursivo(v, 1, dimL, valor);
end; 

procedure ImprimirDigitos (v: vector; dimL: integer);

  procedure MostrarDigitosRecursivo(num: integer);
  begin
    if (num < 10) then
        write(num, ' ')
    else
    begin
        MostrarDigitosRecursivo(num div 10);
        write(num mod 10, ' ');
    end;
  end;

var
    i: integer;
begin
    writeln('--- Digitos de cada numero del vector ---');
    for i := 1 to dimL do
    begin
        write('Numero ', v[i], ': ');
        MostrarDigitosRecursivo(v[i]);
        writeln;
    end;
end; 

var dimL, sumaPares, maximo, valor: integer; 
    v: vector;
    encontre: boolean;
Begin 
  CargarVector (v, dimL);
  writeln;
  if (dimL = 0) then writeln ('--- Vector sin elementos ---')
                else begin
                       ImprimirVector (v, dimL);
                       ImprimirVectorRecursivo (v, dimL);
                     end;
  writeln;                 
  sumaPares:= SumarPares(v, dimL);
  writeln('La suma de los valores pares del vector es ', sumaPares); 
  writeln;
  maximo:= ObtenerMaximo(v, dimL);
  writeln('El maximo del vector es ', maximo); 
  writeln;
  write ('Ingrese un valor a buscar: ');
  readln (valor);
  encontre:= BuscarValor(v, dimL, valor);
  if (encontre) then writeln('El ', valor, ' esta en el vector')
                else writeln('El ', valor, ' no esta en el vector');
                
  writeln;
  ImprimirDigitos (v, dimL);
end.
