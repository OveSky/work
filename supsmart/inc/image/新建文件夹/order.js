//<--Start--从cookie中读出购物车数据的函数
function ReadOrderForm(name)
{
    var cookieString=document.cookie;
    if (cookieString=="")
    {
        return false;
    }
    else
    {
        var firstChar,lastChar;
        firstChar=cookieString.indexOf(name);
        if(firstChar!=-1)
        {
            firstChar+=name.length+1;
            lastChar = cookieString.indexOf(';', firstChar);
            if(lastChar == -1) lastChar=cookieString.length;
            return cookieString.substring(firstChar,lastChar);
        }
        else
        {
            return false;
        }
    }    
}
//-->End

//<--Start--添加商品至购物车的函数
function SetOrderForm(item_no,item_name,item_amount,item_price)
{
    var cookieString=document.cookie;
    if (cookieString.length>=4000)
    {
        alert("您的购物车已满\n请结束此次购物车操作后添加新购物车！");
    }
    else if(isNaN(item_amount)||item_amount<1||item_amount.indexOf('.')!=-1)
    {
        alert("数量必须为整数");
    }
    else
    {
        var mer_list=ReadOrderForm('OrderStr');
        var Then = new Date();
        Then.setTime(Then.getTime()+30*60*1000);
        var item_detail="|"+item_no+"$"+item_name+"$"+item_amount+"$"+item_price;
        if(mer_list==false)
        {
            document.cookie="OrderStr="+escape(item_detail)+";expires=" + Then.toGMTString()+";path=/";
            alert("添加成功");
			history.go(0);
        }
        else
        {
            if (mer_list.indexOf(escape("|"+item_no+"$"))!=-1)
            {
                alert("添加成功");
            }
            else
            {
                document.cookie="OrderStr="+mer_list+escape(item_detail)+";expires=" + Then.toGMTString()+";path=/";
                alert("添加成功");
				history.go(0);
            }
        }
    }
}
//-->End

//<--Start--删除单个商品的函数
function Delete(id)
{
    var confirm_delete=window.confirm("确定要删除吗？")
    if (confirm_delete)
    {
		var deletedList=document.getElementById("storage").value;
        var broken_deletedList=deletedList.split("|");
        
        for (i=1;i<broken_deletedList.length;i++)
        {
            if(broken_deletedList[i].indexOf(id+"$")==0) delete broken_deletedList[i];
        }
        
        var new_deletedList="";
        
        for (i=1;i<broken_deletedList.length;i++)
        {
            
            if (broken_deletedList[i]!=undefined) new_deletedList=new_deletedList+"|"+broken_deletedList[i];
            
        }
        
        document.getElementById("storage").value=new_deletedList;
		var Then = new Date();
		Then.setTime(Then.getTime()+30*60*1000);
		var values=new_deletedList
		document.cookie="OrderStr="+escape(values)+";expires=" + Then.toGMTString()+";path=/";
		history.go(0);
    }
}
//-->End

//<--Start--清空购物车
function ClearShopBus()
{
    var confirm_delete=window.confirm("确定要清空吗？")
    if (confirm_delete)
    {
		var Then = new Date();
		Then.setTime(Then.getTime()+30*60*1000);
		var values="";
		document.cookie="OrderStr="+escape(values)+";expires=" + Then.toGMTString()+";path=/";
		history.go(0);
    }
}
//-->End