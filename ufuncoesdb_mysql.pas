unit ufuncoesDB_mysql;

{Unit que centraliza toda a comunicação com o banco MYSQL, via componentes ZEOS.}

interface

uses
  SysUtils, Variants, Classes, DateUtils,
  DB, ZConnection, ZAbstractRODataset, ZAbstractDataset,
  ZDataset, ZSqlProcessor, uFuncoes, udatatypes_apps;

  { MySQL }

  function MySQL_ZEOS_ConectarDB(var Conexao: TZConnection;
   Host, User, Password, BaseDeDados: AnsiString): RActionReturn;


  { ZEOS - Genéricas }

  function ZEOS_ExecutarQuery(var Conexao: TZConnection;
   sql: AnsiString; var aResultSet: aDynamicStringArray): RActionReturn; overload;

  function DML_ZEOS_ExecSQLQuery(var Conexao: TZConnection;
   sql: AnsiString; var qry: TZQuery): RActionReturn; overload;

  function DML_ZEOS_OpenQuery(var Conexao: TZConnection;
   sql: AnsiString; var qry: TZQuery): RActionReturn; overload;

   
  { Outras }

  function  DateConversion_Delphi2MySQL(data: AnsiString): AnsiString;

  function  GetTableExistsOnDatabase(Con: TZConnection; table_name: string): boolean;
  
  function  GetIndexExistsOnDatabaseTable(Con: TZConnection;
   table_name: string; indice: string): boolean;

  procedure GetAllTablesFromDatabase(Con: TZConnection; var tables_list: aDynamicStringArray);

  procedure GetAllIndexesFromDatabaseTable(Con: TZConnection;
   tabela: string; var indexes_list: aDynamicStringArray);

  function  GetSQLOperationFromSQLString(sql_string: string): ESQLOperations;

  function  ExecutarScriptSQL(Con: TZConnection; nome_arquivo: string;
   APP_NAME: string): RActionReturn;

   
  { Funções DEPRECADAS - Não as utilize (serão removidas futuramente) }

  function ZEOS_ExecutarQuery_SEARCHDATABASE(var Conexao: TZConnection;
   sql: AnsiString; var aResultSet: aDynamicStringArray): RActionReturn;

  function ZEOS_ExecutarQuery_CHANGEDATABASE(var Conexao: TZConnection;
   SQLOperation: ESQLOperations; sSQL: AnsiString): RActionReturn;



implementation

uses Math, RegExpr, StrUtils;

function MySQL_ZEOS_ConectarDB(var Conexao: TZConnection;
 Host, User, Password, BaseDeDados: AnsiString): RActionReturn;
var
  rrActionReturn: RActionReturn;
begin
  (*

  CRIADA POR: Tiago Paranhos Lima
  
  *)

  rrActionReturn.sucesso := True;
  rrActionReturn.mensagem := '';

  try
    if Conexao.Connected then Conexao.Connected := false;
    Conexao.Protocol := 'mysql-5';
    Conexao.HostName := Host;
    Conexao.User     := User;
    Conexao.Password := Password;
    Conexao.Database := BaseDeDados;

    {Corrige do erro "can't return a result set in the given context"
    ao executar Stored Procedures no MySQL:}
    Conexao.Properties.Add('CLIENT_MULTI_STATEMENTS=1');

    Conexao.Connected := true;
  except
    on E:Exception do
    begin
      rrActionReturn.mensagem := 'udatatypes_apps.MySQL_ZEOS_ConectarDB() - Não foi possível conectar ao banco "'
       +BaseDeDados+'". Exceção: '+E.Message;

      rrActionReturn.sucesso := False; 

      Logar(rrActionReturn.mensagem, Erro);
    end;
  end;

  result := rrActionReturn;
end;

function ZEOS_ExecutarQuery_SEARCHDATABASE(var Conexao: TZConnection;
 sql: AnsiString; var aResultSet: aDynamicStringArray): RActionReturn;
var
  qry: TZQuery;
  rrActionReturn: RActionReturn;
  i, j: integer;
