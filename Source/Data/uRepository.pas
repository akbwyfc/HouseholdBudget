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

    {************************************************}
    { Budgets                                        }
    {************************************************}
    
    procedure AddBudget(
      ACategoryID: Integer;
      const ABudgetMonth: string;
      AAmount: Double);
    
    procedure UpdateBudget(
      AID: Integer;
      ACategoryID: Integer;
      const ABudgetMonth: string;
      AAmount: Double);
    
    procedure DeleteBudget(
      AID: Integer);
    
    procedure GetBudgets(AQuery: TFDQuery);
    
    {************************************************}
    { Statistics                                     }
    {************************************************}
    
    function GetMonthlyIncome(
      AYear,
      AMonth: Integer): Double;
    
    function GetMonthlyExpense(
      AYear,
      AMonth: Integer): Double;
    
    function GetBalance: Double;
    
    function GetYearlyIncome(
      AYear: Integer): Double;
    
    function GetYearlyExpense(
      AYear: Integer): Double;
    {************************************************}
    { Reports                                        }
    {************************************************}
    
    procedure GetMonthlyReport(
      AYear,
      AMonth: Integer;
      AQuery: TFDQuery);
    
    procedure GetTransactionsByDateRange(
      const AStartDate,
      AEndDate: TDate;
      AQuery: TFDQuery);
    
    procedure GetTransactionsByCategory(
      ACategoryID: Integer;
      AQuery: TFDQuery);
    
    procedure GetCategorySummary(
      AYear,
      AMonth: Integer;
      AQuery: TFDQuery);
    
    procedure GetBudgetVsActual(
      const ABudgetMonth: string;
      AQuery: TFDQuery);      

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

{************************************************}
{ Budgets                                        }
{************************************************}

procedure TRepository.AddBudget(
  ACategoryID: Integer;
  const ABudgetMonth: string;
  AAmount: Double);
var
  Q: TFDQuery;
begin
  Q := NewQuery;
  try

    Q.SQL.Text :=
      'INSERT INTO Budgets ' +
      '(CategoryID,BudgetMonth,Amount) ' +
      'VALUES (:CategoryID,:BudgetMonth,:Amount)';

    Q.ParamByName('CategoryID').AsInteger := ACategoryID;
    Q.ParamByName('BudgetMonth').AsString := ABudgetMonth;
    Q.ParamByName('Amount').AsFloat := AAmount;

    Q.ExecSQL;

  finally
    Q.Free;
  end;
end;

procedure TRepository.UpdateBudget(
  AID: Integer;
  ACategoryID: Integer;
  const ABudgetMonth: string;
  AAmount: Double);
var
  Q: TFDQuery;
begin
  Q := NewQuery;
  try

    Q.SQL.Text :=
      'UPDATE Budgets SET ' +
      'CategoryID=:CategoryID,' +
      'BudgetMonth=:BudgetMonth,' +
      'Amount=:Amount ' +
      'WHERE ID=:ID';

    Q.ParamByName('ID').AsInteger := AID;
    Q.ParamByName('CategoryID').AsInteger := ACategoryID;
    Q.ParamByName('BudgetMonth').AsString := ABudgetMonth;
    Q.ParamByName('Amount').AsFloat := AAmount;

    Q.ExecSQL;

  finally
    Q.Free;
  end;
end;

procedure TRepository.DeleteBudget(AID: Integer);
var
  Q: TFDQuery;
begin
  Q := NewQuery;
  try

    Q.SQL.Text :=
      'DELETE FROM Budgets WHERE ID=:ID';

    Q.ParamByName('ID').AsInteger := AID;

    Q.ExecSQL;

  finally
    Q.Free;
  end;
end;

