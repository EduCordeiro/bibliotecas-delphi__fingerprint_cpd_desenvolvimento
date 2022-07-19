unit ufuncoes;

interface

uses
  Classes, SysUtils, Forms, Controls,
  Graphics, Dialogs, StdCtrls, Grids, CheckLst, StrUtils,
  Math, (*superobject,*)
  {$IFDEF MSWINDOWS}ShellAPI, Windows, regexpr, WinSock,{$ENDIF}
  udatatypes_apps, ClassTextFile, ClassDirectory;


  {Seção COMPONENTES VISUAIS}
  function  AtivarEditSeCheckboxMarcado(checkBox: TCheckBox; edit: TEdit): boolean;

  procedure PopularCheckListBox(checklistbox: TCheckListBox;
   var  aResultSet: aDynamicStringArray);

  procedure SelecionarTodosCheckListBox(checklistbox: TCheckListBox;
   selecionarTodos: boolean);

  {Seção MANIPULAÇÃO DE STRINGS}
  function GetTermoFromString(numeroDoTermo: integer; separador, linha: string; turbo: boolean=False): string;

  function GetTermoFromString_FAST(numero_termo: Byte; separador: char;
   texto: string; compat:boolean=True): string;

  function TrimLeftRight(str: string): string;

  function GetNumeroOcorrenciasCaracter(str: string; caracter: char): integer;

  function StrToPChar(const Str: string): PChar;

  function  GetTotalOcorrenciasSubstringEmString(strString: string;
   strSubstring: string): integer;

  procedure PopularStringListFromString(var sl: TStringList; str: string;
   delimitador: string);

  procedure PrepararStringParaInsercaoEmBanco(var str: string);

  function StringToFile(sString: string; sFile: string;
   apagarArquivoSeExiste: boolean=false): RActionReturn;

  procedure InserirConteudoArrayStringOrigemEmArrayStringDestino(
   var origem: aStringArray; var destino: aStringArray);

  {Ajusta a String dentro do espaço informado colunando-a}
  function AjustaStr(str: String; tam: Integer): String;

  {Ajusta a String dentro do espaço informado colunando-a}
  function AjustaStrEsquerda(str: String; tam: Integer): String;

  function MemoryStreamToString(var memory_stream: TMemoryStream): string;
  
  procedure StringToMemoryStream(str: string; var memory_stream: TMemoryStream);

  procedure GetListaCaracteresDaClasseASCII(classe: EClassesCaracteresASCII;
   var slLista: TStringList);

  procedure InserirRegistrosStringListOrigemDentroDeStringListDestino(
   var slOrigem: TStringList; var slDestino: TStringList;
   posicaoInsercaoDestino: integer);

  function GetStringListSize(sl: TStringList): RFile;
  

  {Seção SISTEMA OPERACIONAL}
  {$IFDEF MSWINDOWS}
  function GetArquivos(Mascara, Path: string): RInfoArquivo;

  function GetTamanhoArquivo(const FileName: String): double;

  function GetDataModificacaoArquivo(const FileName: String): string;

  function GetTamanhoArquivo_WinAPI(FileName : String): int64;

  function GetTamanhoMaiorUnidade(Bytes: int64): RFile;

  function GetItemArquivoOuDiretorio(fullpath: string): string;

  function GetVersaoDaAplicacao: string;

  function SearchStringForRegularExpression(strString:string; strRegex: string;  var slMatches: TStringList): string;

  procedure  DelTree(Diretorio: string);

  procedure ExecutarArquivoComProgramaDefault(Arquivo: String);

  function ExecutarPrograma(cmd: string; esconderJanela: boolean=false;
   passarControleparaAplicacao: boolean=false): boolean;

  function GetIP(): string;

  {$ENDIF}


  {Seção DIVERSAS}
  procedure Logar(Mensagem: string; tipo_log: ETipoLog=Normal);

  procedure ValidationErrorsList_Add(var ValidationErrorsList: RValidationErrorsList;
   error_id: string; error_message: string);

  procedure ValidationErrorsList_Clear(var ValidationErrorsList: RValidationErrorsList);

  function Arredondar(Valor: Double; Dec: Integer; ParaCima: boolean=false): Double;

  function  FloatToInt_ArredondarParaMaiorInteiro(valor: double): integer;

  function  TruncFloat(valor: double; QuantidadeCasasDecimais: integer): double;

  procedure ObterListaDeArquivosDeUmDiretorio(Path: string; var ListagemDeArquivos : TStringList; extensao: string='*.*');

  function AjustarPath(path: string; sistema: ESistemaOperacional=soWindows): string;

  function CarregarArquivoINI(var propriedades: RIni): Boolean;

  function CarregarArquivoDeConexoes(PathArquivoConexoes: String; var propriedades: RListaDeBases): integer;

  procedure AboutApplication(autores: String);


  {Seção MANIPULAÇÃO DE ARQUIVOS}
  function GravarLinhaEmArquivo(nomeArquivo: string; linha: string;
   apagarArquivoSeExiste: boolean=False; ForcarQuebraDeLinha: boolean=true): RActionReturn;

  function FileToString(nomeArquivo: string): string;

  procedure LoadStringListFromFile_SafeWay(var sl: TStringList; filename: string);

  procedure GetListaDeArquivosContendoRegex(path : String;
   var listaArquivos : TStringList; regex : String; incluirPathNoNome: boolean=false);

  procedure GetArquivosEmDiretorioRecursivamente(regex_nome_arquivos: string;
   diretorio_raiz: string; var listaArquivos : TStringList);

  function GetSubdiretorios(Directory: String; IsRecursive: Boolean; incluirArquivosOcultos:boolean=true): TStringList;

  function GetArquivoPossuiCaracterNuloAntesDoEOF(nomeArquivo: string): boolean;

  procedure SubstituirCaracterNuloAntesdoEOF(nomeArquivo: string; substituirPelaString: string);

  {Seção "DATAS"}
  function GetTrimestreFromData(data: string): string;

  function GetDataPertenceATrimestre(data: string; trimestre: string): boolean;
  
  procedure GetDatasQuePertecemAoTrimestre(var datas_entrada: TStringList;
    trimestre: string; var datas_pertencentes: TStringList);

implementation

uses faster_search_algorithms, ClassRegularExpression;




function AtivarEditSeCheckboxMarcado(checkBox: TCheckBox; edit: TEdit): boolean;
begin
  (*

  CRIADA POR: Tiago Paranhos Lima
  
  *)

  edit.Visible := checkBox.Checked;

  if not checkBox.Checked then
    edit.Clear;

  result := checkBox.Checked;
end;

procedure PopularCheckListBox(checklistbox: TCheckListBox;
  var aResultSet: aDynamicStringArray);
var
  i: integer;
  iTotalRegistros: integer;
  sDescricao: string;
begin
  (*

  CRIADA POR: Tiago Paranhos Lima

  *)

  checklistbox.Items.Clear;

  iTotalRegistros := Length(aResultSet);

  try

    for i:=0 to iTotalRegistros-1 do
    begin
      sDescricao := aResultSet[i][0];
      checklistbox.Items.Add(sDescricao);
    end;

  except

  end;

end;

