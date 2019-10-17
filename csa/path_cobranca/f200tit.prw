#Include "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F200TIT   ºAutor  ³Wagner Manfre       º Data ³  06/19/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gravação de log de registros na cobrança                   º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function F200Tit
Local aSaveArea := GetArea()
Local cRestrMot := GetMv( "MV_RESTMOT" , .F. , "" ) // se não for definido o parametro, não restringe nada
// Verifica se o Motivo esta dentro da variavel de restrição ou se não ha restricao
If (Empty(cRestrMot)) .or. ;
   (Altrim(upper(SEB->EB_REFBAN))$cRestrMot)
	// Verifica se o SE1 e o SEB estão posicionados
	If !SE1->(Eof()) .and. !SEB->(Eof())
		dbSelectArea("SZB")
		RecLock("SZB", .T.) //Grava o log na tabela SZB
		SZB->ZB_FILIAL   := Subs(cnumtit,1,2)
		SZB->ZB_CLIENTE  := SE1->E1_CLIENTE
		SZB->ZB_LOJA     := SE1->E1_LOJA 
		SZB->ZB_EMISSAO  := dDataBase
		SZB->ZB_PREFIXO  := SE1->E1_PREFIXO
		SZB->ZB_NUM      := SE1->E1_NUM
		SZB->ZB_PARCELA  := SE1->E1_PARCELA
		SZB->ZB_TIPO     := SE1->E1_TIPO
		SZB->ZB_OCORR    := SEB->EB_REFBAN
		SZB->ZB_HIST     := SEB->(AllTrim(EB_DESCRI) + " " + AllTrim(EB_DESCMOT))
		MsUnlock()
    Endif
Endif
RestArea(aSaveArea) //restaura a Area de entrada
Return nil
