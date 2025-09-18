unit bst;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  PNode = ^TNode;
  TNode = record
    id: Integer;
    first_name: String;
    last_name: String;
    email: String;
    left, right: PNode;
  end;

procedure InsertNode(var root: PNode; id: Integer; fname, lname, email: String);
procedure ExportGraphviz(root: PNode; const filename: String);

implementation

procedure InsertNode(var root: PNode; id: Integer; fname, lname, email: String);
begin
  if root = nil then
  begin
    New(root);
    root^.id := id;
    root^.first_name := fname;
    root^.last_name := lname;
    root^.email := email;
    root^.left := nil;
    root^.right := nil;
  end
  else if id < root^.id then
    InsertNode(root^.left, id, fname, lname, email)
  else
    InsertNode(root^.right, id, fname, lname, email);
end;

procedure WriteGraphviz(node: PNode; var f: Text);
begin
  if node <> nil then
  begin
    if node^.left <> nil then
    begin
      Writeln(f, '  "', node^.id, '" -> "', node^.left^.id, '";');
      WriteGraphviz(node^.left, f);
    end;
    if node^.right <> nil then
    begin
      Writeln(f, '  "', node^.id, '" -> "', node^.right^.id, '";');
      WriteGraphviz(node^.right, f);
    end;
  end;
end;

procedure ExportGraphviz(root: PNode; const filename: String);
var
  f: Text;
begin
  AssignFile(f, filename);
  Rewrite(f);
  Writeln(f, 'digraph BST {');
  Writeln(f, '  node [shape=record, style=filled, color=lightblue];');
  WriteGraphviz(root, f);
  Writeln(f, '}');
  CloseFile(f);
end;

end.