procedure SelecionarTodosCheckListBox(checklistbox: TCheckListBox;
  selecionarTodos: boolean);
var
  i: integer;
begin
  (*

  CRIADA POR: Tiago Paranhos Lima
  
  *)


  for i:=0 to checklistbox.Items.Count-1 do
    checklistbox.Checked[i] := selecionarTodos;
end;

//*******************************
{$IFDEF MSWINDOWS}
function GetArquivos(Mascara, Path: string): RInfoArquivo;
var
  SearchRec : TSearchRec;
  intControl : integer;
  InfoArquivo: RInfoArquivo;
  dTamanhoArquivo: double;
begin
  (*

  CRIADA POR: Tiago Paranhos Lima
  
  *)

  Path := Path + '\';

  if DirectoryExists(Path) then
  begin
    intControl := FindFirst( Path+Mascara, faAnyFile, SearchRec );
    if intControl = 0 then
    begin
      while (intControl = 0) do
      begin
        if (SearchRec.Name<>'.') and (SearchRec.Name<>'..') then
        begin
          SetLength(InfoArquivo.Nome,length(InfoArquivo.Nome)+1);
          SetLength(InfoArquivo.Tamanho,length(InfoArquivo.Tamanho)+1);
          SetLength(InfoArquivo.Path,length(InfoArquivo.Path)+1);

          //tamanho em KB
          dTamanhoArquivo := GetTamanhoArquivo(Path+SearchRec.Name);

          InfoArquivo.Nome[length(InfoArquivo.Nome)-1] := SearchRec.Name;
          InfoArquivo.Path[length(InfoArquivo.Path)-1] := Path;
          InfoArquivo.Tamanho[length(InfoArquivo.Tamanho)-1] := dTamanhoArquivo;
        end;
        intControl := FindNext( SearchRec );
      end;
      //FindClose(SearchRec);
    end;
  end;

  result := InfoArquivo;
end;

function GetTamanhoArquivo(const FileName: String): double;
var
  SearchRec : TSearchRec;
begin { !Win32! -> GetFileSize }

  (*

  CRIADA POR: Tiago Paranhos Lima

  OBJETIVO:
    - Retorna o tamanho de um arquivo em KB (/1024)

  *)

  if FindFirst(FileName,faAnyFile,SearchRec)=0 then
    Result:=round(SearchRec.Size/1024)
  else
    Result:=0;
  //FindClose(SearchRec);
end;

function GetDataModificacaoArquivo(const FileName: String): string;
begin
  (*

  CRIADA POR: Tiago Paranhos Lima

  *)

  result := DateTimeToStr(FileDateToDateTime(FileAge(FileName)));
end;

function GetTamanhoArquivo_WinAPI(FileName : String): int64;
var
  SearchRec : TSearchRec;
begin
  (*

  CRIADA POR: Tiago Paranhos Lima

  *)

  if FindFirst(FileName, faAnyFile, SearchRec ) = 0 then
    Result := Int64(SearchRec.FindData.nFileSizeHigh) shl Int64(32)
              +Int64(SearchREc.FindData.nFileSizeLow)
  else
    Result := 0;

  //FindClose(SearchRec);
end;

function GetTamanhoMaiorUnidade(Bytes: int64): RFile;
var
  dTamanho: double;
  sBytes: string;
  iTamanho: integer;
  iPower: integer;
  sUnidade: string;
  rrFile: RFile;
  iParDiv: variant;
begin
  (*

  CRIADA POR: Tiago Paranhos Lima

  *)

  rrFile.Tamanho := 0;
  rrFile.Unidade := '';

  sBytes := inttostr(Bytes);
  iTamanho := length(sBytes);

  case iTamanho of
    4..6:
      begin
        sUnidade := 'KB';
        iPower:= 1;
      end;
    7..9:
      begin
        sUnidade := 'MB';
        iPower := 2;
      end;
    10..12:
      begin
        sUnidade := 'GB';
        iPower := 3;
      end;
    13..15:
      begin
        sUnidade := 'TB';
        iPower := 4;
      end;
  end;

  if iTamanho >= 4 then
  begin
    iParDiv  := power(1024,iPower);
    dTamanho := Bytes / iParDiv;
  end
  else
  begin
    dTamanho := Bytes;
    sUnidade := 'Bytes';
  end;

  rrFile.Tamanho := dTamanho;
  rrFile.Unidade := sUnidade;

  rrFile.Tamanho := arredondar(dTamanho,2);

  result := rrFile;
end;



function GetItemArquivoOuDiretorio(fullpath: string): string;
var
  sTipo: string;
  sFileName: string;
begin
  (*

  CRIADA POR: Tiago Paranhos Lima

  *)

  sTipo := '?';

  sFileName := ExtractFileName(fullpath);

  if (sFileName = '.') then
    sTipo := 'ponteiro_diretorio_atual'
  else
  if (sFileName = '..') then
    sTipo := 'ponteiro_diretorio_anterior'
  else
  begin
    if DirectoryExists(fullpath) then
      sTipo := 'diretorio'
    else
      sTipo := 'arquivo';
  end;

  result := sTipo;
end;


function GetVersaoDaAplicacao: string;
var
  VerInfoSize: DWORD;
  VerInfo: Pointer;
  VerValueSize: DWORD;
  VerValue: PVSFixedFileInfo;
  Dummy: DWORD;
  V1, V2, V3, V4: Word;
  sV1, sV2, sV3, sV4: string;
  Prog, sVersao : string;
