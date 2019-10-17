#INCLUDE "protheus.ch"
/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  � LJ7026   �Autor  �Norbert Waage Junior   � Data �  19/07/05   ���
����������������������������������������������������������������������������͹��
���Descricao �Ponto de entrada utilizado para recriar o array aNCCItens      ���
����������������������������������������������������������������������������͹��
���Parametros� Nao ha                                                        ���
����������������������������������������������������������������������������͹��
���Retorno   � Nao ha                                                        ���
����������������������������������������������������������������������������͹��
���Aplicacao � Ponto de entrada executado na montagem da tela para selecao   ���
���          �das NCC's a serem utilizadas na venda assistida.               ���
����������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                   	     ���
����������������������������������������������������������������������������͹��
���Marcelo   �18/01/06�      � Este ponto de entrada foi deletado do projeto ���
���Gaspar    �        �      � porque atualmente o SE1 est� em modo          ���
���          �        �      � Compartilhado e nao ha mais necessidade desta ���
���          �        �      � personalizacao.                               ���
����������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                        ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
User Function LJ7026


Local aArea		:=	GetArea()
Local aAreaSE1  :=	SE1->(GetArea())
Local cArq		:=	""
Local cCliente  :=	M->LQ_CLIENTE
Local cLoja     :=	M->LQ_LOJA
Local nSaldoNCC	:=	0

//��������������������Ŀ
//�Inicializa variaveis�
//����������������������
aNCCItens := {}
nNCCUsada := 0

//����������������������������������������������Ŀ
//�Cria indice temporario sem considerar a Filial�
//������������������������������������������������
cArq := CriaTrab(Nil,.F.)
DbSelectArea("SE1")	
IndRegua("SE1",cArq,"E1_CLIENTE+E1_LOJA+E1_STATUS+DTOS(E1_VENCREA)")

DbSeek(cCliente+cLoja+"A",.T.)

//�����������������������������������������������������������Ŀ
//�Monta o array aNCCItens, lendo os registros do SE1 de todas�
//�as filiais                                                 �
//�������������������������������������������������������������
While ! SE1->(EOF()) .And. SE1->E1_CLIENTE == cCliente .And. SE1->E1_LOJA == cLoja .And. SE1->E1_STATUS == "A"

	If SE1->E1_TIPO $ MV_CRNEG

	   If cPaisLoc == "BRA"

		  AAdd(aNCCItens, {.F., SE1->E1_SALDO, SE1->E1_NUM, SE1->E1_EMISSAO, SE1->(Recno())})

	   Else 

	      nSaldoNCC  := Round(xMoeda(SE1->E1_SALDO,SE1->E1_MOEDA,nMoedaCor,dDataBase,nDecimais+1,,nTxMoeda),nDecimais) 
		  AAdd(aNCCItens, {.F., nSaldoNCC, SE1->E1_NUM, SE1->E1_EMISSAO, SE1->(Recno()),;
		                   SE1->E1_SALDO, SuperGetMV("MV_MOEDA"+Str(SE1->E1_MOEDA,1)),;
		                   SE1->E1_MOEDA})
	   EndIf  
	   	  
	EndIf

	SE1->(dbSkip())

End

//��������������Ŀ
//�Ordena o vetor�
//����������������
If Len(aNCCItens) > 0
	aNCCItens := aSort(aNCCItens,,,{|x,y| x[4]<y[4]})
EndIf
                 
//������������������������Ŀ
//�Apaga arquivo temporario�
//��������������������������
RetIndex("SE1")
DbSetorder(1)
Ferase(cArq+OrdBagExt())
                         
RestArea(aAreaSE1)
RestArea(aArea)

Return Nil
