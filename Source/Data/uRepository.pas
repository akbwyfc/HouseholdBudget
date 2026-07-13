unit uRepository;

interface

uses
  System.SysUtils,
  System.Classes,
  Data.DB,
  FireDAC.Comp.Client,
  uDatabase;

type
  TRepository = class
  private
    FDatabase: TDatabase;

    function NewQuery: TFDQuery;

  public
    constructor Create(ADB: TDatabase);
    property Database: TDatabase
      read FDatabase;
      
    { Categories }
    procedure AddCategory(const AName, AType: string);
    procedure DeleteCategory(AID: Integer);
    //procedure GetCategories(ADataSet: TDataSet);
    procedure UpdateCategory(AID: Integer;  const AName: string);
    procedure GetCategories(AQuery: TFDQuery);

    { Transactions }
    procedure AddTransaction(
      ADate: TDate;
      ATransactionType: Integer;   // 0 = Expense, 1 = Income
      ACategoryID: Integer;
      AAmount: Double;
      const ANote: string);

    procedure UpdateTransaction(
      AID: Integer;
      ADate: TDate;
      ACategoryID: Integer;
      AAmount: Double;
      const ANote: string);

    procedure DeleteTransaction(AID: Integer);

    //procedure GetTransactions(ADataSet: TDataSet);
    procedure GetTransactions(AQuery: TFDQuery);
    procedure GetTransaction(
      AID: Integer;
      out ADate: TDate;
      out ATransactionType: Integer;
      out ACategoryID: Integer;
      out AAmount: Double;
      out ANote: string);
        function GetMonthlyIncome(AYear, AMonth: Integer): Double;
        function GetMonthlyExpense(AYear, AMonth: Integer): Double;
        function GetBalance: Double;
      end;

implementation

uses
  System.DateUtils;

constructor TRepository.Create(ADB: TDatabase);
begin
  inherited Create;
  FDatabase := ADB;
end;

function TRepository.NewQuery: TFDQuery;
begin
  Result := TFDQuery.Create(nil);
  Result.Connection := FDatabase.Connection;
end;

{----------------------------------------------------------}
{ Categories                                                }
{----------------------------------------------------------}

procedure TRepository.AddCategory(
  const AName,
  AType: string);
var
  Q: TFDQuery;
begin
  Q := NewQuery;
  try
    Q.SQL.Text :=
      'INSERT INTO Categories(Name,Type) ' +
      'VALUES(:N,:T)';

    Q.ParamByName('N').AsString := AName;
    Q.ParamByName('T').AsString := AType;

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
      'DELETE FROM Categories WHERE ID=:ID';

    Q.ParamByName('ID').AsInteger := AID;

    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

procedure TRepository.GetCategories(ADataSet: TDataSet);
begin
  if ADataSet is TFDQuery then
  begin
    with TFDQuery(ADataSet) do
    begin
      Close;
      Connection := FDatabase.Connection;
      SQL.Text :=
        'SELECT * FROM Categories ' +
        'ORDER BY Type,Name';
      Open;
    end;
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
    Q.ParamByName('Name').AsString := AName;

    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;
{----------------------------------------------------------}
{ Transactions                                              }
{----------------------------------------------------------}

procedure TRepository.AddTransaction(
  ADate: TDate;
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
      '(TDate,CategoryID,Amount,Note) ' +
      'VALUES(:D,:C,:A,:N)';

    Q.ParamByName('D').AsDate := ADate;
    Q.ParamByName('C').AsInteger := ACategoryID;
    Q.ParamByName('A').AsFloat := AAmount;
    Q.ParamByName('N').AsString := ANote;

    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

procedure TRepository.UpdateTransaction(
  AID: Integer;
  ADate: TDate;
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
      'TDate=:D,' +
      'CategoryID=:C,' +
      'Amount=:A,' +
      'Note=:N ' +
      'WHERE ID=:ID';

    Q.ParamByName('ID').AsInteger := AID;
    Q.ParamByName('D').AsDate := ADate;
    Q.ParamByName('C').AsInteger := ACategoryID;
    Q.ParamByName('A').AsFloat := AAmount;
    Q.ParamByName('N').AsString := ANote;

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
      'DELETE FROM Transactions WHERE ID=:ID';

    Q.ParamByName('ID').AsInteger := AID;

    Q.ExecSQL;
  finally
    Q.Free;
  end;
end;

procedure TRepository.GetTransactions(AQuery: TFDQuery);
begin
  AQuery.Close;
  AQuery.Connection := FDatabase.Connection;

  AQuery.SQL.Text :=
    'SELECT ID, TDate, TransactionType, CategoryID, Amount, Note ' +
    'FROM Transactions ' +
    'ORDER BY TDate DESC';

  AQuery.Open;
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

    if not Q.IsEmpty then
    begin
      ADate := Q.FieldByName('TDate').AsDateTime;
      ATransactionType := Q.FieldByName('TransactionType').AsInteger;
      ACategoryID := Q.FieldByName('CategoryID').AsInteger;
      AAmount := Q.FieldByName('Amount').AsFloat;
      ANote := Q.FieldByName('Note').AsString;
    end;
  finally
    Q.Free;
  end;
end;

{----------------------------------------------------------}
{ Statistics                                                }
{----------------------------------------------------------}

function TRepository.GetMonthlyIncome(
  AYear,
  AMonth: Integer): Double;
var
  Q: TFDQuery;
begin
  Result := 0;

  Q := NewQuery;
  try
    Q.SQL.Text :=
      'SELECT SUM(T.Amount) Total ' +
      'FROM Transactions T ' +
      'JOIN Categories C ON C.ID=T.CategoryID ' +
      'WHERE C.Type=''Income'' ' +
      'AND strftime(''%Y'',T.TDate)=:Y ' +
      'AND strftime(''%m'',T.TDate)=:M';

    Q.ParamByName('Y').AsString := Format('%.4d',[AYear]);
    Q.ParamByName('M').AsString := Format('%.2d',[AMonth]);

    Q.Open;

    Result := Q.Fields[0].AsFloat;
  finally
    Q.Free;
  end;
end;

function TRepository.GetMonthlyExpense(
  AYear,
  AMonth: Integer): Double;
var
  Q: TFDQuery;
begin
  Result := 0;

  Q := NewQuery;
  try
    Q.SQL.Text :=
      'SELECT SUM(T.Amount) Total ' +
      'FROM Transactions T ' +
      'JOIN Categories C ON C.ID=T.CategoryID ' +
      'WHERE C.Type=''Expense'' ' +
      'AND strftime(''%Y'',T.TDate)=:Y ' +
      'AND strftime(''%m'',T.TDate)=:M';

    Q.ParamByName('Y').AsString := Format('%.4d',[AYear]);
    Q.ParamByName('M').AsString := Format('%.2d',[AMonth]);

    Q.Open;

    Result := Q.Fields[0].AsFloat;
  finally
    Q.Free;
  end;
end;

function TRepository.GetBalance: Double;
begin
  Result :=
    GetMonthlyIncome(YearOf(Date), MonthOf(Date)) -
    GetMonthlyExpense(YearOf(Date), MonthOf(Date));
end;

end.