begin
  (*

  CRIADA POR: Tiago Paranhos Lima

  OBS.:
    - Para que funcione corretamente é necessário que a versão da aplicação
      seja informada em Project => Options => Version Info,
      campo "Module Version Number".

  *)

   sVersao := '';

   Prog := Application.Exename;
   VerInfoSize := GetFileVersionInfoSize(PChar(prog), Dummy);
   GetMem(VerInfo, VerInfoSize);
   GetFileVersionInfo(PChar(prog), 0, VerInfoSize, VerInfo);
   VerQueryValue(VerInfo, '\', Pointer(VerValue), VerValueSize);
   with VerValue^ do
   begin
     V1 := dwFileVersionMS shr 16;
     V2 := dwFileVersionMS and $FFFF;
     V3 := dwFileVersionLS shr 16;
     V4 := dwFileVersionLS and $FFFF;
   end;
   FreeMem(VerInfo, VerInfoSize);

   {
   sV1 := Copy (IntToStr (100 + v1), 3, 2);
   sV2 := Copy (IntToStr (100 + v2), 3, 2);
   sV3 := Copy (IntToStr (100 + v3), 3, 2);
   sV4 := Copy (IntToStr (100 + v4), 3, 2);
   }
   sV1 := IntToStr(v1);
   sV2 := IntToStr(v2);
   sV3 := IntToStr(v3);
   sV4 := IntToStr(v4);

   sVersao := sV1 + '.' + sV2 + '.' + sV3 + '.' + sV4;

   Result := sVersao;
end;

function SearchStringForRegularExpression(strString:string;
 strRegex: string; var slMatches: TStringList): string;
var
  sExpressao: string;
  r : TRegExpr;
  bExecutou: boolean;
  sRetorno, sLinhaAtual: string;
begin
  (*

  CRIADA POR: Tiago Paranhos Lima
  
  *)

  sRetorno := 'SUCESSO';

  sExpressao := stringreplace(strRegex, #13#10, '',[rfReplaceAll]);

  r := TRegExpr.Create;
  try // ensure memory clean-up
    r.Expression := sExpressao;

    // Assign r.e. source code. It will be compiled when necessary
    // (for example when Exec called). If there are errors in r.e.
    // run-time execption will be raised during r.e. compilation
    try
      bExecutou := r.Exec (strString);

      if bExecutou then
      begin
        REPEAT
          sLinhaAtual := r.Match [0];
          if sLinhaAtual <> '' then
            slMatches.Add(sLinhaAtual);
        UNTIL not r.ExecNext;
      end;
    except
      on E:Exception do
        sRetorno := 'ERRO. Exceção: '+E.Message;
    end;
  finally
    r.Free;
  end;

  result := sRetorno;
end;

procedure  DelTree(Diretorio: string);
var
  sComandoDelDir: string;
begin
  {apaga um diretório, os arquivos e subdiretórios contidos nele}
  if DirectoryExists(Diretorio) then
  begin
    sComandoDelDir := 'CMD /C RMDIR /Q /S "'+Diretorio+'"';
    ExecutarPrograma(sComandoDelDir,true,true);
  end;
end;

procedure ExecutarArquivoComProgramaDefault(Arquivo: String);
Var
 Nome: Array[0..1024] of Char;
 Parms: Array[0..1024] of Char;
begin
  StrPCopy (Nome, 'Open');
  StrPCopy (Parms, Arquivo);

  ShellExecute(0, Nome, Parms, nil, nil, SW_NORMAL);
end;

function ExecutarPrograma(cmd: string; esconderJanela: boolean=false;
 passarControleparaAplicacao: boolean=false): boolean;
var
  SUInfo: TStartupInfo;
  ProcInfo: TProcessInformation;
begin
  {Com o parâmetro "passarControleparaAplicacao" ativado, o programa
   que está chamando essa função interromperá a sua execução até que
   o programa passado como parâmetro aqui seja encerrado.}

  FillChar(SUInfo, SizeOf(SUInfo), #0);
  SUInfo.cb      := SizeOf(SUInfo);
  SUInfo.dwFlags := STARTF_USESHOWWINDOW;


  if esconderJanela then
    SUInfo.wShowWindow := SW_HIDE
  else
    SUInfo.wShowWindow := SW_NORMAL;

  Result := CreateProcess(nil,
                          PChar(cmd),
                          nil,
                          nil,
                          false,
                          CREATE_NEW_CONSOLE or
                          NORMAL_PRIORITY_CLASS,
                          nil,
                          nil,
                          SUInfo,
                          ProcInfo);

  if (Result) then
  begin
    if passarControleparaAplicacao then
      WaitForSingleObject(ProcInfo.hProcess, INFINITE);

    CloseHandle(ProcInfo.hProcess);
    CloseHandle(ProcInfo.hThread);
  end;
end;

function GetIP(): string;
var
  WSAData: TWSAData;
  HostEnt: PHostEnt;
  Name:string;
begin
  WSAStartup(2, WSAData);
  SetLength(Name, 255);
  Gethostname(PChar(Name), 255);
  SetLength(Name, StrLen(PChar(Name)));
  HostEnt := gethostbyname(PChar(Name));

  with HostEnt^ do
  begin
    Result := Format('%d.%d.%d.%d',
    [Byte(h_addr^[0]),Byte(h_addr^[1]),
    Byte(h_addr^[2]),Byte(h_addr^[3])]);
  end;

  WSACleanup;
end;


{$ENDIF}

//**********************************

function GetTermoFromString(numeroDoTermo: integer; separador, linha: string; turbo: boolean=False): string;
var
  slAux: TStringList;
  sRetorno: string;
begin
  (*

  CRIADA POR: Tiago Paranhos Lima

  *)

  sRetorno := '';

  try
    try
      slAux := TStringList.Create;
      
      if not turbo then
        slAux.Text := StringReplace(linha, separador, #13#10, [rfReplaceAll, rfIgnoreCase])
      else
        slAux.Text := StringReplaceBoyer(linha, separador, #13#10, [rfReplaceAll, rfIgnoreCase]);

      if slAux.Count >= numeroDoTermo then
        sRetorno := slAux.Strings[numeroDoTermo-1];
    except
      on E:Exception do
      begin
        Logar('uFuncoes.pas - GetTermoFromString(): Exceção - '+E.Message, Erro);
        sRetorno := '';
      end;
    end;
  finally
    if Assigned(slAux) then
    begin
      slAux.Clear;
      FreeAndNil(slAux);
    end;
  end;

  result := sRetorno;

end;

function TrimLeftRight(str: string): string;
var
  sNovaStr: string;
begin
  (*

  CRIADA POR: Tiago Paranhos Lima

  *)

  sNovaStr := TrimLeft(str);
  sNovaStr := TrimRight(sNovaStr);

  result := sNovaStr;
end;

function AjustarPath(path: string; sistema: ESistemaOperacional=soWindows): string;
var
  sSeparador: string;
begin
  (*

  CRIADA POR: Tiago Paranhos Lima

  *)

  case sistema of
    soWindows: sSeparador := '\';
    soLinux:   sSeparador := '/';
  end;

  if path[length(path)] <> sSeparador then
    path := path + sSeparador;

  result := path;
end;

function GetNumeroOcorrenciasCaracter(str: string; caracter: char): integer;
var
  sTemp: string;
  sCharAtual: string;
  i, iTamString: integer;
  iContOcorrencias: integer;
begin
  (*

  CRIADA POR: Tiago Paranhos Lima
  
  *)

  iContOcorrencias:=0;
  sTemp := str;
  iTamString := length(sTemp);

  for i:=0 to iTamString-1 do
  begin
    sCharAtual := sTemp[i];

    if sCharAtual = caracter then
      iContOcorrencias := iContOcorrencias + 1;
  end;

  result := iContOcorrencias;
end;

procedure Logar(Mensagem: string; tipo_log: ETipoLog=Normal);
var
  fileArquivoDeLog: TextFile;
  sArquivo: string;
  sVersao: string;
  sExecutavel: string;
  sDirSaida: string;
  iTamDirSaida: integer;
  sTipoLog: string;
  sLogInfo: string;
begin
  (*

  CRIADA POR: Tiago Paranhos Lima

  *)

  sDirSaida := ExtractFilePath(Application.ExeName);
  //Adiciona "\ no path, se não houver:
  if copy(sDirSaida,length(sDirSaida),1) <> '\' then
    sDirSaida := sDirSaida + '\';

  sExecutavel := ExtractFileName(Application.ExeName);

  sArquivo := sDirSaida + StringReplace(sExecutavel, '.EXE', '.LOG', [rfReplaceAll, rfIgnoreCase]);

  try

    AssignFile(fileArquivoDeLog, sArquivo);

    if FileExists(sArquivo) then
      Append(fileArquivoDeLog)
    else
      Rewrite(fileArquivoDeLog);

    sVersao := GetVersaoDaAplicacao();

    case tipo_log of
      Normal:  sTipoLog := '[NORMAL] ';
      Warning: sTipoLog := '[WARNING] ';
      Erro:    sTipoLog := '[ERRO] ';
      Debug:   sTipoLog := '[DEBUG] ';
    end;

    sLogInfo := sExecutavel + ' V. '+sVersao+' - '
               +formatdatetime('dd/mm/yyyy hh:nn:ss.zzz',now)
               + ' >>> ';

    if trim(Mensagem)<>'' then
    begin
      Writeln(fileArquivoDeLog, sLogInfo + sTipoLog + Mensagem);
    end
    else
    begin
      Writeln(fileArquivoDeLog, '');
    end;

  finally
    CloseFile(fileArquivoDeLog);
  end;

end;


procedure ValidationErrorsList_Add(var ValidationErrorsList: RValidationErrorsList;
 error_id: string; error_message: string);
begin
  (*

  CRIADA POR: Tiago Paranhos Lima
  
  *)

  SetLength(ValidationErrorsList.ids, Length(ValidationErrorsList.ids)+1);
  SetLength(ValidationErrorsList.messages, Length(ValidationErrorsList.messages)+1);

  ValidationErrorsList.ids[Length(ValidationErrorsList.ids)-1] := error_id;
  ValidationErrorsList.messages[Length(ValidationErrorsList.messages)-1] := error_message;
end;


procedure ValidationErrorsList_Clear(var ValidationErrorsList: RValidationErrorsList);
begin
  (*

  CRIADA POR: Tiago Paranhos Lima
  
  *)

  SetLength(ValidationErrorsList.ids, 0);
  SetLength(ValidationErrorsList.messages, 0);
end;

function Arredondar(Valor: Double; Dec: Integer; ParaCima: boolean=false): Double;
var
  Valor1, Numero1, Numero2, Numero3: Double;
  bJahArredondou: boolean;
begin
  (*

  CRIADA POR: Tiago Paranhos Lima

  *)

  Valor1:=Exp(Ln(10) * (Dec + 1));
  Numero1:=Int(Valor * Valor1);
  Numero2:=(Numero1 / 10);

  Numero3:=Round(Numero2);

  if Numero3 <= trunc(Valor) then
  begin
    //Arredondamento opcional para cima quando não tiver casas decimais após a vírgula
    if (Dec=0) and (ParaCima) then
      Numero3 := Numero3 + 1;
  end;

  Result:=(Numero3 / (Exp(Ln(10) * Dec)));
end;

function  FloatToInt_ArredondarParaMaiorInteiro(valor: double): integer;
var
  dNumero: double;
  sNumero: string;
  sParteInteira, sParteDecimal: string;
  iParteInteira, iParteDecimal: integer;
  sSeparadorDecimais: string;
begin
  (*

  CRIADA POR: Tiago Paranhos Lima
  
  *)

  sNumero := '';
  sParteInteira := '';
  sParteDecimal := '';
  sSeparadorDecimais := '';
  iParteInteira := 0;
  iParteDecimal := 0;

  dNumero := valor;

  sNumero := FloatToStr(dNumero);

  if pos(',', sNumero) > 0 then
    sSeparadorDecimais := ','
  else
  if pos('.', sNumero) > 0 then
    sSeparadorDecimais := '.';

  sParteInteira := GetTermoFromString(1, sSeparadorDecimais, sNumero);
  sParteDecimal := GetTermoFromString(2, sSeparadorDecimais, sNumero);

  iParteInteira := StrToIntDef(sParteInteira, 0);
  iParteDecimal := StrToIntDef(copy(sParteDecimal,1,5), 0);

  if iParteDecimal > 0 then
    iParteInteira := iParteInteira + 1;

  result := iParteInteira;
end;

function  TruncFloat(valor: double; QuantidadeCasasDecimais: integer): double;
var
  dNumero: double;
  sNumero: string;
  sParteInteira, sParteDecimal: string;
  iParteInteira, iParteDecimal: integer;
  sSeparadorDecimais: string;
  sNovoNumero: string;
  dNovoNumero: double;
begin
  (*

  CRIADA POR: Tiago Paranhos Lima
  
  *)

  sNumero := '';
  sParteInteira := '';
  sParteDecimal := '';
  sSeparadorDecimais := '';
  iParteInteira := 0;
  iParteDecimal := 0;

  dNumero := valor;

  sNumero := FloatToStr(dNumero);

  if pos(',', sNumero) > 0 then
    sSeparadorDecimais := ','
  else
  if pos('.', sNumero) > 0 then
    sSeparadorDecimais := '.';

  sParteInteira := GetTermoFromString(1, sSeparadorDecimais, sNumero);
  sParteDecimal := GetTermoFromString(2, sSeparadorDecimais, sNumero);

  if Length(sParteDecimal) > QuantidadeCasasDecimais then
    sParteDecimal := copy(sParteDecimal, 1, QuantidadeCasasDecimais);

  sNovoNumero := sParteInteira + sSeparadorDecimais + sParteDecimal;

  dNovoNumero := strtofloatdef(sNovoNumero, 0);

  result := dNovoNumero;
end;


procedure ObterListaDeArquivosDeUmDiretorio(Path: string; var ListagemDeArquivos : TStringList; extensao: string='*.*');
var
 SR: TSearchRec;
 ret: Integer;
begin
  (*
   CRIADA POR: Eduardo Cordeiro M. Monteiro

   OBJETIVO:
     - Esta função possui o objetivo de obter a listagem de arquivos de um
       diretório específico
  *)

  if extensao = '' then
    extensao:= '*.*';

  if Path = '' then
    Path:= '.';

  Path := AjustarPath(Path);
  ret := FindFirst(Path + extensao, faAnyFile, SR);
  if ret = 0 then
  try
    repeat
      if (SR.Attr <> 0) and (faAnyFile <> 0) and (SR.Name <> '.') and ( SR.Name <> '..') then
        if FileExists(Path + SR.Name) then
          ListagemDeArquivos.Add(SR.Name);
      ret := FindNext( SR );
    until ret <> 0;
  finally
    SysUtils.FindClose(SR)
  end;
end;

function CarregarArquivoINI(var propriedades: RIni): Boolean;
var
  otxtEntrada  : TArquivoTexto;
  objDiretorio : TDiretorio;
  sNomeAplicacao : string;
  sPropriedade : String;
  sValor : string;
  sLinha : string;
begin
  (*
   CRIADA POR: Eduardo Cordeiro M. Monteiro

   OBJETIVO:
     - Esta função possui o objetivo de carregar os paths do arquivo .INI da
       aplicação.
  *)

  objDiretorio := TDiretorio.create();

  sNomeAplicacao := ExtractFileName(Application.ExeName);
  sNomeAplicacao := StringReplace(sNomeAplicacao, '.exe', '.ini', [rfReplaceAll, rfIgnoreCase]);

  try

    if FileExists(sNomeAplicacao) Then
    begin

      otxtEntrada := TArquivoTexto.create(objDiretorio, sNomeAplicacao, leitura);

      while not otxtEntrada.FimDeArquivo do
      begin
        otxtEntrada.LerLinha();
        sLinha := otxtEntrada.getLinha;

        sPropriedade := AnsiLowerCase(Trim(GetTermoFromString(1, '=', sLinha)));
        sValor       := AjustarPath(AnsiLowerCase(Trim(GetTermoFromString(2, '=', sLinha))));

        if sPropriedade = 'path_conexoes' then
          propriedades.PATH_CONEXOES:= sValor;

        if sPropriedade = 'path_configuracoes' then
          propriedades.PATH_CONFIGURACOES:= sValor;

        if sPropriedade = 'path_arquivos_temporarios' then
          propriedades.PATH_ARQUIVOS_TEMPORARIOS:= sValor;

        if sPropriedade = 'path_scripts_sql' then
          propriedades.PATH_SCRIPTS_SQL:= sValor;

        if sPropriedade = 'path_outros_recursos' then
          propriedades.PATH_OUTROS_RECURSOS:= sValor;
          
      end;

    end
    else
    begin

      ShowMessage('Atenção !!! O ARQUIVO '
      + sNomeAplicacao
      + ' não existe no diretório da aplicacao.O mesmo será criado.');

      otxtEntrada := TArquivoTexto.create(objDiretorio, sNomeAplicacao, criacao);

      otxtEntrada.EscreverNoArquivo('PATH_CONEXOES = .\diretorio_conexao\');
      propriedades.PATH_CONEXOES := '.\diretorio_conexao\';

      otxtEntrada.EscreverNoArquivo('PATH_CONFIGURACOES = .\diretorio_configuracao\');
      propriedades.PATH_CONFIGURACOES := '.\diretorio_configuracao\';

      otxtEntrada.EscreverNoArquivo('PATH_ARQUIVOS_TEMPORARIOS = .\diretorio_arquivos_temporarios\');
      propriedades.PATH_ARQUIVOS_TEMPORARIOS:= '.\diretorio_arquivos_temporarios\';

      otxtEntrada.EscreverNoArquivo('PATH_SCRIPTS_SQL = .\diretorio_scripts_sql\');
      propriedades.PATH_SCRIPTS_SQL := '.\diretorio_scripts_sql\';

      otxtEntrada.EscreverNoArquivo('PATH_OUTROS_RECURSOS = .\diretorio_outros_recursos\');
      propriedades.PATH_OUTROS_RECURSOS := '.\diretorio_outros_recursos\';
    end;

  finally
    if Assigned(otxtEntrada) then
    begin
      otxtEntrada.destroy;
      Pointer(otxtEntrada) := nil;
    end;
  end;  

end;

function CarregarArquivoDeConexoes(PathArquivoConexoes: String; var propriedades: RListaDeBases): integer;
var
  otxtArquivoConexao, otxtArquivoConexaoLeitura : TArquivoTexto;
  objDiretorio      : TDiretorio;
  sLinha            : String;
  sArquivoDeConexoes: string;
  sPropriedade : String;
  sValor : string;

  sHost : string;
  sUser : string;
  sPassword: string;
  sProtocolo : string;
  sBase : string;

  iContBases        : Integer;
  iTotalDeBases     : Integer;

  sListaDatabasesDefault: string;
begin
  (*
   CRIADA POR: Eduardo Cordeiro M. Monteiro

   OBJETIVO:
     - Esta função possui o objetivo de carregar os as propriedades das conexoes
       do arquivo databases.conf.
  *)

  objDiretorio := TDiretorio.create();

  sArquivoDeConexoes := 'databases.conf';

  if not FileExists(PathArquivoConexoes + sArquivoDeConexoes) Then
  begin
    ShowMessage('Atenção !!! O arquivo '
    + sArquivoDeConexoes
    + ' não existe no diretório ' + PathArquivoConexoes + '. O mesmo será criado.');
    try

      iContBases:= 1;
      SetLength(propriedades, iContBases);

      if not DirectoryExists(PathArquivoConexoes) then
        ForceDirectories(PathArquivoConexoes);

      try

        otxtArquivoConexao := TArquivoTexto.Create(objDiretorio,PathArquivoConexoes + sArquivoDeConexoes, criacao);

        otxtArquivoConexao.EscreverNoArquivo('Host=localhost');

        otxtArquivoConexao.EscreverNoArquivo('User=root');

        otxtArquivoConexao.EscreverNoArquivo('Password=123456');

        otxtArquivoConexao.EscreverNoArquivo('Protocolo=mysql-5');

        sListaDatabasesDefault := 'fac, processamento, netsat_archive, netsat_config, '
                                 +'netsat_fatura_emails, netsat_editor_relatorios_archive, '
                                 +'netsat_novos_assinantes, netsat_relatorio_unificado, '
                                 +'plano_de_triagem, testes, net_carta_quitacao_emails, '
                                 +'carta_quitacao_de_debitos, app_logs_db, '
                                 +'net_relatorio_faturamento';

        otxtArquivoConexao.EscreverNoArquivo('Databases=('+sListaDatabasesDefault+')');

        sBase:= sListaDatabasesDefault;

        iTotalDeBases:= GetNumeroOcorrenciasCaracter(sBase, ',');

        SetLength(propriedades, iTotalDeBases + 1);
        for iContBases:=0 to iTotalDeBases do
        begin
          propriedades[iContBases].Host      := 'localhost';
          propriedades[iContBases].User      := 'root';
          propriedades[iContBases].Password  := '123456';
          propriedades[iContBases].protocolo := 'mysql-5';
          propriedades[iContBases].Name      := Trim(GetTermoFromString(iContBases + 1, ',', sBase));
        end;

      finally

        if Assigned(otxtArquivoConexao) then
        begin
          otxtArquivoConexao.destroy;
          Pointer(otxtArquivoConexao) := nil;
        end;

      end;

    except
      on E:Exception do
      begin
        ShowMessage('ERRO AO CRIAR O ARQUIVO ' + sArquivoDeConexoes + ' NO PATH ' + PathArquivoConexoes + #13
        + E.Message);
      end;
    end;
  end;

  try

    otxtArquivoConexaoLeitura := TArquivoTexto.create(objDiretorio,PathArquivoConexoes + sArquivoDeConexoes, leitura);

    while not otxtArquivoConexaoLeitura.FimDeArquivo do
    begin
      otxtArquivoConexaoLeitura.LerLinha();
      sLinha := otxtArquivoConexaoLeitura.getLinha();

      sPropriedade := AnsiLowerCase(Trim(GetTermoFromString(1, '=', sLinha)));
      sValor       := AnsiLowerCase(Trim(GetTermoFromString(2, '=', sLinha)));

      if sPropriedade = 'host' Then
        sHost := sValor;

      if sPropriedade = 'user' Then
        sUser := sValor;

      if sPropriedade = 'password' Then
        sPassword := sValor;

      if sPropriedade = 'protocolo' Then
        sProtocolo := sValor;

      if sPropriedade = 'databases' Then
      begin
        sBase:= sValor;
        sBase:= StringReplace(sBase, '(', '', [rfReplaceAll]);
        sBase:= StringReplace(sBase, ')', '', [rfReplaceAll]);

        iTotalDeBases:= GetNumeroOcorrenciasCaracter(sBase, ',') + 1;

        SetLength(propriedades, iTotalDeBases);

        for iContBases:=0 to iTotalDeBases - 1 do
        begin
          propriedades[iContBases].Host      := sHost;
          propriedades[iContBases].User      := sUser;
          propriedades[iContBases].Password  := sPassword;
          propriedades[iContBases].protocolo := sProtocolo;
          propriedades[iContBases].Name      := Trim(GetTermoFromString(iContBases + 1, ',', sBase));
        end;
      end;

    end;

  finally

    if Assigned(otxtArquivoConexaoLeitura) then
    begin
      otxtArquivoConexaoLeitura.destroy;
      Pointer(otxtArquivoConexaoLeitura) := nil;
    end;

  end;

  result := iTotalDeBases;

end;

procedure AboutApplication(autores: String);
var
  sMensagem: string;
begin
  (*

   CRIADA POR: Eduardo Cordeiro M. Monteiro

  *)

  sMensagem := Application.Title + #13#10
             + ' Versão '+GetVersaoDaAplicacao() + #13#10
             + ' @2010-2011 Fingerprint - ' + autores;

  showmessage(sMensagem);

end;

function GravarLinhaEmArquivo(nomeArquivo: string; linha: string;
 apagarArquivoSeExiste: boolean=False; ForcarQuebraDeLinha: boolean=true): RActionReturn;
var
  oArquivo: TArquivoTexto;
  objDiretorio : TDiretorio;
  eModoArquivo: TModoDeAberturaDeArquivo;
  rrRetorno: RActionReturn;
begin
  rrRetorno.sucesso := True;
  rrRetorno.mensagem := '';

  (*

   CRIADA POR: Tiago Paranhos Lima

  *)

  objDiretorio := TDiretorio.create();

  try

    try

      if apagarArquivoSeExiste then
      begin
        DeleteFile(StrToPChar(nomeArquivo));
        eModoArquivo := criacao;
      end
      else
      begin
        if not FileExists(nomeArquivo) then
          eModoArquivo := criacao
        else
          eModoArquivo := escrita;
      end;

      oArquivo := TArquivoTexto.Create(objDiretorio, nomeArquivo, eModoArquivo);

      //oArquivo.EscreverNoArquivo(linha, ForcarQuebraDeLinha);
      oArquivo.EscreverNoArquivo(linha);
      
    except
      on E:Exception do
      begin
        rrRetorno.sucesso := False;
        rrRetorno.mensagem := 'ufuncoes - GravarLinhaEmArquivo() - Exceção: '+E.Message;
      end;
    end;

  finally

    if Assigned(oArquivo) then
    begin
      oArquivo.destroy;
      Pointer(oArquivo) := nil;
    end;

  end;

  result := rrRetorno;
end;

function StrToPChar(const Str: string): PChar;
type
  TRingIndex = 0..7;
var
  Ring: array[TRingIndex] of PChar;
  RingIndex: TRingIndex;
  Ptr: PChar;
begin
  (*

  CRIADA POR: Tiago Paranhos Lima

  OBJETIVO:
    - Converte uma string para PChar.
    - Útil no caso de uma função precisar que se passe um parâmetro
      obrigatoriamente como PChar.

  *)

  Ptr := @Str[Length(Str)];
  Inc(Ptr);

  if Ptr^ = #0 then
  begin
    Result := @Str[1];
  end
  else
  begin
    Result := StrAlloc(Length(Str)+1);
    RingIndex := (RingIndex + 1) mod (High(TRingIndex) + 1);
    StrPCopy(Result,Str);
    StrDispose(Ring[RingIndex]);
    Ring[RingIndex]:= Result;
  end;

end;

function FileToString(nomeArquivo: string): string;
var
  sConteudoArquivo: string;
  slArquivo: TStringList;
begin
  sConteudoArquivo := '';

  try
    slArquivo := TStringList.Create;

    slArquivo.LoadFromFile(nomeArquivo);
    //LoadStringListFromFile_SafeWay(slArquivo, nomeArquivo);

    sConteudoArquivo :=  slArquivo.Text;

  finally

    if Assigned(slArquivo) then
      FreeAndNil(slArquivo);

  end;

  result := sConteudoArquivo;
end;

procedure LoadStringListFromFile_SafeWay(var sl: TStringList; filename: string);
var

  oArquivo: TArquivoTexto;
  objDiretorio : TDiretorio;
  sLinha: string;
  iContLinhas: integer;
begin

  try
    objDiretorio := TDiretorio.create();

    oArquivo := TArquivoTexto.create(objDiretorio, filename, leitura);

    try


      iContLinhas := 0;

      while not oArquivo.FimDeArquivo do
      begin
        oArquivo.LerLinha();
        sLinha := oArquivo.getLinha();


        iContLinhas := iContLinhas + 1;

        if pos(#0, sLinha) > 0 then
          Logar('uFuncoes - LoadStringListFromFile_SafeWay() - '
           +'Arquivo "'+filename+'" contém caracter nulo (#0). Linha: '+inttostr(iContLinhas));


        sl.Add(sLinha);
      end;

    except
      on E:Exception do
        Logar('uFuncoes - LoadStringListFromFile_SafeWay() - Arquivo: "'
         +filename+'"; Exceção: "'+E.Message+'"', Erro);
    end;

  finally

    oArquivo.destroy;
    Pointer(oArquivo) := nil;
  end;

end;

procedure PopularStringListFromString(var sl: TStringList; str: string;
 delimitador: string);
var
  iTotalOcorrenciasDelimitador, i: integer;
  sTermoAtual: string; 
begin

  iTotalOcorrenciasDelimitador := GetTotalOcorrenciasSubstringEmString(
   str, delimitador);

  for i:=0 to iTotalOcorrenciasDelimitador-1 do
  begin
    sTermoAtual := GetTermoFromString(i+1, delimitador, str);
    sl.Add(sTermoAtual);
  end;

end;

procedure PrepararStringParaInsercaoEmBanco(var str: string);
begin
  str := StringReplace(str, '\', '\\', [rfIgnoreCase, rfReplaceAll]);
  str := StringReplace(str, '"', '\"', [rfIgnoreCase, rfReplaceAll]);
  str := StringReplace(str, '''', '\''', [rfIgnoreCase, rfReplaceAll]);
  str := StringReplace(str, #0, ' ', [rfReplaceAll, rfIgnoreCase]);
end;

function  GetTotalOcorrenciasSubstringEmString(strString: string;
 strSubstring: string): integer;
var
  iCont, iPosSubstring: integer;
  sStrTemp: string;
begin
  iCont := 0;

  sStrTemp := strString;

  while length(sStrTemp) > 0 do
  begin
    iPosSubstring := pos(strSubstring, sStrTemp);

    if iPosSubstring=0 then
      break
    else
    begin
      iCont := iCont + 1;
      sStrTemp := copy(sStrTemp, iPosSubstring+1, length(sStrTemp)-iPosSubstring);
    end;
  end;

  result := iCont;
end;

function StringToFile(sString: string; sFile: string;
 apagarArquivoSeExiste: boolean=false): RActionReturn;
begin
  result := GravarLinhaEmArquivo(sFile, sString, apagarArquivoSeExiste);
end;

procedure InserirConteudoArrayStringOrigemEmArrayStringDestino(
 var origem: aStringArray; var destino: aStringArray);
var
  i: integer;
  iTamAtualArrayDestino: integer;
begin

  iTamAtualArrayDestino := Length(destino);
                                            
  for i:=0 to Length(origem)-1 do
  begin
    iTamAtualArrayDestino := iTamAtualArrayDestino + 1;

    SetLength(destino, iTamAtualArrayDestino);
    destino[iTamAtualArrayDestino-1] := origem[i];
  end;

end;

procedure GetListaCaracteresDaClasseASCII(classe: EClassesCaracteresASCII;
 var slLista: TStringList);
var
  i: integer;
begin
  (*

  CRIADA POR: Tiago Paranhos Lima

  OBJETIVO:
    - funcao que retorna o codigo ASCII dos caracteres de uma determinada classe.

  *)

  case classe of
    asControle:
      begin
        for i:=0 to 31 do
          slLista.Add(inttostr(i));

        slLista.Add('127'); //DEL
      end;

    asPontuacao:
      begin
        slLista.Add('32');
        slLista.Add('33');
        slLista.Add('34');
        slLista.Add('39');
        slLista.Add('44');
        slLista.Add('45');
        slLista.Add('46');
        slLista.Add('58');
        slLista.Add('59');
        slLista.Add('63');
        slLista.Add('168');
        slLista.Add('173');
      end;

    asMatematica:
      begin
        slLista.Add('37');
        slLista.Add('40');
        slLista.Add('41');
        slLista.Add('42');
        slLista.Add('43');
        slLista.Add('47');
        slLista.Add('60');
        slLista.Add('61');
        slLista.Add('62');
        slLista.Add('91');
        slLista.Add('93');
        slLista.Add('123');
        slLista.Add('125');
        slLista.Add('171');
        slLista.Add('172');
        slLista.Add('241');
        slLista.Add('242');
        slLista.Add('243');
        slLista.Add('246');
        slLista.Add('251');
        slLista.Add('253');
      end;

    asAcentuacao:
      begin
        slLista.Add('94');
        slLista.Add('96');
        slLista.Add('126');
        slLista.Add('166');
        slLista.Add('167');
      end;

    asNumeros:
      begin
        for i:=48 to 57 do
          slLista.Add(inttostr(i));
      end;

    asCaracteres:
      begin
        for i:=65 to 90 do
          slLista.Add(inttostr(i));

        for i:=97 to 122 do
          slLista.Add(inttostr(i));
      end;

    asCaracteresAcentuados:
      begin
        for i:=128 to 144 do
          slLista.Add(inttostr(i));

        for i:=147 to 151 do
          slLista.Add(inttostr(i));

        for i:=153 to 154 do
          slLista.Add(inttostr(i));

        for i:=160 to 165 do
          slLista.Add(inttostr(i));
      end;

    asSimbolos:
      begin
        slLista.Add('35');
        slLista.Add('36');
        slLista.Add('38');
        slLista.Add('64');
        slLista.Add('92');
        slLista.Add('95');
        slLista.Add('124');

        slLista.Add('145');
        slLista.Add('146');
        slLista.Add('152');
        slLista.Add('156');
        slLista.Add('157');
        slLista.Add('158');
        slLista.Add('159');

        for i:=224 to 240 do
          slLista.Add(inttostr(i));

        slLista.Add('244');
        slLista.Add('245');
        slLista.Add('247');
        slLista.Add('248');
        slLista.Add('252');
      end;

    asGraficos:
      begin
        slLista.Add('169');
        slLista.Add('170');

        for i:=174 to 223 do
          slLista.Add(inttostr(i));

        slLista.Add('254');
      end;

  end;

end;

function GetTrimestreFromData(data: string): string;
var
  iMes, iTrimestre: integer;
  sAno: string;
begin
  (*

  CRIADA POR: Tiago Paranhos Lima

  OBJETIVO:
    - Retorna o trimestre na forma <numero_trimestre>/<ano>.
      Ex.: 01/2010, 02/2010, 03/2010, 04/2010.

  *)

  iMes := strtointdef(GetTermoFromString(2, '/', data),0);
  sAno := GetTermoFromString(3, '/', data);

  case iMes of
    1..3:   iTrimestre := 1;
    4..6:   iTrimestre := 2;
    7..9:   iTrimestre := 3;
    10..12: iTrimestre := 4;
  end;

  result := formatfloat('00', iTrimestre)+'/'+sAno;
end;

function GetDataPertenceATrimestre(data: string; trimestre: string): boolean;
var
  sTrimestreRealDaData: string;
begin
  (*

  CRIADA POR: Tiago Paranhos Lima

  OBS.:
    - Exemplo:
      Data: 31/12/2009
      Trimestre: 04/2009 (quarto trimestre de 2009)
      
  *)

  sTrimestreRealDaData := GetTrimestreFromData(data);

  if sTrimestreRealDaData = trimestre then
    result := true
  else
    result := false;
end;

procedure GetDatasQuePertecemAoTrimestre(var datas_entrada: TStringList;
  trimestre: string; var datas_pertencentes: TStringList);
var
  i: integer;
  sData: string;
begin
  (*

  CRIADA POR: Tiago Paranhos Lima

  *)

  datas_pertencentes.Clear;

  for i:=0 to datas_entrada.Count-1 do
  begin
    sData := datas_entrada[i];

    if GetDataPertenceATrimestre(sData, trimestre) then
      datas_pertencentes.Add(sData);
  end;

end;

procedure GetListaDeArquivosContendoRegex(path : String;
 var listaArquivos : TStringList; regex : String; incluirPathNoNome: boolean=false);
var
  Arq: TSearchRec;
  dir: String;
  sNomeArquivo: string;
  oRegularExpression: TRegularExpressionFingerprint;
  rrRetorno: RActionReturn;
begin
  (*

  CRIADA POR: Tiago Paranhos Lima

  *)

  try

    oRegularExpression := TRegularExpressionFingerprint.Create;

    AjustarPath(path, soWindows);

    if FindFirst(path + '*.*' , faDirectory , Arq) = 0 then
    begin
      repeat
        if (Arq.Attr <> 0) and (faDirectory <> 0)
         and (Arq.Name <> '.') and ( Arq.Name <> '..') then
        begin
          sNomeArquivo := Arq.Name;

          oRegularExpression.StringOriginal := sNomeArquivo;
          oRegularExpression.RegEx := regex;

          rrRetorno := oRegularExpression.ExecuteSearch();

          if rrRetorno.sucesso then
          begin
            if oRegularExpression.Matches.Count > 0 then
            begin
              if incluirPathNoNome then
                sNomeArquivo := path + sNomeArquivo;
              listaArquivos.Add(sNomeArquivo);
            end;
          end;

        end;
      until FindNext(Arq) <> 0;
      //FindClose(Arq); - TODO: Achar um jeito de fechar "Arq",
      //este código funciona em outras funções mas nesta não. 
    end;

    listaArquivos.Sort;

  finally
    if Assigned(oRegularExpression) then
      FreeAndNil(oRegularExpression);
  end;

end;


procedure GetArquivosEmDiretorioRecursivamente(regex_nome_arquivos: string;
 diretorio_raiz: string; var listaArquivos : TStringList);
var
  slSubDiretorios, slArquivosTodos: TStringList;
  i: integer;
  sSubDir: string;
begin
  (*

  CRIADA POR: Tiago Paranhos Lima

  *)

  try
    slSubDiretorios := TStringList.Create;

    slSubDiretorios := GetSubdiretorios(diretorio_raiz, true);

    //Insere na 1a. posição o diretório raiz:
    slSubDiretorios.Insert(0, diretorio_raiz);

    for i:=0 to slSubDiretorios.Count-1 do
    begin
      sSubDir := slSubDiretorios[i];
      GetListaDeArquivosContendoRegex(sSubDir, listaArquivos, regex_nome_arquivos, true);
    end;

  finally

    if Assigned(slSubDiretorios) then
      FreeAndNil(slSubDiretorios);
  end;

end;

function GetSubdiretorios(Directory: String; IsRecursive: Boolean; incluirArquivosOcultos:boolean=true): TStringList;
var
  Sr : TSearchRec;
  slLista: TStringList;
  iOculto: integer;

  procedure Recursive(Dir : String); { Sub Procedure, Recursiva }
  var
    SrAux : TSearchRec;
  begin
    if SrAux.Name = EmptyStr then
      FindFirst(Directory + Dir + '\*.*', (faDirectory+iOculto+faReadOnly), SrAux);
    while FindNext(SrAux) = 0 do
    begin
      if SrAux.Name <> '..' then
      begin
        if DirectoryExists(Directory + Dir + '\' + SrAux.Name) then
        begin
          slLista.Add(Directory + Dir + '\' + SrAux.Name);
          Recursive(Dir + '\' + SrAux.Name);
        end;
      end;
    end;
  end;

begin

  AjustarPath(Directory, soWindows);

  if incluirArquivosOcultos then
    iOculto := faHidden
  else
    iOculto := 0;

  FindFirst(Directory + '*.*', (faDirectory+iOculto+faReadOnly) , Sr);

  slLista := TStringList.Create();

  while FindNext(Sr) = 0 do
  begin
    if Sr.Name <> '..' then
    begin
      if DirectoryExists(Directory + Sr.Name) then
      begin
        slLista.Add(Directory+Sr.Name);

        if IsRecursive then
          Recursive(Sr.Name);
      end;
    end;
  end;

  result := slLista;
end;

function AjustaStr ( str: String; tam: Integer ): String;
begin
  while Length ( str ) < tam do
    str := str + ' ';

  if Length ( str ) > tam then
    str := Copy ( str, 1, tam );

  Result := str;
end;

function AjustaStrEsquerda ( str: String; tam: Integer ): String;
begin
  while Length ( str ) < tam do
    str := ' '+str ;

  if Length ( str ) > tam then
    str := Copy ( str, 1, tam );

  Result := str;
end;

function MemoryStreamToString(
  var memory_stream: TMemoryStream): string;
var
  sString: string;
begin

  sString := '?';

  SetLength(sString, memory_stream.Size);
  memory_stream.Read(sString[1], memory_stream.Size);

  result := sString;
end;

procedure StringToMemoryStream(str: string;
  var memory_stream: TMemoryStream);
begin
  memory_stream.Write(str[1], Length(str));
end;

procedure InserirRegistrosStringListOrigemDentroDeStringListDestino(
 var slOrigem: TStringList; var slDestino: TStringList;
 posicaoInsercaoDestino: integer);
var
  i: integer;
  sRegistro: string;
begin
  (*

  CRIADA POR: Tiago Paranhos Lima

  OBJETIVO:
    - Inserir todos os registros de uma stringlist dentro de uma outra.
      Deve ser informado em "posicaoInsercaoDestino" em qual registro
      da slDestino deverão ser inseridos os registros de slOrigem.
  *)

  for i:=0 to slOrigem.Count-1 do
  begin
    sRegistro := slOrigem[i];
    slDestino.Insert(i+posicaoInsercaoDestino, sRegistro);
  end;

end;

function GetStringListSize(sl: TStringList): RFile;
var
  iLength: int64;
  iDataStructures: int64;
  iTamTotal: int64;
  rrFile: RFile;
begin
  iLength := Length(sl.Text);

  iDataStructures := 2 * sl.Count * 4 + 8;

  iTamTotal := iLength + iDataStructures;

  rrFile := GetTamanhoMaiorUnidade(iTamTotal);

  result := rrFile;
end;  


function GetArquivoPossuiCaracterNuloAntesDoEOF(nomeArquivo: string): boolean;
var
  sConteudoArquivo: string;
  bPossui: boolean;
  iTotalOcorrencias: integer;
begin
  bPossui := true;

  sConteudoArquivo := FileToString(nomeArquivo);

  iTotalOcorrencias := GetTotalOcorrenciasSubstringEmString(sConteudoArquivo, #0);

  if iTotalOcorrencias > 0 then
    bPossui := true
  else
    bPossui := false;

  sConteudoArquivo := '';  

  result := bPossui;
end;

procedure SubstituirCaracterNuloAntesdoEOF(nomeArquivo: string; substituirPelaString: string);
var
  sConteudoArquivo: string;
  bPossui: boolean;
  iTotalOcorrencias: integer;
  sArquivoTemp: string;
  sNovaString: string;
  sCaracterAtual: string;
  i: integer;
begin
  bPossui := true;


  sConteudoArquivo := FileToString(nomeArquivo);

  iTotalOcorrencias := GetTotalOcorrenciasSubstringEmString(sConteudoArquivo, #0);

  sNovaString := '';

  if iTotalOcorrencias > 0 then
  begin
    for i:=1 to length(sConteudoArquivo) do
    begin
      sCaracterAtual := sConteudoArquivo[i];

      if sCaracterAtual = #0 then
      begin
        sCaracterAtual := substituirPelaString;

        Logar('uFuncoes - SubstituirCaracterNuloAntesdoEOF() - '
         +'Encontrado caracter NULO (NUL - #0) no arquivo "'+nomeArquivo+'".'
         +' Substituído por "'+substituirPelaString+'".');
      end;

      sNovaString := sNovaString + sCaracterAtual;
    end;

    sConteudoArquivo := sNovaString;
  end;

  StringToFile(sConteudoArquivo, nomeArquivo, true);

  sConteudoArquivo := '';
end;

function GetTermoFromString_FAST(numero_termo: Byte; separador: char;
 texto: string; compat:boolean=True): string;
var
  i: integer;
  PLine, PStart: PChar;
begin
  PLine := PChar(texto);
  PStart := PLine;
  inc(PLine);
  for i:=1 to numero_termo do
  begin
    while (PLine^ <> #0) and (PLine^ <> separador) do
      inc(PLine);

    if i = numero_termo then
    begin
      SetString(Result, PStart, PLine - PStart);
      break
    end;

    if PLine^ = #0 then
    begin
      result := '';
      break;
    end;

    inc(PLine);
    PStart := PLine;
  end;
end;

end.

