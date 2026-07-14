unit uDatabase;

interface

uses
  System.SysUtils,
  System.Classes,
  FireDAC.Comp.Client,
  FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef,
  FireDAC.Stan.Def,
  FireDAC.Stan.Async,
  FireDAC.DApt;

type
  TDatabase = class
  private
    FConnection: TFDConnection;
    procedure CreateTables;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Connect;

    property Connection: TFDConnection read FConnection;
  end;

implementation

uses
  System.IOUtils;

constructor TDatabase.Create;
begin
  inherited;

  FConnection := TFDConnection.Create(nil);
  FConnection.DriverName := 'SQLite';
end;

destructor TDatabase.Destroy;
begin
  FConnection.Free;
  inherited;
end;

procedure TDatabase.Connect;
var
  DBPath: string;
begin
  DBPath :=
    TPath.Combine(
      ExtractFilePath(ParamStr(0)),
      'Database\Budget.db');

  ForceDirectories(ExtractFilePath(DBPath));

  FConnection.Params.Database := DBPath;

  FConnection.LoginPrompt := False;

  FConnection.Connected := True;

  CreateTables;
end;

procedure TDatabase.CreateTables;
begin

  FConnection.ExecSQL(
    'CREATE TABLE IF NOT EXISTS Categories ('+
    'ID INTEGER PRIMARY KEY AUTOINCREMENT,'+
    'Name TEXT,'+
    'Type TEXT)'
  );

  FConnection.ExecSQL(
    'CREATE TABLE IF NOT EXISTS Transactions ('+
    'ID INTEGER PRIMARY KEY AUTOINCREMENT,'+
    'TDate TEXT,'+
    TransactionType INTEGER,
    'CategoryID INTEGER,'+
    'Amount REAL,'+
    'Note TEXT)'
  );

  FConnection.ExecSQL(
    'CREATE TABLE IF NOT EXISTS Budgets ('+
    'ID INTEGER PRIMARY KEY AUTOINCREMENT,'+
    'CategoryID INTEGER,'+
    'BudgetMonth TEXT,'+
    'Amount REAL)'
  );

end;

end.
