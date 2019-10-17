#Include "Protheus.Ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � LOJA140B �Autor  �Ricardo Mansano     � Data �  12/05/05   ���
�������������������������������������������������������������������������͹��
���Locacao   � Fab.Tradicional  �Contato � mansano@microsiga.com.br       ���
�������������������������������������������������������������������������͹��
���Descricao � P.E. na Exclusao de Orcamentos onde serao excluidas as     ���
���          � Reservas em SC0(Reservas) e SB2(Saldos).                   ���
�������������������������������������������������������������������������͹��
���Parametros� Nao se aplica.                                             ���
�������������������������������������������������������������������������͹��
���Retorno   � Nao se aplica.                                             ���
�������������������������������������������������������������������������͹��
���Aplicacao � P.E. Chamado apos a exclusao do orcamento.                 ���
�������������������������������������������������������������������������͹��
���Uso       � 13797 - Dellavia Pneus                                     ���
�������������������������������������������������������������������������͹��
���Analista  �Data    �Bops  �Manutencao Efetuada                      	  ���
���          �        �      �                                         	  ���
���Norbert   �08/06/05�      �Inclusao do tratamento de sinistro       	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function LOJA140B

//�����������������������������������������������������������������������������Ŀ
//�Inicializacao de variaveis.                                                  �
//�������������������������������������������������������������������������������
Local _cNum 		:= SL1->L1_NUM
Local _aArea   		:= {}
Local _aAlias  		:= {}

P_CtrlArea(1,@_aArea,@_aAlias,{"SL1","SL2","SL4","SC0","SB2"}) // GetArea

//�����������������������������������������������������������������������������Ŀ
//�Deleta todos as reservas relacionadas com o orcamento                        �
//�������������������������������������������������������������������������������
// Estorna Reservas em SC0
dbSelectArea("SB2")
dbSetOrder(1) // Filial + Codigo + Local
    
dbSelectArea("SC0")
dbSetOrder(3) // C0_FILIAL + C0_NUMORC + C0_PRODUTO  

If DbSeek(xFilial("SC0")+_cNum) 
   While !SC0->(Eof()) .And. xFilial("SC0")+_cNum == SC0->(C0_FILIAL + C0_NUMORC)
		Begin Transaction

			//�����������������������������������������������������������������������������Ŀ
			//�Apaga Equipe de Montagem se esta jah existir no PAB para este Orcamento,		�
			//�para evitar duplicidade														�
			//�������������������������������������������������������������������������������
			DbSelectArea("PAB")
			dbSetOrder(3) // PAB_FILIAL + PAB_ORC
			If DbSeek(xFilial("PAB")+_cNum)
				While !(PAB->(Eof())) .and. (PAB->PAB_FILIAL+PAB->PAB_ORC == xFilial("PAB")+_cNum) 
					RecLock("PAB",.F.)
					PAB->(DbDelete())
					MsUnlock()      
				PAB->(DbSkip())
				EndDo
			Endif                                         '
			
			//�����������������������������������������������������������������������������Ŀ
			//�Estorna Reservas em SB2														�
			//�������������������������������������������������������������������������������
		    If SB2->( DbSeek(xFilial("SB2")+SC0->C0_PRODUTO+SC0->C0_LOCAL) )
			    RecLock("SB2",.F.)                                                               
			    SB2->B2_RESERVA -= SC0->C0_QTDPED
			    MsUnLock()
		    EndIf
		    
			//�����������������������������������������������������������������������������Ŀ
			//�Deleta Reserva em SC0  														�
			//�������������������������������������������������������������������������������
			RecLock("SC0",.F.)
			SC0->(dbDelete())
			MsUnLock()       
		End Transaction
			
		SC0->(dbSkip())
   EndDo	

   DbSelectArea("SL1")
   DbSetOrder(1) // L1_FILIAL + L1_NUM
   If DbSeek(xFilial("SL1") + _cNum )
   	  RecLock("SL1",.F.)
	  SL1->L1_RESERVA := "" // Campo padrao utilizado na regra que define as cores do mBrowse (LOJA701)
	  MsUnLock()
   EndIf

EndIf  

P_CtrlArea(2,_aArea,_aAlias) // RestArea

// Apaga seguros
P_D05Apaga(_cNum)

Return