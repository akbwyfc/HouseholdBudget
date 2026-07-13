program HouseholdBudget;

uses
  Vcl.Forms,
  System.SysUtils,

  // Main Form
  uMain in 'Source\Main\uMain.pas' {frmMain},

  // Data Layer
  uDatabase in 'Source\Data\uDatabase.pas',
  uRepository in 'Source\Data\uRepository.pas',

  // Models
  uModels in 'Source\Models\uModels.pas',

  // Forms
  uTransactionEdit in 'Source\Forms\uTransactionEdit.pas' {frmTransactionEdit},
  uCategoryEdit in 'Source\Forms\uCategoryEdit.pas' {frmCategoryEdit},
  uBudgetEdit in 'Source\Forms\uBudgetEdit.pas' {frmBudgetEdit},

  // Utilities
  uConstants in 'Source\Utils\uConstants.pas',
  uHelpers in 'Source\Utils\uHelpers.pas';

{$R *.res}

begin
  Application.Initialize;

  Application.MainFormOnTaskbar := True;

  Application.Title := 'Household Budget';

  Application.CreateForm(TfrmMain, frmMain);

  Application.Run;
end.
