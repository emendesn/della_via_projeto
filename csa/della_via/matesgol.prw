#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
User Function MaTesGol(cOper,cTipo,cTpOper)
       
// u_MaTesVia          (1,     M->D1_OPER,cA100For,cLoja,If(cTipo$"DB","C","F"),M->D1_COD,"D1_TES")       
// Parametros 
// cOper		:= [E/S]   
// cTipo		:= "DB" Devolução / Beneficiamento
// cTpOper		:= Informado
// rTes			:= Retorna TES
                                                                                                         
Local rTES   	:= "   "
Local cQuery	:= ""  
Local aArea     := GetArea()

cQuery := "SELECT FM_TES,F4_TIPO "
cQuery += "  FROM " + RetSqlName("SFM") + " SFM, "
cQuery +=             RetSqlName("SF4") + " SF4, "  
cQuery += " WHERE SFM.D_E_L_E_T_ = '' "           
cQuery += "   AND SF4.D_E_L_E_T_ = '' "                 
cQuery += "   AND SFM.FM_FILIAL  = '' "
cQuery += "   AND SF4.F4_FILIAL  = '' "     
cQuery += "   AND SFM.FM_EST     = '" + SM0->M0_EstEnt  + "' "     
cQuery += "   AND SFM.FM_TIPO    = '" + cTpOper         + "' "
cQuery += "   AND (SFM.FM_GRPROD = '" + SB1->B1_GrTrib  + "' OR SFM.FM_GRPROD = '') "    
if cOper = "E" .and. !(cTipo $ "DB")
    cQuery += "   AND (SFM.FM_GRTRIB = '" + SA2->A2_GrpTrib + "' OR SFM.FM_GRTRIB = '') "   
    cQuery += "   AND (SFM.FM_TpClFor= '" + Iif(Empty(SA2->A2_INSCR).or."ISENT"$upper(SA2->A2_INSCR), "I", SA2->A2_TIPO) + "' OR SFM.FM_TpClFor   = '*') "
    cQuery += "   AND SFM.FM_UFDEST LIKE '%"  + SA2->A2_Est     + "%' "
else                           
    cQuery += "   AND (SFM.FM_GRTRIB = '" + SA1->A1_GrpTrib + "' OR SFM.FM_GRTRIB = '') "   
    cQuery += "   AND (SFM.FM_TpClFor= '" + Iif(Empty(SA1->A1_INSCR).or."ISENT"$upper(SA1->A1_INSCR), "I", SA1->A1_TIPO) + "' OR SFM.FM_TpClFor   = '*') "  
    cQuery += "   AND SFM.FM_UFDEST LIKE '%"  + SA1->A1_Est     + "%' "  
endif  
cQuery += "   AND SF4.F4_CODIGO  = SFM.FM_TES "  

cQuery := ChangeQuery(cQuery)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"cSQL",.T.,.T.)
dbSelectArea("cSql")

if !eof()
	rTES := iif(cSql->F4_Tipo == cOper, cSql->FM_TES, "???")  
else
	rTES := "???"
endif
dbCloseArea()

RestArea(aArea)
Return(rTES)