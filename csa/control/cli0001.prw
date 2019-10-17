// #INCLUDE "finr650.CH"  NOVO RELATORIO
#Include "PROTHEUS.CH"   

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis para tratamento dos Sub-Totais por Ocorrencia  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#DEFINE DESPESAS           3
#DEFINE DESCONTOS          4
#DEFINE ABATIMENTOS        5
#DEFINE VALORRECEBIDO      6			
#DEFINE JUROS              7
#DEFINE MULTA              8
#DEFINE VALORIOF           9
#DEFINE VALORCC	           10

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ CLI0001  ³ Autor ³ Eugenio Arcanjo       ³ Data ³ 04/10/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Relacao de cliente com titulos em abertos                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ CLI0001()                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
/*/
USER Function CLI0001()
Local wnrel
Local cString
Local cDesc1  := "Este programa tem como objetivo imprimir "
Local cDesc2  := "Relacao de clientes que estao com os "
Local cDesc3  := "titulos em aberto."
LOCAL tamanho := "G"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
PRIVATE Titulo := OemToAnsi("Impressao de clientes com titulos em aberto ")
PRIVATE cabec1
PRIVATE cabec2
PRIVATE aReturn  := { OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 2, 2, 1, "",1 }
PRIVATE cPerg    := "FIN860"   , nLastKey := 0
PRIVATE nomeprog := "CLI0001"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte(cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01            // Do cliente                            ³
//³ mv_par02            // Ate o cliente                         ³
//³ mv_par03            // Da Loja                               ³
//³ mv_par04            // Ate a Loja						     ³
//³ mv_par05            // Da emissao 			                 ³
//³ mv_par06            // Ate a emissao                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cString := "SE1"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "CLI0001"            //Nome Default do relatorio em Disco
wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

If nLastKey == 27
    Return
End

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

RptStatus({|lEnd| U_FCLIENTE(@lEnd,wnRel,cString)},Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FCLIENTE ³ Autor ³ EUGENIO ARCANJO       ³ Data ³ 04/10/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Impress„o da Comunicacao Bancaria - Retorno                ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ FA650Imp()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ CLI0001                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
USER Function FCLIENTE(lEnd,wnRel,cString)

Local cPosPrin,cPosJuro,cPosMult,cPosCC ,cPosTipo
Local cPosNum ,cPosData,cPosDesp,cPosDesc,cPosAbat,cPosDtCC,cPosIof,cPosOcor 
Local cPosNosso, cPosForne, cPosCgc
Local lPosNum  := .f. , lPosData := .f. , lPosAbat := .f.
Local lPosDesp := .f. , lPosDesc := .f. , lPosMult := .f.
Local lPosPrin := .f. , lPosJuro := .f. , lPosDtCC := .f.
Local lPosOcor := .f. , lPosTipo := .f. , lPosIof  := .f.
Local lPosCC   := .f. , lPosNosso:= .f. , lPosRej	:= .f.
Local lPosForne:=.f. , lPosCgc := .F.
Local nLidos ,nLenNum  ,nLenData ,nLenDesp ,nLenDesc ,nLenAbat ,nLenDtCC, nLenCGC
Local nLenPrin ,nLenJuro ,nLenMult ,nLenOcor ,nLenTipo ,nLenIof  ,nLenCC
Local nLenRej := 0
Local ntamrej_ := 0
Local cArqConf ,cArqEnt  ,xBuffer  ,nTipo
Local tamanho   := "G", lOcorr := .F.
Local cDescr
LOCAL cEspecie,cData,nTamArq,cForne,cCgc
Local nValIof	:= 0
Local nDespT:=nDescT:=nAbatT:=nValT:=nJurT:=nMulT:=nIOFT:=nCCT:=0
Local nHdlBco  := 0
Local nHdlConf := 0
Local cTabela 	:= "17"
Local lRej := .f.
Local cCarteira
Local nTamDet
Local lHeader := .f.
Local lTrailler:= .F.
Local aTabela 	:= {}
Local cChave650
Local nPos := 0
Local lAchouTit := .F.
Local nValPadrao := 0
Local aValores := {}
Local nCont
Local lOk
Local x
Local nCntOco  := 0
Local aCntOco  := {}
Local cCliFor	:= "  "

PRIVATE m_pag , cbtxt , cbcont , li 

//Essas variaveis tem que ser private para serem manipuladas
//nos pontos de entrada, assim como eh feito no FINA200

//eugenio 
Private cNomeCli
Private cEnd
Private cCEP
Private cMunic
Private CUF
//eugenio


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Impressao do Cabecalho e Rodape    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cbtxt    := SPACE(10)
cbcont   := 0
li       := 80
m_pag    := 1

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao dos cabecalhos                                     ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

cabec1  := OemToAnsi("Nome                                       Endereco de cobranca                          CEP Cobranca             Municipio            Estado     ")
cabec2  := ""
//nTipo:=Iif(aReturn[4]==1,GetMv("MV_COMP"),GetMv("MV_NORM"))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Busca tamanho do detalhe na configura‡„o do banco            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbselectarea("SA1")
//dbsetorder(1)


dbSelectArea("SE1")
//dbsetorder(2) 
//dbSeek(xFilial("SE1")+SA1->A1_COD, .F.)

While !Eof() .And. SE1->E1_CLIENTE >= mv_par01 .And. SE1->E1_CLIENTE <= mv_par02 ;
             .AND. SE1->E1_LOJA >= MV_PAR03 .AND. SE1->E1_LOJA <= MV_PAR04 ;
             .AND. SE1->E1_EMISSAO >= MV_PAR05 .AND. SE1->E1_EMISSAO <= MV_PAR06 ;
             .AND. SE1->E1_CLIENTE == SA1->A1_COD  .AND. EMPTY(SE1->E1_DTBAIXA)  

    cNomeCli := SA1->A1_NOME
    cEnd     := SA1->A1_END
    cCEP     := SA1->A1_CEP 
    cMunic   := SA1->A1_MUN
    cUF      := SA1->A1_EST
	@li,000 PSAY cNomeCli
	@li,042 PSAY cEnd
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica codigo da ocorrencia ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	@li,082 PSAY cCEP	
	@li,100 PSAY cMunic
	@li,130 PSAY cUF  
	li++    




IF lEnd
   @ PROW()+1, 001 PSAY "CANCELADO PELO OPERADOR" 
   Exit
End

IF li > 58
	cabec(Titulo+' - '+mv_par01,cabec1,cabec2,nomeprog,tamanho,nTipo)
End


dbskip()
enddo

Set Device TO Screen
Set Filter To

If aReturn[5] = 1
    Set Printer To
    dbCommit()
    Ourspool(wnrel)
End
MS_FLUSH()
Return




