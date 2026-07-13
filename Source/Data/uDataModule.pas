unit uDataModule;

interface

uses
  System.SysUtils,
  System.Classes,
  FireDAC.Comp.Client,
  uDatabase;

type
  TdmDatabase = class(TDataModule)
  private
    FDB: TDatabase;

  public
    Query : TFDQuery;

    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    property DB : TDatabase read FDB;
  end;

var
  dmDatabase : TdmDatabase;

implementation

{$R *.dfm}

constructor TdmDatabase.Create(AOwner: TComponent);
begin
  inherited;

  FDB := TDatabase.Create;
  FDB.Connect;

  Query := TFDQuery.Create(nil);
  Query.Connection := FDB.Connection;
end;

destructor TdmDatabase.Destroy;
begin
  Query.Free;
  FDB.Free;
  inherited;
end;

end.
