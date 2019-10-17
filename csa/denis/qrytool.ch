#include "rwmake.ch"
#include "topconn.ch"

	#Translate bSETGET(<uVar>) => { | u | If( PCount() == 0, <uVar>, <uVar> := u ) }

	#xCommand @ <nRow>, <nCol> MEMO <uVar> ;
				[ OBJECT <oGet> ] ;
				[ <dlg: OF, WINDOW, DIALOG> <oWnd> ] ;
				[ <color:COLOR,COLORS> <nClrFore> [,<nClrBack>] ] ;
				[ SIZE <nWidth>, <nHeight> ] ;
				[ FONT <oFont> ] ;
				[ <hscroll: HSCROLL> ] ;
				[ CURSOR <oCursor> ] ;
				[ <pixel: PIXEL> ] ;
				[ MESSAGE <cMsg> ] ;
				[ <update: UPDATE> ] ;
				[ WHEN <uWhen> ] ;
				[ <lCenter: CENTER, CENTERED> ] ;
				[ <lRight: RIGHT> ] ;
				[ <readonly: READONLY, NO MODIFY> ] ;
				[ VALID <uValid> ] ;
				[ ON CHANGE <uChange> ] ;
				[ <lDesign: DESIGN> ] ;
				[ <lNoBorder: NO BORDER, NOBORDER> ] ;
				[ <lNoVScroll: NO VSCROLL> ] ;
		=> [ <oGet> := ] TMultiGet():New( <nRow>, <nCol>, bSETGET(<uVar>), [<oWnd>], <nWidth>, <nHeight>;
					, <oFont>, <.hscroll.>,<nClrFore>, <nClrBack>, <oCursor>, <.pixel.>,<cMsg>;
					, <.update.>, <{uWhen}>, <.lCenter.>,<.lRight.>, <.readonly.>, <{uValid}>;
					, [\{|nKey, nFlags, Self| <uChange>\}], <.lDesign.>,[<.lNoBorder.>], [<.lNoVScroll.>] )