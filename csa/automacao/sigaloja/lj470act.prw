#INCLUDE "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LJ470ACT  �Autor  �Marcelo Alcantara	 � Data �  17/08/2005 ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada Para pegar o Fornecedor que gerou o arquivo���
���          �de meio magnetico usado o Parametro MV_LJCDDIS para informar���
���          �o codigo do cliente e a filial pega do arquivo *.nft        ���
�������������������������������������������������������������������������͹��
���Uso       �Della Via Pneus.                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function LJ470ACT()
Local _aArea	:=	GetArea()
Local cCodLoja	:= GetNewPar("MV_LJCDDIS","000001") //fornecedor do parametro
Local cFilLoja	:= SubStr(PARAMIXB[1],1,2)          //Filial do arquivo 
RestArea(_aArea)
Return {cCodLoja, cFilLoja} 
