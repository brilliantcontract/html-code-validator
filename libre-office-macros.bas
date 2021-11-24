REM  *****  BASIC  *****

Sub pasteUnformatted
    Dim document As Object
    Dim dispatcher As Object
    document = ThisComponent.CurrentController.Frame
    dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")
    Dim args1(0) As New com.sun.star.beans.PropertyValue
    args1(0).Name = "SelectedFormat"
    args1(0).Value = 1
    dispatcher.executeDispatch(document, ".uno:ClipboardFormatItems", "", 0, args1())
End Sub

Sub cleanLitterInCells
	dim document   as object
	dim dispatcher as object

	document   = ThisComponent.CurrentController.Frame
	dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")
	
	dim searchProperties(20) as new com.sun.star.beans.PropertyValue
	searchProperties(0).Name = "SearchItem.StyleFamily"
	searchProperties(0).Value = 2
	searchProperties(1).Name = "SearchItem.CellType"
	searchProperties(1).Value = 0
	searchProperties(2).Name = "SearchItem.RowDirection"
	searchProperties(2).Value = true
	searchProperties(3).Name = "SearchItem.AllTables"
	searchProperties(3).Value = false
	searchProperties(4).Name = "SearchItem.SearchFiltered"
	searchProperties(4).Value = false
	searchProperties(5).Name = "SearchItem.Backward"
	searchProperties(5).Value = false
	searchProperties(6).Name = "SearchItem.Pattern"
	searchProperties(6).Value = false
	searchProperties(7).Name = "SearchItem.Content"
	searchProperties(7).Value = false
	searchProperties(8).Name = "SearchItem.AsianOptions"
	searchProperties(8).Value = false
	searchProperties(9).Name = "SearchItem.AlgorithmType"
	searchProperties(9).Value = 1
	searchProperties(10).Name = "SearchItem.SearchFlags"
	searchProperties(10).Value = 65536
	searchProperties(11).Name = "SearchItem.SearchString"
	searchProperties(11).Value = "(^[\s,\.\-_:;]+|[\s,\.\-_:;]+$)"
	searchProperties(12).Name = "SearchItem.ReplaceString"
	searchProperties(12).Value = ""
	searchProperties(13).Name = "SearchItem.Locale"
	searchProperties(13).Value = 255
	searchProperties(14).Name = "SearchItem.ChangedChars"
	searchProperties(14).Value = 2
	searchProperties(15).Name = "SearchItem.DeletedChars"
	searchProperties(15).Value = 2
	searchProperties(16).Name = "SearchItem.InsertedChars"
	searchProperties(16).Value = 2
	searchProperties(17).Name = "SearchItem.TransliterateFlags"
	searchProperties(17).Value = 1280
	searchProperties(18).Name = "SearchItem.Command"
	searchProperties(18).Value = 3
	searchProperties(19).Name = "SearchItem.SearchFormatted"
	searchProperties(19).Value = false
	searchProperties(20).Name = "SearchItem.AlgorithmType2"
	searchProperties(20).Value = 2
	
	dispatcher.executeDispatch(document, ".uno:ExecuteSearch", "", 0, searchProperties())
	
	dim dialogProperties(0) as new com.sun.star.beans.PropertyValue
	dialogProperties(0).Name = "Visible"
	dialogProperties(0).Value = false
	
	dispatcher.executeDispatch(document, ".uno:SearchResultsDialog", "", 0, dialogProperties())
end sub

