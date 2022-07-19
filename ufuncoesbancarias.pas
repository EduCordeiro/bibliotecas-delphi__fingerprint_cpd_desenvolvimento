unit ufuncoesbancarias;

interface
  uses
    Windows, SysUtils, dialogs;
    //funções BRADESCO SEM REGISTRO
    Function BRADESCO_SR_CODIGOBARRAS(sBanco,sMoeda,sVencimento,sValor,sCampoLivre : String):String;
    Function BRADESCO_SR_LINHADIGITAVEL(sBanco,sMoeda,sVencimento,sValor,sCampoLivre : String):String;
    Function BRADESCO_SR_CALCULA_MODULO10(sString:String):String;
    Function BRADESCO_SR_CALCULA_MODULO11(sString:String):String;
    Function BRADESCO_SR_CALCULA_NOSSONUMERO(sString:String):String;

    // função genérica (vale para todos os bancos)
    Function GENERICO_FATOR_DE_VENCIMENTO(sVencimento : String):Integer;

    //funções CAIXA ECONÔMICA SEM REGISTRO - SIGCB
    Function CaixaEconomicaFederal_SR_SIGCB_CODIGOBARRAS(sBanco,sMoeda,sVencimento,sValor,sCampoLivre:string):string;
    Function CaixaEconomicaFederal_SR_SIGCB_LINHADIGITAVEL(sBanco,sMoeda,sVencimento,sValor,sCampoLivre:string):string;
    Function CaixaEconomicaFederal_SR_SIGCB_MODULO10(sString:string):string;
    Function CaixaEconomicaFederal_SR_SIGCB_MODULO11(sString:string):string;
    Function CaixaEconomicaFederal_SR_SIGCB_NOSSONUMERO(sNossoNr:string):string;
    Function CaixaEconomicaFederal_SR_SIGCB_DIGITOCAMPOLIVRE(sCampoLivre:string):string;

    //funções CAIXA ECONÔMICA SEM REGISTRO - Nosso nr começado com 8
    Function CaixaEconomicaFederal_SR_CODIGOBARRAS(sBanco,sMoeda,sVencimento,sValor,sCampoLivre:string):string;
    Function CaixaEconomicaFederal_SR_LINHADIGITAVEL(sBanco,sMoeda,sVencimento,sValor,sCampoLivre:string):string;

    //funções ITAU SEM REGISTRO (NOSSO NUMERO 12 BYTES)
    Function ITAU_SR_CODIGOBARRAS(sVencimento,sValor,sCampoLivre:STRING):string;
    Function ITAU_SR_175_CODIGOBARRAS(sVencimento,sValor,sCampoLivre:STRING):string;
    Function ITAU_SR_LINHADIGITAVEL(sVencimento,sValor,sCampoLivre:STRING):string;
    Function ITAU_SR_175_LINHADIGITAVEL(sVencimento,sValor,sCampoLivre:string):string;
    Function ITAU_SR_MODULO10(sString:string):string;
    Function ITAU_SR_MODULO11(sString:string):string;
    Function ITAU_SR_NOSSONUMERO(sNossoNr:string):string;
    Function ITAU_SR_SOMADIGITOS(sNumero: String): String;

    //funções SANTANDER SEM REGISTRO (NOSSO NUMERO 12 BYTES)
    Function SANTANDER_SR_CODIGOBARRAS(sBanco,sMoeda,sVencimento,sValor,sCampoLivre:STRING):string;
    Function SANTANDER_SR_LINHADIGITAVEL(sBanco,sMoeda,sVencimento,sValor,sCampoLivre:STRING):string;
    Function SANTANDER_SR_MODULO10(sString:string):string;
    Function SANTANDER_SR_MODULO11(sString:string):string;
    Function SANTANDER_SR_NOSSONUMERO(sNossoNr:string):string;

    //funções BANCO DO BRASIL SEM REGISTRO (NOSSO NUMERO 17 BYTES (CONVENIO 7 BYTES))
    Function BRASIL_SR_CODIGOBARRAS(sBanco,sMoeda,sVencimento,sValor,sNossoNr,sModCob:STRING):string;
    Function BRASIL_SR_LINHADIGITAVEL(sBanco,sMoeda,sVencimento,sValor,sNossoNr,sModCob:STRING):string;
    Function BRASIL_SR_MODULO10(sString:string):string;
    Function BRASIL_SR_MODULO11(sString:string):string;

    Function BRASIL_SR_NOSSONUMERO(sNossoNr:string):string;

    //funções BANCO DO BRASIL SEM REGISTRO (NOSSO NUMERO 11 BYTES (CONVENIO 6 BYTES))
    Function BRASIL_SR6_CODIGOBARRAS(sBanco,sMoeda,sVencimento,sValor,sNossoNr,sModCob,sAgencia,sConta:STRING):string;
    Function BRASIL_SR6_LINHADIGITAVEL(sBanco,sMoeda,sVencimento,sValor,sNossoNr,sModCob,sAgencia,sConta:STRING):string;
    Function BRASIL_SR6_NOSSONUMERO(sNossoNr:string):string;

    //funções BANCO DO BRASIL SEM REGISTRO (NOSSO NÚMERO DE 17 POSIÇOES LIVRE DO CLIENTE)
    Function BRASIL_SR17_CODIGOBARRAS(sBanco,sMoeda,sVencimento,sValor,sConvenio,sNossoNr,sModCob:STRING):string;
    Function BRASIL_SR17_LINHADIGITAVEL(sBanco,sMoeda,sVencimento,sValor,sConvenio,sNossoNr,sModCob:STRING):string;

    //funções UNIBANCO????

    
implementation

Function BRADESCO_SR_CODIGOBARRAS(sBanco,sMoeda,sVencimento,sValor,sCampoLivre: String):String;
Var
  sDAC_CB, sLivre, sFator : String;

