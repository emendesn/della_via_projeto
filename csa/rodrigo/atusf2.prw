#INCLUDE "RWMAKE.CH"

User Function ATUSF2


aRotina := {{ "Pesquisa","AxPesqui", 0 , 1},;
      		{ "Altera","u_mod3f2()", 0 , 4, 20 }}     
      		
SET FILTER TO SF2->F2_FILIAL == XFILIAL("SF2")      		
mBrowse(6,1,22,75,"SF2")      		
SET FILTER TO                                         

Return


User function mod3f2     

aCopia := Aclone(aRotina)
 		
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Opcoes de acesso para a Modelo 3                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
DBSELECTaREA("SF2") 

cOpcao:="VISUALIZAR"
Do Case
	Case cOpcao=="INCLUIR"; nOpcE:=3 ; nOpcG:=3
	Case cOpcao=="ALTERAR"; nOpcE:=2 ; nOpcG:=3
	Case cOpcao=="VISUALIZAR"; nOpcE:=2 ; nOpcG:=2
EndCase
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria variaveis M->????? da Enchoice                          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
RegToMemory("SF2",(cOpcao=="INCLUIR"))
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria aHeader e aCols da GetDados                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nUsado:=0
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SD2")
aHeader:={}
While !Eof().And.(x3_arquivo=="SD2")              
	If X3USO(x3_usado)
	   	nUsado:=nUsado+1
        Aadd(aHeader,{ TRIM(x3_titulo), x3_campo, x3_picture,;
	         x3_tamanho, x3_decimal,"AllwaysTrue()",;
    	     x3_usado, x3_tipo, x3_arquivo, x3_context } )
	Endif
    dbSkip()
End

If cOpcao=="INCLUIR"
	aCols:={Array(nUsado+1)}
	aCols[1,nUsado+1]:=.F.
	For _ni:=1 to nUsado
		aCols[1,_ni]:=CriaVar(aHeader[_ni,2])
	Next
Else
	aCols:={}
	dbSelectArea("SD2")
	dbSetOrder(3)
	dbSeek(xFilial()+M->F2_DOC+M->F2_SERIE+M->F2_CLIENTE+M->F2_LOJA)
	While !eof().and.SD2->D2_DOC==M->F2_DOC .AND. SD2->D2_FILIAL == XFILIAL("SD2") ;
	  .AND. M->F2_CLIENTE == SD2->D2_CLIENTE .AND. M->F2_LOJA == SD2->D2_LOJA ;
	  .AND. M->F2_SERIE == SD2->D2_SERIE
		AADD(aCols,Array(nUsado+1))
		For _ni:=1 to nUsado
			aCols[Len(aCols),_ni]:=FieldGet(FieldPos(aHeader[_ni,2]))
		Next 
		aCols[Len(aCols),nUsado+1]:=.F.
		dbSkip()
	End
Endif      
If Len(aCols)>0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executa a Modelo 3                                           ³
	cTitulo:="Nota Fiscal de Saida"
	cAliasEnchoice:="SF2"
	cAliasGetD:="SD2"
	cLinOk:="AllwaysTrue()"
	cTudOk:="AllwaysTrue()"
	cFieldOk:="AllwaysTrue()"
	aCpoEnchoice:={"F2_DOC","F2_SERIE"}

//	_lRet:=Modelo3(cTitulo,cAliasEnchoice,cAliasGetD,aCpoEnchoice,cLinOk,cTudOk,nOpcE,nOpcG,cFieldOk,.F.,LEN(ACOLS))
	_lRet:=Modelo3(cTitulo,cAliasEnchoice,cAliasGetD,,cLinOk,cTudOk,nOpcE,nOpcG,cFieldOk,.F.,LEN(ACOLS))
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Executar processamento                                       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If _lRet
		dbSelectArea("SX3")
		dbSetOrder(1)
		dbSeek("SF2")
		WHILE !EOF() .AND. SX3->X3_ARQUIVO == "SF2"     
			If SX3->X3_CONTEXT <> "V"
			    dbSelectArea("SF2")
				Reclock("SF2",.F.) 
			    &(SX3->X3_CAMPO) := &("M->"+SX3->X3_CAMPO)
				Msunlock()               
			Endif                  
			dbSelectArea("SX3")
			dbSkip()
		End-Do                   
		                              
		For i:=1 to Len(acols) 
			// Regrava somente os ativos
			If !( aCols[i,Len(aCols[i])] )
				_cdoc	:= M->F2_DOC
				_cSerie	:= M->F2_SERIE
				_cFornec:= M->F2_CLIENTE
				_cLoja	:= M->F2_LOJA
				_cCod	:= aCOLS[ i,aScan(aHeader,{|x|Upper(AllTrim(x[2]))=="D2_COD"}) ]
				_cItem 	:= aCOLS[ i,aScan(aHeader,{|x|Upper(AllTrim(x[2]))=="D2_ITEM"}) ]
				dbSelectArea("SD2")
				dbSetOrder(3)
				If dbSeek(xFilial("SD2")+_cdoc+_cSerie+_cFornec+_cLoja+_cCod+_cItem)
					dbSelectArea("SX3")
					dbSetOrder(1)
					dbSeek("SD2")
					WHILE !EOF() .AND. SX3->X3_ARQUIVO == "SD2"     
						If SX3->X3_CONTEXT <> "V"
							IF aScan(aHeader,{|x|Upper(AllTrim(x[2]))==Alltrim(SX3->X3_CAMPO)}) > 0
							    dbSelectArea("SD2")
								Reclock("SD2",.F.) 
							    &(SX3->X3_CAMPO) := aCols[i,aScan(aHeader,{|x|Upper(AllTrim(x[2]))==Alltrim(SX3->X3_CAMPO)})]   
//							    aCols[i,ASCAN(AHEADER, { |X|  UPPER( ALLTRIM( X[ 2 ] ) )  == "D1_PEDIDO "} ) ]
								Msunlock()               
							Endif
						Endif                  
						dbSelectArea("SX3")
						dbSkip()
					End-Do                   
		        Endif                        
			Endif
		Next i
		Aviso("Nota Fiscal de Saida","Gravacao OK!",{"Ok"})
		
	Endif
Endif

Return