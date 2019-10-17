#Include "PROTHEUS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F200TIT   ºAutor  ³Wagner Manfre       º Data ³  06/19/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gravação de log de registros na cobrança e                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function F200Tit
Local aSaveArea := GetArea()
Local a_areaSE1	:= SE1->(GetArea())

Local cRestrMot := GetMv( "MV_RESTMOT" , .F. , "" ) // se não for definido o parametro, não restringe nada

local _acdisp := {}
local _wi := 1
local _nordem := 0
local _nrecno := 0

// Verifica se o Motivo esta dentro da variavel de restrição ou se não ha restricao
If (Empty(cRestrMot)) .or. ;
   (Altrim(upper(SEB->EB_REFBAN))$cRestrMot)
	// Verifica se o SE1 e o SEB estão posicionados
	If !SE1->(Eof()) .and. !SEB->(Eof())
		dbSelectArea("SZB")
		RecLock("SZB", .T.) //Grava o log na tabela SZB
		SZB->ZB_FILIAL   := SE1->E1_FILIAL
		SZB->ZB_CLIENTE  := SE1->E1_CLIENTE
		SZB->ZB_LOJA     := SE1->E1_LOJA 
		SZB->ZB_EMISSAO  := dDataBase
		SZB->ZB_PREFIXO  := SE1->E1_PREFIXO
		SZB->ZB_NUM      := SE1->E1_NUM
		SZB->ZB_PARCELA  := SE1->E1_PARCELA
		SZB->ZB_TIPO     := SE1->E1_TIPO
        If SEB->EB_OCORR=="08"   // titulo pago em cartorio
           SZB->ZB_OCORR := SEB->EB_OCORR
        ElseIf SEB->EB_REFBAN<>"08"
           SZB->ZB_OCORR := SEB->EB_REFBAN
        Else
           SZB->ZB_OCORR := SEB->EB_OCORR 
        End
		SZB->ZB_HIST     := SEB->(AllTrim(EB_DESCRI) + " " + AllTrim(EB_DESCMOT))
		MsUnlock()
    Endif
Endif
 
// Atualiza titulo com informacao de pagamento em cartorio para SIGACRD Della Via

If SM0->M0_CODIGO=="01"   // Della Via
   If SEB->EB_OCORR=="08"
      DbSelectArea("SE1")
      Reclock("SE1",.F.)
      Replace E1_PAGCART with "S"
      Msunlock()
   End
End

RestArea(a_areaSE1)
RestArea(aSaveArea) //restaura a Area de entrada
Return nil
