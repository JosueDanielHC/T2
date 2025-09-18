program main;

{$mode objfpc}{$H+}

uses
  SysUtils, fpjson, jsonparser, Classes, Process, bst;

var
  root: PNode = nil;
  jsonData: TJSONData;
  jsonArray: TJSONArray;
  obj: TJSONObject;
  i, id: Integer;
  fname, lname, email: String;
  dotFile, imgFile: String;

procedure GenerateImage(dotFile, imgFile: String);
var
  AProcess: TProcess;
begin
  AProcess := TProcess.Create(nil);
  try
    AProcess.Executable := 'dot';
    AProcess.Parameters.Add('-Tpng');
    AProcess.Parameters.Add(dotFile);
    AProcess.Parameters.Add('-o');
    AProcess.Parameters.Add(imgFile);
    AProcess.Execute;
  finally
    AProcess.Free;
  end;
end;

begin
  try
    // Cargar JSON
    jsonData := GetJSON(ReadFileToString('datos.json'));
    jsonArray := TJSONArray(jsonData);

    for i := 0 to jsonArray.Count - 1 do
    begin
      obj := jsonArray.Objects[i];
      id := obj.Integers['id'];
      fname := obj.Strings['first_name'];
      lname := obj.Strings['last_name'];
      email := obj.Strings['email'];
      InsertNode(root, id, fname, lname, email);
    end;

    // Exportar Graphviz
    dotFile := 'graphviz.dot';
    imgFile := 'graphviz.png';
    ExportGraphviz(root, dotFile);
    GenerateImage(dotFile, imgFile);

    Writeln('Árbol cargado desde datos.json');
    Writeln('Archivo Graphviz generado: ', dotFile);
    Writeln('Imagen generada: ', imgFile);

  except
    on E: Exception do
      Writeln('Error: ', E.Message);
  end;
end.
