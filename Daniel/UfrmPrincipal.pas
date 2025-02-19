unit UfrmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, UCaixa,
  Vcl.Imaging.jpeg;

type
  NOpcoes = (OPAbrir, OPSuplemento, OPSangria, OPSaldoAtual, OPFechar);

  TfrmCaixa = class(TForm)
    lblResultado: TLabel;
    Label1: TLabel;
    EdtValor: TEdit;
    RGOpcoes: TRadioGroup;
    btnExecutar: TButton;
    btnExibir: TButton;
    btnSair: TButton;
    mmOperacoes: TMemo;
    imgCaixa: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnExecutarClick(Sender: TObject);
    procedure btnExibirClick(Sender: TObject);
    procedure RGOpcoesClick(Sender: TObject);
    procedure btnSairClick(Sender: TObject);
  private
    fCaixa: TCaixa;

    procedure UltimaOp(operacao: string; resultado: string = '');
    procedure LimpaMemo;
    procedure Executar;
    function RetornaValor: double;
    procedure AbreCaixa;
    procedure Suplemento;
    procedure Sangria;
    procedure SaldoAtual;
    procedure FechaCaixa;
    procedure ExibeOp;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCaixa: TfrmCaixa;

implementation

{$R *.dfm}

procedure TfrmCaixa.AbreCaixa;
var
  xValorInicial: double;
begin
  edtValor.Enabled := true;
  if not Assigned(fCaixa) then
    fCaixa := TCaixa.Create;

  fCaixa.AbreCaixa(RetornaValor);
  UltimaOP('Caixa aberto. Saldo inicial: ', formatFloat('R$ 0.00',fCaixa.SaldoInicial));
  edtValor.Enabled := true;
end;

procedure TfrmCaixa.btnExecutarClick(Sender: TObject);
begin
  Executar;
end;

procedure TfrmCaixa.btnExibirClick(Sender: TObject);
begin
  ExibeOp;
end;

procedure TfrmCaixa.btnSairClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TfrmCaixa.Executar;
begin
  case NOpcoes (rgOpcoes.itemIndex) of
  OPAbrir:
    AbreCaixa;
  OPSuplemento:
    Suplemento;
  OPSangria:
    Sangria;
  OPSaldoAtual:
    SaldoAtual;
  OPFechar:
    FechaCaixa;
  else
    raise Exception.Create('Erro. Seleciona uma op��o acima');
  end;
end;

procedure TfrmCaixa.ExibeOp;
var
  I: Integer;
begin
  if fCaixa.OPeracoes.count = 0 then
    exit;
  imgCaixa.Visible := false;
  mmOperacoes.Visible := true;
  for I := 0 to fCaixa.Operacoes.Count-1 do
  begin
    mmOperacoes.Lines.Add(fCaixa.Operacoes.Strings[i]);
  end;

end;

procedure TfrmCaixa.FechaCaixa;
begin
  fCaixa.FechaCaixa;
  edtValor.Enabled := false;
  UltimaOP('Caixa fechado. Saldo final: ', formatFloat('R$ 0.00',fCaixa.SaldoAtual));
  mmOperacoes.Lines.Add('');
end;

procedure TfrmCaixa.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FreeAndNil(fCaixa);
end;

procedure TfrmCaixa.FormCreate(Sender: TObject);
begin
  fCaixa := TCaixa.Create;
end;

procedure TfrmCaixa.LimpaMemo;
begin
  imgCaixa.Visible := true;
  mmOperacoes.Visible := false;
  mmOperacoes.Clear;
end;

function TfrmCaixa.RetornaValor: double;
var
  xValor: double;
begin
  xValor := 0;
  tryStrToFloat(edtValor.Text, xValor);
  Result := xValor;
end;

procedure TfrmCaixa.RGOpcoesClick(Sender: TObject);
begin
  case NOpcoes (rgOpcoes.itemIndex) of
  OPSaldoAtual:
    {SaldoAtual};
  OPFechar:
    {FechaCaixa};
  else
    edtValor.Enabled := true;
    //LimpaMemo;
  end;
end;

procedure TfrmCaixa.SaldoAtual;
begin
  fCaixa.ChecaCaixaFechado;
  edtValor.Enabled := false;
  UltimaOP('Saldo atual: ', formatFloat('R$ 0.00',fCaixa.SaldoAtual));
end;

procedure TfrmCaixa.Sangria;
begin
  edtValor.Enabled := true;
  fCaixa.RetiraValor(RetornaValor);
  UltimaOP('Sangria de ', formatFloat('R$ 0.00', RetornaValor));
end;

procedure TfrmCaixa.Suplemento;
begin
  edtValor.Enabled := true;
  fCaixa.AdicionaValor(RetornaValor);
  UltimaOP('Suplemento de ', formatFloat('R$ 0.00', RetornaValor));
end;

procedure TfrmCaixa.UltimaOp(operacao: string; resultado: string = '');
begin
  lblResultado.Caption := operacao + resultado;
  edtValor.Text := '';
  fCaixa.Operacoes.Add(lblResultado.Caption);
  LimpaMemo;
end;

end.
