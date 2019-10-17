#INCLUDE "rwmake.ch"

user function FiltrBco()
local cCodBco
local cCodAg
local cCodCon

if CMODULO=="LOJ" 
	cCodBco:= POSICIONE("SLJ",1,XFILIAL("SLJ")+PADL(SM0->M0_CODFIL,6,"0"),"LJ_BCODEP")
	cCodAg := POSICIONE("SLJ",1,XFILIAL("SLJ")+PADL(SM0->M0_CODFIL,6,"0"),"LJ_AGDEP")	
	cCodCon:= POSICIONE("SLJ",1,XFILIAL("SLJ")+PADL(SM0->M0_CODFIL,6,"0"),"LJ_CNTDEP")
	if SA6->A6_COD == cCodBco .and. SA6->A6_AGENCIA = cCodAg .and. SA6->A6_NUMCON = cCodCon
		Return .T.
	else
		Return .F.	
	endif	
endif
Return .T.
//if(cModulo=="LOJ" .and. __ReadVar <> "M->LJ_BCODEP",SA6->A6_COD="CX1",.T.)