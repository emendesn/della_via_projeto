#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 26/09/00

User Function Codbar()        // incluido pelo assistente de conversao do AP5 IDE em 26/09/00

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("LRET,CSTR,I,NMULT,NMODULO,CCHAR")
SetPrvt("CDIGITO,CDV1,CDV2,CDV3,CCAMPO1,CCAMPO2")
SetPrvt("CCAMPO3,NVAL,NCALC_DV1,NCALC_DV2,NCALC_DV3,NREST")

/*/
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o    � CODBARVL � Autor � Vicente Sementilli    � Data � 26/02/97 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri豫o � Calculo do modulo 11 sugerido pelo ITAU. Esta funcao       낢�
굇�          � somente e utilizada como validacao do campo E2_CODBAR.     낢�
굇�          �                                                            낢�
굇�          � Esta rotina tambem tranforma o codigo digitado em codigo   낢�
굇�          � de barras se necessario                                    낢�
굇�          �                                                            낢�
굇�          �                                                            낢�
굇�          � O campo E2_CODBAR nao existe no padr�o ele deve ser criado 낢�
굇�          �                                                            낢�
굇�          � Nome        Tipo   Tamanho   Validacao                     낢�
굇�          � -----------  --     ----     ----------------------------  낢�
굇�          � E2_CODBAR    C       44      EXECBLOCK("CODBARVL")         낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
/*/
LRET := .F.

if ValType(M->E2_CODBAR) == NIL
// Substituido pelo assistente de conversao do AP5 IDE em 26/09/00 ==>   __Return(.t.)
Return(.t.)        // incluido pelo assistente de conversao do AP5 IDE em 26/09/00
Endif

cStr := M->E2_CODBAR

i		:= 0
nMult	:= 2
nModulo := 0
cChar	:= SPACE(1)
cDigito	:= SPACE(1)

If len(AllTrim(cStr)) < 44
   
   cDV1    := SUBSTR(cStr,10, 1) 
   cDV2    := SUBSTR(cStr,21, 1) 
   cDV3    := SUBSTR(cStr,32, 1) 
   
   cCampo1 := SUBSTR(cStr, 1, 9)
   cCampo2 := SUBSTR(cStr,11,10)
   cCampo3 := SUBSTR(cStr,22,10)

   /*/
   굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
   굇旼컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴엽�
   굇쿏escri뇚o � Calculo do modulo 10 sugerido pelo ITAU. Esta funcao       낢�
   굇�          � somente e utilizada como validacao do campo E2_CODBAR.     낢�
   굇�          � Verifica a digitacao do codigo de barras                   낢�
   굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
   굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
   /*/
   //
   // Calcula DV1
   //
   nMult	:= 2
   nModulo	:= 0
   nVal		:= 0
   
	For i := Len(cCampo1) to 1 Step -1
   	cChar := Substr(cCampo1,i,1)
      
      If isAlpha(cChar)
		 Help(" ", 1, "ONLYNUM")
         Return(.f.)
	  Endif
		 nModulo := Val(cChar)*nMult
		If nModulo >= 10
			nVal := NVAL + 1
			nVal := nVal + (nModulo-10)
		Else
			nVal := nVal + nModulo	
		EndIf	
		nMult:= if(nMult==2,1,2)
   Next        
   nCalc_DV1 := 10 - (nVal % 10)

   //
   // Calcula DV2
   //

   nMult	:= 2
   nModulo	:= 0
   nVal		:= 0
   
	For i := Len(cCampo2) to 1 Step -1
   	cChar := Substr(cCampo2,i,1)
     	If isAlpha(cChar)
			Help(" ", 1, "ONLYNUM")
		    Return(.f.)
		Endif        
		nModulo := Val(cChar)*nMult
		If nModulo >= 10
			nVal := nVal + 1
			nVal := nVal + (nModulo-10)
		Else
			nVal := nVal + nModulo	
		EndIf	
		nMult:= if(nMult==2,1,2)
   Next        
   nCalc_DV2 := 10 - (nVal % 10)

   //
   // Calcula DV3
   //
   nMult	:= 2
   nModulo	:= 0
   nVal		:= 0
   
   For i := Len(cCampo3) to 1 Step -1
		cChar := Substr(cCampo3,i,1)
		If isAlpha(cChar)
		   Help(" ", 1, "ONLYNUM")
           Return(.f.)
		Endif        
		nModulo := Val(cChar)*nMult
		If nModulo >= 10
			nVal := nVal + 1
			nVal := nVal + (nModulo-10)
		Else
			nVal := nVal + nModulo	
		EndIf	
		nMult:= If(nMult==2,1,2)
   Next        
   nCalc_DV3 := 10 - (nVal % 10)

   If !(nCalc_DV1 == Val(cDV1) .and. nCalc_DV2 == Val(cDV2) .and. nCalc_DV3 == Val(cDV3) )
      Help(" ",1,"INVALCODBAR")
      lRet := .f.
   else         
      lRet := .t.
   endif                
   
Else
   cDigito := SUBSTR(cStr,5, 1)
   cStr    := SUBSTR(cStr,1, 4)+ ;
              SUBSTR(cStr,6,39)

   /*/
   굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
   굇旼컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴엽�
   굇쿏escri뇚o � Calculo do modulo 11 sugerido pelo ITAU. Esta funcao       낢�
   굇�          � somente e utilizada como validacao do campo E2_CODBAR.     낢�
   굇�          � Verifica o codigo de barras grafico (Atraves de leitor)    낢�
   굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
   굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
   /*/

   cStr := AllTrim(cStr)

   If Len(cStr) < 43
      Help(" ", 1, "FALTADG")
      Return(.f.)
   Endif

   For i := Len(cStr) to 1 Step -1
        cChar := Substr(cStr,i,1)
        If isAlpha(cChar)
           Help(" ", 1, "ONLYNUM")
           Return(.f.)
        Endif        
        nModulo := nModulo + Val(cChar)*nMult
        nMult:= if(nMult==9,2,nMult+1)
   Next        
   nRest := 11 - (nModulo % 11)
   nRest := if(nRest==10 .or. nRest==11,1,nRest)  
   If nRest <> Val(cDigito)
      Help(" ",1,"DgSISPAG")
      lRet := .f.
   Else         
      lRet := .t.
   Endif                

Endif


Return(lRet)        // incluido pelo assistente de conversao do AP5 IDE em 26/09/00