procedure TRepository.GetBudgets(AQuery: TFDQuery);
begin

  AQuery.Close;

  AQuery.Connection := FDatabase.Connection;

  AQuery.SQL.Text :=
    'SELECT ' +
    'B.ID,' +
    'C.Name AS Category,' +
    'B.BudgetMonth,' +
    'B.Amount ' +
    'FROM Budgets B ' +
    'LEFT JOIN Categories C ' +
    'ON B.CategoryID=C.ID ' +
    'ORDER BY B.BudgetMonth DESC,C.Name';

  AQuery.Open;

end;

{************************************************}
{ Statistics                                     }
{************************************************}

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
      'SELECT IFNULL(SUM(Amount),0) Total '+
      'FROM Transactions '+
      'WHERE TransactionType=1 '+
      'AND strftime(''%Y'',TDate)=:Y '+
      'AND strftime(''%m'',TDate)=:M';

    Q.ParamByName('Y').AsString :=
      Format('%.4d',[AYear]);

    Q.ParamByName('M').AsString :=
      Format('%.2d',[AMonth]);

    Q.Open;

    Result := Q.FieldByName('Total').AsFloat;

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
      'SELECT IFNULL(SUM(Amount),0) Total '+
      'FROM Transactions '+
      'WHERE TransactionType=0 '+
      'AND strftime(''%Y'',TDate)=:Y '+
      'AND strftime(''%m'',TDate)=:M';

    Q.ParamByName('Y').AsString :=
      Format('%.4d',[AYear]);

    Q.ParamByName('M').AsString :=
      Format('%.2d',[AMonth]);

    Q.Open;

    Result := Q.FieldByName('Total').AsFloat;

  finally
    Q.Free;
  end;

end;

function TRepository.GetBalance: Double;
var
  Q: TFDQuery;
begin

  Result := 0;

  Q := NewQuery;
  try

    Q.SQL.Text :=
      'SELECT '+
      'IFNULL('+
      'SUM(CASE WHEN TransactionType=1 THEN Amount ELSE -Amount END),0) Balance '+
      'FROM Transactions';

    Q.Open;

    Result := Q.FieldByName('Balance').AsFloat;

  finally
    Q.Free;
  end;

end;

function TRepository.GetYearlyIncome(
  AYear: Integer): Double;
var
  Q: TFDQuery;
begin

  Result := 0;

  Q := NewQuery;
  try

    Q.SQL.Text :=
      'SELECT IFNULL(SUM(Amount),0) Total '+
      'FROM Transactions '+
      'WHERE TransactionType=1 '+
      'AND strftime(''%Y'',TDate)=:Y';

    Q.ParamByName('Y').AsString :=
      Format('%.4d',[AYear]);

    Q.Open;

    Result := Q.FieldByName('Total').AsFloat;

  finally
    Q.Free;
  end;

end;

function TRepository.GetYearlyExpense(
  AYear: Integer): Double;
var
  Q: TFDQuery;
begin

  Result := 0;

  Q := NewQuery;
  try

    Q.SQL.Text :=
      'SELECT IFNULL(SUM(Amount),0) Total '+
      'FROM Transactions '+
      'WHERE TransactionType=0 '+
      'AND strftime(''%Y'',TDate)=:Y';

    Q.ParamByName('Y').AsString :=
      Format('%.4d',[AYear]);

    Q.Open;

    Result := Q.FieldByName('Total').AsFloat;

  finally
    Q.Free;
  end;

end;

{************************************************}
{ Monthly Report                                }
{************************************************}

procedure TRepository.GetMonthlyReport(
  AYear,
  AMonth: Integer;
  AQuery: TFDQuery);
begin

  AQuery.Close;
  AQuery.Connection := FDatabase.Connection;

  AQuery.SQL.Text :=
    'SELECT ' +
    'T.ID, ' +
    'T.TDate, ' +
    'CASE T.TransactionType ' +
    'WHEN 0 THEN ''Expense'' ' +
    'ELSE ''Income'' END AS Type, ' +
    'C.Name AS Category, ' +
    'T.Amount, ' +
    'T.Note ' +
    'FROM Transactions T ' +
    'LEFT JOIN Categories C ' +
    'ON T.CategoryID=C.ID ' +
    'WHERE strftime(''%Y'',T.TDate)=:Y ' +
    'AND strftime(''%m'',T.TDate)=:M ' +
    'ORDER BY T.TDate';

  AQuery.ParamByName('Y').AsString :=
    Format('%.4d',[AYear]);

  AQuery.ParamByName('M').AsString :=
    Format('%.2d',[AMonth]);

  AQuery.Open;

