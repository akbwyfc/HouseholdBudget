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

  // Enable SQLite foreign key constraints
  FConnection.ExecSQL('PRAGMA foreign_keys = ON;');

  CreateTables;
end;

procedure TDatabase.CreateTables;
begin
FConnection.ExecSQL(
  'CREATE INDEX IF NOT EXISTS IDX_TransactionDate ' +
  'ON Transactions(TDate)');
FConnection.ExecSQL(
  'CREATE INDEX IF NOT EXISTS IDX_TransactionCategory ' +
  'ON Transactions(CategoryID)');

FConnection.ExecSQL(
  'CREATE INDEX IF NOT EXISTS IDX_BudgetMonth ' +
  'ON Budgets(BudgetMonth)');
FConnection.ExecSQL(
  'INSERT OR IGNORE INTO Categories (ID, Name, Type) VALUES ' +
  '(1, ''Salary'', ''Income'')');

FConnection.ExecSQL(
  'INSERT OR IGNORE INTO Categories (ID, Name, Type) VALUES ' +
  '(2, ''Bonus'', ''Income'')');

FConnection.ExecSQL(
  'INSERT OR IGNORE INTO Categories (ID, Name, Type) VALUES ' +
  '(3, ''Food'', ''Expense'')');

FConnection.ExecSQL(
  'INSERT OR IGNORE INTO Categories (ID, Name, Type) VALUES ' +
  '(4, ''Rent'', ''Expense'')');

FConnection.ExecSQL(
  'INSERT OR IGNORE INTO Categories (ID, Name, Type) VALUES ' +
  '(5, ''Transportation'', ''Expense'')');

FConnection.ExecSQL(
  'INSERT OR IGNORE INTO Categories (ID, Name, Type) VALUES ' +
  '(6, ''Utilities'', ''Expense'')');

FConnection.ExecSQL(
  'CREATE TABLE IF NOT EXISTS Categories (' +
  'ID INTEGER PRIMARY KEY AUTOINCREMENT,' +
  'Name TEXT NOT NULL,' +
  'Type TEXT NOT NULL)'
);

FConnection.ExecSQL(
  'CREATE TABLE IF NOT EXISTS Transactions (' +
  'ID INTEGER PRIMARY KEY AUTOINCREMENT,' +
  'TDate TEXT NOT NULL,' +
  'TransactionType INTEGER NOT NULL,' +
  'CategoryID INTEGER NOT NULL,' +
  'Amount REAL NOT NULL,' +
  'Note TEXT,' +
  'FOREIGN KEY(CategoryID) REFERENCES Categories(ID))'
);

FConnection.ExecSQL(
  'CREATE TABLE IF NOT EXISTS Budgets (' +
  'ID INTEGER PRIMARY KEY AUTOINCREMENT,' +
  'CategoryID INTEGER NOT NULL,' +
  'BudgetMonth TEXT NOT NULL,' +
  'Amount REAL NOT NULL,' +
  'FOREIGN KEY(CategoryID) REFERENCES Categories(ID))'
);

end;

end.
