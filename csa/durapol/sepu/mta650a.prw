
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ MTA650A  º Autor ³ Jader              º Data ³  23/08/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada na confirmacao da alteracao da OP.        º±±
±±º          ³ Usado para disparar o Job de envio de aprovacao de SEPU    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Durapol                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MTA650A()

Local _aAliasAnt := GetArea()
Local _cObs1,_cObs2,_cObs3,_lOk

If SM0->M0_CODIGO == "03"   // So executa para Durapol

    //-- grava campos memos especificos
	_cObs1 := M->C2_XOBS1
	MSMM(SC2->C2_XCOBS1,80,,_cObs1,1,,,"SC2","C2_XCOBS1")

	_cObs2 := M->C2_XOBS2
	MSMM(SC2->C2_XCOBS2,80,,_cObs2,1,,,"SC2","C2_XCOBS2")

	_cObs3 := M->C2_XOBS3
	MSMM(SC2->C2_XCOBS3,80,,_cObs3,1,,,"SC2","C2_XCOBS3")

	//-- verifica se a profundidade aferida esta preenchida
	If SC2->C2_XPROFAF > 0

    	//-- verifica se ja foi enviado 
		If SC2->C2_XWFSEPU == "S"
			_lOk := MsgYesNo("E-mail para aprovacao do SEPU ja enviado. Deseja enviar novamente e reiniciar o processo?","Confirmacao")
		Else
			_lOk := .T.
		Endif		

		//-- faz chamada do job para envio do e-mail para aprovacao do SEPU   
		If _lOk
			//U_WSEPU01(	SC2->(C2_NUM+C2_ITEM+C2_SEQUEN) )
			U_WSEPU01()
        Endif

        //-- atualiza que foi enviado o e-mail de aprovacao de SEPU
		dbSelectArea("SC2")
		RecLock("SC2",.F.)
		SC2->C2_XWFSEPU := "S"	
		MsUnlock()
        
	Endif
		  
Endif

RestArea(_aAliasAnt)

Return(NIL)
