#INCLUDE "TBICONN.CH"
//Pula Linha
#Define CTRL Chr(10)+Chr(13)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Rotina    �LimpaMAL  �Autor  � Marcio Domingos    � Data �  30/06/06   ���
�������������������������������������������������������������������������͹��
���Descricao �Rotina para Limpar os Contratos gerados pelo Call Center   ���
���          �ap�s faturamento.                                           ���
�������������������������������������������������������������������������͹��
���Parametros�cContrato = Numero do Contrato                              ���
�������������������������������������������������������������������������͹��
���Retorno   �Nao se aplica                                               ���
�������������������������������������������������������������������������͹��
���Aplicacao � Rotina executada nos progrmas:                             ���
�������������������������������������������������������������������������͹��
�������������������������������������������������������������������������͹��
���Uso       �13797 - Della Via Pneus                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function LimpaMAL(cContrato)

DbSelectArea("MAL")  //Compartilhado
DbSetOrder(1)
DbGoTop()

BEGIN TRANSACTION

//��������������������������������������������������������������������Ŀ
//�Varre o arquivo MAL em busca de registros que devem ser atualizados �
//����������������������������������������������������������������������  
  
lDelMAL  := .F.
 
DbSelectArea("MAL")            
DbSetOrder(1)
DbSeek(xFilial("MAL")+cContrato)
While 	MAL_FILIAL 	==	xFilial("MAL")	.And.;
		MAL_CONTRA	==	cContrato		.And.	!Eof()

	RecLock("MAL",.F.)
   	DbDelete()
   	MsUnlock()   		 	         
   		            
   	DbSkip()                   //Skip MAL*
   		 	            
Enddo
   
END TRANSACTION

Return .T.