begin
  (*

  CRIADA POR: Tiago Paranhos Lima

  =================================================================================
  NÃO UTILIZE esta função, pois ela será removida futuramente (ela está deprecada).
  Ao invés dela, use a função 'ZEOS_ExecutarQuery()'.
  =================================================================================

  OBJETIVO:
    - Executa queries que alteram a base de dados
     (Insert, Update, Delete, Create).

  EXEMPLO DE CHAMADAS:
    - Como iterar no resultset populado por esta função quando
      a query retorna só 1 coluna:

      for i:=0 to Length(aResultSet)-1 do
      begin
        sLinha := aResultSet[i][0];
      end;

  *)

  rrActionReturn.sucesso := True;
  rrActionReturn.mensagem := '';

  try
    qry := TZQuery.Create(nil);

    qry.Connection := Conexao;

    qry.SQL.Text := sql;

    try
      qry.Open;

      SetLength(aResultSet,qry.RecordCount,qry.FieldCount);

      i := 0;
      while Not qry.Eof do
      begin
        for j:= 0 to qry.FieldCount - 1 do
        begin
          aResultSet[i,j] := qry.Fields[j].AsString;

          //Converte a codificação do MySQL (Ansi) para UTF-8 (default do lazarus):
          //aResultSet[i,j] := AnsiToUtf8(aresultset[i,j]);

          If aresultset[i,j] = '' then
          begin
            aresultset[i,j] := '(empty)';
          end;
        end;
        Inc(i);
        qry.next;
      end;

      qry.Close;

    except
      on E:Exception do
      begin
        rrActionReturn.sucesso := False;

        rrActionReturn.mensagem := 'udatatypes_apps.ZEOS_ExecutarQuery_SEARCHDATABASE()'
         +' - Não foi possível executar a consulta. Exceção: '+E.Message+'. SQL: '+sql;

        Logar(rrActionReturn.mensagem, Erro);
      end;

    end;

  finally
    if Assigned(qry) then
      FreeAndNil(qry);
  end;

  result := rrActionReturn;
end;


function ZEOS_ExecutarQuery_CHANGEDATABASE(var Conexao: TZConnection;
 SQLOperation: ESQLOperations; sSQL: AnsiString): RActionReturn;
var
  qry: TZQuery;
  rrActionReturn: RActionReturn;
  sSQLAnsi: AnsiString;
begin

  (*

  CRIADA POR: Tiago Paranhos Lima

  =================================================================================
  NÃO UTILIZE esta função, pois ela será removida futuramente (ela está deprecada).
  Ao invés dela, use a função 'ZEOS_ExecutarQuery()'.
  =================================================================================

  *)

  rrActionReturn.sucesso := True;
  rrActionReturn.mensagem := '';

  //Converte de UTF8 (lazarus) para Ansi (MySQL)
  sSQLAnsi:=sSQL;

  //sSQLAnsi:=Utf8ToAnsi(sSQLAnsi);

  try
    qry := TZQuery.Create(nil);

    qry.Connection := Conexao;

    qry.SQL.Text := sSQLAnsi;

    try
      qry.ExecSQL;

    except
      on E:Exception do
      begin
        rrActionReturn.sucesso := False;

        rrActionReturn.mensagem := 'udatatypes_apps.ZEOS_ExecutarQuery_CHANGEDATABASE()'
         +' - Não foi possível executar a consulta. Exceção: '+E.Message+'. SQL: '+sSQL;

        Logar(rrActionReturn.mensagem, Erro);

      end;

    end;

  finally
    if Assigned(qry) then
      FreeAndNil(qry);
  end;

  result := rrActionReturn;
end;


function DateConversion_Delphi2MySQL(data: AnsiString): AnsiString;
var
  sDia, sMes, sAno: AnsiString;
  sDataMySQL: AnsiString;
begin
  (*

  CRIADA POR: Tiago Paranhos Lima

  OBS.:
    - formato do Delphi: dd/mm/aaaa

  *)

  sDia := copy(data, 1, 2);
  sMes := copy(data, 4, 2);
  sAno := copy(data, 7, 4);

  sDataMySQL := sAno + '-' + sMes + '-' + sDia;

  result := sDataMySQL;
end;

function GetTableExistsOnDatabase(Con: TZConnection; table_name: string): boolean;
var
  sTableAtual: string;
  i: integer;
  bExiste: boolean;
  aResultSet: aDynamicStringArray;
begin
  bExiste := False;

  GetAllTablesFromDatabase(Con, aResultSet);

  for i := 0 to Length(aResultSet)-1 do
  begin
    sTableAtual := aResultSet[i][0];
    sTableAtual := TrimLeftRight(AnsiLowerCase(sTableAtual));

    if TrimLeftRight(AnsiLowerCase(table_name)) = sTableAtual then
    begin
      bExiste := True;
      break;
    end;
  end;

  result := bExiste;
end;

