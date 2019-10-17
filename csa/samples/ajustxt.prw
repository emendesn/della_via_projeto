///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | Le_Arq_Txt.prw       | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - u_LeArqTxt()                                           |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Este programa importa dados de arquivo texto                    |//
//+-----------------------------------------------------------------------------+//
//| MANUTENCAO DESDE SUA CRIACAO                                                |//
//+-----------------------------------------------------------------------------+//
//| DATA     | AUTOR                | DESCRICAO                                 |//
//+-----------------------------------------------------------------------------+//
//|          |                      |                                           |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////

/******
ESTRUTURA DO ARQUIVO TEXTO -> CLIENTE.TXT
0        1         2         3         4         5         6         7         8         9         100
1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

X90001AAMICROSIGA SOFTWARE SA         MICROSIGA      SP100000           2802200268293976000133
X90002AABARBER GREEN LTDA - MUNDIAL   BARBER GREEN   RJ197422           3112200253113791000122
X90003AAJUND SONDAS SOFISTICAO BRASIL JUND-SONDAS    AM888899           2303200257507378000101

123456  -> CODIGO
      12  -> LOJA
        123456789012345678901234567890  -> NOME COMPLETO
                                      123456789012345  -> NOME REDUZIDO
                                                     12  -> ESTADO
                                                       12345678901234567  -> VALOR ULT. COMPRA
                                                                        12345678  -> DATA ULT. COMPRA
                                                                                12345678901234  -> CGC
*/                                                                      

#INCLUDE "PROTHEUS.CH"
#INCLUDE "fileio.ch"

USER FUNCTION Ajustxt()
Local   cPerg     := "IMPORT"
Private nOpc      := 0
Private cCadastro := "Importação de dados."
Private aSay      := {}
Private aButton   := {}

aAdd( aSay, "Esta rotina irá ler um arquivo texto e gravar log de inconsistencias." )

aAdd( aButton, { 1,.T.,{|| nOpc := 1,FechaBatch()}})
aAdd( aButton, { 2,.T.,{|| FechaBatch() }} )

FormBatch( cCadastro, aSay, aButton )

If nOpc == 1
	Processa( {|| Import() }, "Processando..." )
Endif

Return

///////////////////////////////////////////////////////////////////////////////////
//+-----------------------------------------------------------------------------+//
//| PROGRAMA  | Le_Arq_Txt.prw       | AUTOR | Robson Luiz  | DATA | 18/01/2004 |//
//+-----------------------------------------------------------------------------+//
//| DESCRICAO | Funcao - Import()                                               |//
//|           | Fonte utilizado no curso oficina de programacao.                |//
//|           | Funcao de importacao de dados                                   |//
//+-----------------------------------------------------------------------------+//
//| MANUTENCAO DESDE SUA CRIACAO                                                |//
//+-----------------------------------------------------------------------------+//
//| DATA     | AUTOR                | DESCRICAO                                 |//
//+-----------------------------------------------------------------------------+//
//|          |                      |                                           |//
//+-----------------------------------------------------------------------------+//
///////////////////////////////////////////////////////////////////////////////////
STATIC FUNCTION Import()
Local cBuffer   := ""
Local aDados    := {}
Local lOk       := .T.
Local aMatA030  := {}

Private lMsHelpAuto := .T.
Private lMsErroAuto := .F.

DbSelectArea("SA1")
DbSetOrder(3)

If !File("CLIENTE.TXT")
   MsgAlert("Arquivo texto: CLIENTE.TXT não localizado",cCadastro)
   Return
Endif

_lHandle := Fcreate("CLILIB.TXT", FC_NORMAL)

FT_FUSE("CLIENTE.TXT")
FT_FGOTOP()
ProcRegua(FT_FLASTREC())

While !FT_FEOF()
   IncProc()

   // Capturar dados
   cBuffer := FT_FREADLN()
   _cCGC  := Substr(cBuffer,336,14)
   _cNome := Substr(cBuffer,16,40)
   
   DbSelectArea("SA1")
   If DbSeek(xFilial("SA1")+_cCGC, .f.)
      MsgAlert("Cliente ja existe com esse CNPJ/CPF"+_cNome,cCadastro)
      FT_FSKIP()
      Loop
   Endif
   
   If ! CGC(_cCGC)
      MsgAlert("CGC inválido ["+_cCGC+"] nome "+_cNome,cCadastro)
      FT_FSKIP()
      Loop
   Endif
        
   cBuffer := cBuffer+chr(13)+chr(10)
   If FWrite(_lHandle, cBuffer, len(cBuffer)) < len(cBuffer)
      MsgAlert("Erro de gravacao")
   Endif
      
   FT_FSKIP()   
EndDo

FT_FUSE()
FClose(_lHandle)

MostraErro()

MsgInfo("Processo finalizada")

Return
