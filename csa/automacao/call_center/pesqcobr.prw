#Include 'rwmake.ch'

User Function PesqCobr()

Local _aArea		:= GetArea()
Local _nPosPrefix	:= aScan(aHeader,{ |x| Alltrim(x[2])=="ACG_PREFIX" })
Local _nPosTitulo	:= aScan(aHeader,{ |x| Alltrim(x[2])=="ACG_TITULO" })
Local _nPosParcel	:= aScan(aHeader,{ |x| Alltrim(x[2])=="ACG_PARCEL" })
Local _nPosTipo		:= aScan(aHeader,{ |x| Alltrim(x[2])=="ACG_TIPO" })

DbSelectArea("SE1")
DbSetOrder(1)
If DbSeek(xFilial("SE1")+Acols[n,_nPosPrefix]+Acols[n,_nPosTitulo]+Acols[n,_nPosParcel]+Acols[n,_nPosTipo])
	_nRecno	:= Recno()                 
//	MsgBox(SE1->E1_FILIAL+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA)
	U_PesqSZB(_nRecno,M->ACF_CLIENT)
Endif

RestArea(_aArea)
Return .T.	

