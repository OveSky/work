<!--
document.write('<style>.dragAble {width:200px;height:230px;position:relative;cursor:move;background-color: transparent;z-index:9998;}</style>');

var cal;
var isFocus=false; //是否为焦点
function left_char(mainstr,lnglen) {
 if (lnglen>0) {return mainstr.substring(0,lnglen)}
 else{return null}
 }
function right_char(mainstr,lnglen) {
 if (mainstr.length-lnglen>=0 && mainstr.length>=0 && mainstr.length-lnglen<=mainstr.length) {
 return mainstr.substring(mainstr.length-lnglen,mainstr.length)}
 else{return null}
 }

function SelectDate(obj)
{
    var date = new Date();
    var by = date.getFullYear()-8; //最小值 → 20 年前
    var ey = date.getFullYear()+3; //最大值 → 5 年后
    cal = (cal==null) ? new Calendar(by, ey, 0) : cal;    //初始化为中文版，1为英文版
    //cal.dateFormatStyle = strFormat; // 默认显示格式为:yyyy-MM-dd ,还可显示 yyyy/MM/dd
    cal.show(obj);
}
/* 返回日期 */
String.prototype.toDate = function(style){
var y = this.substring(style.indexOf('y'),style.lastIndexOf('y')+1);//年
var m = this.substring(style.indexOf('M'),style.lastIndexOf('M')+1);//月
var d = this.substring(style.indexOf('d'),style.lastIndexOf('d')+1);//日
if(isNaN(y)) y = new Date().getFullYear();
if(isNaN(m)) m = new Date().getMonth();
if(isNaN(d)) d = new Date().getDate();
var dt ;
eval ("dt = new Date('"+ y+"', '"+(m-1)+"','"+ d +"')");
return dt;
}
/* 格式化日期 */
Date.prototype.format = function(style){
var o = {
    "M+" : this.getMonth() + 1, //month
    "d+" : this.getDate(),      //day
    "h+" : this.getHours(),     //hour
    "m+" : this.getMinutes(),   //minute
    "s+" : this.getSeconds(),   //second
    "w+" : "天一二三四五六".charAt(this.getDay()),   //week
    "q+" : Math.floor((this.getMonth() + 3) / 3), //quarter
    "S" : this.getMilliseconds() //millisecond
}
if(/(y+)/.test(style)){
    style = style.replace(RegExp.$1,
    (this.getFullYear() + "").substr(4 - RegExp.$1.length));
}
for(var k in o){
    if(new RegExp("("+ k +")").test(style)){
      style = style.replace(RegExp.$1,
        RegExp.$1.length == 1 ? o[k] :
        ("00" + o[k]).substr(("" + o[k]).length));
    }
}
return style;
};

/*
* 日历类
* @param   beginYear 1990
* @param   endYear   2010
* @param   lang      0(中文)|1(英语) 可自由扩充
* @param   dateFormatStyle "yyyy-MM-dd";
*/
function Calendar(beginYear, endYear, lang, dateFormatStyle){
this.beginYear = 2000;
this.endYear = 2020;
this.lang = 0;            //0(中文) | 1(英文)
this.dateFormatStyle = "yyyy-MM-dd";

if (beginYear != null && endYear != null){
    this.beginYear = beginYear;
    this.endYear = endYear;
}
if (lang != null){
    this.lang = lang
}

if (dateFormatStyle != null){
    this.dateFormatStyle = dateFormatStyle
}

this.dateControl = null;
this.panel = this.getElementById("calendarPanel");
this.container = this.getElementById("ContainerPanel");
this.form = null;

this.date = new Date();
this.year = this.date.getFullYear();
this.month = this.date.getMonth();


this.colors = {
"cur_word"      : "#FFFFFF", //当日日期文字颜色
"cur_bg"        : "#83A6F4", //当日日期单元格背影色
"sel_bg"        : "#FFCCCC", //已被选择的日期单元格背影色
"sun_word"      : "#FF0000", //星期天文字颜色
"sat_word"      : "#0000FF", //星期六文字颜色
"td_word_light" : "#333333", //单元格文字颜色
"td_word_dark" : "#CCCCCC", //单元格文字暗色
"td_bg_out"     : "#EFEFEF", //单元格背影色
"td_bg_over"    : "#FFCC00", //单元格背影色
"tr_word"       : "#FFFFFF", //日历头文字颜色
"tr_bg"         : "#666666", //日历头背影色
"input_border" : "#CCCCCC", //input控件的边框颜色
"input_bg"      : "#EFEFEF"   //input控件的背影色
}

this.draw();
this.bindYear();
this.bindMonth();
this.changeSelect();
this.bindData();
}

