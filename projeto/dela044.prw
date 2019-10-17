#INCLUDE "protheus.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDELA044   บ Autor ณNorbert Waage Juniorบ Data ณ  12/08/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณRotina responsavel pelo tratamento de descontos no televen- บฑฑ
ฑฑบ          ณdas, respeitando o desconto estabelecido no cadastro de     บฑฑ
ฑฑบ          ณoperadores                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณNao se aplica                                               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณlRet - (.T.) Valida a alteracao do desconto sempre, pois    บฑฑ
ฑฑบ          ณa negacao permite que se retorne ao valor antigo, caso o    บฑฑ
ฑฑบ          ณusuario pressione ESC.                                      บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณRotina acionada apos a digitacao do desconto ou do valor do บฑฑ
ฑฑบ          ณdesconto.                                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ 13797 - Della Via Pneus                                    บฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณBops  ณManutencao Efetuada                   	  บฑฑ
ฑฑบ          ณ        ณ      ณ                                            บฑฑ
ฑฑศออออออออออฯออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Project Function DELA044()

Local aArea		:= GetArea()
Local lRet 		:= .T.
Local nDesc		:= 0
Local nVlrDesc	:= 0
Local nVlrItem	:= 0
Local nQuant	:= 0
Local nDescAtu	:= aCols[N,aScan(aHeader,{|x| AllTrim(x[2]) == "UB_VALDESC"})]

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณLe desconto do operadorณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nDesc := GetAdvFVal("SU7","U7_PERDESC",xFilial("SU7")+TkOperador(),1,0)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSe a rotina foi acionada pelo valor de descontoณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If AllTrim(ReadVar()) == "M->UB_VALDESC"

	nVlrItem	:= aCols[N,aScan(aHeader,{|x| AllTrim(x[2]) == "UB_VLRITEM"})]
	nQuant		:= aCols[N,aScan(aHeader,{|x| AllTrim(x[2]) == "UB_QUANT"})]
	nVlrDesc 	:= &(ReadVar())
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณSe o desconto for maior que o permitido, zera variaveisณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If !(lRet :=  (nVlrDesc/((nVlrItem + nDescAtu))) * 100 <= nDesc )
		aCols[N,aScan(aHeader,{|x| AllTrim(x[2]) == "UB_VALDESC"})] := 0
		aCols[N,aScan(aHeader,{|x| AllTrim(x[2]) == "UB_DESC"})] := 0
		M->UB_VALDESC := 0
		TK273Calcula("UB_VALDESC")
	EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณSe a rotina foi acionada pelo % de desconto ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
ElseIf AllTrim(ReadVar()) == "M->UB_DESC"    

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณSe o desconto for maior que o permitido, zera variaveisณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	If !(lRet := &(ReadVar()) <= nDesc )
		aCols[N,aScan(aHeader,{|x| AllTrim(x[2]) == "UB_VALDESC"})] := 0
		aCols[N,aScan(aHeader,{|x| AllTrim(x[2]) == "UB_DESC"})] := 0
		M->UB_DESC := 0
		Tk273Calcula("UB_DESC")
	EndIf

EndIf

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณNotifica o usuario e retorna .T.                               ณ
//ณ*NOTA: Se a rotina retornar .F., o campo selecionado permitira ณ
//ณque pressione-se ESC, retornando ao valor de desconto anterior,ณ
//ณporem sem que este tenha sido aplicado aos valores             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
If !lRet                                                                                                
	MsgAlert("O desconto aplicado ้ maior do que o desconto permitido para o operador atual","Desconto")
	oGetTlv:oBrowse:Refresh()
	lRet := .T.
EndIf

RestArea(aArea)

Return lRet