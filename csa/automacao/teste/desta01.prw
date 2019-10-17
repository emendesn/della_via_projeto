#Include "Protheus.Ch"
#include "TBICONN.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ DELA052  บAutor  ณAnderson            บ Data ณ  23/09/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออุออออออออัอออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบLocacao   ณ Fab.Tradicional  ณContato ณ andkurt@microsiga.com.br       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออฯออออออออฯออออออออออออออออออออออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina utilizada para DELETAR do banco de dados registros  บฑฑ
ฑฑบ          ณ da tabela SYP que estiverem relacionados com o campo       บฑฑ
ฑฑบ          ณ A1_CODHIST do cliente padrao (Obtido do MV_CLIPAD).        บฑฑ
ฑฑบ          ณ Nao sera utilizado o dbdelete e sim uma query com o DELETE บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ cParam =  Nil --> Executado via menu                       บฑฑ
ฑฑบ          ณ cParam <> Nil --> Executado via Job                        บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบObservacaoณ Nao se aplica.                                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ Nao se aplica.                                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAplicacao ณ Rotina executada via JOB e atraves de menu                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ 13797 - Dellavia Pneus                                     บฑฑ
ฑฑฬออออออออออุออออออออัออออออัออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบAnalista  ณData    ณBops  ณManutencao Efetuada                      	  บฑฑ
ฑฑบ          ณ        ณ      ณ                                         	  บฑฑ
ฑฑบ          ณ        ณ      ณ                                         	  บฑฑ
ฑฑศออออออออออฯออออออออฯออออออฯออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function DELA052(cParam)
//Project Function DELA052(cParam)
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณInicializacao de variaveis.                                                  ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
Local cQuery 	:= ""
Local _aArea 	:= {}
Local _aAlias	:= {}
Local _cCliPad	:= Alltrim(GetMv("MV_CLIPAD"))

// Se Cliente Padrao em Branco
If Empty(_cCliPad)

	If cParam <> Nil 
		ConOut("Cliente Padrao em Branco, verifique com o TI !!!")
	Else
		Aviso("Aten็ใo !","Cliente Padrao em Branco, verifique com o TI !!!",{'Ok'} )
	EndIf
		
	Return

EndIf

// Abre as Tabelas para ser usado via JOB
If cParam <> Nil 
	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" FUNNAME "DELA052" TABLES "SA1","SYP"
Else
	If !MsgNoYes("Elimina registros de historicos do Cliente Padrao: " + _cCliPad + " ?", "Pergunta")
		Return
	EndIf
EndIf

P_CtrlArea(1,@_aArea,@_aAlias,{"SA1","SYP"}) // GetArea

DbSelectArea("SA1")
DbSetOrder(1)
If !DbSeek(xFilial("SA1")+_cCliPad)

	If cParam == Nil // Executado via menu
		Aviso("Aviso!","Cliente Padrao NAO Encontrado !!!",{'Ok'} )	
	Else
		ConOut("Cliente Padrao NAO Encontrado !!!")
	EndIF

	Return	

EndIf

#IFDEF TOP
	cQuery := "DELETE FROM " + RetSQLName("SYP")			"
	cQuery += " WHERE YP_FILIAL = '" + xFILIAL("SYP") + "'	"
	cQuery += " AND YP_CHAVE = '" + SA1->A1_CODHIST + "'	"
	cQuery += " AND D_E_L_E_T_ <> '*'					"

	TcSqlExec(cQuery)
	
	// Grava Data e Hora da ultima limpeza do arquivo SYP efetuada pelo JOB. - Marcelo Alcantara
	if cParam <> Nil
		PutMv( "MV_LIMPSYP", DtoC(Date()) + " - " + Time() ) 
	endif

#ELSE
	// Linha incluida pois o Compilador entendeu que esta variavel nunca foi usada
	// e impediu a Compilacao
	cQuery := cQuery
	If cParam == Nil // Executado via menu
		Aviso("Aten็ใo !","Rotina s๓ pode ser rodada com o SGBD Relacional (TOP) - Contate o Dpto. de TI !!!",{'Ok'} )
	EndIf
#ENDIF

If cParam == Nil // Executado via menu
	Aviso("Fim !","Rotina executada com sucesso !!!",{'Ok'} )	
Else
	ConOut("DELA052 - FIM DO PROCESSO DE ELIMINACAO DE REGISTROS DO SYP")
EndIF

P_CtrlArea(2,_aArea,_aAlias) // RestArea

Return()
