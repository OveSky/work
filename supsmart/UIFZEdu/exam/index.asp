<%option explicit%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>���ӵ����߿���ϵͳ</title>
</head>
<script language="javascript">
//���Ʊ�ҳ�洰��Ϊ���㴰��
	if(window.parent.name!=window.name)
	{
		window.open('index.asp','_top');
	}
</script>
<frameset rows="80,*" cols="*" framespacing="2" frameborder="no" border="0">
  <frame name="top" src="index_top.asp">
  <frameset cols="190,*" rows="*" framespacing="0" frameborder="no" border="0">
    <frame name="left" src="index_left.asp">
	<%
	'�����Ƿ���������������Ҫ�����д��ĸ�ҳ��
	if request.querystring("continue") <> "" then
		response.write "<frame name='main' src='testing.asp?prjid=" & Trim(request("prjid")) & "'>"
	else
		response.write "<frame name='main' src='index_main.asp'>"	
	end if
	%>
<frame src="UntitledFrame-3"></frameset><noframes></noframes>
</html>
