object frmCategories: TfrmCategories
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Categories'
  ClientHeight = 420
  ClientWidth = 600
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15

  object DBGrid1: TDBGrid
    Left = 0
    Top = 0
    Width = 600
    Height = 370
    Align = alClient
    DataSource = dsCategories
    ReadOnly = True
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines,
               dgRowLines, dgTabs, dgRowSelect, dgAlwaysShowSelection,
               dgConfirmDelete, dgCancelOnExit]
    TabOrder = 0
  end

  object pnlBottom: TPanel
    Left = 0
    Top = 370
    Width = 600
    Height = 50
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1

    object btnAdd: TButton
      Left = 10
      Top = 10
      Width = 80
      Height = 30
      Caption = 'Add'
      TabOrder = 0
      OnClick = btnAddClick
    end

    object btnEdit: TButton
      Left = 100
      Top = 10
      Width = 80
      Height = 30
      Caption = 'Edit'
      TabOrder = 1
      OnClick = btnEditClick
    end

    object btnDelete: TButton
      Left = 190
      Top = 10
      Width = 80
      Height = 30
      Caption = 'Delete'
      TabOrder = 2
      OnClick = btnDeleteClick
    end

    object btnClose: TButton
      Left = 510
      Top = 10
      Width = 80
      Height = 30
      Caption = 'Close'
      TabOrder = 3
      OnClick = btnCloseClick
    end
  end

  object dsCategories: TDataSource
    DataSet = qryCategories
    Left = 440
    Top = 16
  end

  object qryCategories: TFDQuery
    Left = 520
    Top = 16
  end

end
