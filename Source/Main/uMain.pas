unit uMain;

interface

uses
  Winapi.Windows,
  Winapi.Messages,

  System.SysUtils,
  System.Classes,

  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.DBGrids,

  Data.DB,

  FireDAC.Comp.Client,

  uDatabase,
  uRepository,
  uTransaction,
  uCategories;

type
  TfrmMain = class(TForm)

    pnlTop: TPanel;

    lblIncomeTitle: TLabel;
    lblExpenseTitle: TLabel;
    lblBalanceTitle: TLabel;

    lblIncome: TLabel;
    lblExpense: TLabel;
    lblBalance: TLabel;

    DBGrid1: TDBGrid;

    pnlBottom: TPanel;

    btnAdd: TButton;
    btnEdit: TButton;
    btnDelete: TButton;
    btnCategories: TButton;
    btnBudget: TButton;
    btnReports: TButton;
    btnExit: TButton;

    dsTransactions: TDataSource;
    qryTransactions: TFDQuery;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

    procedure btnAddClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);

    procedure btnCategoriesClick(Sender: TObject);

    procedure btnBudgetClick(Sender: TObject);
    procedure btnReportsClick(Sender: TObject);

    procedure btnExitClick(Sender: TObject);

  private

    FDatabase: TDatabase;
    FRepository: TRepository;

    procedure RefreshDashboard;
    procedure RefreshTotals;

  public

  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin

  FDatabase := TDatabase.Create;

  FDatabase.Connect;

  FRepository := TRepository.Create(FDatabase);

  qryTransactions.Connection := FDatabase.Connection;
  dsTransactions.DataSet := qryTransactions;

  RefreshDashboard;

end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin

  FRepository.Free;
  FDatabase.Free;

end;

procedure TfrmMain.RefreshDashboard;
begin

  FRepository.GetTransactions(qryTransactions);

  RefreshTotals;

end;

procedure TfrmMain.RefreshTotals;
var
  Y,M,D : Word;
begin

  DecodeDate(Date,Y,M,D);

  lblIncome.Caption :=
    FormatFloat(
      '#,##0.00',
      FRepository.GetMonthlyIncome(Y,M));

  lblExpense.Caption :=
    FormatFloat(
      '#,##0.00',
      FRepository.GetMonthlyExpense(Y,M));

  lblBalance.Caption :=
    FormatFloat(
      '#,##0.00',
      FRepository.GetBalance);

end;

procedure TfrmMain.btnAddClick(Sender: TObject);
begin

  frmTransaction := TfrmTransaction.Create(Self);

  try

    frmTransaction.Repository := FRepository;
    frmTransaction.EditMode := False;

    if frmTransaction.ShowModal = mrOK then
      RefreshDashboard;

  finally
    frmTransaction.Free;
  end;

end;

procedure TfrmMain.btnEditClick(Sender: TObject);
begin

  if qryTransactions.IsEmpty then
    Exit;

  frmTransaction := TfrmTransaction.Create(Self);

  try

    frmTransaction.Repository := FRepository;

    frmTransaction.EditMode := True;

    frmTransaction.TransactionID :=
      qryTransactions.FieldByName('ID').AsInteger;

    if frmTransaction.ShowModal = mrOK then
      RefreshDashboard;

  finally
    frmTransaction.Free;
  end;

end;

procedure TfrmMain.btnDeleteClick(Sender: TObject);
begin

  if qryTransactions.IsEmpty then
    Exit;

  if MessageDlg(
      'Delete selected transaction?',
      mtConfirmation,
      [mbYes,mbNo],
      0) <> mrYes then
      Exit;

  FRepository.DeleteTransaction(
    qryTransactions.FieldByName('ID').AsInteger);

  RefreshDashboard;

end;

procedure TfrmMain.btnCategoriesClick(Sender: TObject);
begin

  frmCategories := TfrmCategories.Create(Self);

  try

    frmCategories.Repository := FRepository;

    frmCategories.ShowModal;

    RefreshDashboard;

  finally
    frmCategories.Free;
  end;

end;

procedure TfrmMain.btnBudgetClick(Sender: TObject);
begin
  ShowMessage('Budget form not implemented yet.');
end;

procedure TfrmMain.btnReportsClick(Sender: TObject);
begin
  ShowMessage('Reports form not implemented yet.');
end;

procedure TfrmMain.btnExitClick(Sender: TObject);
begin
  Close;
end;

end.