function  GetIndexExistsOnDatabaseTable(Con: TZConnection;
 table_name: string; indice: string): boolean;
var
  sIndiceAtual: string;
  i: integer;
  bExiste: boolean;
  aResultSet: aDynamicStringArray;
begin
  bExiste := False;

  GetAllIndexesFromDatabaseTable(Con, table_name, aResultSet);

  for i := 0 to Length(aResultSet)-1 do
  begin
    sIndiceAtual := aResultSet[i][2]; //key_name
    sIndiceAtual := TrimLeftRight(AnsiLowerCase(sIndiceAtual));

    if TrimLeftRight(AnsiLowerCase(indice)) = sIndiceAtual then
    begin
      bExiste := True;
      break;
    end;
  end;

  result := bExiste;
end;



procedure GetAllTablesFromDatabase(Con: TZConnection; var tables_list: aDynamicStringArray);
var
  sSQL: string;
  aResultSet: aDynamicStringArray;
begin
  SetLength(tables_list, 0);

  sSQL := ' SHOW TABLES ';

  ZEOS_ExecutarQuery(Con, sSQL, tables_list);
end;

procedure GetAllIndexesFromDatabaseTable(Con: TZConnection;
 tabela: string; var indexes_list: aDynamicStringArray);
var
  sSQL: string;
  aResultSet: aDynamicStringArray;
begin
  SetLength(indexes_list, 0);

  sSQL := ' SHOW INDEX FROM ' + tabela;

  ZEOS_ExecutarQuery(Con, sSQL, indexes_list);
end;


function  GetSQLOperationFromSQLString(sql_string: string): ESQLOperations;
begin

  if pos('LOAD DATA INFILE ', AnsiUpperCase(sql_string)) > 0 then
    result := sopLoadDataInfile
  else if pos('INSERT ', AnsiUpperCase(sql_string)) > 0 then
    result := sopInsert
  else if pos('UPDATE ', AnsiUpperCase(sql_string)) > 0 then
    result := sopUpdate
  else if pos('DELETE ', AnsiUpperCase(sql_string)) > 0 then
    result := sopDelete
  else if pos('SELECT ', AnsiUpperCase(sql_string)) > 0 then
  begin
    if pos('INTO OUTFILE', AnsiUpperCase(sql_string)) > 0 then
      result := sopSelectIntoOutfile
    else
      result := sopSelect;
  end
  else if pos('CREATE TABLE ', AnsiUpperCase(sql_string)) > 0 then
    result := sopCreateTable
  else if pos('CREATE DATABASE ', AnsiUpperCase(sql_string)) > 0 then
    result := sopCreateDatabase
  else if pos('CREATE INDEX ', AnsiUpperCase(sql_string)) > 0 then
    result := sopCreateIndex
  else if pos('SHOW ', AnsiUpperCase(sql_string)) > 0 then
    result := sopShow
  else if pos('DESCRIBE ', AnsiUpperCase(sql_string)) > 0 then
    result := sopDescribe
  else if pos('PROCEDURE ', AnsiUpperCase(sql_string)) > 0 then
    result := sopProcedure
  else if pos('TRIGGER ', AnsiUpperCase(sql_string)) > 0 then
    result := sopTrigger
  else
    result := sopUnknown;

end;

function DML_ZEOS_OpenQuery(var Conexao: TZConnection;
 sql: AnsiString; var qry: TZQuery): RActionReturn; overload;
var
  rrActionReturn : RActionReturn;
begin
  (*

  CRIADA POR: Eduardo

  OBJETIVO:
    - Abrir queries na forma tradicional na base de dados
      para interação na própria query;
  *)

  rrActionReturn.sucesso  := True;
  rrActionReturn.mensagem := '';

  try
    if not Assigned(qry) then
      qry := TZQuery.Create(nil);

    qry.Connection := Conexao;
    qry.SQL.Text   := sql;
    qry.Open;

  except
    on E:Exception do
    begin
      rrActionReturn.sucesso := False;
      rrActionReturn.mensagem := 'ufuncoesdb_mysql.DML_ZEOS_OpemQuery()'
       +' - Não foi possível executar a consulta. Exceção: '+E.Message+'. SQL: '+sql;

      Logar(rrActionReturn.mensagem, Erro);
    end;
  end;
  result := rrActionReturn;
end;

function DML_ZEOS_ExecSQLQuery(var Conexao: TZConnection;
 sql: AnsiString; var qry: TZQuery): RActionReturn; overload;