/*
* 日历类属性（语言包，可自由扩展）
*/
Calendar.language ={
"year"   : [[""], [""]],
"months" : [["一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月"],
        ["JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"]
         ],
"weeks" : [["日","一","二","三","四","五","六"],
        ["SUN","MON","TUR","WED","THU","FRI","SAT"]
         ],
"clear" : [["清空"], ["CLS"]],
"today" : [["今天"], ["TODAY"]],
"close" : [["关闭"], ["CLOSE"]]
}

Calendar.prototype.draw = function(){
calendar = this;

var mvAry = [];
mvAry[mvAry.length] = ' <div class="dragAble"><table width="200px" border="0" cellspacing="0" cellpadding="0" align="center" style="filter:progid:DXImageTransform.Microsoft.Shadow(color=#505050,direction=120,strength=4);-moz-box-shadow: 3px 3px 10px #505050;-webkit-box-shadow: 3px 3px 10px #505050;box-shadow:3px 3px 10px #505050;"><tr height="26"><td height="26" width="5px" style="background:url(/mis/images/dialog_background_top_left.gif); background-repeat:no-repeat;"></td><td nowrap style="background:url(/mis/images/dialog_background_top_center.gif); background-repeat:repeat-x;"><div name="calendarForm" style="margin: 0px;" id="drag"><span style="color:white;float:left;height:20px;margin-top:4px;width:150px;"><b><img src="/mis/images/application.gif" align="absmiddle"><image src="/mis/images/pline.gif" width=3 border=0 align="absmiddle">选择日期</b></span><span style="float:right;margin-right:0px;margin-top:4px;"><img src="/mis/images/window_close.gif" onMouseOver=javascript:this.src="/mis/images/window_close_r.gif" onMouseOut=javascript:this.src="/mis/images/window_close.gif" title="关闭" onClick="JavaScript:calendar.hide();" style="cursor:hand;"></span></div></td><td width="5px" style="background:url(/mis/images/dialog_background_top_right.gif); background-repeat:no-repeat;"></td></tr><tr height="100%" bgcolor="#00688b"><td height="100%" width="5px" style="background:url(/mis/images/dialog_background_middle_left.gif); background-repeat:repeat-y;"></td><td align="center">';
mvAry[mvAry.length] = '    <table width="100%" border="0" cellpadding="0" cellspacing="1" style="font-size:12px;background-color:#aaaaaa;">';
mvAry[mvAry.length] = '      <tr height=18>';
mvAry[mvAry.length] = '        <th align="left" width="10%" nowrap><input style="border: 1px solid ' + calendar.colors["input_border"] + ';background-color:' + calendar.colors["input_bg"] + ';width:18px;height:18px;" name="prevYear" type="button" id="prevYear" value="&lt;&lt;" /><input style="border: 1px solid ' + calendar.colors["input_border"] + ';background-color:' + calendar.colors["input_bg"] + ';width:18px;height:18px;" name="nextYear" type="button" id="nextYear" value="&gt;&gt;" /></th>';
mvAry[mvAry.length] = '        <th align="center" width="80%" nowrap="nowrap"><select name="calendarYear" id="calendarYear" style="font-size:12px;width:50px;" title="点击选择"></select><select name="calendarMonth" id="calendarMonth" style="font-size:12px;width:60px;" title="点击选择"></select></th>';
mvAry[mvAry.length] = '        <th align="right" width="10%" nowrap><input style="border: 1px solid ' + calendar.colors["input_border"] + ';background-color:' + calendar.colors["input_bg"] + ';width:15px;height:18px;" name="prevMonth" type="button" id="prevMonth" value="&lt;" /><input style="border: 1px solid ' + calendar.colors["input_border"] + ';background-color:' + calendar.colors["input_bg"] + ';width:15px;height:18px;" name="nextMonth" type="button" id="nextMonth" value="&gt;" /></th>';
mvAry[mvAry.length] = '      </tr>';
mvAry[mvAry.length] = '    </table>';
mvAry[mvAry.length] = '    <table id="calendarTable" width="100%" style="border:0px solid #CCCCCC;background-color:#FFFFFF;font-size:12px" border="0" cellpadding="1" cellspacing="1">';
mvAry[mvAry.length] = '      <tr height=18>';
for(var i = 0; i < 7; i++){
    mvAry[mvAry.length] = '      <th style="font-weight:normal;background-color:' + calendar.colors["tr_bg"] + ';color:' + calendar.colors["tr_word"] + ';">' + Calendar.language["weeks"][this.lang][i] + '</th>';
}
mvAry[mvAry.length] = '      </tr>';
for(var i = 0; i < 6;i++){
    mvAry[mvAry.length] = '    <tr height=18 align="center">';
    for(var j = 0; j < 7; j++){
      if (j == 0){
        mvAry[mvAry.length] = ' <td style="cursor:hand;color:' + calendar.colors["sun_word"] + ';"></td>';
      } else if(j == 6){
        mvAry[mvAry.length] = ' <td style="cursor:hand;color:' + calendar.colors["sat_word"] + ';"></td>';
      } else{
        mvAry[mvAry.length] = ' <td style="cursor:hand;"></td>';
      }
    }
    mvAry[mvAry.length] = '    </tr>';
}
mvAry[mvAry.length] = '      <tr height=18 style="background-color:' + calendar.colors["input_bg"] + ';"><td colspan=7 align=center>时分：<select id="set_hour" title="时分选择框留空则为不启用时分设置。\n如需启用则请先选择时分，然后点击日期！"><option value=""></option><option value="00">00</option><option value="01">01</option><option value="02">02</option><option value="03">03</option><option value="04">04</option><option value="05">05</option><option value="06">06</option><option value="07">07</option><option value="08">08</option><option value="09">09</option><option value="10">10</option><option value="11">11</option><option value="12">12</option><option value="13">13</option><option value="14">14</option><option value="15">15</option><option value="16">16</option><option value="17">17</option><option value="18">18</option><option value="19">19</option><option value="20">20</option><option value="21">21</option><option value="22">22</option><option value="23">23</option></select>时<select id="set_minute" title="时分选择框留空则为不启用时分设置。\n如需启用则请先选择时分，然后点击日期！"><option value=""></option><option value="00">00</option><option value="05">05</option><option value="10">10</option><option value="15">15</option><option value="20">20</option><option value="25">25</option><option value="30">30</option><option value="35">35</option><option value="40">40</option><option value="45">45</option><option value="50">50</option><option value="55">55</option></select>分<input title="清空时分选择框则为不启用时分设置！" type="button" value="清除" style="border: 1px solid ' + calendar.colors["input_border"] + ';background-color:' + calendar.colors["input_bg"] + ';width:35px;height:18px;font-size:12px;cursor:pointer;" onclick="document.getElementById(\'set_hour\').value=\'\';document.getElementById(\'set_minute\').value=\'\';"/></td></tr>';
mvAry[mvAry.length] = '      <tr height=18 style="background-color:' + calendar.colors["input_bg"] + ';">';
mvAry[mvAry.length] = '        <th colspan="2"><input name="calendarClear" type="button" id="calendarClear" value="' + Calendar.language["clear"][this.lang] + '" style="border: 1px solid ' + calendar.colors["input_border"] + ';background-color:' + calendar.colors["input_bg"] + ';width:100%;height:18px;font-size:12px;cursor:pointer;"/></th>';
mvAry[mvAry.length] = '        <th colspan="3"><input name="calendarToday" type="button" id="calendarToday" value="' + Calendar.language["today"][this.lang] + '" style="border: 1px solid ' + calendar.colors["input_border"] + ';background-color:' + calendar.colors["input_bg"] + ';width:100%;height:18px;font-size:12px;cursor:pointer;"/></th>';
mvAry[mvAry.length] = '        <th colspan="2"><input name="calendarClose" type="button" id="calendarClose" value="' + Calendar.language["close"][this.lang] + '" style="border: 1px solid ' + calendar.colors["input_border"] + ';background-color:' + calendar.colors["input_bg"] + ';width:100%;height:18px;font-size:12px;cursor:pointer;"/></th>';
mvAry[mvAry.length] = '      </tr>';
mvAry[mvAry.length] = '    </table>';
mvAry[mvAry.length] = ' </td><td width="5px" style="background:url(/mis/images/dialog_background_middle_right.gif); background-repeat:repeat-y;"></td></tr><tr height="5" bgcolor="#00688b"><td height="5" width="5px" style="background:url(/mis/images/dialog_background_bottom_left.gif); background-repeat:no-repeat;"></td><td style="background:url(/mis/images/dialog_background_bottom_center.gif); background-repeat:repeat-x;"></td><td width="5px" style="background:url(/mis/images/dialog_background_bottom_right.gif); background-repeat:no-repeat;"></td></tr></table></div>';
this.panel.innerHTML = mvAry.join("");

var obj = this.getElementById("prevYear");
obj.onclick = function (){calendar.goPrevYear(calendar);}
obj.onblur = function (){calendar.onblur();}
this.prevYear= obj;

obj = this.getElementById("nextYear");
obj.onclick = function (){calendar.goNextYear(calendar);}
obj.onblur = function (){calendar.onblur();}
this.nextYear= obj;

obj = this.getElementById("prevMonth");
obj.onclick = function (){calendar.goPrevMonth(calendar);}
obj.onblur = function (){calendar.onblur();}
this.prevMonth= obj;

obj = this.getElementById("nextMonth");
obj.onclick = function (){calendar.goNextMonth(calendar);}
obj.onblur = function (){calendar.onblur();}
this.nextMonth= obj;

obj = this.getElementById("calendarClear");
obj.onclick = function (){calendar.dateControl.value = "";calendar.hide();}
this.calendarClear = obj;

obj = this.getElementById("calendarClose");
obj.onclick = function (){calendar.hide();}
this.calendarClose = obj;

obj = this.getElementById("calendarYear");
obj.onchange = function (){calendar.update(calendar);}
obj.onblur = function (){calendar.onblur();}
this.calendarYear = obj;

obj = this.getElementById("calendarMonth");
with(obj)
{
    onchange = function (){calendar.update(calendar);}
    onblur = function (){calendar.onblur();}
}this.calendarMonth = obj;

obj = this.getElementById("calendarToday");
obj.onclick = function (){
    var today = new Date();
    calendar.date = today;
    calendar.year = today.getFullYear();
    calendar.month = today.getMonth();
    calendar.changeSelect();
    calendar.bindData();
    calendar.dateControl.value = today.format(calendar.dateFormatStyle);
    if(document.getElementById('set_hour').value!=''){if (document.getElementById('set_minute').value==''){document.getElementById('set_minute').value='00'};calendar.dateControl.value=calendar.dateControl.value + ' '+document.getElementById('set_hour').value +':'+document.getElementById('set_minute').value+':00'};
    calendar.hide();
}
this.calendarToday = obj;
}

