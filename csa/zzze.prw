#include "Protheus.ch"
Main User Function Ze()
//Local cQuery //n, aCpo := {}, aSX2, nTempo
//Local aStru := {}
//Local cSourceTable, aSourceCols := {}, cSourceWhere, cTargetTable, aTargetCols := {}
//Local aResult := {}
Local cQuery, n, nValor, nTit, sec, aResult := {}, cData
Local cTabela, aIndice := {}, cStr, cNome, nHdl
RpcSetEnv( "06", "01" ) //01, 02, 98, 95, 96, 97
//n := TCLINK( "DB2/DBITAPUA","LOCALHOST" )
                                        
SX2->( dbGoTop() )
While !SX2->( Eof() )

	if TCCanOpen( SX2->X2_ARQUIVO )
		cTABELA := SX2->X2_CHAVE
		cNome := Alltrim( SX2->X2_ARQUIVO )
		SIX->( dbSeek( SX2->X2_CHAVE ) )
		While ! SIX->( Eof() ) .and. SIX->INDICE = cTABELA
			cStr := "create index DB2." + cNome + Alltrim( SIX->ORDEM ) + " on DB2." + cNome + "( " + SqlOrder( SIX->( CHAVE ) ) + ", R_E_C_N_O_, D_E_L_E_T_ ) PCTFREE 10 MINPCTUSED 10 ALLOW REVERSE SCANS COLLECT STATISTICS" + CRLF + "@" + CRLF
			AADD( aIndice, cStr )
			SIX->( dbSkip() )
		Enddo
	endif
	
	SX2->( dbSkip() )
Enddo

nHdl := Fcreate( "CriaIdx06.sql" )
For n:=1 to Len( aIndice )
	Fwrite( nHdl, aIndice[ n ] )
Next

Fclose(nHdl)

//FT_SAVEARR(aIndice, "CriaIdx.sql")

Return



n := SldCliente( "00004701", date() )
Return

MsgStop( "Começando" )
cQuery := "SELECT E1_PREFIXO, E1_NUM, E1_PARCELA, E1_CLIENTE, E1_LOJA FROM SE1010"
cQuery += " where D_E_L_E_T_ = ' '"
cQuery := ChangeQuery( cQuery )

nValor:= 0
nTit:= 0
dbUseArea( .T., "TOPCONN", TCGENQRY(,,cQuery),"TRB", .F., .T.)
sec := Seconds()
while !TRB->( Eof() )
//	SomaAbat( TRB->E1_PREFIXO, TRB->E1_NUM, TRB->E1_PARCELA, "R", 1, dDataBase, TRB->E1_CLIENTE, TRB->E1_LOJA )
	aResult := TCSPEXEC("FIN001_01", TRB->E1_PREFIXO, TRB->E1_NUM, TRB->E1_PARCELA, "R", 1, DTOS( Date() ), TRB->E1_CLIENTE, TRB->E1_LOJA, "01", DTOS( Date() ) )
	nValor += aResult[ 1 ]
	nTit++
	TRB->( dbSkip() )
enddo
sec := Seconds() - sec
TRB->( dbCloseArea() )
Conout( "Fez em " + Alltrim( Str( sec ) ) + " segundos" )
Conout( "Total de Abatimento ($) " + AllTrim( Str( nValor ) ) )
Conout( "Total de Titulos " + StrZero( nTit, 6 ) )
//MsgStop( "Fez em " + Alltrim( Str( sec ) ) + " segundos" )

Return	