var
  rrActionReturn : RActionReturn;
begin
  (*

  CRIADA POR: Eduardo

  OBJETIVO:
    - Abrir Excecutar na forma tradicional na base de dados
      para interação na própria query;
  *)

  rrActionReturn.sucesso  := True;
  rrActionReturn.mensagem := '';

  try
    if not Assigned(qry) then
      qry := TZQuery.Create(nil);

    qry.Connection := Conexao;
    qry.SQL.Text   := sql;
    qry.ExecSQL;

  except
    on E:Exception do
    begin
      rrActionReturn.sucesso := False;
      rrActionReturn.mensagem := 'ufuncoesdb_mysql.DML_ZEOS_OpemQuery()'
       +' - Não foi possível executar a consulta. Exceção: '+E.Message+'. SQL: '+sql;

      Logar(rrActionReturn.mensagem, Erro);
    end;
  end;
  result := rrActionReturn;
end;


function ZEOS_ExecutarQuery(var Conexao: TZConnection;
 sql: AnsiString; var aResultSet: aDynamicStringArray): RActionReturn; overload;
var
  qry: TZQuery;
  rrActionReturn: RActionReturn;
  i, j: integer;
  eOperacaoSQL: ESQLOperations;
begin
  (*

  CRIADA POR: Tiago Paranhos Lima

  OBJETIVO:
    - Executa queries na base de dados
     (Insert, Update, Delete, Create, etc...).

  OBS.:
    - Como iterar no resultset populado por esta função quando
      a query retorna só 1 coluna:

      for i:=0 to Length(aResultSet)-1 do
      begin
        sLinha := aResultSet[i][0];
      end;

  *)

  rrActionReturn.sucesso := True;
  rrActionReturn.mensagem := '';

  eOperacaoSQL := GetSQLOperationFromSQLString(sql);

  try
    qry := TZQuery.Create(nil);

    qry.Connection := Conexao;

    qry.SQL.Text := sql;

    case eOperacaoSQL of

      sopUnknown:
        begin
          //Não faz nada, apenas levanta uma exceção dizendo que não reconheceu a cláusula SQL passada

          aResultSet := nil;
        end;

      sopSelect, sopShow, sopDescribe:
        begin
          try
            qry.Open;

            SetLength(aResultSet,qry.RecordCount,qry.FieldCount);

            i := 0;
            while Not qry.Eof do
            begin
              for j:= 0 to qry.FieldCount - 1 do
              begin
                aResultSet[i,j] := qry.Fields[j].AsString;

                //Converte a codificação do MySQL (Ansi) para UTF-8 (default do lazarus):
                //aResultSet[i,j] := AnsiToUtf8(aresultset[i,j]);

                If aresultset[i,j] = '' then
                begin
                  aresultset[i,j] := '(empty)';
                end;
              end;
              Inc(i);
              qry.next;
            end;

            qry.Close;

          except
            on E:Exception do
            begin
              rrActionReturn.sucesso := False;

              rrActionReturn.mensagem := 'ufuncoesdb_mysql.ZEOS_ExecutarQuery()'
               +' - Não foi possível executar a consulta. Exceção: '+E.Message+'. SQL: '+sql;

              Logar(rrActionReturn.mensagem, Erro);
            end;

          end;

        end;

    else
      begin
        try
          qry.ExecSQL;

          aResultSet := nil;

        except
          on E:Exception do
          begin
            rrActionReturn.sucesso := False;

            rrActionReturn.mensagem := 'ufuncoesdb_mysql.ZEOS_ExecutarQuery()'
             +' - Não foi possível executar a consulta. Exceção: '+E.Message+'. SQL: '+sql;

            Logar(rrActionReturn.mensagem, Erro);

          end;

        end;
      end;
    end;



  finally
    if Assigned(qry) then
      FreeAndNil(qry);
  end;

  result := rrActionReturn;
end;

function  ExecutarScriptSQL(Con: TZConnection; nome_arquivo: string;
 APP_NAME: string): RActionReturn;
var
  sScript: string;
  slComandosSQL: TStringList;
  i: integer;
  sComandoAtual: string;
  eOperacaoSQL: ESQLOperations;
  aResultSet: aDynamicStringArray;
  sComandoSQLTemp, sNomeTabela, sNomeIndice: string;
  iPosPrimeiroEspaco: integer;
  iPosClausulaON: integer;
  rrRetorno: RActionReturn;