Begin
  sFator  := '';
  sLivre  := '';
  sDAC_CB := '';

  if Trim(sVencimento) = '' then
    sFator  :='0000'
  else
    sFator  := IntToStr(GENERICO_FATOR_DE_VENCIMENTO(sVencimento));

  //  WDAC_CB   -->  Digito Verificador [Codigo de Barras]   "MODULO 11"
  sDAC_CB := BRADESCO_SR_CALCULA_MODULO11(sBanco+sMoeda+sFator+sValor+sCampoLivre);

  Result  := PChar(sBanco   + sMoeda   + sDAC_CB   + sFator   +
                   sValor   + sCampoLivre);
End;

Function BRADESCO_SR_LINHADIGITAVEL(sBanco,sMoeda,sVencimento,sValor,sCampoLivre : String):String;
Var
  sCampo1, sCampo2, sCampo3, sCampo4, sCampo5, sLivre : String;
  sDac_c1, sDac_c2, sDac_c3, sFator,sresult : String;
Begin
  sFator  := '';
  sLivre  := '';
  sCampo1 := '';
  sCampo2 := '';
  sCampo3 := '';
  sCampo4 := '';
  sCampo5 := '';

  if Trim(sVencimento) = '' then
    sFator  :='0000'
  else
    sFator  := IntToStr(GENERICO_FATOR_DE_VENCIMENTO(sVencimento));

  {-- Campo 1 ---------------------------------------------------------------}
  sCampo1 := sBanco+sMoeda+Copy(sCampoLivre,1,5);
  sDac_c1 := BRADESCO_SR_CALCULA_MODULO10(sCampo1);
  sCampo1 := Copy(sCampo1,1,5) + '.' + Copy(sCampo1,6,5) + sDac_c1;

  {-- Campo 2 ---------------------------------------------------------------}
  sCampo2 := Copy(sCampoLivre,6,10);
  sDac_c2 := BRADESCO_SR_CALCULA_MODULO10(sCampo2);
  sCampo2 := Copy(sCampo2,1,5) + '.' + Copy(sCampo2,6,5) + sDac_c2;

  {-- Campo 3 ---------------------------------------------------------------}
  sCampo3 := Copy(sCampoLivre,16,10);
  sDac_c3 := BRADESCO_SR_CALCULA_MODULO10(sCampo3);
  sCampo3 := Copy(sCampo3,1,5) + '.' + Copy(sCampo3,6,5) + sDac_c3;

  {-- Campo 4 ---------------------------------------------------------------}
  sCampo4 := BRADESCO_SR_CALCULA_MODULO11(sBanco+sMoeda+sFator+sValor+sCampoLivre);

  {-- Campo 5 ---------------------------------------------------------------}
  sCampo5 := sFator+sValor;

  Result := Pchar(sCampo1 + ' ' + sCampo2 + ' ' + sCampo3 + ' ' + sCampo4 + ' ' + sCampo5);
End;

Function BRADESCO_SR_CALCULA_MODULO10(sString:String):String;
Var
  iRes, iSoma, iI : Integer;
  bDig : Boolean;
  sresult: String;
Begin
  bDig := True;
  isoma := 0;
  For iI := Length(sString) downto 1 do
    Begin
      If bDig = True then
        iRes := StrToInt(Copy(sString,iI,1)) * 2
      Else
        iRes := StrToInt(Copy(sString,iI,1)) * 1;

      If Length(IntToStr(iRes)) = 2 Then
        iRes := StrToInt(Copy(IntToStr(iRes),1,1)) + StrToInt(Copy(IntToStr(iRes),2,1));

        iSoma := iSoma + iRes;
        bDig := Not(bDig);
    End;

  Case (10-(iSoma mod 10)) of
    10 : sresult := IntToStr(0);
    Else
      sresult := IntToStr(10-(iSoma mod 10));
  End;

  result := pchar(sresult);
End;

Function BRADESCO_SR_CALCULA_MODULO11(sString:String):String;
Var
  iRes, iSoma, iI, iMult: Integer;
  sresult : String;
Begin
  iMult := 2;
  iSoma := 0;
  For iI := Length(sString) downto 1 do
    Begin
      iRes := StrToInt(Copy(sString,iI,1)) * iMult;
      iSoma := iSoma + iRes;
      iMult := iMult + 1;
      If iMult = 10 Then
        iMult := 2;
    End;

    Case (11-(iSoma mod 11)) of
      0,1,10,11 : sresult := IntToStr(1)
      Else
        sresult := IntToStr(11-(iSoma mod 11));
    End;

  result := Pchar(sresult);
End;

Function BRADESCO_SR_CALCULA_NOSSONUMERO(sString:String):String;
Var
  iRes, iSoma, iI, iMult: Integer;
  sresult : String;
Begin
  iMult := 2;
  iSoma := 0;
  For iI := Length(sString) downto 1 do
    Begin
      iRes := StrToInt(Copy(sString,iI,1)) * iMult;
      iSoma := iSoma + iRes;
      iMult := iMult + 1;
      If iMult = 8 Then
        iMult := 2;
      End;

      Case (iSoma mod 11) of
        0 : sresult := IntToStr(0);
        1 : sresult := 'P';
      Else
        sresult := IntToStr(11-(iSoma mod 11));
      End;

  result := Pchar(sresult);
End;

Function GENERICO_FATOR_DE_VENCIMENTO(sVencimento : String) : Integer;
Var
  iI, isomd : Integer;
  aDAno : Array[1..12] of Integer;
  aDAnobi : Array[1..12] of Integer;
