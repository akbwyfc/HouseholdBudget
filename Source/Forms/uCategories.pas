unit uCategories;

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
  Vcl.DBGrids,
  Vcl.ExtCtrls,

  Data.DB,
  FireDAC.Comp.Client,

  uRepository;

type
  TfrmCategories = class(TForm)
    DBGrid1: TDBGrid;
    dsCategories: TDataSource;
    qryCategories: TFDQuery;

    pnlBottom: TPanel;

    btnAdd: TButton;
    btnEdit: TButton;
    btnDelete: TButton;
    btnClose: TButton;

    procedure FormShow(Sender: TObject);

    procedure btnAddClick(Sender: TObject);
    procedure btnEditClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);

  private

    FRepository: TRepository;

    procedure RefreshData;

  public

    property Repository: TRepository
      read FRepository
      write FRepository;

  end;

var
  frmCategories: TfrmCategories;

implementation

{$R *.dfm}

procedure TfrmCategories.FormShow(Sender: TObject);
begin

  if FRepository = nil then
    raise Exception.Create('Repository has not been assigned.');

  qryCategories.Connection := FRepository.Database.Connection;
  dsCategories.DataSet := qryCategories;

  RefreshData;

end;

procedure TfrmCategories.RefreshData;
begin
  FRepository.GetCategories(qryCategories);
end;

procedure TfrmCategories.btnAddClick(Sender: TObject);
var
  S : string;
begin

  S := '';

  if InputQuery(
      'New Category',
      'Category Name:',
      S) then
  begin

    S := Trim(S);

    if S <> '' then
    begin
      FRepository.AddCategory(S);
      RefreshData;
    end;

  end;

end;

procedure TfrmCategories.btnEditClick(Sender: TObject);
var
  S : string;
  ID : Integer;
begin

  if qryCategories.IsEmpty then
    Exit;

  ID := qryCategories.FieldByName('ID').AsInteger;
  S  := qryCategories.FieldByName('Name').AsString;

  if InputQuery(
      'Edit Category',
      'Category Name:',
      S) then
  begin

    S := Trim(S);

    if S <> '' then
    begin
      FRepository.UpdateCategory(ID,S);
      RefreshData;
    end;

  end;

end;

procedure TfrmCategories.btnDeleteClick(Sender: TObject);
var
  ID : Integer;
begin

  if qryCategories.IsEmpty then
    Exit;

  if MessageDlg(
       'Delete this category?',
       mtConfirmation,
       [mbYes,mbNo],
       0) <> mrYes then
    Exit;

  ID := qryCategories.FieldByName('ID').AsInteger;

  FRepository.DeleteCategory(ID);

  RefreshData;

end;

procedure TfrmCategories.btnCloseClick(Sender: TObject);
begin
  Close;
end;

end.
