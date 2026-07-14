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
  uRepository;
  uCategories;
  uTransaction;

type
  TfrmMain = class(TForm)

    lblIncome : TLabel;
    lblExpense : TLabel;
    lblBalance : TLabel;

    pnlTop : TPanel;
    pnlButtons : TPanel;

    DBGrid1 : TDBGrid;

    btnAdd : TButton;
    btnEdit : TButton;
    btnDelete : TButton;
    btnCategories : TButton;
    btnBudget : TButton;
    btnExit : TButton;

    dsTransactions : TDataSource;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

    procedure btnExitClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnCategoriesClick(Sender: TObject);
    procedure btnBudgetClick(Sender: TObject);

  private

    FDatabase : TDatabase;
    FRepository : TRepository;
    FQuery : TFDQuery;

    procedure RefreshDashboard;

  public

  end;

var
  frmMain : TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin

  FDatabase := TDatabase.Create;
  FDatabase.Connect;

  FRepository := TRepository.Create(FDatabase);

  FQuery := TFDQuery.Create(nil);
  FQuery.Connection := FDatabase.Connection;

  dsTransactions.DataSet := FQuery;

  RefreshDashboard;

end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin

  FQuery.Free;
  FRepository.Free;
  FDatabase.Free;

end;

procedure TfrmMain.RefreshDashboard;
begin

  FRepository.GetTransactions(FQuery);

  lblIncome.Caption :=
    Format('Income : %.2f',
      [FRepository.GetMonthlyIncome(YearOf(Date),MonthOf(Date))]);

  lblExpense.Caption :=
    Format('Expense : %.2f',
      [FRepository.GetMonthlyExpense(YearOf(Date),MonthOf(Date))]);

  lblBalance.Caption :=
    Format('Balance : %.2f',
      [FRepository.GetBalance]);

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
  if FQuery.IsEmpty then
    Exit;

  frmTransaction := TfrmTransaction.Create(Self);
  try
    frmTransaction.Repository := FRepository;
    frmTransaction.EditMode := True;
    frmTransaction.TransactionID :=
      FQuery.FieldByName('ID').AsInteger;

    if frmTransaction.ShowModal = mrOK then
      RefreshDashboard;
  finally
    frmTransaction.Free;
  end;
end;

procedure TfrmMain.btnDeleteClick(Sender: TObject);
begin
  if FQuery.IsEmpty then
    Exit;

  if MessageDlg(
       'Delete selected transaction?',
       mtConfirmation,
       [mbYes, mbNo],
       0) <> mrYes then
    Exit;

  FRepository.DeleteTransaction(
    FQuery.FieldByName('ID').AsInteger);

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
  //ShowMessage('Not implemented yet.');
  frmCategories := TfrmCategories.Create(Self);
  try
    frmCategories.Repository := FRepository;
    frmCategories.ShowModal;
  finally
    frmCategories.Free;
  end;
end;

procedure TfrmMain.btnExitClick(Sender: TObject);
begin
  Close;
end;

end.
