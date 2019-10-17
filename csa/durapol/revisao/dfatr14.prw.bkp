#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDfatr14   บ Autor ณ AP6 IDE            บ Data ณ  21/09/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Codigo gerado pelo AP6 IDE.                                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP6 IDE                                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function DFATR14


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1       := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2       := "de acordo com os parametros informados pelo usuario."
Local cDesc3       := "Diferencas de comissao"
Local cPict        := ""
Local titulo       := "Relatorio Comissao"
Local nLin         := 80
LOCAL aPergunta         :={}
LOCAL Cabec1       := "Dt.Baixa Titulo Prefixo Parc. Dt.Emissao Cliente Nome Cliente                                 Vlr.Faturado   Vlr.Baixado     Em Aberto       Em Atraso   %Comissao Vlr.comissao   Ok"
Local Cabec2       := ""
Local imprime      := .T.
Local aOrd := {}
Private lEnd       := .F.
Private lAbortPrint:= .F.
Private CbTxt      := ""
Private limite     := 132
Private tamanho    := "G"
Private nomeprog   := "DFATR14" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo      := 18
Private aReturn    := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey   := 0
Private cbtxt      := Space(10)
Private cbcont     := 00
PRIVATE cPerg      := "DFAT14"
Private CONTFL     := 01
Private m_pag      := 01
Private wnrel      := "DFATR14" 

Private cString := "SE1"

dbSelectArea("SE1")
dbSetOrder(1)


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