Begin
  if Trim(sVencimento) = '' then
    isomd := 0
  else
  begin
    aDAno[01] := 31;
    aDAno[02] := 28;
    aDAno[03] := 31;
    aDAno[04] := 30;
    aDAno[05] := 31;
    aDAno[06] := 30;
    aDAno[07] := 31;
    aDAno[08] := 31;
    aDAno[09] := 30;
    aDAno[10] := 31;
    aDAno[11] := 30;
    aDAno[12] := 31;
    aDAnobi[01] := 31;
    aDAnobi[02] := 29;
    aDAnobi[03] := 31;
    aDAnobi[04] := 30;
    aDAnobi[05] := 31;
    aDAnobi[06] := 30;
    aDAnobi[07] := 31;
    aDAnobi[08] := 31;
    aDAnobi[09] := 30;
    aDAnobi[10] := 31;
    aDAnobi[11] := 30;
    aDAnobi[12] := 31;

    //66 dias de 07/10/1997 até 31/12/1997
    isomd := 85;

    //Soma até último dia do ano anterior
    //se o vencimento é 30/03/2006, a soma é feita até 31/12/2005
    //Depois do For i, é feito a soma dos dias do ano atual [até o vencimento]
    For ii := 1998 to StrToInt(Copy(sVencimento,7,4))-1 do
      Case iI of
        //Ano Bisexto
        2000,2004,2008,2012,2016,2020,2024 : isomd := isomd + 366
      Else
        isomd := isomd + 365;
      End;


    //Soma dos dias do ano até o mês anterior do vencimento
    For ii := 1 to StrToInt(Copy(sVencimento,4,2))-1 do
      Case StrToInt(Copy(sVencimento,7,4)) of
        //Ano Bisexto
        2000,2004,2008,2012,2016,2020 : isomd := isomd + aDanobi[ii]
      Else
        isomd := isomd + aDano[ii]
      End;

    //Soma dos dias do mes do vencimento
    isomd := isomd + StrToInt(Copy(sVencimento,1,2));
  end;
  Result := isomd;
End;

Function CaixaEconomicaFederal_SR_CODIGOBARRAS(sBanco,sMoeda,sVencimento,sValor,sCampoLivre : String):String;
Var
  sDigito,sFator : String;
Begin
  sFator  := IntToStr(GENERICO_FATOR_DE_VENCIMENTO(sVencimento));
  sDigito := CaixaEconomicaFederal_SR_SIGCB_MODULO11(sBanco+sMoeda+sFator+sValor+sCampoLivre);
  Result := sBanco+sMoeda+sDigito+sFator+sValor+sCampoLivre;
End;

Function CaixaEconomicaFederal_SR_LINHADIGITAVEL(sBanco,sMoeda,sVencimento,sValor,sCampoLivre:string):string;
Var
  sDig1, sDig2, sDig3, sDig4, sDig5, sFator : String;
Begin
  sFator  := IntToStr(GENERICO_FATOR_DE_VENCIMENTO(sVencimento));

  sDig1 := sBanco+sMoeda+ Copy(sCampoLivre,1,5);
  sDig1 := Copy(sDig1,1,5) + '.' + Copy(sDig1,6,4) +CaixaEconomicaFederal_SR_SIGCB_MODULO10(sDig1);

  sDig2 := Copy(sCampoLivre,6,10);
  sDig2 := Copy(sDig2,1,5) + '.' + Copy(sDig2,6,5) + CaixaEconomicaFederal_SR_SIGCB_MODULO10(sDig2);

  sDig3 := Copy(sCampoLivre,16,10);
  sDig3 := Copy(sDig3,1,5) + '.' + Copy(sDig3,6,5) + CaixaEconomicaFederal_SR_SIGCB_MODULO10(sDig3);

  sDig4 := CaixaEconomicaFederal_SR_SIGCB_MODULO11(sBanco+sMoeda+sFator+sValor+sCampoLivre);

  sDig5 := sFator+sValor;

  Result := sDig1 + '  ' + sDig2 + '  ' + sDig3 + '  ' + sDig4 + '  ' + sDig5;
End;

Function CaixaEconomicaFederal_SR_SIGCB_CODIGOBARRAS(sBanco,sMoeda,sVencimento,sValor,sCampoLivre : String):String;
Var
  sDigito,sFator : String;
Begin
  sFator  := IntToStr(GENERICO_FATOR_DE_VENCIMENTO(sVencimento));
  sDigito := CaixaEconomicaFederal_SR_SIGCB_MODULO11(sBanco+sMoeda+sFator+sValor+sCampoLivre);
  Result := sBanco+sMoeda+sDigito+sFator+sValor+sCampoLivre;
End;

Function CaixaEconomicaFederal_SR_SIGCB_LINHADIGITAVEL(sBanco,sMoeda,sVencimento,sValor,sCampoLivre:string):string;
Var
  sDig1, sDig2, sDig3, sDig4, sDig5, sFator : String;
Begin
  sFator  := IntToStr(GENERICO_FATOR_DE_VENCIMENTO(sVencimento));

  sDig1 := sBanco+sMoeda+ Copy(sCampoLivre,1,5);
  sDig1 := Copy(sDig1,1,5) + '.' + Copy(sDig1,6,4) +CaixaEconomicaFederal_SR_SIGCB_MODULO10(sDig1);

  sDig2 := Copy(sCampoLivre,6,10);
  sDig2 := Copy(sDig2,1,5) + '.' + Copy(sDig2,6,5) + CaixaEconomicaFederal_SR_SIGCB_MODULO10(sDig2);

  sDig3 := Copy(sCampoLivre,16,10);
  sDig3 := Copy(sDig3,1,5) + '.' + Copy(sDig3,6,5) + CaixaEconomicaFederal_SR_SIGCB_MODULO10(sDig3);

  sDig4 := CaixaEconomicaFederal_SR_SIGCB_MODULO11(sBanco+sMoeda+sFator+sValor+sCampoLivre);

  sDig5 := sFator+sValor;

  Result := sDig1 + ' ' + sDig2 + ' ' + sDig3 + ' ' + sDig4 + ' ' + sDig5;
