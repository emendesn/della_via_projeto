#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AcertaSAD �Autor  �Microsiga           � Data �  15/04/05   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function AcertaSAD

	Processa({|| Atualiza()},"Atualizando SAD")

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Atualiza  �Autor  �Microsiga           � Data �  15/04/05   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function Atualiza

Local _aArea := GetArea()
Local nProc         := 0
Local nProc2        := 0

cMsg := "Prosseguir a Atualizacao?"

If ! MsgYesNo(cMsg,"Confirma")
    MsgAlert("Atualizacao nao efetuada.")
	Return
Endif

//����������������������������������������������������Ŀ
//� Processos iniciais...                              �
//������������������������������������������������������

dbSelectArea("SAD")
dbSetOrder(1)
dbGotop()

ProcRegua(1000)

While !Eof()          
	IncProc("Registros processados: "+Alltrim(Str(nProc2)))
	nProc ++
	nProc2 ++
	
	If nProc > 1000
		ProcRegua(1000)
		nProc := 0
	Endif
	
	dbSelectArea("SA2")
	dbSetOrder(1)
	dbSeek(xFilial()+SAD->AD_FORNECE+SAD->AD_LOJA)
	_cNome:=Alltrim(SA2->A2_NOME)
	
	dbSelectArea("SBM")
	dbSetOrder(1)
	dbSeek(xFilial()+SAD->AD_GRUPO)
	
	_cGrupo := SBM->BM_DESC
	
	dbSelectArea("SAD")
	RecLock("SAD",.F.)
		SAD->AD_NOMEFOR := _cNome
		SAD->AD_NOMGRUP := _cGrupo
	MsUnlock()

	dbSkip()
EndDo

MsgInfo("Atualizacao efetuada com sucesso!","Aten��o")

RestArea(_aArea)

Return


