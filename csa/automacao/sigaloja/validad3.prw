#INCLUDE "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValidaD3  บAutor  ณMarcelo Alcantara   บ Data ณ  16/12/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออุออออออออัอออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Validacao do Campo D3_COD da Tela de Tranf entre armazens  บฑฑ
ฑฑบ          ณ MATA261 para nao deixar o usuario trocar codigo de destino บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ  Nao se aplica                                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ lRet - .T. - D3_COD da origem = D3_COD Destino             บฑฑ
ฑฑบ          ณ        .F. - D3_COD da origem <> D3_COD Destino            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Validacao de Usuario do campo SD3->D3_COD                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ 13797 - Dellavia Pneus                                     บฑฑ
ฑฑฬออออออออออุออออออออัอออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณManutencao Efetuada                          	  บฑฑ
ฑฑศออออออออออฯออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ValidaD3()
Local aArea		:= GetArea()
Local lRet		:= .T.
Local nPosd3	:= aScan(aHeader,{|x| AllTrim(x[2]) == AllTrim("D3_COD") }) //Posicao do campo D3_COD

If FunName() = "MATA261"					//Se For MATA261
	If oGet:oBrowse:ColPos <> nPosd3		//Pega Posicao da coluna no acols atual		
		If &(Readvar()) <> acols[n][nPosd3]	//Se o valor digitado no cod de destino for <> na origem 
			msgBox(" O Codigo de Origem e Destino nao podem ser diferentes ")
			lRet:= .F.
		ENDIF
	Else
		acols[n][6]:= &(Readvar())			//Preenche o Acols de Codigo de Destino com o mesmo valod do de origem
	EndIf
EndIf

RestArea(aArea)		//Restaura area
Return lRet
