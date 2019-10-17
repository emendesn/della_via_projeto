#INCLUDE "protheus.ch"
/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �DelA048   �Autor  �Norbert Waage Junior   � Data �  19/08/05   ���
����������������������������������������������������������������������������͹��
���Descricao �Rotina de preenchimento automatico de campos nao utilizados no ���
���          �cadastro de clientes da Della Via, porem obrigatorios para as  ���
���          �rotinas do SIGACRD.                                            ���
����������������������������������������������������������������������������͹��
���Parametros�Nao se aplica                                                  ���
����������������������������������������������������������������������������͹��
���Retorno   �Nao se aplica                                                  ���
����������������������������������������������������������������������������͹��
���Aplicacao �Rotina acionada atraves do gatilho do campo A1_CGC             ���
����������������������������������������������������������������������������͹��
���Analista      � Data   �Bops  �Manutencao Efetuada                        ���
����������������������������������������������������������������������������͹��
���              �        �      �                                           ���
����������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                        ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
Project Function DELA048()   

Local aArea		:= GetArea()
Local nMA6Num	:= aScan(oGetD6:aHeader,{|x| AllTrim(x[2]) == "MA6_NUM"   })
Local nMA6Mot	:= aScan(oGetD6:aHeader,{|x| AllTrim(x[2]) == "MA6_MOTIVO"})
Local nMA8Tip	:= aScan(oGetD1:aHeader,{|x| AllTrim(x[2]) == "MA8_TIPO"  })
Local nMA8Emp	:= aScan(oGetD1:aHeader,{|x| AllTrim(x[2]) == "MA8_EMPRES"})
Local nMA8Ren	:= aScan(oGetD1:aHeader,{|x| AllTrim(x[2]) == "MA8_RENDA" })
Local nMABNom	:= aScan(oGetD4:aHeader,{|x| AllTrim(x[2]) == "MAB_NOME"  })
Local nMABTel	:= aScan(oGetD4:aHeader,{|x| AllTrim(x[2]) == "MAB_TEL"   })

//�������������������������������������������������������Ŀ
//�A rotina so pode ser executada a partir da tela CRDA010�
//���������������������������������������������������������
If !P_NaPilha("CRDA010")
	Return Nil
EndIf

//���������������������������Ŀ
//�Inicializa os campos vazios�
//�����������������������������
//Tabela Cartoes
If Empty( oGetD6:aCols[1,nMA6Num] + oGetD6:aCols[1,nMA6Mot] )
	oGetD6:aCols[1,nMA6Num]	:= M->A1_CGC
	oGetD6:aCols[1,nMA6Mot]	:= "1"		//Cartao Novo
	oGetD6:oBrowse:Refresh()
EndIf
                
//Tabela Referencias de Trabalho
If Empty( oGetD1:aCols[1,nMA8Tip] + oGetD1:aCols[1,nMA8Emp]) .And. (oGetD1:aCols[1,nMA8Ren] == 0)
	oGetD1:aCols[1,nMA8Tip]	:= "1"		// 1 - Empresa Atual, 2 - Anterior , 3 = Conjuge
	oGetD1:aCols[1,nMA8Emp]	:= "N/I"	// Nao informado
	oGetD1:aCols[1,nMA8Ren]	:= 1
	oGetD1:oBrowse:Refresh()
EndIf

//Tabela Referencias Pessoais
If Empty( oGetD4:aCols[1,nMABNom] ) .And. ( AllTrim(oGetD4:aCols[1,nMABTel]) == "0" )
	oGetD4:aCols[1,nMABNom]	:= "."
	oGetD4:aCols[1,nMABTel]	:= "0"
	oGetD4:oBrowse:Refresh()
EndIf

RestArea(aArea)

Return Nil