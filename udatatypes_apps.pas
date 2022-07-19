unit udatatypes_apps;

{Unit que centraliza os tipos de dados customizados.}

interface

uses
  SysUtils, Variants, Classes;

type


  {OBS.: Se precisar retornar vários dados no campo "mensagem",
   usar "JSON" como retorno. }
  RActionReturn = record
    sucesso: boolean;
    mensagem: AnsiString;
  end;

  ETipoLog = (Normal, Warning, Erro, Debug);

  ESistemaOperacional = (soWindows, soLinux);

  EClassesCaracteresASCII = (asControle, asPontuacao, asMatematica, asAcentuacao, asNumeros,
   asCaracteres, asCaracteresAcentuados, asSimbolos, asGraficos);

  aDynamicStringArray = array of array of AnsiString;


  aString      = array of string;
  TStringArray = array of string;

  aStringArray = array of AnsiString;

  EDatasetModes = (Browsing, Editing, Inserting);

  EFileStreamAddMode = (amAppend, amRewrite);

  ESQLOperations = (sopInsert, sopUpdate, sopDelete,
   sopSelect, sopSelectIntoOutfile, sopLoadDataInfile,
   sopCreateTable, sopCreateDatabase, sopCreateIndex, sopShow,
   sopDescribe, sopProcedure, sopTrigger, sopUnknown);

  EModosExecucaoProgramas = (meDesenvolvimento, meProducao, meTestes);

  RConexao = record
    status    : Boolean;
    hostname  : string;
    user      : string;
    database  : string;
    password  : string;
    protocolo : string;
  end;

  RConfiguracoes = record
    path_origem_dos_arquiivos_de_log            : string;
    path_origem_dos_arquivos_de_prod            : string;
    path_backup_dos_arquiivos_de_log            : string;
    mascara_de_arquivo_prod                     : string;
    mascara_de_arquivo_log                      : string;
    nome_aplicacao                              : string;
    path_aplicacao                              : string;
    path_backup_dos_arquivos_de_prod            : string;
    path_destino_transferencia                  : string;
    aplicativo_para_zipar_arquivos              : string;
    tabela_de_historico_de_logs                 : string;
    nome_arquivo_script_para_criacao_de_tabelas : string;
  end;

  RJSONKeyPositions = record
    nome_chave: array of string;
    posicao: array of integer;
  end;

  RInfoArquivo = record
    Nome: array of string;
    Tamanho: array of double;
    Path: array of string;
  end;

  RIni = record
    path_conexoes : string;
    path_configuracoes : string;
    path_arquivos_temporarios : string;
    path_scripts_sql : string;
    path_outros_recursos : string;
  end;

  RDatabaseProperties = record
    Name: string;
    Host: string;
    User: string;
    Password: string;
    protocolo : string;
  end;

  RListaDeBases = array of RDatabaseProperties;

  RValidationErrorsList = record
    ids: array of string;
    messages: array of string;
    sltListaDeErros : TStringList;
  end;

  RValidationResult = record
    valid: boolean;
    validationErrorsList: RValidationErrorsList;
  end;

  RFile = record
    Tamanho: double;
    Unidade: string;
  end;

implementation



end.

