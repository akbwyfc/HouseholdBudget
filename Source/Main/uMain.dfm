object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Household Budget'
  ClientHeight = 600
  ClientWidth = 900
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 15

  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 900
    Height = 70
    Align = alTop
    TabOrder = 0

    object lblIncomeTitle: TLabel
      Left = 20
      Top = 10
      Width = 42
      Height = 15
      Caption = 'Income'
    end

    object lblIncome: TLabel
      Left = 20
      Top = 35
      Width = 80
      Height = 15
      Caption = '0.00'
      Font.Style = [fsBold]
      ParentFont = False
    end

    object lblExpenseTitle: TLabel
      Left = 250
      Top = 10
      Width = 49
      Height = 15
      Caption = 'Expense'
    end

    object lblExpense: TLabel
      Left = 250
      Top = 35
      Width = 80
      Height = 15
      Caption = '0.00'
      Font.Style = [fsBold]
      ParentFont = False
    end

    object lblBalanceTitle: TLabel
      Left = 500
      Top = 10
      Width = 45
      Height = 15
      Caption = 'Balance'
    end

    object lblBalance: TLabel
      Left = 500
      Top = 35
      Width = 80
      Height = 15
      Caption = '0.00'
      Font.Style = [fsBold]
      ParentFont = False
    end

  end

  object DBGrid1: TDBGrid
    Left = 0
    Top = 70
    Width = 900
    Height = 470
    Align = alClient
    DataSource = dsTransactions
    ReadOnly = True
    Options = [dgTitles, dgIndicator, dgColumnResize,
               dgColLines, dgRowLines, dgTabs,
               dgRowSelect, dgAlwaysShowSelection]
    TabOrder = 1
  end

  object pnlBottom: TPanel
    Left = 0
    Top = 540
    Width = 900
    Height = 60
    Align = alBottom
    TabOrder = 2

    object btnAdd: TButton
      Left = 10
      Top = 15
      Width = 90
      Height = 30
      Caption = 'Add'
      TabOrder = 0
      OnClick = btnAddClick
    end

    object btnEdit: TButton
      Left = 110
      Top = 15
      Width = 90
      Height = 30
      Caption = 'Edit'
      TabOrder = 1
      OnClick = btnEditClick
    end

    object btnDelete: TButton
      Left = 210
      Top = 15
      Width = 90
      Height = 30
      Caption = 'Delete'
      TabOrder = 2
      OnClick = btnDeleteClick
    end

    object btnCategories: TButton
      Left = 330
      Top = 15
      Width = 100
      Height = 30
      Caption = 'Categories'
      TabOrder = 3
      OnClick = btnCategoriesClick
    end

    object btnBudget: TButton
      Left = 450
      Top = 15
      Width = 90
      Height = 30
      Caption = 'Budget'
      TabOrder = 4
      OnClick = btnBudgetClick
    end

    object btnReports: TButton
      Left = 550
      Top = 15
      Width = 90
      Height = 30
      Caption = 'Reports'
      TabOrder = 5
      OnClick = btnReportsClick
    end

    object btnExit: TButton
      Left = 790
      Top = 15
      Width = 90
      Height = 30
      Caption = 'Exit'
      TabOrder = 6
      OnClick = btnExitClick
    end

  end

  object dsTransactions: TDataSource
    DataSet = qryTransactions
    Left = 760
    Top = 88
  end

  object qryTransactions: TFDQuery
    Left = 840
    Top = 88
  end

end
