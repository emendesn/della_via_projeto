USER FUNCTION MT100GE2
	RecLock("SE2",.F.)
	SE2->E2_CONTAD	:= m->D1_CONTA   //Gravar a conta, ccusto e item informados no D1 
	SE2->E2_CCD		:= m->D1_CC      // estes campos sao obrigatorios e eram gerados vazios, o que   
	SE2->E2_ITEMD	:= m->D1_ITEMCTA // fazia a usuaria ter dificuldades na hora de manipular titulos do E2 		
	MSUNLOCK
RETURN	
