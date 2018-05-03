//<--Start--从cookie中读出购物车数据的函数
function ReadOrder(name)
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
function SetOrder(item_no,item_gg,item_amount)
{
    var cookieString=document.cookie;
    if (cookieString.length>=4000)
    {
        alert("您的购物车已满\n请结束此次购物车操作后添加新购物车！");
    }
    else
    {
        var mer_list=ReadOrder('OrderStr');
        var Then = new Date();
        Then.setTime(Then.getTime()+30*60*1000);
        var item_detail="|"+item_no+"$"+item_gg+"$"+item_amount;
        if(mer_list==false)
        {
            document.cookie="OrderStr="+escape(item_detail)+";expires=" + Then.toGMTString()+";path=/";
        }
        else
        {
            if (mer_list.indexOf(escape("|"+item_no+"$"+item_gg+"$"))!=-1)
            {
				//已经有这个产品
				Edit("edit",item_no,item_gg,item_amount)
            }
            else
            {
				var o_str=mer_list.split("%7c");
				var c_str=o_str[0].split("%24");
				//alert(o_str[0]+item_gg+"|"+c_str[1]);
				if(item_gg!=c_str[1]){
					alert("此商品和你购物车中的商品不在一个店铺，请先提交购物车后购买！");
				}
				else {
                    document.cookie="OrderStr="+mer_list+escape(item_detail)+";expires=" + Then.toGMTString()+";path=/";
				}

            }
        }
		GetNum()
    }
}
//-->End

//<--Start--编辑购物车
function Edit(type,id,gg,num)
{
	var values=""
	var order_list=unescape(ReadOrder('OrderStr')).split("|");
	if(type=="del"){
		for (i=1;i<order_list.length;i++)
        {
            if(id==i) {
				values=values+"|";
			}
			else {
				values=values+"|"+order_list[i]
			}
        }
	}
	else {
		for (i=1;i<order_list.length;i++)
        {
            if(order_list[i].indexOf(id+"$"+gg+"$")==0) {
				num=parseInt(num)+parseInt(order_list[i].split("$")[2])
				order_list[i]=id+"$"+gg+"$"+num
			}
			values=values+"|"+order_list[i]
        }
	}
	var Then = new Date();
	Then.setTime(Then.getTime()+30*60*1000);
	document.cookie="OrderStr="+escape(values)+";expires=" + Then.toGMTString()+";path=/";
	//history.go(0);
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

function GetNum(){
	var m_num=0;
	var order_list=unescape(ReadOrder('OrderStr')).split("|");
    for (i=1;i<order_list.length;i++)
	{
		m_num=m_num+parseInt(order_list[i].split("$")[2])
	}
	$("#gwc_ctr").html(m_num);
}