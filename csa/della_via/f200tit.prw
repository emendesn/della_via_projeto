#Include "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F200TIT   �Autor  �Wagner Manfre       � Data �  06/19/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Grava��o de log de registros na cobran�a e                 ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function F200Tit
Local aSaveArea := GetArea()
Local a_areaSE1	:= SE1->(GetArea())

Local cRestrMot := GetMv( "MV_RESTMOT" , .F. , "" ) // se n�o for definido o parametro, n�o restringe nada

local _acdisp := {}
local _wi := 1
local _nordem := 0
local _nrecno := 0

// Verifica se o Motivo esta dentro da variavel de restri��o ou se n�o ha restricao
If (Empty(cRestrMot)) .or. ;
   (Altrim(upper(SEB->EB_REFBAN))$cRestrMot)
	// Verifica se o SE1 e o SEB est�o posicionados
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
