#INCLUDE "rwmake.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDESTR05   บAutor  ณ Reinaldo Caldas    บ Data ณ  24/08/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Relatorio de Programa Auto-Clave                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Durapol Renovadora de Pneus LTDA.                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function DESTR05()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Private cString
Private aOrd 		:= {}
Private CbTxt       := ""
Private cDesc1      := "Relatorio de Programa Auto-Clave "
Private cDesc2      := ""
Private cDesc3      := ""
Private cPict       := ""
Private lEnd        := .F.
Private lAbortPrint := .F.
Private limite      := 78
Private tamanho     := "G"
Private nomeprog    := "DESTR05"
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private titulo      := "Programa Auto-Clave"
Private nLin        := 80
Private nPag		:= 0
Private Cabec1      := ""
Private Cabec2      := "   Ficha/Coleta Item      Medida           Fogo     Serie      Marca     TP   Desenho    Cliente                   Sq   Motorista                      Obs                                    OK"
Private cbtxt      	:= Space(10)
Private cbcont     	:= 00
Private CONTFL     	:= 01
Private m_pag      	:= 01
Private imprime     := .T.
Private wnrel      	:= "DESTR05"
Private _cPerg     	:= "DEST05"

Private cString 	:= "SC2"                                    


dbSelectArea("SC2")
dbSetOrder(1)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Monta a interface padrao com o usuario...                           ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

_aRegs:={}

AAdd(_aRegs,{_cPerg,"01","Data Autoclave ?"    ," "," ","mv_ch1","D", 8,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","",""}) 
AAdd(_aRegs,{_cPerg,"02","Autoclave      ?"    ," "," ","mv_ch2","C", 2,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","",""})
AAdd(_aRegs,{_cPerg,"03","Rodada         ?"    ," "," ","mv_ch3","C", 2,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","",""})
                                                              
ValidPerg(_aRegs,_cPerg)
Pergunte(_cPerg,.F.)

wnrel := SetPrint(cString,NomeProg,_cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,aOrd,,Tamanho)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

Processa( {|| ImpRel() } )

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณ ImpRel   บAutor  ณ Reinaldo Caldas    บ Data ณ  17/08/05   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para impressao do relatorio                         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function ImpRel()

LOCAL _nX,_nPos,_cQry
LOCAL cGrupo := GetMV("MV_X_GRPRO")
LOCAL nCont  :=0
ProcRegua(100)

IF Select("TMPEST") > 0
	TMPEST->(dbCloseArea())
EndIF	

_cQry := "select C2_PRODUTO ,C2_NUMFOGO, C2_SERIEPN, C2_MARCAPN, C2_X_DESEN, C2_NUM, C2_ITEM, C2_XNREDUZ, C2_OBS, C2_XMOTORI, C2_XRODADA, C2_XNUMROD, C2_XACLAVE, C2_XTRILHO,C2_XDTCLAV,C2_XBICO, C2_SEQUEN "
_cQry += " from " + RetSqlName("SC2")+ " C2 "
_cQry += " where C2.D_E_L_E_T_ = ' ' "
_cQry += " and C2_FILIAL =  '" + xFilial("SC2") + "' "
_cQry += " and C2_XDTCLAV = '" + DtoS(mv_par01) + "' "
_cQry += " and C2_XACLAVE = '" + mv_par02       + "' "
_cQry += " and C2_XNUMROD = '" + mv_par03       + "' "
_cQry += " order by C2_XBICO||C2_NUM||C2_ITEM "

_cQry := ChangeQuery(_cQry)
		
dbUseArea(.T.,"TOPCONN",TCGenQry(,,_cQry),"TMPEST",.F.,.T.)

dbSelectArea("TMPEST")
dbGoTop()

Cabec1 := "   Numero da Autoclave: " +TMPEST->C2_XACLAVE+    "   Trilho: "+TMPEST->C2_XTRILHO+"     Data da Autoclave: "+SUBSTR(TMPEST->C2_XDTCLAV,07,02)+"/"+SUBSTR(TMPEST->C2_XDTCLAV,05,02)+"/"+SUBSTR(TMPEST->C2_XDTCLAV,01,04)+ "   Hora Rodada: "+TMPEST->C2_XRODADA 

While ! Eof()
    nCont ++
	IF lEnd
		@Prow()+1, 001 Psay "Cancelado pelo operador "
		Exit
	EndIF
	
	IncProc()
	
	IF nLin > 60
		Cabec(Titulo,cabec1,cabec2,nomeprog,tamanho,GetMV("MV_COMP"))
	    nLin := 8
	EndIF
    
    nLin := nLin+1
    @ nLin, 005 Psay TMPEST->C2_NUM
    @ nLin, 017 Psay TMPEST->C2_ITEM 
    @ nLin, 026 Psay TMPEST->C2_PRODUTO        
    @ nLin, 043 Psay TMPEST->C2_NUMFOGO
    @ nLin, 052 Psay TMPEST->C2_SERIEPN
    @ nLin, 065 Psay TMPEST->C2_MARCAPN
    @ nLin, 080 Psay TMPEST->C2_X_DESEN 
    @ nLin, 090 Psay TMPEST->C2_XNREDUZ
    @ nLin, 116 Psay TMPEST->C2_XBICO 
    @ nLin, 120 Psay TMPEST->C2_XMOTORI
    @ nLin, 152 Psay TMPEST->C2_OBS
    @ nLin, 187 Psay "|        |"
	
	nLin += 2

	SD3->(dbSetOrder(1))
	SD3->(dbSeek(xFilial("SD3")+TMPEST->C2_NUM+TMPEST->C2_ITEM+TMPEST->C2_SEQUEN))
    _lImp := .F.
	While !Eof() .and. Alltrim(SD3->D3_OP) == Alltrim(TMPEST->C2_NUM+TMPEST->C2_ITEM+TMPEST->C2_SEQUEN) 
		
		SB1->(dbSetOrder(1))
		SB1->(dbSeek(xFilial()+SD3->D3_X_PROD))
		/* SOMENTE GRUPO CI/SC
		IF ! Alltrim(SB1->B1_GRUPO) $ Alltrim(cGrupo)
			SD3->(dbSkip())
			Loop
		EndIF
		*/
		IF SD3->D3_ESTORNO == "S"
			SD3->(dbSkip())
			Loop
		EndIF
		IF !_lImp
			@ nLin, 160 Psay "Consertos/Bandas : "
			_lImp := .T.
		EndIF	
		@ nLin, 182 Psay Iif(Alltrim(SB1->B1_GRUPO) != "BAND",Alltrim(Str(SD3->D3_QUANT)),Alltrim(Str(SD3->D3_XTERCUM)))
		@ nLin, 194 Psay SD3->D3_XDESC  		
		nLin ++
		SD3->(dbSkip())
	EndDo
	
	@ nLin, 000 Psay Replicate ("_",220)
	
	nLin ++
	dbSelectArea("TMPEST")
	dbSkip()
	
Enddo
@ nLin, 187 Psay "Pneus: " + Alltrim(Str(nCont))
nLin ++
IF nLin != 80
	IF nLin > 60
		cabec(titulo,cabec1,cabec2,nomeprog,tamanho,GetMv("MV_COMP"))
	EndIF
	Roda(cbcont,cbtxt,"M")
EndIF

dbSelectArea("TMPEST")
dbCloseArea()

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Se impressao em disco, chama o gerenciador de impressao...          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

SetPgEject(.F.)

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return