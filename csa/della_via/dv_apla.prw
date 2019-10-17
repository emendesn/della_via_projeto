#include "rwmake.ch"    // incluido pelo assistente de conversao do AP5 IDE em 16/03/01
#include "TOPCONN.ch"   // incluido pelo assistente de conversao do AP5 IDE em 16/03/01

User Function DV_APLA() // incluido pelo assistente de conversao do AP5 IDE em 16/03/01
	/***************************************************************************************
	* M185FGR.PRW - Especifico Della Via                                                                            em: 04/10/06 *
	* Autor       : Geraldo Sabino Ferreira                                                                                                 *
	* Objetivo   : Apagar o flag de marcacao de contabilizacao.                                                    *
	*              // Existe no Padrao. porem ainda com erro. Dvia nao pode atualizar as funcoes do CTB                      *
	*              // Tabelas SE1,SE2,SF1,SF2,SE5
	***************************************************************************************
	*/

	aRadio:={}
	aadd(aRadio,"SF1-NF Entrada ")
	aadd(aRadio,"SF2-NF Saida   ")
	aadd(aRadio,"SE1-Ctas Receb ")
	aadd(aRadio,"SE2-Ctas Pagar ")
	aadd(aRadio,"SE5-Mov.Banc Pg")
	aadd(aRadio,"SE5-Mov.Banc Rc")

	nRadio := 1
	_dPer1:=DDATABASE
	_dPer2:=DDATABASE
	_cFilial:=Spac(2)
	_cFilial_:=Spac(2)

	lSF1  := .F.
	lSF2  := .F.
	lSE1  := .F.
	lSE2  := .F.
	lSE5P := .F.
	lSE5R := .F.

	cCombo:="Desmarca"
	@ 0,0 TO 250,450 DIALOG oDlg1 TITLE "Desmarca Flag de Contabilizacao"

	@ 13,085 TO 75,180 TITLE "Selecione.Planilha
	//@ 23,100 RADIO aRadio VAR nRadio
	@ 20,090 CHECKBOX aRadio[1] VAR lSF1
	@ 28,090 CHECKBOX aRadio[2] VAR lSF2
	@ 36,090 CHECKBOX aRadio[3] VAR lSE1
	@ 44,090 CHECKBOX aRadio[4] VAR lSE2
	@ 52,090 CHECKBOX aRadio[5] VAR lSE5P
	@ 60,090 CHECKBOX aRadio[6] VAR lSE5R

	@ 85,070 Say "Periodo Inicial   "
	@ 85,140 Get _dPer1                

	@ 100,070 Say "Periodo Final     "
	@ 100,140 Get _dPer2                

	@ 115,070 Say "Filial            "
	@ 115,140 Get _cFilial  F3 "SM0"     Valid naovazio(_cFilial)
	@ 115,165 Get _cFilial_ F3 "SM0"     Valid naovazio(_cFilial_)

	@ 20,195 BMPBUTTON TYPE 1 ACTION Selec()
	@ 45,197 BMPBUTTON TYPE 2 ACTION Close(oDlg1)
	ACTIVATE DIALOG oDlg1 CENTER
Return                                       


Static Function Selec()
	/*
	IF (_dPer2 - _dPer1)>10   .OR. (_dPer2 - _dPer1)<0   
	   MSGSTOP("Periodo incorreto / Nao sera permitido a desmarcacao por mais de 10 Dias de uma vez. Faca por Lotes !!!")
	   Return
	ENDIF
	*/

	IF !MSGYESNO("Confirma ? ")
	   Return
	Endif

   IF lSF1
	    MsgRun("Desmarcando SF1...",,{ || _lpSF1() })
   Endif
   if lSF2
        MsgRun("Desmarcando SF2...",,{ || _lpSF2() })
   Endif
   if lSE1
        MsgRun("Desmarcando SE1...",,{ || _lpSE1() })
   Endif
   if lSE2
        MsgRun("Desmarcando SE2...",,{ || _lpSE2() })
   Endif
   if lSE5P
        MsgRun("Desmarcando SE5 Pagar...",,{ || _lpSE5P() })
   Endif
   if lSE5R
        MsgRun("Desmarcando SE5 Receber...",,{ || _lpSE5R() })
   Endif

	Close(oDlg1)