sub tidyHtmlCode
	dim document   as object
	dim dispatcher as object
	
	document   = ThisComponent.CurrentController.Frame
	dispatcher = createUnoService("com.sun.star.frame.DispatchHelper")
	
	dim searchProperties(20) as new com.sun.star.beans.PropertyValue
	searchProperties(0).Name = "SearchItem.StyleFamily"
	searchProperties(0).Value = 2
	searchProperties(1).Name = "SearchItem.CellType"
	searchProperties(1).Value = 0
	searchProperties(2).Name = "SearchItem.RowDirection"
	searchProperties(2).Value = true
	searchProperties(3).Name = "SearchItem.AllTables"
	searchProperties(3).Value = false
	searchProperties(4).Name = "SearchItem.SearchFiltered"
	searchProperties(4).Value = false
	searchProperties(5).Name = "SearchItem.Backward"
	searchProperties(5).Value = false
	searchProperties(6).Name = "SearchItem.Pattern"
	searchProperties(6).Value = false
	searchProperties(7).Name = "SearchItem.Content"
	searchProperties(7).Value = false
	searchProperties(8).Name = "SearchItem.AsianOptions"
	searchProperties(8).Value = false
	searchProperties(9).Name = "SearchItem.AlgorithmType"
	searchProperties(9).Value = 1
	searchProperties(10).Name = "SearchItem.SearchFlags"
	searchProperties(10).Value = 65536
	searchProperties(11).Name = "SearchItem.SearchString"
	searchProperties(11).Value = ""
	searchProperties(12).Name = "SearchItem.ReplaceString"
	searchProperties(12).Value = ""
	searchProperties(13).Name = "SearchItem.Locale"
	searchProperties(13).Value = 255
	searchProperties(14).Name = "SearchItem.ChangedChars"
	searchProperties(14).Value = 2
	searchProperties(15).Name = "SearchItem.DeletedChars"
	searchProperties(15).Value = 2
	searchProperties(16).Name = "SearchItem.InsertedChars"
	searchProperties(16).Value = 2
	searchProperties(17).Name = "SearchItem.TransliterateFlags"
	searchProperties(17).Value = 1280
	searchProperties(18).Name = "SearchItem.Command"
	searchProperties(18).Value = 3
	searchProperties(19).Name = "SearchItem.SearchFormatted"
	searchProperties(19).Value = false
	searchProperties(20).Name = "SearchItem.AlgorithmType2"
	searchProperties(20).Value = 2
	
	dim dialogProperties(0) as new com.sun.star.beans.PropertyValue
	dialogProperties(0).Name = "Visible"
	dialogProperties(0).Value = false

	
	
	REM Tydy HTML table.
	searchProperties(11).Value = "\s*(<table[^>]*>)\s*"
	searchProperties(12).Value = "$1"
	dispatcher.executeDispatch(document, ".uno:ExecuteSearch", "", 0, searchProperties())
	dispatcher.executeDispatch(document, ".uno:SearchResultsDialog", "", 0, dialogProperties())
	
	searchProperties(11).Value = "\s*(<thead[^>]*>)\s*"
	searchProperties(12).Value = "$1"
	dispatcher.executeDispatch(document, ".uno:ExecuteSearch", "", 0, searchProperties())
	dispatcher.executeDispatch(document, ".uno:SearchResultsDialog", "", 0, dialogProperties())
	
	searchProperties(11).Value = "\s*(<tbody[^>]*>)\s*"
	searchProperties(12).Value = "$1"
	dispatcher.executeDispatch(document, ".uno:ExecuteSearch", "", 0, searchProperties())
	dispatcher.executeDispatch(document, ".uno:SearchResultsDialog", "", 0, dialogProperties())
	
	searchProperties(11).Value = "\s*(<th[^>]*>)\s*"
	searchProperties(12).Value = "$1"
	dispatcher.executeDispatch(document, ".uno:ExecuteSearch", "", 0, searchProperties())
	dispatcher.executeDispatch(document, ".uno:SearchResultsDialog", "", 0, dialogProperties())
	
	searchProperties(11).Value = "\s*(<tr[^>]*>)\s*"
	searchProperties(12).Value = "$1"
	dispatcher.executeDispatch(document, ".uno:ExecuteSearch", "", 0, searchProperties())
	dispatcher.executeDispatch(document, ".uno:SearchResultsDialog", "", 0, dialogProperties())
	
	searchProperties(11).Value = "\s*(<td[^>]*>)\s*"
	searchProperties(12).Value = "$1"
	dispatcher.executeDispatch(document, ".uno:ExecuteSearch", "", 0, searchProperties())
	dispatcher.executeDispatch(document, ".uno:SearchResultsDialog", "", 0, dialogProperties())
	
	searchProperties(11).Value = "\s*</td>\s*"
	searchProperties(12).Value = "</td>"
	dispatcher.executeDispatch(document, ".uno:ExecuteSearch", "", 0, searchProperties())
	dispatcher.executeDispatch(document, ".uno:SearchResultsDialog", "", 0, dialogProperties())
	
	searchProperties(11).Value = "\s*</th>\s*"
	searchProperties(12).Value = "</th>"
	dispatcher.executeDispatch(document, ".uno:ExecuteSearch", "", 0, searchProperties())
	dispatcher.executeDispatch(document, ".uno:SearchResultsDialog", "", 0, dialogProperties())
	
	searchProperties(11).Value = "\s*</tr>\s*"
	searchProperties(12).Value = "</tr>"
	dispatcher.executeDispatch(document, ".uno:ExecuteSearch", "", 0, searchProperties())
	dispatcher.executeDispatch(document, ".uno:SearchResultsDialog", "", 0, dialogProperties())



	REM Replace <td> with <th> in HTML table.
	searchProperties(11).Value = "<tr><td>([^<]*)</td>"
	searchProperties(12).Value = "<tr><th>$1</th>"
	dispatcher.executeDispatch(document, ".uno:ExecuteSearch", "", 0, searchProperties())
	dispatcher.executeDispatch(document, ".uno:SearchResultsDialog", "", 0, dialogProperties())



	REM Convert UL list to HTML table.
	searchProperties(11).Value = "<ul>"
	searchProperties(12).Value = "<table>"
	dispatcher.executeDispatch(document, ".uno:ExecuteSearch", "", 0, searchProperties())
	dispatcher.executeDispatch(document, ".uno:SearchResultsDialog", "", 0, dialogProperties())
	
	searchProperties(11).Value = "</ul>"
	searchProperties(12).Value = "</table>"
	dispatcher.executeDispatch(document, ".uno:ExecuteSearch", "", 0, searchProperties())
	dispatcher.executeDispatch(document, ".uno:SearchResultsDialog", "", 0, dialogProperties())
	
	searchProperties(11).Value = "<li>([^:]+):([^<]+)</li>"
	searchProperties(12).Value = "<tr><th>$1</th><td>$2</td></tr>"
	dispatcher.executeDispatch(document, ".uno:ExecuteSearch", "", 0, searchProperties())
	dispatcher.executeDispatch(document, ".uno:SearchResultsDialog", "", 0, dialogProperties())



	REM Add CSS class to HTML table.
	searchProperties(11).Value = "<table>"
	searchProperties(12).Value = "<table class=""description-table"">"
	dispatcher.executeDispatch(document, ".uno:ExecuteSearch", "", 0, searchProperties())
	dispatcher.executeDispatch(document, ".uno:SearchResultsDialog", "", 0, dialogProperties())	



	REM Remove empty tags like "<p></p>.
	searchProperties(11).Value = "<p>\s*</p>"
	searchProperties(12).Value = ""
	dispatcher.executeDispatch(document, ".uno:ExecuteSearch", "", 0, searchProperties())
	dispatcher.executeDispatch(document, ".uno:SearchResultsDialog", "", 0, dialogProperties())



	REM Remove prohibitted tags like strong, s, b, iframe, frame, object, embed, script, noscript.
	searchProperties(11).Value = "</?strong[^>]*>|</?s>|</?b>|</?iframe[^>]*>|</?frame[^>]*>|</?object[^>]*>|</?embed[^>]*>"
	searchProperties(12).Value = ""
	dispatcher.executeDispatch(document, ".uno:ExecuteSearch", "", 0, searchProperties())
	dispatcher.executeDispatch(document, ".uno:SearchResultsDialog", "", 0, dialogProperties())
	
	searchProperties(11).Value = "<noscript>[^<]+</noscript>"
	searchProperties(12).Value = ""
	dispatcher.executeDispatch(document, ".uno:ExecuteSearch", "", 0, searchProperties())
	dispatcher.executeDispatch(document, ".uno:SearchResultsDialog", "", 0, dialogProperties())
	
	searchProperties(11).Value = "<script>[^<]+</script>"
	searchProperties(12).Value = ""
	dispatcher.executeDispatch(document, ".uno:ExecuteSearch", "", 0, searchProperties())
	dispatcher.executeDispatch(document, ".uno:SearchResultsDialog", "", 0, dialogProperties())



	REM Replace header tags like H1, H2, etc. with H5 tag.
	searchProperties(11).Value = "<h\d+[^>]*>"
	searchProperties(12).Value = "<h5>"
	dispatcher.executeDispatch(document, ".uno:ExecuteSearch", "", 0, searchProperties())
	dispatcher.executeDispatch(document, ".uno:SearchResultsDialog", "", 0, dialogProperties())
	
	searchProperties(11).Value = "</h\d+>"
	searchProperties(12).Value = "</h5>"
	dispatcher.executeDispatch(document, ".uno:ExecuteSearch", "", 0, searchProperties())
	dispatcher.executeDispatch(document, ".uno:SearchResultsDialog", "", 0, dialogProperties())



	REM Remove new lines.
	searchProperties(11).Value = "\n"
	searchProperties(12).Value = " "
	dispatcher.executeDispatch(document, ".uno:ExecuteSearch", "", 0, searchProperties())
	dispatcher.executeDispatch(document, ".uno:SearchResultsDialog", "", 0, dialogProperties())
	
	searchProperties(11).Value = "\s+"
	searchProperties(12).Value = " "
	dispatcher.executeDispatch(document, ".uno:ExecuteSearch", "", 0, searchProperties())
	dispatcher.executeDispatch(document, ".uno:SearchResultsDialog", "", 0, dialogProperties())
End Sub
