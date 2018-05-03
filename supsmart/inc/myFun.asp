<%
Function CHWeek(ThisDay)
	If ThisDay<>"" And IsDate(ThisDay) Then
	   Dim CharWeek
	   CharWeek=Weekday(ThisDay)
	   Select Case CharWeek
	    Case 1
	     CHWeek="星期日"
	    Case 2
	     CHWeek="星期一"
	    Case 3
	     CHWeek="星期二"
	    Case 4
	     CHWeek="星期三"
	    Case 5
	     CHWeek="星期四"
	    Case 6
	     CHWeek="星期五"
	    Case 7
	     CHWeek="星期六"
	   End Select
	End If
End Function


Function FormatDate(sDateTime, sReallyDo)
 Dim sJorkin
 sJorkin = GetLocale()
 If Not IsDate(sDateTime) Then sDateTime = Now()
 sDateTime = CDate(sDateTime)
 Select Case UCase(sReallyDo & "")
 Case "0", "1", "2", "3", "4"
  FormatDate = FormatDateTime(sDateTime, sReallyDo)
 Case "00"
  FormatDate = FormatDate(sDateTime, "YYYY-MM-DD hh:mm:ss")
 Case "01"
  FormatDate = FormatDate(sDateTime, "YYYY年MM月DD日")
 Case "02"
  FormatDate = FormatDate(sDateTime, "YYYY-MM-DD")
 Case "03"
  FormatDate = FormatDate(sDateTime, "hh:mm:ss")
 Case "04"
  FormatDate = FormatDate(sDateTime, "hh:mm")
 Case "ISO8601", "GOOGLE", "SITEMAP" '//ISO8601格式, 一般用于GoogleSiteMap, "+08:00" 为时区.
  FormatDate = FormatDate(sDateTime, "YYYY-MM-DDThh:mm:ss.000+08:00")
 Case "RFC822", "RSS", "FEED" '//RFC822格式, 一般用于RSS, "+0800" 为时区.
  SetLocale("en-gb")
  FormatDate = FormatDate(sDateTime, "ew, DD eMM YYYY hh:mm:ss +0800")
  SetLocale(sJorkin)
 Case "RND", "RAND", "RANDOMIZE" '//随机字符串
  Randomize
  sJorkin = Rnd()
  FormatDate = FormatDate(sDateTime, "YYYYMMDDhhmmss") & _
    Fix((9 * 10^6 -1) * sJorkin) + 10^6
 Case Else
  FormatDate = sReallyDo
  FormatDate = Replace(FormatDate, "YYYY", Year(sDateTime))
  FormatDate = Replace(FormatDate, "DD", Right("0" & Day(sDateTime), 2))
  FormatDate = Replace(FormatDate, "hh", Right("0" & Hour(sDateTime), 2))
  FormatDate = Replace(FormatDate, "mm", Right("0" & Minute(sDateTime), 2))
  FormatDate = Replace(FormatDate, "ss", Right("0" & Second(sDateTime), 2))
  FormatDate = Replace(FormatDate, "YY", Right(Year(sDateTime), 2))
  FormatDate = Replace(FormatDate, "D", Day(sDateTime))
  FormatDate = Replace(FormatDate, "h", Hour(sDateTime))
  FormatDate = Replace(FormatDate, "m", Minute(sDateTime))
  FormatDate = Replace(FormatDate, "s", Second(sDateTime))
  If InStr(1, FormatDate, "EW", 1) > 0 Then
  SetLocale("en-gb")
  FormatDate = Replace(FormatDate, "EW", UCase(WeekdayName(Weekday(sDateTime), False)))
  FormatDate = Replace(FormatDate, "eW", WeekdayName(Weekday(sDateTime), False))
  FormatDate = Replace(FormatDate, "Ew", UCase(WeekdayName(Weekday(sDateTime), True)))
  FormatDate = Replace(FormatDate, "ew", WeekdayName(Weekday(sDateTime), True))
  SetLocale(sJorkin)
  Else
  FormatDate = Replace(FormatDate, "W", WeekdayName(Weekday(sDateTime), False))
  FormatDate = Replace(FormatDate, "w", WeekdayName(Weekday(sDateTime), True))
  End If
  If InStr(1, FormatDate, "EMM", 1) > 0 Then
  SetLocale("en-gb")
  FormatDate = Replace(FormatDate, "EMM", MonthName(Month(sDateTime), False))
  FormatDate = Replace(FormatDate, "eMM", MonthName(Month(sDateTime), True))
  SetLocale(sJorkin)
  Else
  FormatDate = Replace(FormatDate, "MM", Right("0" & Month(sDateTime), 2))
  FormatDate = Replace(FormatDate, "M", Month(sDateTime))
  End If
 End Select
End Function

Sub Died
	Response.End()
End Sub

%>