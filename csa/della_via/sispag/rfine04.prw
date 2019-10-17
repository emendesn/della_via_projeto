#include "rwmake.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ RFINE04  ºAutor  ³ Marciane Gennari   º Data ³  29/11/04   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Programa para determinar o fator de vencimento e o valor doº±±
±±º          ³  titulo retirando a informacao do codigo de Barras.        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Sispag Itau                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function rfine04()

SetPrvt("CCAMPO,")

If     Len(Alltrim(SE2->E2_CODBAR)) < 44
          cCampo := "00000000000000" //Substr(SE2->E2_CODBAR,34,5)
ElseIf Len(Alltrim(SE2->E2_CODBAR)) == 47        
	      cCampo := Substr(SE2->E2_CODBAR,34,14)
Else
	      cCampo := Substr(SE2->E2_CODBAR,6,14)
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inclui o fator de vencimento conforme Carta-circular 002926 do Banco   ³
	//³ Central do Brasil, de 24/07/2000. A partir de 02/04/2001, o Banco      ³
	//³ acolhedor/recebedor nao sera mais responsavel  por eventuais diferen‡as³ 
	//³ de recebimento de bloquetos fora do prazo, ou sem a indica‡ao do fator ³
	//³ de vencimento. Forma para obten‡Æo do Fator de Vencimento:             ³
	//³ Calcula-se o n£mero de dias corridos entre a data base                 ³
	//³ ("Fixada" em 07.10.1997) e a do Vencimento do titulo                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//Campo := StrZero(SE2->E2_VENCREA-Ctod("07/10/97", "dd/mm/yy"),4)+;
//		 Right(cCampo,10)
EndIf	

cCampo := Strzero(Val(cCampo),14)

Return(cCampo)