End;

Function CaixaEconomicaFederal_SR_SIGCB_MODULO10(sString:string):string;
Var
  iRes, iSoma, iI : Integer;
  bDig : Boolean;
  sResult : String;
Begin
  bDig := True;
  isoma := 0;
  For iI := Length(sString) downto 1 do
  Begin
    If bDig = True then
      iRes := StrToInt(Copy(sString,iI,1)) * 2
    Else
      iRes := StrToInt(Copy(sString,iI,1)) * 1;

    If Length(IntToStr(iRes)) = 2 Then
      iRes := StrToInt(Copy(IntToStr(iRes),1,1)) + StrToInt(Copy(IntToStr(iRes),2,1));

    iSoma := iSoma + iRes;
    bDig := Not(bDig);
  End;

  Case (10-(iSoma mod 10)) of
    10,0 :
      sResult := IntToStr(0);
    Else
      sResult := IntToStr(10-(iSoma mod 10));
    End;

    result := pchar(sResult);
End;

Function CaixaEconomicaFederal_SR_SIGCB_NOSSONUMERO(sNossoNr:string):string;
Var
  iRes, iSoma, iI, iMult, iRest: Integer;
  sResult : String;
Begin
  iMult := 2;
  iSoma := 0;
  For iI := Length(sNossoNr) downto 1 do
  Begin
    iRes := StrToInt(Copy(sNossoNr,iI,1)) * iMult;
    iSoma := iSoma + iRes;

    iMult := iMult + 1;
    If iMult = 10 Then
      iMult := 2;
  End;

  irest:=(11-(iSoma mod 11));
  if irest > 9 then
    sResult := IntToStr(0)
  Else
    sResult := IntToStr(iRest);

  result := Pchar(sResult);
End;

Function CaixaEconomicaFederal_SR_SIGCB_MODULO11(sString:string):string;
Var
  iRes, iSoma, iI, iMult: Integer;
  sResult : String;
Begin
  iMult := 2;
  iSoma := 0;
  For iI := Length(sString) downto 1 do
  Begin
    iRes := StrToInt(Copy(sString,iI,1)) * iMult;
    iSoma := iSoma + iRes;

    iMult := iMult + 1;
    If iMult = 10 Then
      iMult := 2;
  End;

  case (11-(iSoma mod 11)) of
    0,10,1,11 :
      sResult := IntToStr(1);
    Else
      sResult := IntToStr(11-(iSoma mod 11));
     end;

  result := Pchar(sResult);
End;

Function CaixaEconomicaFederal_SR_SIGCB_DIGITOCAMPOLIVRE(sCampoLivre:string):string;
Var
  iRes, iSoma, iI, iMult: Integer;
  sResult : String;
Begin
  iMult := 2;
  iSoma := 0;
  For iI := Length(sCampoLivre) downto 1 do
  Begin
    iRes := StrToInt(Copy(sCampoLivre,iI,1)) * iMult;
    iSoma := iSoma + iRes;

    iMult := iMult + 1;
    If iMult = 10 Then
      iMult := 2;
  End;

  if (11-(iSoma mod 11)) > 9 then
    sResult := IntToStr(0)
  Else
    sResult := IntToStr(11-(iSoma mod 11));

  result := Pchar(sResult);
End;

Function ITAU_SR_MODULO10(sString:string):string;
var
  iRes, iI, iSoma : Integer;
  bDig : Boolean;
  sResult : String;
begin
  bDig  := True;
  iSoma := 0;
  For iI := Length(sString) downto 1 do
  begin
    if bDig = True then
      iRes := StrToInt(Copy(sString,iI,1)) * 2
    else
      iRes := StrToInt(Copy(sString,iI,1)) * 1;

    if Length(IntToStr(iRes)) = 2 then
      iRes := StrToInt(Copy(IntToStr(iRes),1,1)) + StrToInt(Copy(IntToStr(iRes),2,1));

    iSoma := iSoma + iRes;
    bDig := Not(bDig);
  end;

  case (10-(iSoma mod 10)) of
    10,0 : sResult := IntToStr(0);
  else
    sResult := IntToStr(10-(iSoma mod 10));
  end;
  result := pchar(sResult);
end;


Function ITAU_SR_NOSSONUMERO(sNossoNr:string):string;
var
    iDig, iI, iMult,iSoma: Integer;
    sResult : String;
begin

  iSoma := 0;
  iMult := 2;

  for iI := Length(sNossoNr) downto 1 do
  begin

    iDig := StrToInt(Copy(sNossoNr,iI,1)) * iMult;

    if iDig >= 10 then
      iSoma := iSoma + StrToInt(ITAU_SR_SOMADIGITOS(IntToStr(iDig)))
    else
      iSoma := iSoma + iDig;

    if iMult = 2 then
      iMult := 1
    else
      iMult := 2;

  end;

  iDig:=(10-(iSoma mod 10));

   case iDig of
    10,0 : Result := IntToStr(0);
  else
    Result := Pchar(IntToStr(iDig));
  end;
end;

function ITAU_SR_SOMADIGITOS(sNumero: String): String;
var
  iDigitos     : Integer;
  iContDigitos : Integer;
  iSoma        : Integer;
begin
  iSoma    := 0;
  iDigitos := Length(sNumero);

  for iContDigitos := 0 to iDigitos - 1 do
    iSoma :=  + iSoma + StrToInt(Copy(sNumero, iContDigitos + 1, 1));
  Result := IntToStr(iSoma);
end;

Function ITAU_SR_CODIGOBARRAS(sVencimento,sValor,sCampoLivre:string):string;
var
  sDigito,sFator : String;