//年份下拉框绑定数据
Calendar.prototype.bindYear = function(){
var cy = this.calendarYear;
cy.length = 0;
for (var i = this.beginYear; i <= this.endYear; i++){
    cy.options[cy.length] = new Option(i + Calendar.language["year"][this.lang], i);
}
}

//月份下拉框绑定数据
Calendar.prototype.bindMonth = function(){
var cm = this.calendarMonth;
cm.length = 0;
for (var i = 0; i < 12; i++){
    cm.options[cm.length] = new Option(Calendar.language["months"][this.lang][i], i);
}
}

//向前一年
Calendar.prototype.goPrevYear = function(e){
if (this.year == 1900 && this.month == 0){return;}
this.year--;
this.date = new Date(this.year, this.month, 1);
this.changeSelect();
this.bindData();
}

//向后一年
Calendar.prototype.goNextYear = function(e){
if (this.year == 2999 && this.month == 11){return;}
this.year++;
this.date = new Date(this.year, this.month, 1);
this.changeSelect();
this.bindData();
}

//向前一月
Calendar.prototype.goPrevMonth = function(e){
if (this.year == 1900 && this.month == 0){return;}
this.month--;
if (this.month == -1){
    this.year--;
    this.month = 11;
}
this.date = new Date(this.year, this.month, 1);
this.changeSelect();
this.bindData();
}