AAdd(aPergunta,{cPerg,"01","Da  Emissao?"    ,"Da  Data"       ,"Da  Data"       ,"mv_ch1","D", 8,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aPergunta,{cPerg,"02","Ate Emissao?"    ,"Ate Data"       ,"Ate Data"       ,"mv_ch2","D", 8,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aPergunta,{cPerg,"03","Da  Baixa ?"     ,"Da  Data"       ,"Da  Data"       ,"mv_ch3","D", 8,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aPergunta,{cPerg,"04","Ate Baixa ?"     ,"Ate Data"       ,"Ate Data"       ,"mv_ch4","D", 8,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aPergunta,{cPerg,"05","Do Vencimento?"  ,"Da  Data"       ,"Da  Data"       ,"mv_ch5","D", 8,0,0,"G","","mv_par05","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aPergunta,{cPerg,"06","Ate Vencimento ?","Ate Data"       ,"Ate Data"       ,"mv_ch6","D", 8,0,0,"G","","mv_par06","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(aPergunta,{cPerg,"07","Do  Vendedor?"   ,"Ate Data"       ,"Ate Data"       ,"mv_ch7","C", 6,0,0,"G","","mv_par07","","","","","","","","","","","","","","","","","","","","","","","","","SA3"})
AAdd(aPergunta,{cPerg,"08","Ate Vendedor?"   ,"Ate Data"       ,"Ate Data"       ,"mv_ch8","C", 6,0,0,"G","","mv_par08","","","","","","","","","","","","","","","","","","","","","","","","","SA3"})
AAdd(aPergunta,{cPerg,"09","Prefixo   ?"     ,"Ate Data"       ,"Ate Data"       ,"mv_ch9","C", 3,0,0,"G","","mv_par09","","","","","","","","","","","","","","","","","","","","","","","","",""})

ValidPerg(aPergunta,cPerg)

pergunte(cPerg,.F.)


wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,.T.,Tamanho,,.F.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
   Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Processamento. RPTSTATUS monta janela com a regua de processamento. ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณRUNREPORT บ Autor ณ AP6 IDE            บ Data ณ  21/09/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS บฑฑ
ฑฑบ          ณ monta a janela com a regua de processamento.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Programa principal                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

Local nOrdem
LOCAL aArqTrab        := {}
LOCAL nValBase  := nComissao3 := nComissao4 := nComissao5 := nPerComis1 :=nPerComis2 :=nPerComis3 := nPerComis4 := nPerComis5 := 0
LOCAL lDifVend3 := .F.
LOCAL lDifVend4 := .F.
LOCAL lDifVend5 := .F.
LOCAL nValComiV1:= 0
LOCAL nValComiV2:= 0
LOCAL nValComiV3:= 0
LOCAL nValComiV4:= 0
LOCAL nValComiV5:= 0
LOCAL lDifBase3  := lDifBase4  := lDifBase5  := .F.    
LOCAL lDifPer3   := lDifPer4   := lDifPer5   := .F. 
LOCAL aVendedores := {}
LOCAL nTtComis := 0
LOCAL nTotTit  := 0
LOCAL nTtBaixa := 0
LOCAL nTotSald := 0
LOCAL nTotAtra := 0
LOCAL nGrComis := 0
LOCAL nGrTit   := 0
LOCAL nGrBaixa := 0
LOCAL nGrSald  := 0
LOCAL nGrAtra  := 0


//-- CRIA ARQUIVO DE TRABALHO 
AAdd(aArqTrab,{"DATAB"  ,"D",8,0})   //-- Data Baixa
AAdd(aArqTrab,{"TITULO" ,"C",6,0})   //-- Titulo
AAdd(aArqTrab,{"PREFIXO","C",3,0})   //-- Prefixo
AAdd(aArqTrab,{"PARCELA","C",1,0})   //-- Parcela
AAdd(aArqTrab,{"DATAE"  ,"D",8,0})   //-- Data Emissao
AAdd(aArqTrab,{"DATAV"  ,"D",8,0})   //-- Data Vencimento
AAdd(aArqTrab,{"CLIENTE","C",6,0})   //-- Cliente
AAdd(aArqTrab,{"LOJA"   ,"C",2,0})   //-- Loja
AAdd(aArqTrab,{"NOME"   ,"C",25,0})  //-- Nome
AAdd(aArqTrab,{"VENDCLI","C",6,0})   //-- Vendedor do Cliente
AAdd(aArqTrab,{"VENDTIT","C",6,0})   //-- Vendedor Titulo
AAdd(aArqTrab,{"VALTIT" ,"N",17,2})  //-- Valor Titulo
AAdd(aArqTrab,{"SALDO"  ,"N",17,2})  //-- Valor de Saldo
AAdd(aArqTrab,{"VALLIQ" ,"N",17,2})  //-- Valor Liquido da baixa
AAdd(aArqTrab,{"BASE"   ,"N",17,2})  //-- Base Comissao
AAdd(aArqTrab,{"PCOMIS" ,"N",5,2})   //-- Percentual de comissao
AAdd(aArqTrab,{"PVEND"  ,"N",5,2})   //-- Percentual do vendedor
AAdd(aArqTrab,{"VLCOMIS","N",17,2})  //-- Valor da Comissao
AAdd(aArqTrab,{"CONFERE","C",2,0})  //-- Confere

cArqTrab := CriaTrab(aArqTrab,.T.)
dbUseArea(.t.,,cArqTrab,"TRB",)

dbSelectArea("TRB")
IndRegua("TRB",cArqTrab,"TRB->VENDCLI+DTOS(TRB->DATAB)",,,"Criando Arquivo de Trabalho...")


_cQry :="SELECT E1_BAIXA, E1_SALDO, E1_MULTA, E1_JUROS, E1_NUM, E1_PREFIXO, E1_EMISSAO, E1_CLIENTE, E1_LOJA, E1_VALOR, E1_VALLIQ, E1_VEND1, E1_VEND2, E1_VEND3, E1_VEND4, E1_VEND5, E1_PARCELA, E1_VENCREA "
_cQry +="FROM " + RetSqlName("SE1")+ " SE1 "
_cQry +="WHERE E1_EMISSAO >= '" + DTOS(mv_par01) + "' and E1_EMISSAO <= '" + DTOS(mv_par02) + "' "
_cQry +="    and ( ( E1_BAIXA >= '" + DTOS(mv_par03) + "' and E1_BAIXA <=  '" + DTOS(mv_par04) + "' )  "
_cQry +="    or  E1_BAIXA = '        ' ) "
_cQry +="    and E1_VENCREA BETWEEN '" + DTOS(mv_par05)+ "' and '" + DTOS(mv_par06) + "'  "
_cQry +="    and E1_PREFIXO = '" + mv_par09 + "' "
_cQry +="    and SE1.D_E_L_E_T_ = '' "

_cQry := ChangeQuery(_cQry)
memowrite("dfatr14.sql",_cQry)
dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQry),"TRBSE1",.F.,.T.)

TcSetField("TRBSE1", "E1_EMISSAO", "D")
TcSetField("TRBSE1", "E1_BAIXA"  , "D")
TcSetField("TRBSE1", "E1_VENCREA", "D")

dbSelectArea("TRBSE1")
dbGoTop()
ProcRegua(RecCount())

SA1->(dbSetOrder(1))
SA3->(dbSetOrder(1))
SE3->(dbSetOrder(2))
SD2->(dbSetOrder(3))

While !EOF()

	SA1->(dbSeek(xFilial("SA1")+TRBSE1->E1_CLIENTE+TRBSE1->E1_LOJA))	
	
	SA3->(dbSeek(xFilial("SA3")+SA1->A1_VEND)) 
	
	nValComiV1 := SA3->A3_COMIS
	
	lDifVend1 := SA1->A1_VEND <> TRBSE1->E1_VEND1
	
	
	SA1->(dbSeek(xFilial("SA1")+TRBSE1->E1_CLIENTE+TRBSE1->E1_LOJA))	
	
	SA3->(dbSeek(xFilial("SA3")+SA1->A1_VEND2)) 
	
	nValComiV1 := SA3->A3_COMIS
	
	lDifVend1 := SA1->A1_VEND2 <> TRBSE1->E1_VEND2
	
	
	SA1->(dbSeek(xFilial("SA1")+TRBSE1->E1_CLIENTE+TRBSE1->E1_LOJA))	
	
	SA3->(dbSeek(xFilial("SA3")+SA1->A1_VEND3)) 
	
	nValComiV3 := SA3->A3_COMIS
	
	lDifVend3 := SA1->A1_VEND3 <> TRBSE1->E1_VEND3
	
	
	SA3->(dbSeek(xFilial("SA3")+SA1->A1_VEND4))
	
	nValComiV4 := SA3->A3_COMIS
	
	lDifVend4 := SA1->A1_VEND4 <> TRBSE1->E1_VEND4
	
	SA3->(dbSeek(xFilial("SA3")+SA1->A1_VEND5))
	
	nValComiV5 := SA3->A3_COMIS
	
	lDifVend5 := SA1->A1_VEND5 <> TRBSE1->E1_VEND5
	    
	SD2->(dbSeek(xFilial("SD2")+TRBSE1->E1_NUM)) 
	
	While !Eof() .and. xFilial("SD2")== SD2->D2_FILIAL .and. TRBSE1->E1_NUM == SD2->D2_DOC
		nPerComis1:= SD2->D2_COMIS1
		nPerComis2:= SD2->D2_COMIS2
		nPerComis3:= SD2->D2_COMIS3
		nPerComis4:= SD2->D2_COMIS4
		nPerComis5:= SD2->D2_COMIS5
		dbSelectArea("SD2")
		SD2->( dbSkip() )
	EndDo
	
	lDifPer1 := IIF( nValComiV3 == 0, nPerComis1,nValComiV1)
	lDifPer2 := IIF( nValComiV2 == 0, nPerComis1,nValComiV2)
	lDifPer3 := IIF( nValComiV3 == 0, nPerComis3,nValComiV3)
	lDifPer4 := IIF( nValComiV4 == 0, nPerComis4,nValComiV4)
	lDifPer5 := IIF( nValComiV5 == 0, nPerComis5,nValComiV5)
	
	IF !Empty(TRBSE1->E1_VEND1)
		aAdd(aVendedores,{SA1->A1_VEND,TRBSE1->E1_VEND1,lDifPer1})
	ElseIF !Empty(SA1->A1_VEND)
		aAdd(aVendedores,{SA1->A1_VEND,"",lDifPer1})	
	EndIF
	
	IF !Empty(TRBSE1->E1_VEND2)
		aAdd(aVendedores,{SA1->A1_VEND2,TRBSE1->E1_VEND2,lDifPer2})
	ElseIF !Empty(SA1->A1_VEND2)
		aAdd(aVendedores,{SA1->A1_VEND2,"",lDifPer2})	
	EndIF
		
	IF !Empty(TRBSE1->E1_VEND3)
		aAdd(aVendedores,{SA1->A1_VEND3,TRBSE1->E1_VEND3,lDifPer3})
	ElseIF !Empty(SA1->A1_VEND3)
		aAdd(aVendedores,{SA1->A1_VEND3,"",lDifPer3})
	EndIF
	
	IF !Empty(TRBSE1->E1_VEND4)
		aAdd(aVendedores,{SA1->A1_VEND4,TRBSE1->E1_VEND4,lDifPer4})
	ElseIF !Empty(SA1->A1_VEND4)
		aAdd(aVendedores,{SA1->A1_VEND4,"",lDifPer3})	
	EndIF
	
	IF !Empty(TRBSE1->E1_VEND5)
		aAdd(aVendedores,{SA1->A1_VEND5,TRBSE1->E1_VEND5,lDifPer5})		
	ElseIF !Empty(SA1->A1_VEND5)
		aAdd(aVendedores,{SA1->A1_VEND5,"",lDifPer5})
	EndIF
	
	dbSelectArea("TRB")
	For i:= 1 To Len(aVendedores)
		IF aVendedores[i,1] >= mv_par07 .and. aVendedores[i,1] <= mv_par08
			RecLock("TRB",.T.)
				TRB->VENDCLI := IIF(Empty(aVendedores[i,1]),aVendedores[i,2],aVendedores[i,1])   //-- Vendedor Titulo Vendedor do Cliente
				TRB->DATAB   := TRBSE1->E1_BAIXA    //-- Data Baixa
				TRB->DATAV   := TRBSE1->E1_VENCREA //-- Data Vencimento
				TRB->TITULO  := TRBSE1->E1_NUM     //-- Titulo
				TRB->PREFIXO := TRBSE1->E1_PREFIXO //-- Prefixo
				TRB->PARCELA := TRBSE1->E1_PARCELA //-- Parcela
				TRB->DATAE   := TRBSE1->E1_EMISSAO //-- Data Emissao
				TRB->CLIENTE := TRBSE1->E1_CLIENTE //-- Cliente
				TRB->LOJA    := TRBSE1->E1_LOJA    //-- Loja
				TRB->VALTIT	 := TRBSE1->E1_VALOR   //-- Valor Titulo
				TRB->VALLIQ	 := TRBSE1->E1_VALLIQ  //-- Valor liquido da baixa
				TRB->SALDO   := TRBSE1->E1_SALDO   //-- Saldo
				TRB->PVEND   := aVendedores[i,3]   //-- Percentual do vendedor
				TRB->VLCOMIS := TRBSE1->E1_VALLIQ * aVendedores[i,3] / 100 //aVendedores[i,5]  //-- Valor da Comissao
				TRB->CONFERE := IIF (!Empty(aVendedores[i,1]) .and. !Empty(aVendedores[i,2]).and. aVendedores[i,1] == aVendedores[i,2] ,"OK","")
			MsUnlock()
		ElseIF aVendedores[i,2] >= mv_par07 .and. aVendedores[i,2] <= mv_par08
			RecLock("TRB",.T.)
				TRB->VENDCLI := IIF(Empty(aVendedores[i,1]),aVendedores[i,2],aVendedores[i,1])   //-- Vendedor Titulo Vendedor do Cliente
				TRB->DATAB   := TRBSE1->E1_BAIXA    //-- Data Baixa
				TRB->DATAV   := TRBSE1->E1_VENCREA //-- Data Vencimento				
				TRB->TITULO  := TRBSE1->E1_NUM     //-- Titulo
				TRB->PREFIXO := TRBSE1->E1_PREFIXO //-- Prefixo
				TRB->PARCELA := TRBSE1->E1_PARCELA //-- Parcela
				TRB->DATAE   := TRBSE1->E1_EMISSAO //-- Data Emissao
				TRB->CLIENTE := TRBSE1->E1_CLIENTE //-- Cliente
				TRB->LOJA    := TRBSE1->E1_LOJA    //-- Loja
				TRB->VALTIT	 := TRBSE1->E1_VALOR   //-- Valor Titulo
				TRB->VALLIQ	 := TRBSE1->E1_VALLIQ  //-- Valor liquido da baixa
				TRB->SALDO   := TRBSE1->E1_SALDO   //-- Saldo				
				TRB->PVEND   := aVendedores[i,3]   //-- Percentual do vendedor
				TRB->VLCOMIS := TRBSE1->E1_VALLIQ * aVendedores[i,3] / 100 //aVendedores[i,5]  //-- Valor da Comissao
				TRB->CONFERE := IIF (!Empty(aVendedores[i,1]) .and. !Empty(aVendedores[i,2]).and. aVendedores[i,1] == aVendedores[i,2] ,"OK","")
			MsUnlock()		
		EndIF	
	Next i
	
	aVendedores := {}
	
	nPerComis1 := nPerComis2 := nPerComis3 := nPerComis4 := nPerComis5 := 0
	nValComiV1 := nValComiV2 := nValComiV3 := nValComiV4 := nValComiV5 := 0
	nComissao3 := nComissao4 := nValComiV5 := nValBase:= 0
	lDifVend1  := lDifVend2  := lDifVend3  := lDifVend4  := lDifVend5  := .F.
	lDifBase1  := lDifBase2  := lDifBase3  := lDifBase4  := lDifBase5  := .F.    
	lDifPer1   := lDifPer2   := lDifPer3   := lDifPer4   := lDifPer5   := .F. 

	dbSelectArea("TRBSE1")
	TRBSE1->( dbSkip() )
EndDo


TRBSE1->(dbCloseArea())

dbSelectArea("TRB")
dbGotop()
 
cVend    := ""
While !Eof()

 	IF lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	EndIF

	IF nLin > 55 
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
	Endif
	/*
	IF TRB->VENDCLI  <= mv_par07 .and. TRB->VENDCLI >= mv_par08
		dbSelectArea("TRB")
		dbSkip()
	EndIF
	*/
	
/*
         10     17      25    31         42      50                                        92             107            122            137              154    161            176
Dt.Baixa Titulo Prefixo Parc. Dt.Emissao Cliente Nome Cliente                              Vlr.Faturado   Vlr.Baixado     Em Aberto       Em Atraso   %Comissao Vlr.comissao   Ok"
99/99/99 999999 XXX     X     99/99/99   XXXXXX  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX  99,999,999.99  99,999,999.99  99,999,999.99  99,999.999,99    999    999.999.999,99 
*/

	IF cVend != TRB->VENDCLI
		@nLin,001 PSAY "Vendedor : "+ TRB->VENDCLI +"  " + Posicione("SA3",1,xFilial("SA3")+TRB->VENDCLI,"A3_NREDUZ")
		cVend := TRB->VENDCLI
		nLin += 2
	EndIF
	
	@nLin,001 PSAY TRB->DATAB
	@nLin,010 PSAY TRB->TITULO    			
	@nLin,017 PSAY TRB->PREFIXO 
	@nLin,025 PSAY TRB->PARCELA
	@nLin,031 PSAY TRB->DATAE
	@nLin,042 PSAY TRB->CLIENTE	
	@nLin,050 PSAY Alltrim( Substr( Posicione("SA1",1,xFilial("SA1")+TRB->CLIENTE + TRB->LOJA,"A1_NOME"),1,40) )
	@nLin,092 PSAY TRB->VALTIT  PICTURE "@E 99,999,999.99"
	@nLin,107 PSAY TRB->VALLIQ  PICTURE "@E 99,999,999.99"
	@nLin,122 PSAY TRB->SALDO	PICTURE "@E 99,999,999.99"
	IF dDataBase - TRB->DATAV > 0
		@nLin,137 PSAY TRB->SALDO PICTURE "@E 99,999,999.99"
	Else
		@nLin,137 PSAY 0 PICTURE "@E 99,999,999.99"
	EndIF	
	@nLin,154 PSAY TRB->PVEND   PICTURE "@E 99.99"
	@nLin,161 PSAY TRB->VLCOMIS	PICTURE "@E 99,999,999.99"
	@nLin,178 PSAY TRB->CONFERE

	nTtComis += TRB->VLCOMIS
	nGrComis += TRB->VLCOMIS
	
	nTotTit  += TRB->VALTIT
	nGrTit   += TRB->VALTIT
	
	nTtBaixa += TRB->VALLIQ
	nGrBaixa += TRB->VALLIQ
	
	nTotSald += TRB->SALDO
	nGrSald += TRB->SALDO
	
	nTotAtra += TRB->SALDO
	nGrAtra += TRB->SALDO

	
	nLin ++
		
	TRB->( dbSkip() )
	
	IF cVend != TRB->VENDCLI
		nLin ++	
		@nLin,001 Psay "SubTotal Comissao: "
		@nLin,092 PSAY nTotTit   PICTURE "@E 99,999,999.99"
		@nLin,107 PSAY nTtBaixa  PICTURE "@E 99,999,999.99"
		@nLin,122 PSAY nTotSald  PICTURE "@E 99,999,999.99"
		@nLin,137 PSAY nTotAtra  PICTURE "@E 99,999,999.99"		
		@nLin,161 PSAY nTtComis  Picture "@E 999,999,999.99"
		
		nTotTit  := 0
		nTtBaixa := 0
		nTotSald := 0
		nTtComis := 0
		nTotAtra := 0
		
		nLin ++
		
		cVend := TRB->VENDCLI
		IF !Empty(TRB->VENDCLI)
			nLin ++
			@nLin,001 PSAY "Vendedor : "+ TRB->VENDCLI + "  " + Posicione("SA3",1,xFilial("SA3")+TRB->VENDCLI,"A3_NREDUZ")
			nLin += 2	
		EndIF
	EndIF	
	
EndDo

If nGrTit > 0
	IF nLin > 60
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	EndIF
	nLin ++
	@nLin,001 PSAY "Total Geral: "
	@nLin,092 PSAY nGrTit   PICTURE "@E 99,999,999.99"
	@nLin,107 PSAY nGrBaixa PICTURE "@E 99,999,999.99"
	@nLin,122 PSAY nGrSald  PICTURE "@E 99,999,999.99"
	@nLin,137 PSAY nGrAtra  PICTURE "@E 99,999,999.99"
	@nLin,161 PSAY nGrComis Picture "@E 99,999,999.99"
		
	Roda(cbcont,cbtxt,"G")
Endif


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Finaliza a execucao do relatorio...                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
dbSelectArea("TRB")
dbCloseArea("TRB")
FErase(cArqTRAB+OrdBagExt())


SET DEVICE TO SCREEN

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

If aReturn[5]==1
   dbCommitAll()
   SET PRINTER TO
   OurSpool(wnrel)
Endif

MS_FLUSH()

Return