begin
  rrRetorno.sucesso := True;
  rrRetorno.mensagem := '';

  sScript := FileToString(nome_arquivo);

  //TODO: Rodar aqui o script para criar as tabelas.
  //      OBS.: Apenas se elas não existirem!

  //Elimina as quebras de linha (porque um comando SQL pode estar em várias linhas):
  sScript := StringReplace(sScript, #13#10, ' ', [rfReplaceAll, rfIgnoreCase]);

  //Tendo agora uma única string com o script, guarda cada comando SQL
  //em um registro de uma stringlist:
  try
    slComandosSQL := TStringList.Create;

    PopularStringListFromString(slComandosSQL, sScript, ';');

    sNomeTabela := '';
    sNomeIndice := '';

    for i:=0 to slComandosSQL.Count-1 do
    begin
      sComandoAtual := slComandosSQL[i];

      eOperacaoSQL  := GetSQLOperationFromSQLString(sComandoAtual);

      Logar('COMANDO ATUAL >>> ' + sComandoAtual);

      //Se for CREATE TABLE ou CREATE INDEX, verifica se a tabela já existe.
      //Só o roda o comando se a tabela não existir.
      case eOperacaoSQL of
        sopCreateDatabase:
          begin
            rrRetorno := ZEOS_ExecutarQuery(Con, sComandoAtual, aResultSet);
          end;

        sopCreateTable:
          begin
            //Pega o nome da tabela:
            sComandoSQLTemp := AnsiUpperCase(sComandoAtual);
            sComandoSQLTemp := TrimLeftRight(sComandoSQLTemp);
            sComandoSQLTemp := StringReplace(sComandoSQLTemp,
             'CREATE TABLE', '', [rfReplaceAll]);
            sComandoSQLTemp := TrimLeftRight(sComandoSQLTemp);
            iPosPrimeiroEspaco := pos(' ', sComandoSQLTemp);
            sNomeTabela := copy(sComandoSQLTemp, 1, iPosPrimeiroEspaco-1);

            if sNomeTabela = '__TABELA_LOG_APP__' then
            begin
              sComandoAtual := StringReplace(sComandoAtual, '__tabela_log_app__', AnsiLowerCase(APP_NAME), [rfReplaceAll, rfIgnoreCase]);
              sNomeTabela   := AnsiLowerCase(APP_NAME);
            end;

            if not GetTableExistsOnDatabase(Con, sNomeTabela) then
              rrRetorno := ZEOS_ExecutarQuery(Con, sComandoAtual, aResultSet);
          end;

        sopCreateIndex:
          begin
            //Pega o nome do índice:
            sComandoSQLTemp := AnsiUpperCase(sComandoAtual);
            sComandoSQLTemp := TrimLeftRight(sComandoSQLTemp);
            sComandoSQLTemp := StringReplace(sComandoSQLTemp,
             'CREATE INDEX', '', [rfReplaceAll]);
            sComandoSQLTemp := TrimLeftRight(sComandoSQLTemp);
            iPosPrimeiroEspaco := pos(' ', sComandoSQLTemp);
            sNomeIndice := copy(sComandoSQLTemp, 1, iPosPrimeiroEspaco-1);

            //TODO: CONTINUAR...
            iPosClausulaON := pos(' ON ', sComandoSQLTemp);
            sNomeTabela := copy(sComandoSQLTemp, iPosClausulaON+4, Length(sComandoSQLTemp));
            sNomeTabela := TrimLeftRight(sNomeTabela);
            iPosPrimeiroEspaco := pos(' ', sNomeTabela);
            sNomeTabela := copy(sNomeTabela, 1, iPosPrimeiroEspaco-1);

            if sNomeTabela = '__TABELA_LOG_APP__' then
            begin
              sComandoAtual := StringReplace(sComandoAtual, '__tabela_log_app__', AnsiLowerCase(APP_NAME), [rfReplaceAll, rfIgnoreCase]);
              sNomeTabela   := AnsiLowerCase(APP_NAME);

              sNomeIndice   := StringReplace(sNomeIndice, '__tabela_log_app__', sNomeTabela, [rfReplaceAll, rfIgnoreCase]);
            end;

            if not GetIndexExistsOnDatabaseTable(Con, sNomeTabela, sNomeIndice) then
              rrRetorno := ZEOS_ExecutarQuery(Con, sComandoAtual, aResultSet);
          end;
      end;
    end;

  finally
    if Assigned(slComandosSQL) then
      FreeAndNil(slComandosSQL);
  end;

  result := rrRetorno;
  
end;


end.

