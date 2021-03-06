// #INCLUDE "finr650.CH"  NOVO RELATORIO
#Include "PROTHEUS.CH"   

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Variaveis para tratamento dos Sub-Totais por Ocorrencia  �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
#DEFINE DESPESAS           3
#DEFINE DESCONTOS          4
#DEFINE ABATIMENTOS        5
#DEFINE VALORRECEBIDO      6			
#DEFINE JUROS              7
#DEFINE MULTA              8
#DEFINE VALORIOF           9
#DEFINE VALORCC	           10

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o    � CLI0001  � Autor � Eugenio Arcanjo       � Data � 04/10/05 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � Relacao de cliente com titulos em abertos                  낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿞intaxe   � CLI0001()                                                  낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
/*/
USER Function CLI0001()
Local wnrel
Local cString
Local cDesc1  := "Este programa tem como objetivo imprimir "
Local cDesc2  := "Relacao de clientes que estao com os "
Local cDesc3  := "titulos em aberto."
LOCAL tamanho := "G"

//旼컴컴컴컴컴컴컴컴커
//� Define Variaveis �
//읕컴컴컴컴컴컴컴컴켸
PRIVATE Titulo := OemToAnsi("Impressao de clientes com titulos em aberto ")
PRIVATE cabec1
PRIVATE cabec2
PRIVATE aReturn  := { OemToAnsi("Zebrado"), 1,OemToAnsi("Administracao"), 2, 2, 1, "",1 }
PRIVATE cPerg    := "FIN860"   , nLastKey := 0
PRIVATE nomeprog := "CLI0001"

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Verifica as perguntas selecionadas �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
pergunte(cPerg,.F.)
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Variaveis utilizadas para parametros                         �
//� mv_par01            // Do cliente                            �
//� mv_par02            // Ate o cliente                         �
//� mv_par03            // Da Loja                               �
//� mv_par04            // Ate a Loja						     �
//� mv_par05            // Da emissao 			                 �
//� mv_par06            // Ate a emissao                         �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

cString := "SE1"

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Envia controle para a funcao SETPRINT �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
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
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o    � FCLIENTE � Autor � EUGENIO ARCANJO       � Data � 04/10/05 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � Impress꼘 da Comunicacao Bancaria - Retorno                낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿞intaxe   � FA650Imp()                                                 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      � CLI0001                                                    낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
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


//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Variaveis utilizadas para Impressao do Cabecalho e Rodape    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
cbtxt    := SPACE(10)
cbcont   := 0
li       := 80
m_pag    := 1

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Definicao dos cabecalhos                                     �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

cabec1  := OemToAnsi("Nome                                       Endereco de cobranca                          CEP Cobranca             Municipio            Estado     ")
cabec2  := ""
//nTipo:=Iif(aReturn[4]==1,GetMv("MV_COMP"),GetMv("MV_NORM"))

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Busca tamanho do detalhe na configura뇙o do banco            �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

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
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
	//� Verifica codigo da ocorrencia �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
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




