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

local _acdisp := {}
local _wi := 1
local _nordem := SE5->(indexord())
local _nrecno := se5->(recno())

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

If se1->e1_filial!=se5->e5_filial
  DbSelectArea("SE5")
  DbSetOrder(7)
  DbSeek(sm0->m0_codfil+se1->(e1_prefixo+e1_num+e1_parcela+e1_tipo+e1_cliente+e1_loja),.T.)

  While sm0->m0_codfil+se1->(e1_prefixo+e1_num+e1_parcela+e1_tipo+e1_cliente+e1_loja)== ;
    e5_filial+e5_prefixo+e5_numero+e5_parcela+e5_tipo+e5_clifor+e5_loja
    If e5_recpag=="R"
      aadd(_acdisp, { se5->(recno()) } )
    End
    DbSkip()
  Enddo

  For _wi := 1 to len(_acdisp)
   dbgoto( _acdisp[_wi,1]  )
   reclock("SE5")
   replace e5_filial with se1->e1_filial 
   msunlock()
  Next

  dbSetOrder(_nordem)
  dbgoto(_nrecno)

End

RestArea(aSaveArea) //restaura a Area de entrada
Return nil
