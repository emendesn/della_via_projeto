#include 'protheus.ch'  
#include 'dellavia.ch'

User Function DGOLA23 ()
	Local vModalPagto		 := "??"   
	
	if !empty(SRA->RA_CTDEPSA)
		if SUBSTR(SRA->RA_BCDEPSA,1,3) == "237"
		   vModalPagto := "05"
		else
		   vModalPagto := "03"
		endif
	else
		if SUBSTR(SRA->RA_BCDEPSA,1,3) == "237"
		   vModalPagto := "02"
		endif
	endif
	
Return vModalPagto