//向后一月
Calendar.prototype.goNextMonth = function(e){
if (this.year == 2999 && this.month == 11){return;}
this.month++;
if (this.month == 12){
    this.year++;
    this.month = 0;
}
this.date = new Date(this.year, this.month, 1);
this.changeSelect();
this.bindData();
}

//改变SELECT选中状态
Calendar.prototype.changeSelect = function(){
var cy = this.calendarYear;
var cm = this.calendarMonth;
var pass = 0;
for (var i= 0; i < cy.length; i++){
    if (cy.options[i].value == this.date.getFullYear()){
      cy[i].selected = true;
      pass = 1;
      break;
    }
  }
if (pass==0){
    cy.options[cy.length] = new Option(this.date.getFullYear() + Calendar.language["year"][this.lang], this.date.getFullYear());
    for (var i= 0; i < cy.length; i++){
        if (cy.options[i].value == this.date.getFullYear()){
          cy[i].selected = true;
          pass = 1;
          break;
        }
      }
    }
for (var i= 0; i < cm.length; i++){
    if (cm.options[i].value == this.date.getMonth()){
      cm[i].selected = true;
      break;
    }
}
}

//更新年、月
Calendar.prototype.update = function (e){
this.year = e.calendarYear.options[e.calendarYear.selectedIndex].value;
this.month = e.calendarMonth.options[e.calendarMonth.selectedIndex].value;
this.date = new Date(this.year, this.month, 1);
this.changeSelect();
this.bindData();
}

