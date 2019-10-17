#INCLUDE "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LJ430NF   �Autor  �Marcelo Alcantara	 Data �  22/07/2005   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada na apos a geracao do arquivo de distrib 	  ���
���          �altera o nome do arquivo para:							  ���
���          �FilialOrigem+filialDest+NumeroNota.NFT					  ���
���          �e Copia o arquivo *.NFT para diretorio 					  ���
���          �especificado no parametro MV_DIRDIST                        ���
�������������������������������������������������������������������������͹��
���Uso       �Della Via Pneus.                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function LJ430NF()
//���������������Ŀ
//�PARAMIXB:      �
//�	1-Numero da NF�
//�	2-Serie da NF �
//�	3-Loja        �
//�����������������
Local _aArea	:=	GetArea()
//Local _cRotina	:=	""                                  

if PARAMIXB[1]== nil
	Return Nil   
endif
Private _cFileOri	:=	PARAMIXB[3] + PARAMIXB[1] //nome do arquivo de origem
Private _cFileDes	:= cFilAnt + PARAMIXB[3] + PARAMIXB[1] //nome do arquivo de destino filial de origem filial de destino e numero da nota

If FunName() # "LOJA430" //Se nao For o modulo de Distrib de Mercadoria
	Return Nil
Endif

// Pega Diretorio do Parametro e Copia o Arquivo
_cDirTransf:= GetMv("MV_LJDIRGR")

IF FRename(_cDirTransf + _cFileOri + ".NFT" , _cDirTransf + _cFileDes + ".NFT") < 0
   msgBox("  Nao foi possivel renomear o arquivo "+_cDirTransf + _cFileOri+", verifique os direitos de gravacao no diretorio ou o parametro MV_LJDIRGR " + AllTrim(Str(Ferror())) )
endif

// Imprime a NF no momento do processamento da nota (Alexandre)
If MsgYesNo("Deseja imprimir a Nota Fiscal agora?")
   U_RFATR01(PARAMIXB[1], PARAMIXB[1], PARAMIXB[2], 2)
Endif

RestArea(_aArea)
Return Nil