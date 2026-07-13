object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Household Budget'
  ClientHeight = 600
  ClientWidth = 900
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy

  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 900
    Height = 70
    Align = alTop
    TabOrder = 0

    object lblIncome: TLabel
      Left = 20
      Top = 12
      Caption = 'Income : 0'
    end

    object lblExpense: TLabel
      Left = 20
      Top = 30
      Caption = 'Expense : 0'
    end

    object lblBalance: TLabel
      Left = 20
      Top = 48
      Caption = 'Balance : 0'
    end
  end

  object pnlButtons: TPanel
    Left = 0
    Top = 550
    Width = 900
    Height = 50
    Align = alBottom
    TabOrder = 2

    object btnAdd: TButton
      Left = 10
      Top = 10
      Width = 75
      Height = 25
      Caption = 'Add'
      OnClick = btnAddClick
    end

    object btnEdit: TButton
      Left = 95
      Top = 10
      Width = 75
      Height = 25
      Caption = 'Edit'
      OnClick = btnEditClick
    end

    object btnDelete: TButton
      Left = 180
      Top = 10
      Width = 75
      Height = 25
      Caption = 'Delete'
      OnClick = btnDeleteClick
    end

    object btnCategories: TButton
      Left = 265
      Top = 10
      Width = 90
      Height = 25
      Caption = 'Categories'
      OnClick = btnCategoriesClick
    end

    object btnBudget: TButton
      Left = 365
      Top = 10
      Width = 75
      Height = 25
      Caption = 'Budget'
      OnClick = btnBudgetClick
    end

    object btnExit: TButton
      Left = 800
      Top = 10
      Width = 75
      Height = 25
      Caption = 'Exit'
      OnClick = btnExitClick
    end

  end

  object DBGrid1: TDBGrid
    Left = 0
    Top = 70
    Width = 900
    Height = 480
    Align = alClient
    DataSource = dsTransactions
    TabOrder = 1
  end

  object dsTransactions: TDataSource
    Left = 720
    Top = 16
  end

end
