unit uModels;

interface

uses
  System.SysUtils,
  System.DateUtils;

type
  // 0 = Expense
  // 1 = Income
  TTransactionType = (ttExpense, ttIncome);

  TTransaction = class
  private
    FID: Integer;
    FDate: TDate;
    FTransactionType: TTransactionType;
    FCategoryID: Integer;
    FAmount: Double;
    FNote: string;
  public
    constructor Create;

    property ID: Integer
      read FID write FID;

    property TransactionDate: TDate
      read FDate write FDate;

    property TransactionType: TTransactionType
      read FTransactionType write FTransactionType;

    property CategoryID: Integer
      read FCategoryID write FCategoryID;

    property Amount: Double
      read FAmount write FAmount;

    property Note: string
      read FNote write FNote;
  end;

  TCategory = class
  private
    FID: Integer;
    FName: string;
  public
    constructor Create;

    property ID: Integer
      read FID write FID;

    property Name: string
      read FName write FName;
  end;

  TBudget = class
  private
    FID: Integer;
    FCategoryID: Integer;
    FYear: Integer;
    FMonth: Integer;
    FAmount: Double;
  public
    constructor Create;

    property ID: Integer
      read FID write FID;

    property CategoryID: Integer
      read FCategoryID write FCategoryID;

    property BudgetYear: Integer
      read FYear write FYear;

    property BudgetMonth: Integer
      read FMonth write FMonth;

    property Amount: Double
      read FAmount write FAmount;
  end;

implementation

{ TTransaction }

constructor TTransaction.Create;
begin
  inherited Create;

  FID := 0;
  FDate := Date;
  FTransactionType := ttExpense;
  FCategoryID := 0;
  FAmount := 0;
  FNote := '';
end;

{ TCategory }

constructor TCategory.Create;
begin
  inherited Create;

  FID := 0;
  FName := '';
end;

{ TBudget }

constructor TBudget.Create;
begin
  inherited Create;

  FID := 0;
  FCategoryID := 0;
  FYear := YearOf(Date);
  FMonth := MonthOf(Date);
  FAmount := 0;
end;

end.
