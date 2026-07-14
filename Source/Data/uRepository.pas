unit uRepository;

interface

uses
  System.SysUtils,
  FireDAC.Comp.Client,
  uDatabase;

type
  TRepository = class
  private
    FDatabase: TDatabase;

    function NewQuery: TFDQuery;

  public
    constructor Create(ADatabase: TDatabase);
    destructor Destroy; override;

    property Database: TDatabase
      read FDatabase;

    { Categories }
    procedure GetCategories(AQuery: TFDQuery);
    procedure AddCategory(
       const AName: string; const AType: string); //procedure AddCategory(const AName: string);
    procedure UpdateCategory(AID: Integer; const AName: string);
    procedure DeleteCategory(AID: Integer);

    { Transactions }
    procedure AddTransaction(
      ADate: TDate;
      ATransactionType: Integer;
      ACategoryID: Integer;
      AAmount: Double;
      const ANote: string);

    procedure UpdateTransaction(
      AID: Integer;
      ADate: TDate;
      ATransactionType: Integer;
      ACategoryID: Integer;
      AAmount: Double;
      const ANote: string);

    procedure DeleteTransaction(AID: Integer);

    procedure GetTransaction(
      AID: Integer;
      out ADate: TDate;
      out ATransactionType: Integer;
      out ACategoryID: Integer;
      out AAmount: Double;
      out ANote: string);

    procedure GetTransactions(AQuery: TFDQuery);

  end;

implementation

{************************************************}
{ Constructor / Destructor                       }
{************************************************}

constructor TRepository.Create(ADatabase: TDatabase);
begin
  inherited Create;
  FDatabase := ADatabase;
end;

destructor TRepository.Destroy;
begin
  inherited;
end;

{************************************************}
{ Create a temporary query                       }
{************************************************}

function TRepository.NewQuery: TFDQuery;
begin
  Result := TFDQuery.Create(nil);
  Result.Connection := FDatabase.Connection;
end;

{************************************************}
{ Categories                                     }
{************************************************}

procedure TRepository.GetCategories(AQuery: TFDQuery);
begin
  AQuery.Close;

  AQuery.Connection := FDatabase.Connection;

  AQuery.SQL.Text :=
    'SELECT ' +
    'ID, ' +
    'Name, ' +
    'Type ' +
    'FROM Categories ' +
    'ORDER BY Name';

  AQuery.Open;
end;

procedure TRepository.AddCategory(const AName: string);
var
  Q: TFDQuery;
begin
  Q := NewQuery;
  try

    Q.SQL.Text :=
      'INSERT INTO Categories ' +
      '(Name) ' +
      'VALUES (:Name)';

    Q.ParamByName('Name').AsString := Trim(AName);

    Q.ExecSQL;

  finally
    Q.Free;
  end;
end;

procedure TRepository.UpdateCategory(
  AID: Integer;
  const AName: string);
var
  Q: TFDQuery;
begin
  Q := NewQuery;
  try

    Q.SQL.Text :=
      'UPDATE Categories ' +
      'SET Name=:Name ' +
      'WHERE ID=:ID';

    Q.ParamByName('ID').AsInteger := AID;
    Q.ParamByName('Name').AsString := Trim(AName);

    Q.ExecSQL;

  finally
    Q.Free;
  end;
end;

procedure TRepository.DeleteCategory(AID: Integer);
var
  Q: TFDQuery;
begin
  Q := NewQuery;
  try

    Q.SQL.Text :=
      'DELETE FROM Categories ' +
      'WHERE ID=:ID';

    Q.ParamByName('ID').AsInteger := AID;

    Q.ExecSQL;

  finally
    Q.Free;
  end;
end;

{************************************************}
{ Transactions                                   }
{************************************************}

procedure TRepository.AddTransaction(
  ADate: TDate;
  ATransactionType: Integer;
  ACategoryID: Integer;
  AAmount: Double;
  const ANote: string);
var
  Q: TFDQuery;
begin
  Q := NewQuery;
  try
    Q.SQL.Text :=
      'INSERT INTO Transactions ' +
      '(TDate, TransactionType, CategoryID, Amount, Note) ' +
      'VALUES (:TDate, :TType, :CategoryID, :Amount, :Note)';

    Q.ParamByName('TDate').AsDate := ADate;
    Q.ParamByName('TType').AsInteger := ATransactionType;
    Q.ParamByName('CategoryID').AsInteger := ACategoryID;
    Q.ParamByName('Amount').AsFloat := AAmount;
    Q.ParamByName('Note').AsString := Trim(ANote);

    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

procedure TRepository.UpdateTransaction(
  AID: Integer;
  ADate: TDate;
  ATransactionType: Integer;
  ACategoryID: Integer;
  AAmount: Double;
  const ANote: string);
var
  Q: TFDQuery;
begin
  Q := NewQuery;
  try
    Q.SQL.Text :=
      'UPDATE Transactions SET ' +
      'TDate=:TDate, ' +
      'TransactionType=:TType, ' +
      'CategoryID=:CategoryID, ' +
      'Amount=:Amount, ' +
      'Note=:Note ' +
      'WHERE ID=:ID';

    Q.ParamByName('ID').AsInteger := AID;
    Q.ParamByName('TDate').AsDate := ADate;
    Q.ParamByName('TType').AsInteger := ATransactionType;
    Q.ParamByName('CategoryID').AsInteger := ACategoryID;
    Q.ParamByName('Amount').AsFloat := AAmount;
    Q.ParamByName('Note').AsString := Trim(ANote);

    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

procedure TRepository.DeleteTransaction(AID: Integer);
var
  Q: TFDQuery;
begin
  Q := NewQuery;
  try
    Q.SQL.Text :=
      'DELETE FROM Transactions ' +
      'WHERE ID=:ID';

    Q.ParamByName('ID').AsInteger := AID;

    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

procedure TRepository.GetTransaction(
  AID: Integer;
  out ADate: TDate;
  out ATransactionType: Integer;
  out ACategoryID: Integer;
  out AAmount: Double;
  out ANote: string);
var
  Q: TFDQuery;
begin
  Q := NewQuery;
  try
    Q.SQL.Text :=
      'SELECT * FROM Transactions ' +
      'WHERE ID=:ID';

    Q.ParamByName('ID').AsInteger := AID;

    Q.Open;

    if Q.IsEmpty then
      Exit;

    ADate := Q.FieldByName('TDate').AsDateTime;
    ATransactionType := Q.FieldByName('TransactionType').AsInteger;
    ACategoryID := Q.FieldByName('CategoryID').AsInteger;
    AAmount := Q.FieldByName('Amount').AsFloat;
    ANote := Q.FieldByName('Note').AsString;

  finally
    Q.Free;
  end;
end;

procedure TRepository.GetTransactions(AQuery: TFDQuery);
begin
  AQuery.Close;

  AQuery.Connection := FDatabase.Connection;

  AQuery.SQL.Text :=
    'SELECT ' +
    'T.ID, ' +
    'T.TDate, ' +
    'T.TransactionType, ' +
    'T.CategoryID, ' +
    'C.Name AS Category, ' +
    'T.Amount, ' +
    'T.Note ' +
    'FROM Transactions T ' +
    'LEFT JOIN Categories C ' +
    'ON T.CategoryID = C.ID ' +
    'ORDER BY T.TDate DESC';

  AQuery.Open;
end;

end.