begin
  sFator  := IntToStr(GENERICO_FATOR_DE_VENCIMENTO(sVencimento));
  sValor  := FormatFloat('0000000000',StrToInt(sValor));
  sDigito := ITAU_SR_MODULO11('3419' + sFator+sValor+sCampoLivre+ITAU_SR_MODULO10(sCampoLivre)+'0');
  Result  := '3419'+sDigito+sFator+sValor+sCampoLivre+ITAU_SR_MODULO10(sCampoLivre)+'0';
end;

Function ITAU_SR_175_CODIGOBARRAS(sVencimento,sValor,sCampoLivre:string):string;
var
  sDigito,sFator : String;
begin
  if Trim(sVencimento) = '' then
    sFator  :='0000'
  else
    sFator  := IntToStr(GENERICO_FATOR_DE_VENCIMENTO(sVencimento));

  sValor  := FormatFloat('0000000000',StrToInt(sValor));
  sDigito := ITAU_SR_MODULO11('3419' + sFator+sValor+sCampoLivre);
  Result  := '3419'+sDigito+sFator+sValor+sCampoLivre;
end;

Function ITAU_SR_LINHADIGITAVEL(sVencimento,sValor,sCampoLivre:string):string;
var
  sDig1, sDig2, sDig3, sDig4, sDig5, sFator : String;
begin
  sFator  := IntToStr(GENERICO_FATOR_DE_VENCIMENTO(sVencimento));
  sValor := FormatFloat('0000000000',StrToInt(sValor));

  sDig1 := '3419'+ Copy(sCampoLivre,1,5);
  sDig1 := Copy(sDig1,1,5) + '.' + Copy(sDig1,6,4) + ITAU_SR_MODULO10(sDig1);

  sDig2 := Copy(sCampoLivre,6,10);
  sDig2 := Copy(sDig2,1,5) + '.' + Copy(sDig2,6,5) + ITAU_SR_MODULO10(sDig2);

  sDig3 := Copy(sCampoLivre,16,8)+ITAU_SR_MODULO10(sCampoLivre)+'0';
  sDig3 := Copy(sDig3,1,5) + '.' + Copy(sDig3,6,5) + ITAU_SR_MODULO10(sDig3);

  sDig4 := ITAU_SR_MODULO11('3419' + sFator+sValor+sCampoLivre+ITAU_SR_MODULO10(sCampoLivre)+'0');

  sDig5 := sFator+sValor;

  Result := sDig1 + '  ' + sDig2 + '  ' + sDig3 + '  ' + sDig4 + '  ' + sDig5;
end;

Function ITAU_SR_175_LINHADIGITAVEL(sVencimento,sValor,sCampoLivre:string):string;
var
  sDig1, sDig2, sDig3, sDig4, sDig5, sFator : String;
begin
  if Trim(sVencimento) = '' then
    sFator  :='0000'
  else
    sFator  := IntToStr(GENERICO_FATOR_DE_VENCIMENTO(sVencimento));
    
  sValor := FormatFloat('0000000000',StrToInt(sValor));

  sDig1 := '3419'+ Copy(sCampoLivre,1,5);
  sDig1 := Copy(sDig1,1,5) + '.' + Copy(sDig1,6,4) + ITAU_SR_MODULO10(sDig1);

  sDig2 := Copy(sCampoLivre,6,10);
  sDig2 := Copy(sDig2,1,5) + '.' + Copy(sDig2,6,5) + ITAU_SR_MODULO10(sDig2);

  sDig3 := Copy(sCampoLivre,16,10);
  sDig3 := Copy(sDig3,1,5) + '.' + Copy(sDig3,6,5) + ITAU_SR_MODULO10(sDig3);

  sDig4 := ITAU_SR_MODULO11('3419' +sFator+sValor+sCampoLivre);

  sDig5 := sFator+sValor;

  Result := sDig1 + '  ' + sDig2 + '  ' + sDig3 + '  ' + sDig4 + '  ' + sDig5;
end;

Function ITAU_SR_MODULO11(sString:string):string;
var
    iRes, iSoma, iI, iMult: Integer;
    sResult : String;
begin
  iMult := 2;
  iSoma := 0;
  for iI := Length(sString) downto 1 do
  begin
    iRes := StrToInt(Copy(sString,iI,1)) * iMult;
    iSoma := iSoma + iRes;

    iMult := iMult + 1;
    If iMult = 10 Then
      iMult := 2;
  end;

  case (11-(iSoma mod 11)) of
   0,10,1,11 : sResult := IntToStr(1);
  else
    sResult := IntToStr(11-(iSoma mod 11));
  end;

  Result := Pchar(sResult);
end;


Function SANTANDER_SR_CODIGOBARRAS(sBanco,sMoeda,sVencimento,sValor,sCampoLivre:string):string;
var
  sFator, sDig : String;
begin
    sFator:= '';
    sDig:= '';

    sFator     := IntToStr(GENERICO_FATOR_DE_VENCIMENTO(sVencimento));

//  sDig   -->  Digito Verificador [Codigo de Barras]   "MODULO 11"
    sDig    := SANTANDER_SR_MODULO11(sBanco+sMoeda+sFator+sValor+sCampoLivre);

    Result := (sBanco   + sMoeda    + sDig + sFator +
               sValor   + sCampoLivre );
               
end;

Function SANTANDER_SR_LINHADIGITAVEL(sBanco,sMoeda,sVencimento,sValor,sCampoLivre:string):string;
var
    sCampo1, sCampo2, sCampo3, sCampo4, sCampo5 : String;
    sDig_c1, sDig_c2, sDig_c3,sFator , sDig : String;
