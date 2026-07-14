unit uTransaction;

interface

uses
  Winapi.Windows,
  Winapi.Messages,

  System.SysUtils,
  System.Classes,

  Vcl.Forms,
  Vcl.Controls,
  Vcl.StdCtrls,
  Vcl.ComCtrls,
  Vcl.ExtCtrls,
  Vcl.Dialogs,
  Vcl.DBCtrls,

  Data.DB,
  FireDAC.Comp.Client,

  uRepository;

type
  TfrmTransaction = class(TForm)
    lblDate: TLabel;
    lblType: TLabel;
    lblCategory: TLabel;
    lblAmount: TLabel;
    lblNote: TLabel;

    dtDate: TDateTimePicker;
    rgType: TRadioGroup;
    cbCategory: TDBLookupComboBox; //TComboBox;
    dsCategories: TDataSource;
    edtAmount: TEdit;
    memNote: TMemo;

    btnSave: TButton;
    btnCancel: TButton;

    qryCategories: TFDQuery;

    procedure FormShow(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);

  private
    FRepository: TRepository;

    FEditMode: Boolean;
    FTransactionID: Integer;
    procedure LoadTransaction;

    //procedure LoadCategories;

  public
    property Repository: TRepository
      read FRepository
      write FRepository;

    property EditMode: Boolean
      read FEditMode
      write FEditMode;

    property TransactionID: Integer
      read FTransactionID
      write FTransactionID;
  end;

var
  frmTransaction: TfrmTransaction;

implementation

{$R *.dfm}

procedure TfrmTransaction.LoadTransaction;
var
  D: TDate;
  TType: Integer;
  CatID: Integer;
  Amt: Double;
  Note: string;
begin
  FRepository.GetTransaction(
    FTransactionID,
    D,
    TType,
    CatID,
    Amt,
    Note);

  dtDate.Date := D;
  rgType.ItemIndex := TType;
  cbCategory.KeyValue := CatID;
  edtAmount.Text := FloatToStr(Amt);
  memNote.Text := Note;
end;

procedure TfrmTransaction.FormShow(Sender: TObject);
begin

  if FRepository = nil then
    raise Exception.Create('Repository has not been assigned.');

  qryCategories.Connection := FRepository.Database.Connection;

  qryCategories.Close;

  qryCategories.SQL.Text :=
    'SELECT ID, Name ' +
    'FROM Categories ' +
    'ORDER BY Name';

  qryCategories.Open;

  dsCategories.DataSet := qryCategories;

  cbCategory.ListSource := dsCategories;
  cbCategory.ListField := 'Name';
  cbCategory.KeyField := 'ID';

  dtDate.Date := Date;

  rgType.ItemIndex := 0;

  edtAmount.Clear;
  memNote.Clear;
  if FEditMode then
     LoadTransaction;
end;

procedure TfrmTransaction.LoadCategories;
begin
  cbCategory.Clear;

  qryCategories.Close;
  qryCategories.SQL.Text :=
    'SELECT ID, Name ' +
    'FROM Categories ' +
    'ORDER BY Name';

  qryCategories.Open;

  while not qryCategories.Eof do
  begin
    cbCategory.Items.AddObject(
      qryCategories.FieldByName('Name').AsString,
      TObject(NativeInt(qryCategories.FieldByName('ID').AsInteger)));

    qryCategories.Next;
  end;

  if cbCategory.Items.Count > 0 then
    cbCategory.ItemIndex := 0;
end;

procedure TfrmTransaction.btnSaveClick(Sender: TObject);
var
  CategoryID: Integer;
  Amount: Double;
begin

  if cbCategory.KeyValue = Null then
  begin
    MessageDlg('Please select a category.',
      mtWarning, [mbOK], 0);
    Exit;
  end;

  if not TryStrToFloat(edtAmount.Text, Amount) then
  begin
    MessageDlg('Please enter a valid amount.',
      mtError, [mbOK], 0);
    edtAmount.SetFocus;
    Exit;
  end;

  CategoryID := cbCategory.KeyValue;

  if not FEditMode then
  begin
    FRepository.AddTransaction(
      dtDate.Date,
      rgType.ItemIndex,
      CategoryID,
      Amount,            // <-- use the variable here
      memNote.Text);
  end
  else
  begin
    FRepository.UpdateTransaction(
      FTransactionID,
      dtDate.Date,
      rgType.ItemIndex,
      CategoryID,
      Amount,            // <-- and here
      memNote.Text);
  end;

  ModalResult := mrOK;
end;

procedure TfrmTransaction.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
