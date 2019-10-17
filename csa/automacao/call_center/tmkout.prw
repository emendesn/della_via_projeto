
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TMKOUT    �Autor  �Andrea Farias       � Data �  04/10/04   ���
�������������������������������������������������������������������������͹��
���Desc.     �Validacao de saida da tela de atendimento, que somente      ���
���          �devera ser finalizada se nao estiver em uma alteracao.      ���
�������������������������������������������������������������������������͹��
���Uso       � CALL CENTER - TELECOBRANCA                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function TMKOUT(lMsg,nOpc)

Local lRet:= .T.

//�����������������������������������������������������������������������������Ŀ
//�Se a variavel lMsg estiver como TRUE significa que o usuario clicou no botao �
//�Cancelar (CTRL + O). A tela de Atendimento quando aberta pela rotina de pre- �
//�atendimento passa o nOpc como 4 (alteracao).                                 �
//�������������������������������������������������������������������������������
If lMsg
	If (nOpc == 3 .OR. nOpc == 4) .AND. Funname() == "TMKA280" //Se estiver em uma alteracao ou inclusao e em telecobranca
		If M->ACF_STATUS == "2" .AND. M->ACF_OPERA == "2" //Status Cobranca e Ativo
			MsgStop("Para finalizar o atendimento, preencha todos os dados e confirme!","Opera��o Negada!")
			lRet:= .F.                                  
		Endif
	Endif
Endif      

If (Funname() == "TMKA271" .Or. Substr(Upper(Funname()),1,7) == "TMKUSER") .And. GetMv("MV_USERWS") .And. !Empty(Mv_Par38) // Call Center 
	
	DbSelectArea("SA1")
	DbSetOrder(1)

	DbSeek(xFilial("SA1")+M->UA_CLIENTE+M->UA_LOJA)
	
	RecLock("SA1",.F.)            
	SA1->A1_USERLGI	:= Mv_Par38
	SA1->A1_USERLGA	:= Mv_Par39
	MsUnlock()           
	
	Mv_Par38	:= ""
	Mv_Par39	:= ""
	
Endif	
	
Return(lRet)	