end;

{************************************************}
{ Date Range                                     }
{************************************************}

procedure TRepository.GetTransactionsByDateRange(
  const AStartDate,
  AEndDate: TDate;
  AQuery: TFDQuery);
begin

  AQuery.Close;
  AQuery.Connection := FDatabase.Connection;

  AQuery.SQL.Text :=
    'SELECT ' +
    'T.ID,' +
    'T.TDate,' +
    'C.Name Category,' +
    'T.Amount,' +
    'T.Note ' +
    'FROM Transactions T ' +
    'LEFT JOIN Categories C ' +
    'ON T.CategoryID=C.ID ' +
    'WHERE date(T.TDate) BETWEEN :D1 AND :D2 ' +
    'ORDER BY T.TDate';

  AQuery.ParamByName('D1').AsDate := AStartDate;
  AQuery.ParamByName('D2').AsDate := AEndDate;

  AQuery.Open;

end;

{************************************************}
{ Category Transactions                          }
{************************************************}

procedure TRepository.GetTransactionsByCategory(
  ACategoryID: Integer;
  AQuery: TFDQuery);
begin

  AQuery.Close;
  AQuery.Connection := FDatabase.Connection;

  AQuery.SQL.Text :=
    'SELECT * ' +
    'FROM Transactions ' +
    'WHERE CategoryID=:ID ' +
    'ORDER BY TDate';

  AQuery.ParamByName('ID').AsInteger := ACategoryID;

  AQuery.Open;

end;

{************************************************}
{ Category Summary                               }
{************************************************}

procedure TRepository.GetCategorySummary(
  AYear,
  AMonth: Integer;
  AQuery: TFDQuery);
begin

  AQuery.Close;
  AQuery.Connection := FDatabase.Connection;

  AQuery.SQL.Text :=
    'SELECT ' +
    'C.Name Category,' +
    'SUM(T.Amount) Total ' +
    'FROM Transactions T ' +
    'LEFT JOIN Categories C ' +
    'ON T.CategoryID=C.ID ' +
    'WHERE strftime(''%Y'',T.TDate)=:Y ' +
    'AND strftime(''%m'',T.TDate)=:M ' +
    'GROUP BY C.Name ' +
    'ORDER BY Total DESC';

  AQuery.ParamByName('Y').AsString :=
    Format('%.4d',[AYear]);

  AQuery.ParamByName('M').AsString :=
    Format('%.2d',[AMonth]);

  AQuery.Open;

end;

{************************************************}
{ Budget vs Actual                               }
{************************************************}

procedure TRepository.GetBudgetVsActual(
  const ABudgetMonth: string;
  AQuery: TFDQuery);
begin

  AQuery.Close;
  AQuery.Connection := FDatabase.Connection;

  AQuery.SQL.Text :=
    'SELECT ' +
    'C.Name Category,' +
    'B.Amount Budget,' +
    'IFNULL(SUM(T.Amount),0) Actual ' +
    'FROM Budgets B ' +
    'LEFT JOIN Categories C ' +
    'ON B.CategoryID=C.ID ' +
    'LEFT JOIN Transactions T ' +
    'ON B.CategoryID=T.CategoryID ' +
    'AND strftime(''%Y-%m'',T.TDate)=B.BudgetMonth ' +
    'WHERE B.BudgetMonth=:M ' +
    'GROUP BY C.Name,B.Amount ' +
    'ORDER BY C.Name';

  AQuery.ParamByName('M').AsString := ABudgetMonth;

  AQuery.Open;

end;

end.
