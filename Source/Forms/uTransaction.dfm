object frmTransaction: TfrmTransaction
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Transaction'
  ClientHeight = 360
  ClientWidth = 420
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15

  object lblDate: TLabel
    Left = 20
    Top = 20
    Width = 60
    Height = 15
    Caption = 'Date'
  end

  object dtDate: TDateTimePicker
    Left = 120
    Top = 16
    Width = 200
    Height = 24
    Date = 46000.000000000000000000
    Time = 0.000000000000000000
    TabOrder = 0
  end

  object lblType: TLabel
    Left = 20
    Top = 60
    Width = 60
    Height = 15
    Caption = 'Type'
  end

  object rgType: TRadioGroup
    Left = 120
    Top = 52
    Width = 200
    Height = 55
    Caption = 'Transaction Type'
    Columns = 2
    Items.Strings = (
      'Expense'
      'Income')
    TabOrder = 1
  end

  object lblCategory: TLabel
    Left = 20
    Top = 125
    Width = 60
    Height = 15
    Caption = 'Category'
  end

  object cbCategory: TDBLookupComboBox //TComboBox
    Left = 120
    Top = 120
    Width = 200
    Height = 23
    Style = csDropDownList
    TabOrder = 2
  end
  object dsCategories: TDataSource
    Left = 360
    Top = 56
  end

  object lblAmount: TLabel
    Left = 20
    Top = 160
    Width = 60
    Height = 15
    Caption = 'Amount'
  end

  object edtAmount: TEdit
    Left = 120
    Top = 156
    Width = 120
    Height = 23
    TabOrder = 3
  end

  object lblNote: TLabel
    Left = 20
    Top = 195
    Width = 60
    Height = 15
    Caption = 'Note'
  end

  object memNote: TMemo
    Left = 120
    Top = 192
    Width = 250
    Height = 90
    ScrollBars = ssVertical
    TabOrder = 4
  end

  object btnSave: TButton
    Left = 120
    Top = 310
    Width = 90
    Height = 30
    Caption = 'Save'
    Default = True
    ModalResult = 0
    OnClick = btnSaveClick
    TabOrder = 5
  end

  object btnCancel: TButton
    Left = 230
    Top = 310
    Width = 90
    Height = 30
    Caption = 'Cancel'
    Cancel = True
    ModalResult = 2
    OnClick = btnCancelClick
    TabOrder = 6
  end

  object qryCategories: TFDQuery
    Left = 360
    Top = 16
  end

end