begin
    sCampo1 := '';
    sCampo2 := '';
    sCampo3 := '';
    sCampo4 := '';
    sCampo5 := '';

    {-- Campo 1 ---------------------------------------------------------------}
    sCampo1 := sBanco+sMoeda+copy(sCampoLivre,1,5);
    sDig_c1 := SANTANDER_SR_MODULO10(sCampo1);
    sCampo1 := Copy(sCampo1,1,5) + '.' + Copy(sCampo1,6,5) + sDig_c1;

    {-- Campo 2 ---------------------------------------------------------------}
    sCampo2 := copy(sCampoLivre,6,10);
    sDig_c2 := SANTANDER_SR_MODULO10(sCampo2);
    sCampo2 := Copy(sCampo2,1,5) + '.' + Copy(sCampo2,6,5) + sDig_c2;

    {-- Campo 3 ---------------------------------------------------------------}
    sCampo3 := copy(sCampoLivre,16,10);
    sDig_c3 := SANTANDER_SR_MODULO10(sCampo3);
    sCampo3 := Copy(sCampo3,1,5) + '.' + Copy(sCampo3,6,5) + sDig_c3;

    {-- Campo 4 ---------------------------------------------------------------}
    sFator :='';
    sDig :='';
    sFator     := IntToStr(GENERICO_FATOR_DE_VENCIMENTO(sVencimento));

//  sDig_CB   -->  Digito Verificador [Codigo de Barras]   "MODULO 11"
    sDig    := SANTANDER_SR_MODULO11(sBanco+sMoeda+sFator+sValor+sCampoLivre);

    sCampo4 := sDig;

    {-- Campo 5 ---------------------------------------------------------------}
    sCampo5 := sFator+sValor;

    Result := (sCampo1 + ' ' + sCampo2 + ' ' + sCampo3 + ' ' + sCampo4 + ' ' + sCampo5);
end;

Function SANTANDER_SR_MODULO10(sString:string):string;
var
  iRes, iSoma, iI : Integer;
  bDig : Boolean;
  sResult:string;
begin
  bDig := True;
  iSoma := 0;
  For iI := Length(sString) downto 1 do
  begin
    if bDig = True then
      iRes := StrToInt(Copy(sString,iI,1)) * 2
    else
      iRes := StrToInt(Copy(sString,iI,1)) * 1;

    if Length(IntToStr(iRes)) = 2 Then
      iRes := StrToInt(Copy(IntToStr(iRes),1,1)) + StrToInt(Copy(IntToStr(iRes),2,1));

    iSoma := iSoma + iRes;
    bDig := Not(bDig);
  end;

  case (10-(iSoma mod 10)) of
    10 : sResult := IntToStr(0);
    else
      sResult := IntToStr(10-(iSoma mod 10));
    end;

  Result := sResult;
end;

Function SANTANDER_SR_MODULO11(sString:string):string;
var
  iRes, iSoma, iI, iMult: Integer;
  sResult : String;
Begin
  iMult := 2;
  iSoma := 0;
  for iI := Length(sString) downto 1 do
  begin
    iRes := StrToInt(Copy(sString,iI,1)) * iMult;
    iSoma := iSoma + iRes;

    iMult := iMult + 1;
    if iMult = 10 then
      iMult := 2;
    end;

    case (11-(iSoma mod 11)) of
      0,1,10,11: sResult := IntToStr(1)
      else
        sResult := IntToStr(11-(iSoma mod 11));
    end;

     Result := (sResult);
end;

Function SANTANDER_SR_NOSSONUMERO(sNossoNr:string):string;
var
  iRes, iSoma, iI, iMult: Integer;
  sResult : String;
begin
  iMult := 2;
  iSoma := 0;
  for iI := Length(sNossoNr) downto 1 do
  begin
    iRes := StrToInt(Copy(sNossoNr,iI,1)) * iMult;
    iSoma := iSoma + iRes;

    iMult := iMult + 1;
    if iMult = 10 then
      iMult := 2;
  end;

  case ((iSoma mod 11)) of
    10: sResult := IntToStr(1);
    0,1,11:  sResult := IntToStr(0)
    else
      sResult := IntToStr(11-(iSoma mod 11));
  end;

  Result := (sResult);
end;


Function BRASIL_SR_CODIGOBARRAS(sBanco,sMoeda,sVencimento,sValor,sNossoNr,sModCob:string):string;
var
  sDig_CB, sLivre, sFator : String;
begin
  sFator  := '';
  sLivre  := '';
  sDig_CB := '';

  if sVencimento ='00/00/0000' then
    sFator  := '0000'
  else
    sFator  := IntToStr(GENERICO_FATOR_DE_VENCIMENTO(sVencimento));

  sLivre  := '000000'+sNossoNr+sModCob;

// Wig_CB   -->  Digito Verificador [Codigo de Barras]   "MODULO 11"
  sDig_CB := BRASIL_SR_MODULO11(sBanco+sMoeda+sFator+sValor+sLivre);

  Result  := PChar(sBanco   + sMoeda   + sDig_CB   + sFator   + svalor +
                   sLivre);
end;


Function BRASIL_SR_LINHADIGITAVEL(sBanco,sMoeda,sVencimento,sValor,sNossoNr,sModCob:string):string;
var
    sCampo1, sCampo2, sCampo3, sCampo4, sCampo5, sLivre : String;
    sDig_c1, sDig_c2, sDig_c3, sFator : String;