//绑定数据到月视图
Calendar.prototype.bindData = function (){
var calendar = this;
var dateArray = this.getMonthViewArray(this.date.getFullYear(), this.date.getMonth());
var tds = this.getElementById("calendarTable").getElementsByTagName("td");
for(var i = 0; i < tds.length; i++){
tds[i].style.backgroundColor = calendar.colors["td_bg_out"];
    tds[i].onclick = function () {return;}
    tds[i].onmouseover = function () {return;}
    tds[i].onmouseout = function () {return;}
    if (i > dateArray.length - 1) break;
    tds[i].innerHTML = dateArray[i];
    if (dateArray[i] != "&nbsp;"){
      tds[i].onclick = function () {
        if (calendar.dateControl != null){
          calendar.dateControl.value = new Date(calendar.date.getFullYear(),calendar.date.getMonth(),this.innerHTML).format(calendar.dateFormatStyle);
          if(document.getElementById('set_hour').value!=''){if (document.getElementById('set_minute').value==''){document.getElementById('set_minute').value='00'};calendar.dateControl.value=calendar.dateControl.value + ' '+document.getElementById('set_hour').value +':'+document.getElementById('set_minute').value+':00'};
        }
        calendar.hide();
      }
      tds[i].onmouseover = function () {
        this.style.backgroundColor = calendar.colors["td_bg_over"];
      }
      tds[i].onmouseout = function () {
        this.style.backgroundColor = calendar.colors["td_bg_out"];
      }
      if (new Date().format(calendar.dateFormatStyle) ==
          new Date(calendar.date.getFullYear(),
                   calendar.date.getMonth(),
                   dateArray[i]).format(calendar.dateFormatStyle)) {
        tds[i].style.backgroundColor = calendar.colors["cur_bg"];
        tds[i].onmouseover = function () {
          this.style.backgroundColor = calendar.colors["td_bg_over"];
        }
        tds[i].onmouseout = function () {
          this.style.backgroundColor = calendar.colors["cur_bg"];
        }
      }//end if
 
      //设置已被选择的日期单元格背影色
      if (calendar.dateControl != null && calendar.dateControl.value == new Date(calendar.date.getFullYear(),
                   calendar.date.getMonth(),
                   dateArray[i]).format(calendar.dateFormatStyle)) {
        tds[i].style.backgroundColor = calendar.colors["sel_bg"];
        tds[i].onmouseover = function () {
          this.style.backgroundColor = calendar.colors["td_bg_over"];
        }
        tds[i].onmouseout = function () {
          this.style.backgroundColor = calendar.colors["sel_bg"];
        }
      }
    }
}
}

//根据年、月得到月视图数据(数组形式)
Calendar.prototype.getMonthViewArray = function (y, m) {
var mvArray = [];
var dayOfFirstDay = new Date(y, m, 1).getDay();
var daysOfMonth = new Date(y, m + 1, 0).getDate();
for (var i = 0; i < 42; i++) {
    mvArray[i] = "&nbsp;";
}
for (var i = 0; i < daysOfMonth; i++){
    mvArray[i + dayOfFirstDay] = i + 1;
}
return mvArray;
}

//扩展 document.getElementById(id) 多浏览器兼容性 from meizz tree source
Calendar.prototype.getElementById = function(id){
if (typeof(id) != "string" || id == "") return null;
if (document.getElementById) return document.getElementById(id);
if (document.all) return document.all(id);
try {return eval(id);} catch(e){ return null;}
}

//扩展 object.getElementsByTagName(tagName)
Calendar.prototype.getElementsByTagName = function(object, tagName){
if (document.getElementsByTagName) return document.getElementsByTagName(tagName);
if (document.all) return document.all.tags(tagName);
}

//取得HTML控件绝对位置
Calendar.prototype.getAbsPoint = function (e){
var x = e.offsetLeft;
var y = e.offsetTop-100;
while(e = e.offsetParent){
    x += e.offsetLeft;
    y += e.offsetTop;
}
return {"x": x, "y": y};
}

