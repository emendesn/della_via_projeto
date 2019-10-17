#include "Protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � FZeraTes �Autor  � Alexandre Martim   � Data �  30/12/05   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para zerar o TES e o tipo de operacao caso o usua-  ���
���          �ario altere o cliente ou a loja. Isso para garantir que o   ���
���          �TES Inteligente fa�a o ajuste correto da TES.               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP8 - Especifico DellaVia                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FZeraTES()
     //
     Local _nPosTES, _nPosOper
     //
     If Len(aCols)>0
        For _n:=1 to Len(aCols)
            //
            If Readvar()$"M->C5_CLIENTE/M->C5_LOJACLI"
               //
               _nPosTes  := aScan(aHeader, {|x| rTrim(x[2]) == "C6_TES"})
               _nPosOper := aScan(aHeader, {|x| rTrim(x[2]) == "C6_OPER"})
               //
            ElseIf Readvar()$"M->UA_CLIENTE/M->UA_LOJA"
               //
               _nPosTes  := aScan(aHeader, {|x| rTrim(x[2]) == "UB_TES"})
               _nPosOper := aScan(aHeader, {|x| rTrim(x[2]) == "UB_OPER"})
               //
            Endif
            //
            If _nPosTes>0
               aCols[_n, _nPosTes ] := "   "
               aCols[_n, _nPosOper] := "  "
            Endif
            //
        Next
     Endif
     //
Return .t.

