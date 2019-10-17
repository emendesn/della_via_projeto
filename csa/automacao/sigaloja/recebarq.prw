#INCLUDE "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LJ430NF   �Autor  �Marcelo Alcantara	 Data �  22/07/2005   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o para Copiar arquivo Gerado Na Distr. de Mercadoria   ���
���          �em diretorio especificado no parametro MV_DIRDIST para o    ���
���          �remote Local.                                               ���
�������������������������������������������������������������������������͹��
���Uso       �Della Via Pneus.                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function RecebArq()

Private _cFileOri	:=	"??"+SM0->M0_CODFIL + "*.NFT"

// Pega Diretorio do Parametro e Copia o Arquivo no diretirio

_cDirTransf:= GetMv("MV_DIRDIST")
aDir:= Directory(_cDirTransf + _cFileOri)

for i=1 to len(aDir)
    __CopyFile( _cDirTransf + aDir[i][1], GetClientDir() + aDir[i][1] )
	_cCaminho := _cDirTransf + aDir[i][1]

	//Apaga Arquivo de Origem
	If File(_cCaminho)
		Delete File &_cCaminho
	Endif
Next

LOJA470() //Chama Funcao de Receb meio magnetico

Return Nil