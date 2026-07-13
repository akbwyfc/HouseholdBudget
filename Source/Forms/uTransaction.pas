unit uTransaction;

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
  Vcl.ComCtrls,

  FireDAC.Comp.Client,

  uDatabase,
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

    cbCategory: TComboBox;

    edtAmount: TEdit;

    memNote: TMemo;

    btnSave: TButton;
    btnCancel: TButton;

    qryCategories: TFDQuery;

    procedure FormCreate(Sender: TObject);

    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);

  private

   // FDatabase : TDatabase;
    FRepository : TRepository;

    FEditMode : Boolean;
    FTransactionID : Integer;

    procedure LoadCategories;

  public

    property EditMode : Boolean
      read FRepository //FEditMode
      write FRepository; //FEditMode;

    property TransactionID : Integer
      read FTransactionID
      write FTransactionID;

  end;

var
  frmTransaction : TfrmTransaction;

implementation

{$R *.dfm}

procedure TfrmTransaction.FormCreate(Sender: TObject);
begin

  FDatabase := TDatabase.Create;
  FDatabase.Connect;

  FRepository := TRepository.Create(FDatabase);

  qryCategories.Connection := FDatabase.Connection;

  dtDate.Date := Date;

  rgType.Items.Clear;
  rgType.Items.Add('Expense');
  rgType.Items.Add('Income');
  rgType.ItemIndex := 0;

  LoadCategories;

  FEditMode := False;
  FTransactionID := 0;

end;

procedure TfrmTransaction.LoadCategories;
begin

  qryCategories.Close;

  qryCategories.SQL.Text :=
    'SELECT ID, Name ' +
    'FROM Categories ' +
    'ORDER BY Name';

  qryCategories.Open;

  cbCategory.Items.Clear;

  while not qryCategories.Eof do
  begin

    cbCategory.Items.AddObject(
      qryCategories.FieldByName('Name').AsString,
      TObject(qryCategories.FieldByName('ID').AsInteger));

    qryCategories.Next;

  end;

  if cbCategory.Items.Count > 0 then
    cbCategory.ItemIndex := 0;

end;

procedure TfrmTransaction.btnSaveClick(Sender: TObject);
var
  CategoryID : Integer;
begin

  if cbCategory.ItemIndex < 0 then
  begin
    MessageDlg(
      'Please select a category.',
      mtWarning,
      [mbOK],
      0);
    Exit;
  end;

  if Trim(edtAmount.Text) = '' then
  begin
    MessageDlg(
      'Please enter an amount.',
      mtWarning,
      [mbOK],
      0);
    Exit;
  end;

  CategoryID :=
    Integer(cbCategory.Items.Objects[
      cbCategory.ItemIndex]);

  if not FEditMode then
  begin

    FRepository.AddTransaction(
      dtDate.Date,
      rgType.ItemIndex,
      CategoryID,
      StrToFloat(edtAmount.Text),
      memNote.Text);

  end
  else
  begin

    FRepository.UpdateTransaction(
      FTransactionID,
      dtDate.Date,
      rgType.ItemIndex,
      CategoryID,
      StrToFloat(edtAmount.Text),
      memNote.Text);

  end;

  ModalResult := mrOK;

end;

procedure TfrmTransaction.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

end.
