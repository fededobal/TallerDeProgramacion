program DecimalABinario;

procedure ConvertirABinario(n: integer);
begin
    if (n < 2) then
        write(n)
    else
    begin
        ConvertirABinario(n div 2);
        write(n mod 2);
    end;
end;

var
    numero: integer;

begin
    write('Ingrese un numero decimal (0 para terminar): ');
    readln(numero);
    while (numero <> 0) do
    begin
        write('El numero ', numero, ' en binario es: ');
        ConvertirABinario(numero);
        writeln;
        writeln;
        write('Ingrese otro numero decimal (0 para terminar): ');
        readln(numero);
    end;
end.