Begin
  sFator  := '';
  sLivre  := '';
  sCampo1 := '';
  sCampo2 := '';
  sCampo3 := '';
  sCampo4 := '';
  sCampo5 := '';

  sLivre  := '000000'+sNossoNr+sModCob;

  if sVencimento ='00/00/0000' then
    sFator  := '0000'
  else
    sFator  := IntToStr(GENERICO_FATOR_DE_VENCIMENTO(sVencimento));

  {-- Campo 1 ---------------------------------------------------------------}
  sCampo1 := sBanco+sMoeda+Copy(sLivre,1,5);
  sDig_c1 := BRASIL_SR_MODULO10(sCampo1);
  sCampo1 := Copy(sCampo1,1,5) + '.' + Copy(sCampo1,6,5) + sDig_c1;

  {-- Campo 2 ---------------------------------------------------------------}
  sCampo2 := Copy(sLivre,6,10);
  sDig_c2 := BRASIL_SR_MODULO10(sCampo2);
  sCampo2 := Copy(sCampo2,1,5) + '.' + Copy(sCampo2,6,5) + sDig_c2;

  {-- Campo 3 ---------------------------------------------------------------}
  sCampo3 := Copy(sLivre,16,10);
  sDig_c3 := BRASIL_SR_MODULO10(sCampo3);
  sCampo3 := Copy(sCampo3,1,5) + '.' + Copy(sCampo3,6,5) + sDig_c3;

  {-- Campo 4 ---------------------------------------------------------------}
  sCampo4 := BRASIL_SR_MODULO11(sBanco+sMoeda+sFator+sValor+sLivre);

  {-- Campo 5 ---------------------------------------------------------------}
  sCampo5 := sFator+sValor;

  Result := Pchar(sCampo1 + ' ' + sCampo2 + ' ' + sCampo3 + ' ' + sCampo4 + ' ' + sCampo5);
End;

Function BRASIL_SR_MODULO10(sString:string):string;
var
  iRes, iSoma, iI : Integer;
  bDig : Boolean;
  sResult:string;
begin
  bDig := True;
  iSoma := 0;
  for iI := Length(sString) downto 1 do
  begin
    if bDig = True then
      iRes := StrToInt(Copy(sString,iI,1)) * 2
    else
      iRes := StrToInt(Copy(sString,iI,1)) * 1;

    if Length(IntToStr(iRes)) = 2 Then
      iRes := StrToInt(Copy(IntToStr(iRes),1,1)) + StrToInt(Copy(IntToStr(iRes),2,1));

    iSoma := iSoma + iRes;
    bDig := Not(bDig);
  end;

  case (10-(iSoma mod 10)) of
    10 : sResult := IntToStr(0);
    else
      sResult := IntToStr(10-(iSoma mod 10));
  end;

  Result := pchar(sResult);
end;

Function BRASIL_SR6_NOSSONUMERO(sNossoNr:string):string;
var
  iRes, iSoma, iI, iMult: Integer;
  sResult : String;
begin
  iMult := 2;
  iSoma := 0;
  for iI := Length(sNossoNr) downto 1 do
  begin
    iRes := StrToInt(Copy(sNossoNr,iI,1)) * iMult;
    iSoma := iSoma + iRes;

    iMult := iMult + 1;
    if iMult = 10 Then
      iMult := 2;
  end;

  case (iSoma mod 11) of
    0  : sResult := IntToStr(0);
    10 : sResult := 'X';
    else
      sResult := IntToStr(iSoma mod 11);
  end;

  Result := Pchar(sResult);
End;

Function BRASIL_SR_MODULO11(sString:string):string;
var
  iRes, iSoma, iI, iMult: Integer;
  sResult : String;
begin
  iMult := 2;
  iSoma := 0;
  for iI := Length(sString) downto 1 do
  begin
    iRes := StrToInt(Copy(sString,iI,1)) * iMult;
    iSoma := iSoma + iRes;

    iMult := iMult + 1;
    if iMult = 10 Then
      iMult := 2;
  end;

  case (11-(iSoma mod 11)) of
    0,1,10,11 : sResult := IntToStr(1)
    else
      sResult := IntToStr(11-(iSoma mod 11));
  end;

  Result := Pchar(sResult);
End;



Function BRASIL_SR_NOSSONUMERO(sNossoNr:string):string;
var
  iN1,iN2,iN3,iN4,iN5,iN6,iN7,iN8,iN9,iN10: integer;
  iN11,iN12,iN13,iN14,iN15,iN16,iN17, iAux :integer;
begin
  iN1 := StrToInt(Copy(sNossoNr,1,1) ) * 2;
  iN2 := StrToInt(Copy(sNossoNr,2,1) ) * 2;
  iN3 := StrToInt(Copy(sNossoNr,3,1) ) * 3;
  iN4 := StrToInt(Copy(sNossoNr,4,1) ) * 4;
  iN5 := StrToInt(Copy(sNossoNr,5,1) ) * 5;
  iN6 := StrToInt(Copy(sNossoNr,6,1) ) * 6;
  iN7 := StrToInt(Copy(sNossoNr,7,1) ) * 7;
  iN8 := StrToInt(Copy(sNossoNr,8,1) ) * 8;
  iN9 := StrToInt(Copy(sNossoNr,9,1) ) * 9;
  iN10:= StrToInt(Copy(sNossoNr,10,1)) * 2;
  iN11:= StrToInt(Copy(sNossoNr,11,1)) * 3;
  iN12:= StrToInt(Copy(sNossoNr,12,1)) * 4;
  iN13:= StrToInt(Copy(sNossoNr,13,1)) * 5;
  iN14:= StrToInt(Copy(sNossoNr,14,1)) * 6;
  iN15:= StrToInt(Copy(sNossoNr,15,1)) * 7;
  iN16:= StrToInt(Copy(sNossoNr,16,1)) * 8;
  iN17:= StrToInt(Copy(sNossoNr,17,1)) * 9;

  iAux := 0;
  iAux := (iN1 + iN2 + iN3 + iN4 + iN5 + iN6 + iN7 + iN8 + iN9 + iN10);
  iAux := (iAux + iN11 + iN12 + iN13 + iN14 + iN15 + iN16 + iN17) MOD 11;

  if iAux = 10 then
     Result:= 'X'
  else
  begin
   Result:= IntToStr(iAux);
  end;
end;

Function BRASIL_SR6_CODIGOBARRAS(sBanco,sMoeda,sVencimento,sValor,sNossoNr,sModCob,sAgencia,sConta:string):string;
var
  sDig_CB, sLivre, sFator : String;