Return


Static Function _LPSF1()
	_cQuery := "UPDATE "+RetSqlName("SF1")+ " SET F1_DTLANC='' "
	_cQuery += "WHERE F1_FILIAL BETWEEN '"+_cFilial+"' AND '"+_cFilial_+"' AND F1_DTDIGIT BETWEEN '"+DTOS(_dPer1)+"' AND '"+DTOS(_dPer2)+"' AND "
	_cQuery += "D_E_L_E_T_<>'*' "

	IF TCSQLEXEC(_cQuery) < 0
		MsgBox(TcSqlError(),"Desmarcando Lancamento","STOP")
	ENDIF
Return

Static Function _LPSF2()
	_cQuery := "UPDATE "+RetSqlName("SF2")+ " SET F2_DTLANC='' "
	_cQuery += "WHERE F2_FILIAL BETWEEN '"+_cFilial+"' AND '"+_cFilial_+"' AND F2_EMISSAO BETWEEN '"+DTOS(_dPer1)+"' AND '"+DTOS(_dPer2)+"' AND "
	_cQuery += "D_E_L_E_T_<>'*' "

	IF TCSQLEXEC(_cQuery) < 0
		MsgBox(TcSqlError(),"Desmarcando Lancamento","STOP")
	ENDIF
Return


Static Function _LPSE1()
	_cQuery := "UPDATE "+RetSqlName("SE1")+ " SET E1_LA='' "
	_cQuery += "WHERE E1_MSFIL BETWEEN '"+_cFilial+"' AND '"+_cFilial_+"' AND E1_EMIS1   BETWEEN '"+DTOS(_dPer1)+"' AND '"+DTOS(_dPer2)+"' AND "
	_cQuery += "D_E_L_E_T_<>'*' "

	IF TCSQLEXEC(_cQuery) < 0
		MsgBox(TcSqlError(),"Desmarcando Lancamento","STOP")
	ENDIF
Return


Static Function _LPSE2()
	_cQuery := "UPDATE "+RetSqlName("SE2")+ " SET E2_LA='' "
	_cQuery += "WHERE E2_MSFIL BETWEEN '"+_cFilial+"' AND '"+_cFilial_+"' AND E2_EMIS1   BETWEEN '"+DTOS(_dPer1)+"' AND '"+DTOS(_dPer2)+"' AND "
	_cQuery += "D_E_L_E_T_<>'*' "

	IF TCSQLEXEC(_cQuery) < 0
		MsgBox(TcSqlError(),"Desmarcando Lancamento","STOP")
	ENDIF
Return

Static Function _LPSE5P()
	_cQuery := "UPDATE "+RetSqlName("SE5")+ " SET E5_LA='' "
	_cQuery += "WHERE E5_DATA BETWEEN '"+DTOS(_dPer1)+"' AND '"+DTOS(_dPer2)+"' "
	_cQuery += "AND E5_RECPAG = 'P' AND E5_TIPODOC NOT IN ('TR','TE') AND D_E_L_E_T_<>'*' "

	IF TCSQLEXEC(_cQuery) < 0
		MsgBox(TcSqlError(),"Desmarcando Lancamento","STOP")
	ENDIF
Return
                         

Static Function _LPSE5R()
	_cQuery := "UPDATE "+RetSqlName("SE5")+ " SET E5_LA='' "
	_cQuery += "WHERE E5_DATA BETWEEN '"+DTOS(_dPer1)+"' AND '"+DTOS(_dPer2)+"' "
	_cQuery += "AND E5_RECPAG = 'R' AND E5_TIPODOC NOT IN ('TR','TE') AND D_E_L_E_T_<>'*' "

	IF TCSQLEXEC(_cQuery) < 0
		MsgBox(TcSqlError(),"Desmarcando Lancamento","STOP")
	ENDIF
Return