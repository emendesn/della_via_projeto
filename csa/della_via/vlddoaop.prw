#include "rwmake.ch"
#include "topconn.ch"

/*
Validação utilizada no campo UB_OPER
Denis Tofoli
*/

User Function VLDDOAOP()
	Local nCpoOper  := Ascan(aHeader,{|x| Alltrim(x[2]) == "UB_OPER"})
	Local lRet := .T.

	IF M->UB_OPER = AllTrim(GetMv("FS_DEL038"))
		IF Empty(M->UA_CODCON) .OR. Posicione("PA6",1,xFilial("PA6")+M->UA_CODCON,"PA6->PA6_DOACAO") <> "S"
			Help(" ",1,"Doacao",,"Convenio inválido para esse tipo de operação",4,1)
			lRet := .F.
		Endif
		nItens := 0
		For k=1 to Len(aCols)
			If !aCols[k,Len(aCols[k])]
				nItens++
			Endif
			If nItens > 1
				Help(" ",1,"Doacao",,"Não é permitido mais do que 1 item para NF de doação",4,1)
				lRet := .F.
				exit
			Endif
		Next
	Endif

	If Len(aCols) > 1 .and. lRet
		For k=1 to Len(aCols)
			If aCols[k,nCpoOper] = AllTrim(GetMv("FS_DEL038")) .and. !aCols[k,Len(aCols[k])]
				Help(" ",1,"Doacao",,"Não é permitido mais do que 1 item para NF de doação",4,1)
				lRet := .F.
				exit
			Endif
		Next
	Endif
Return lRet