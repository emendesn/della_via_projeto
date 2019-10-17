#include "rwmake.ch"

User Function AtuSalDup(cOper,nValor,nMoeda,cTipoDoc,nTaxa,dData)

Local cCampo,cCampo1
Local cTpNaoAtu   // Tipos que nao atualizam saldo algum no cadastro de clientes

cTiposLC := Nil

cOper	 :=  If(cOper	 ==	Nil,"+",cOper)
nValor   :=  If(nValor	 ==	Nil,10,nValor)
cTipoDoc :=  If(cTipoDoc ==	Nil,"NF",cTipoDoc)
nTaxa	:=  If(nTaxa	==	Nil,0,nTaxa)
nMoeda	:=	If(nMoeda	==	Nil,1,nMoeda)
dData	:=	If(dData	==	Nil,dDataBase,dData)

If !cOper $ "+-="
	MsgAlert("Operando incorreto, Verifique se é uma atribuição, soma ou subtração")
	Return
Endif

If cTiposLC == Nil
	cTiposLC := ""
	cTiposLC := GetSESTipos({ || ES_SALDUP == "2"},"1")
	nMCusto		:=	Val(GetMV("MV_MCUSTO"))
Endif

// Tipos que nao atualizam nenhum dos saldos
If cTpNaoAtu == Nil
	cTpNaoAtu := ""
	cTpNaoAtu := GetSESTipos({ || ES_SALDUP == "3"},"1")
Endif

If !(cTipoDoc $ cTpNaoAtu)
	If cTipoDoc $ cTiposLC
		cCampo	:=	"SA1->A1_SALFIN"
		cCampo1	:=	"SA1->A1_SALFINM"
	Else
		cCampo	:=	"SA1->A1_SALDUP"
		cCampo1	:=	"SA1->A1_SALDUPM"
	Endif
Else
	Return
Endif

If SA1->(Eof())		// garantir que estah posicionado em algum registro valido
	Return
Endif

nMoedaF		:= If(SA1->A1_MOEDALC > 0,SA1->A1_MOEDALC,nMCusto)

//nValorMoe1	:= Round(xMoeda(nValor,nMoeda,1,dData,MsDecimais(1)+1,nTaxa),MsDecimais(1))
nValorMoe1	:= xMoeda(nValor,nMoeda,1,dData,MsDecimais(1)+1,nTaxa)
nValorMoeF  := Round(xMoeda(nValor,nMoeda,nMoedaF,dData,MsDecimais(nMoedaF)+1,nTaxa),MsDecimais(nMoedaF))

msgbox(AllTrim(str(MsDecimais(1))))

/*
RecLock("SA1",.F.)
If cOper=="+"
	&cCampo. 	+= nValorMoe1
	&cCampo1. 	+= nValorMoeF
ElseIf cOper=="-"
	&cCampo. 	-= nValorMoe1
	&cCampo1. 	-= nValorMoeF
Elseif cOper="="
	&cCampo. 	:= nValorMoe1
	&cCampo1.	:= nValorMoeF
EndIf
MsUnlock()
*/
Return