//显示日历
Calendar.prototype.show = function (dateObj, popControl) {
if (dateObj == null){
    throw new Error("arguments[0] is necessary")
}
this.dateControl = dateObj;
var mytime;
if (dateObj.value.length>0)
{
  dateObj.value=dateObj.value.replace(/\//g,"-");
  if (right_char(left_char(dateObj.value,7),1)=='-'){dateObj.value=left_char(dateObj.value,4)+'-0'+right_char(dateObj.value,(dateObj.value.length-5))};
  if (dateObj.value.length-9==0){dateObj.value=left_char(dateObj.value,7)+'-0'+right_char(dateObj.value,1)};
  if (dateObj.value.length-9>0)
    {
      if (right_char(left_char(dateObj.value,10),1)==' '){dateObj.value=left_char(dateObj.value,7)+'-0'+right_char(dateObj.value,(dateObj.value.length-8))};
        if (dateObj.value.length-10>0)
        {
          if (right_char(left_char(dateObj.value,13),1)==':'){dateObj.value=left_char(dateObj.value,10)+' 0'+right_char(dateObj.value,(dateObj.value.length-11))};
          if (right_char(left_char(dateObj.value,16),1)==':'){dateObj.value=left_char(dateObj.value,13)+':0'+right_char(dateObj.value,(dateObj.value.length-14))};
        };
    };
  mytime = dateObj.value;
};
this.date = (dateObj.value.length > 0) ? new Date(dateObj.value.toDate(this.dateFormatStyle)) : new Date() ;//若为空则显示当前月份
this.year = this.date.getFullYear();
this.month = this.date.getMonth();
this.changeSelect();
this.bindData();
if (popControl == null){popControl = dateObj;};
var xy = this.getAbsPoint(popControl);
this.panel.style.left = xy.x -25 + "px";
this.panel.style.top = (xy.y + dateObj.offsetHeight) + "px";
this.panel.style.display = "";
this.container.style.display = "";
dateObj.onblur = function(){calendar.onblur();}
this.container.onmouseover = function(){isFocus=true;}
this.container.onmouseout = function(){isFocus=false;}
if ((mytime+'CS').length > 17)
  {this.getElementById('set_hour').value=right_char(left_char(mytime,13),2);this.getElementById('set_minute').value=right_char('0'+(parseInt(right_char(left_char(mytime,16),2)/5)*5),2);}
  else
  {this.getElementById('set_hour').value='';this.getElementById('set_minute').value='';}
}

//隐藏日历
Calendar.prototype.hide = function() {
this.panel.style.display = "none";
this.container.style.display = "none";
isFocus=false;
}

//焦点转移时隐藏日历
Calendar.prototype.onblur = function() {
    if(!isFocus){this.hide();}
}
document.write('<div id="ContainerPanel" style="display:none;"><div id="calendarPanel" style="position: absolute;display: none;z-index: 9999;');
document.write('background-color: transparent;border: 0px solid #CCCCCC;width:160px;font-size:12px;margin-left:25px;"></div>');
document.write('</div>');

/*
在class为dragAble的元素上执行拖动操作时，改变class为dragAble的元素的位置。
*/

var ie=document.all;
var nn6=document.getElementByIdx&&!document.all;
var isdrag_me=false;
var pos_y,pos_x;
var oDragObj;

function moveMouse(e) {
 if (isdrag_me) {
 oDragObj.style.top  =  (nn6 ? nTY + e.clientY - pos_y : nTY + event.clientY - pos_y)+"px";
 oDragObj.style.left  =  (nn6 ? nTX + e.clientX - pos_x : nTX + event.clientX - pos_x)+"px";
 //return false;
 }
}

function initDrag(e) {
 var oDragHandle = nn6 ? e.target : event.srcElement;
 var topElement = "HTML";
 while (oDragHandle.tagName != topElement && oDragHandle.className != "dragAble") {
 oDragHandle = nn6 ? oDragHandle.parentNode : oDragHandle.parentElement;
 }
 if (oDragHandle.className=="dragAble") {
 isdrag_me = true;
 oDragObj = oDragHandle;
 nTY = parseInt(oDragObj.style.top+0);
 pos_y = nn6 ? e.clientY : event.clientY;
 nTX = parseInt(oDragObj.style.left+0);
 pos_x = nn6 ? e.clientX : event.clientX;
 document.onmousemove=moveMouse;
 //return false;
 }
}
document.onmousedown=initDrag;
document.onmouseup=new Function("isdrag_me=false");
//-->