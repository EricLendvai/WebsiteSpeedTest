2019 (c) Copyright Eric Lendvai - License MIT

#require "hbwin"

#xcommand TRY => BEGIN SEQUENCE WITH __BreakBlock()
#xcommand CATCH [<!oErr!>] => RECOVER [USING <oErr>] <-oErr->
#xcommand FINALLY => ALWAYS
#xcommand ENDTRY => END
#xcommand ENDDO => END
#xcommand ENDFOR => END

#xtranslate Allt( <x> )    => alltrim( <x> )
#xtranslate Trans( <x> )    => alltrim( str(<x>,10) )

Function Main()

local oHttp
local cURL
local oError
local tDateTime1
local tDateTime2
local iSecondIn1Day := 24*60*60
local iNumberOfSecondsToPullFor
local iNumberOfRequests := 0
local cOutputFolder
local cOutputFileRootName
local lSaveResultResponse := .f.

cURL := hb_argv(1)
// hb_Default(@cURL,"")  Not needed since hb_argv return a blank string if no parameter is passed

iNumberOfSecondsToPullFor := val(hb_argv(2))
if empty(iNumberOfSecondsToPullFor)
    iNumberOfSecondsToPullFor := 2
endif

cOutputFolder := hb_argv(3)

cOutputFileRootName := hb_argv(4)

if empty(cURL)
    ?"Missing URL as parameter"
elseif iNumberOfSecondsToPullFor <= 0 .or. iNumberOfSecondsToPullFor > 120
    ?"Second parameter must be > 0 and <= 120 "
else
    if !empty(cOutputFolder) .and. !empty(cOutputFileRootName)
        cOutputFolder := hb_DirSepAdd(cOutputFolder)
        lSaveResultResponse := .t.
        ?"Deleting files: "+cOutputFolder + cOutputFileRootName + "*.html"
        hb_FileDelete( cOutputFolder + cOutputFileRootName + "*.html" )
    endif

    ?"Will test website "+cURL
    ?

    try
        //oHttp := win_oleCreateObject("MSXML2.XMLHTTP.6.0")  This control May cache requests
        oHttp := win_oleCreateObject("MSXML2.ServerXMLHTTP")
    catch oError
        ?"Failed to initilalize HTTP object. Error message: "+oError:Description
        oHttp := nil
    endtry
    
    if oHttp <> nil
        tDateTime1 := tDateTime2 := hb_DateTime()
        
        do while (tDateTime2-tDateTime1)*iSecondIn1Day < iNumberOfSecondsToPullFor
            iNumberOfRequests++
            
            try
                oHttp:Open( "GET", cURL, .f. )   // .f. = Synchronous
                //The following fails to turn off cache. instead should go to Internet explorer, Tools, Options, "Browsing History" section Settings, Temporary Internet Files Tab, select "Every time I visit the webpage", than OK.
                oHttp:setRequestHeader( "pragma", "no-cache" )
                oHttp:setRequestHeader( "Cache-Control", "no-cache, no-store" )
                oHttp:SetRequestHeader( "Accept", "*/*" )
                oHttp:Send()
            catch oError
                ?"Failed to execute HTTP GET. Error message: "+oError:Description
                exit
            endtry

            ?"Request: " + Trans(iNumberOfRequests) + " - response: " +  Trans(oHttp:status)
            
            if lSaveResultResponse
                StrFile( oHttp:ResponseText, cOutputFolder + cOutputFileRootName + Trans(iNumberOfRequests) + ".html" )
            endif

            tDateTime2 := hb_DateTime()
            
        enddo

        ?"Process Time =",allt(str((tDateTime2-tDateTime1)*iSecondIn1Day,10,3)),"- Number Of Requests =",trans(iNumberOfRequests)
    endif
endif

RETURN nil