begin
  sFator  := '';
  sLivre  := '';
  sDig_CB := '';

  sFator  := IntToStr(GENERICO_FATOR_DE_VENCIMENTO(sVencimento));
  sLivre  := sNossoNr+sAgencia+sConta+sModCob;

// Wig_CB   -->  Digito Verificador [Codigo de Barras]   "MODULO 11"
  sDig_CB := BRASIL_SR_MODULO11(sBanco+sMoeda+sFator+sValor+sLivre);

  Result  := PChar(sBanco   + sMoeda   + sDig_CB   + sFator   + svalor +
                   sLivre);
end;


Function BRASIL_SR6_LINHADIGITAVEL(sBanco,sMoeda,sVencimento,sValor,sNossoNr,sModCob,sAgencia,sConta:string):string;
var
    sCampo1, sCampo2, sCampo3, sCampo4, sCampo5, sLivre : String;
    sDig_c1, sDig_c2, sDig_c3, sFator : String;
Begin
  sFator  := '';
  sLivre  := '';
  sCampo1 := '';
  sCampo2 := '';
  sCampo3 := '';
  sCampo4 := '';
  sCampo5 := '';

  sLivre  := sNossoNr+sAgencia+sConta+sModCob;
  sFator  := IntToStr(GENERICO_FATOR_DE_VENCIMENTO(sVencimento));

  {-- Campo 1 ---------------------------------------------------------------}
  sCampo1 := sBanco+sMoeda+Copy(sLivre,1,5);
  sDig_c1 := BRASIL_SR_MODULO10(sCampo1);
  sCampo1 := Copy(sCampo1,1,5) + '.' + Copy(sCampo1,6,5) + sDig_c1;

  {-- Campo 2 ---------------------------------------------------------------}
  sCampo2 := Copy(sLivre,6,10);
  sDig_c2 := BRASIL_SR_MODULO10(sCampo2);
  sCampo2 := Copy(sCampo2,1,5) + '.' + Copy(sCampo2,6,5) + sDig_c2;

  {-- Campo 3 ---------------------------------------------------------------}
  sCampo3 := Copy(sLivre,16,10);
  sDig_c3 := BRASIL_SR_MODULO10(sCampo3);
  sCampo3 := Copy(sCampo3,1,5) + '.' + Copy(sCampo3,6,5) + sDig_c3;

  {-- Campo 4 ---------------------------------------------------------------}
  sCampo4 := BRASIL_SR_MODULO11(sBanco+sMoeda+sFator+sValor+sLivre);

  {-- Campo 5 ---------------------------------------------------------------}
  sCampo5 := sFator+sValor;

  Result := Pchar(sCampo1 + ' ' + sCampo2 + ' ' + sCampo3 + ' ' + sCampo4 + ' ' + sCampo5);
End;

Function BRASIL_SR17_CODIGOBARRAS(sBanco,sMoeda,sVencimento,sValor,sConvenio,sNossoNr,sModCob:string):string;
var
  sDig_CB, sLivre, sFator : String;
begin
  sFator  := '';
  sLivre  := '';
  sDig_CB := '';

  sFator  := IntToStr(GENERICO_FATOR_DE_VENCIMENTO(sVencimento));
  sLivre  := sConvenio+sNossoNr+sModCob;

// Wig_CB   -->  Digito Verificador [Codigo de Barras]   "MODULO 11"
  sDig_CB := BRASIL_SR_MODULO11(sBanco+sMoeda+sFator+sValor+sLivre);

  Result  := PChar(sBanco   + sMoeda   + sDig_CB   + sFator   + svalor +
                   sLivre);
end;

Function BRASIL_SR17_LINHADIGITAVEL(sBanco,sMoeda,sVencimento,sValor,sConvenio,sNossoNr,sModCob:string):string;
var
    sCampo1, sCampo2, sCampo3, sCampo4, sCampo5, sLivre : String;
    sDig_c1, sDig_c2, sDig_c3, sFator : String;
Begin
  sFator  := '';
  sLivre  := '';
  sCampo1 := '';
  sCampo2 := '';
  sCampo3 := '';
  sCampo4 := '';
  sCampo5 := '';

  sLivre  := sConvenio+sNossoNr+sModCob;
  sFator  := IntToStr(GENERICO_FATOR_DE_VENCIMENTO(sVencimento));

  {-- Campo 1 ---------------------------------------------------------------}
  sCampo1 := sBanco+sMoeda+Copy(sLivre,1,5);
  sDig_c1 := BRASIL_SR_MODULO10(sCampo1);
  sCampo1 := Copy(sCampo1,1,5) + '.' + Copy(sCampo1,6,5) + sDig_c1;

  {-- Campo 2 ---------------------------------------------------------------}
  sCampo2 := Copy(sLivre,6,10);
  sDig_c2 := BRASIL_SR_MODULO10(sCampo2);
  sCampo2 := Copy(sCampo2,1,5) + '.' + Copy(sCampo2,6,5) + sDig_c2;

  {-- Campo 3 ---------------------------------------------------------------}
  sCampo3 := Copy(sLivre,16,10);
  sDig_c3 := BRASIL_SR_MODULO10(sCampo3);
  sCampo3 := Copy(sCampo3,1,5) + '.' + Copy(sCampo3,6,5) + sDig_c3;

  {-- Campo 4 ---------------------------------------------------------------}
  sCampo4 := BRASIL_SR_MODULO11(sBanco+sMoeda+sFator+sValor+sLivre);

  {-- Campo 5 ---------------------------------------------------------------}
  sCampo5 := sFator+sValor;

  Result := Pchar(sCampo1 + ' ' + sCampo2 + ' ' + sCampo3 + ' ' + sCampo4 + ' ' + sCampo5);
End;

end.
