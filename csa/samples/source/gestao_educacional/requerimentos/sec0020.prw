#include "rwmake.ch"

/*/
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o	 �SEC0020A    � Autor � Gustavo Henrique     � Data � 04/07/02  ���
���������������������������������������������������������������������������Ĵ��
���Descri��o �Filtra as turmas disponiveis para o requerimento de           ���
���          �Transferencia de Turma - Veteranos.                           ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe	 �SEC0020A        					    						���
���������������������������������������������������������������������������Ĵ��
���Parametros�EXPL1 - .T. - Validacao pelo Script da solicitacao.           ���
���          �        .F. - Chamado do filtro da consulta SXB J27.          ���
���������������������������������������������������������������������������Ĵ��
���Uso		 �ACAA410	        										    ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/
User Function SEC0020A( lWeb )

Local lRet := .T.
Local aRet := {}

lWeb := IIf( lWeb == Nil , .F., lWeb)
lRet := JBK->(ExistCpo( "JBK", M->JBH_SCP01 + M->JBH_SCP03 + M->JBH_SCP04 + M->JBH_SCP10 ))

If lRet

	// Seleciona apenas as turmas do mesmo curso e periodo letivo do curso de origem selecionado.
	lRet := (	JBK->JBK_CODCUR == M->JBH_SCP01 .and. JBK->JBK_PERLET == M->JBH_SCP03 .and. JBK->JBK_HABILI == M->JBH_SCP04 .and.;
				M->JBH_SCP10 # M->JBH_SCP06 .and. JBK->JBK_ATIVO == "1" )
	
	If ! lRet             
	    If !lWEb
			MsgStop( "Esta turma n�o pode ser selecionada." )
		Else
	        aadd(aRet,{.F.,"Esta turma n�o pode ser selecionada."})
        	Return aRet	
        EndIf	
	EndIf

EndIf

Return( lRet )

/*/
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o	 �SEC0020b    � Autor � Gustavo Henrique     � Data � 25/09/02  ���
���������������������������������������������������������������������������Ĵ��
���Descri��o �Varirica se o aluno informado no script pode fazer permuta com���
���          �o aluno que solicitou o requerimento.                         ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe	 �SEC0020b        					    						���
���������������������������������������������������������������������������Ĵ��
���Uso		 �ACAA410	        										    ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/
User Function SEC0020b( lScript )
                         
Local lRet
          
lScript := Iif( lScript == NIL, .F., lScript )
           
If lScript

	lRet := .F.
	    
	If JA2->( ExistCpo( "JA2", M->JBH_SCP12 ) )
	
		JBE->( dbSetOrder( 3 ) )
		
		If ! JBE->( dbSeek( xFilial( "JBE" ) + "1" + M->JBH_SCP12 + M->JBH_SCP01 ) )
			MsgStop( "O aluno informado n�o est� matriculado no curso do aluno solicitante." )
		ElseIf JBE->JBE_PERLET # M->JBH_SCP03
			MsgStop( "O aluno informado deve estar matriculado no mesmo periodo letivo do aluno solicitante." )
		ElseIf JBE->JBE_HABILI # M->JBH_SCP04
			MsgStop( "O aluno informado deve estar matriculado na mesma habilitacao do aluno solicitante." )
		ElseIf JBE->JBE_TURMA == M->JBH_SCP06
			MsgStop( "O aluno informado n�o pode estar matriculado na mesma turma do aluno solicitante." )
		Else
			lRet := .T.	
		EndIf
		
	EndIf

Else

	lRet := JBE->(	JBE_NUMRA # Left(M->JBH_CODIDE,TamSX3("JBE_NUMRA")[1]) .and.;	// Alunos diferentes do solicitante
					JBE_ATIVO == "1" .and.;											// Que estejam ativos 
					JBE_CODCUR == M->JBH_SCP01 .and.;								// Matriculados no mesmo curso
					JBE_PERLET == M->JBH_SCP03 .and.;								// Periodo letivo
					JBE_HABILI == M->JBH_SCP04 .and.;								// Habilitacao
					JBE_TURMA # M->JBH_SCP06 )										// e em Turmas diferentes

EndIf
	
Return( lRet )

/*/
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o	 �SEC0020c    � Autor � Gustavo Henrique     � Data � 25/09/02  ���
���������������������������������������������������������������������������Ĵ��
���Descri��o �Nao permitir deixar o numero do RA do aluno de permuta do     ���
���          �script em branco.                                             ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe	 �SEC0020c        					    						���
���������������������������������������������������������������������������Ĵ��
���Uso		 �ACAA410	        										    ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/
User Function SEC0020c( lWeb )

Local uRet := .T.

lWeb := Iif( lWeb == NIL, .F., lWeb )
    
If M->JBH_SCP11 == "2" .and. Empty( M->JBH_SCP12 )

	If lWeb
		AAdd( aRet, { .F., "O RA do aluno de permuta deve ser informado." } )
		uRet := aRet	
	Else
		MsgStop( "O RA do aluno de permuta deve ser informado." )
		uRet := .F.
	EndIf

EndIf

Return( uRet )

/*/
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o	 �SEC0020d    � Autor � Gustavo Henrique     � Data � 25/09/02  ���
���������������������������������������������������������������������������Ĵ��
���Descri��o �Transfere o aluno de permuta para a turma do aluno solicitante���
���          �caso o tipo seja 2=Permuta.                                   ���
���������������������������������������������������������������������������Ĵ��
���Sintaxe	 �SEC0020d        					    						���
���������������������������������������������������������������������������Ĵ��
���Uso		 �ACAA410	        										    ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/
User Function SEC0020d()

Local aRet  := ACScriptRet( M->JBH_NUM )
Local lRet	:= .T.

If aRet[ 11 ] == "2"		//	Permuta
	lRet := ACTransfere( 1, 3, 4, 6, 1, 3, 4, 10, .F.,, 12 )
EndIf

Return( lRet )