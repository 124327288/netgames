<%@ page language="C#" autoeventwireup="true" inherits="GameCardGridInfo, App_Web_gamecardgridinfo.aspx.ddf127e1" enablesessionstate="True" %>
<%@ Register TagPrefix="webdiyer" Namespace="Wuqi.Webdiyer" Assembly="AspNetPager" %>
<%@ Register TagPrefix="cc5" TagName="Header" Src="Header.ascx" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>会员卡管理</title>
     <link href='../Admin_Style.css' rel='stylesheet' type='text/css' />
    <script type="text/javascript" language="javascript" src="js/common.js"></script>
    <link href="/images/DatePicker/skin/WdatePicker.css" rel='stylesheet' type='text/css' />
<link href="/images/DatePicker/skin/whyGreen/datepicker.css" rel='stylesheet' type='text/css' />
<script language="javascript" src="/images/DatePicker/WdatePicker.js" type="text/javascript" charset="gb2312"></script>
<script language="javascript" src="/images/DatePicker/WdatePicker.js" type="text/javascript" charset="gb2312"></script>
</head>
<body leftmargin='2' topmargin='0' marginwidth='0' marginheight='0'>
<cc5:Header ID="header" runat="server" />
    <form id="form1" runat="server">
    <asp:Panel id="searchtable" runat="server"  Visible="true">
    <table width='100%' border='0' cellspacing='1' cellpadding='2' class='border' style="margin-top:4px;">
    <tr class='tdbg'>    
    <td style=" width:100px;"><strong>卡号查询:</strong></td>
    <td style=" width:290px; padding-left:10px;">
       <asp:TextBox id="txtCardNo" runat="server" width="250"></asp:TextBox>
    </td>
    <td style="font-weight:bold; width:90px;">用户查询：</td>
        <td><asp:TextBox id="txtUsername" runat="server" width="250"></asp:TextBox></td>
    </tr>
    
    <tr class="tdbg">
        <td style="font-weight:bold;">使用状态:</td>
        <td style="padding-left:5px; text-align:left">
           <asp:RadioButtonList ID="rblUse" runat="server" RepeatDirection="Horizontal">
               <asp:ListItem Value="0">未使用</asp:ListItem>
               <asp:ListItem Value="1">已经使用</asp:ListItem>
           </asp:RadioButtonList>
        </td>
        <td style="font-weight:bold;">会员卡类：</td>
        <td>
        <asp:DropDownList ID="ddlCardType" runat="server">
            <asp:ListItem Value="0" Text=""></asp:ListItem>
            <asp:ListItem Value="1">新手卡</asp:ListItem>
            <asp:ListItem Value="2">会员卡</asp:ListItem>
            <asp:ListItem Value="3">冲值卡</asp:ListItem>            
            </asp:DropDownList>
        <label style="font-weight:bold; margin-left:20px;">会员级别：</label>
        <asp:DropDownList ID="ddlMemberOrder" runat="server">          
            <asp:ListItem Value="all" Text=""></asp:ListItem>
            <asp:ListItem Value="0">普通会员</asp:ListItem>
            <asp:ListItem Value="1">红钻（30天）</asp:ListItem>
            <asp:ListItem Value="2">蓝钻（30天）</asp:ListItem>
            <asp:ListItem Value="3">黄钻（60天）</asp:ListItem>
            <asp:ListItem Value="4">紫钻（90天）</asp:ListItem>
            </asp:DropDownList>
        </td>
    </tr>
    <tr  class="tdbg">
    <td style="font-weight:bold;">充值日期：</td>
    <td style="padding-left:10px;">
        <input name='in_FilledStartDate' id="in_FilledStartDate" type='text' title="开始时间" value=""  size='10' maxlength='30' onclick="new WdatePicker(form1.in_FilledStartDate,null,false,'whyGreen')" />
        到
        <input name='in_FilledEndDate' id="in_FilledEndDate" type='text' title="结束时间" value=""  size='10' maxlength='30' onclick="new WdatePicker(form1.in_FilledEndDate,null,false,'whyGreen')"/>
    </td>
    <td style="font-weight:bold;">生成日期：</td>
    <td>
         <input name='in_BuiltStartDate' id="in_BuiltStartDate" type='text' title="开始时间" value=""  size='10' maxlength='30' onclick="new WdatePicker(form1.in_BuiltStartDate,null,false,'whyGreen')" />
        到
        <input name='in_BuiltEndDate' id="Text2" type='text' title="结束时间" value=""  size='10' maxlength='30' onclick="new WdatePicker(form1.in_BuiltEndDate,null,false,'whyGreen')"/>
    </td>
    </tr>
    <tr  class="tdbg">
		<td>&nbsp;</td>
	    <td style="padding-left:10px;">
	    <asp:Button ID="btnSearchInfo" runat="server" Text="查询" style=" padding:1px 6px 2px"  OnClick="btnSearchLog_Click"  /></td>
	    <td></td>
	    <td></td>
	</tr>
    </table>
    </asp:Panel>		
	<table id="tbResetSearch" visible="false" runat="server" width='100%' border='0' cellspacing='1' cellpadding='2' class='border' style="margin-top:4px;">
    <tr class='tdbg'>
    <td style=" width:100px;font-weight:bold;">查询</td>	
    <td  style="padding-left:45px;">
	<asp:Button ID="btnResetSearchTable" runat="server" Text="重设查询条件" Visible="False" OnClick="btnResetSearchTable_Click"></asp:Button>
    </td>
    </tr></table>
	<br />
	<table width='100%'>
        <tr>
        <td align='left'>您现在的位置：会员卡管理</a>&gt;&gt;&nbsp;<a href="GameCardGridInfo.aspx">所有成员列表</a>
                     
        </td>
        <td align='right'>共找到 <font color="red"><%=RecordCount %></font> 张卡</td>
        </tr></table>
			 <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" Width="100%" border='0' cellpadding='2' cellspacing='1' class='border' OnRowDataBound="GridView1_RowDataBound">
			 <Columns>
			    <asp:TemplateField HeaderText="选中">
			        <ItemTemplate>
                     <%# "<input onclick=\"javascript:SH_SelectOne()\" type=\"checkbox\" value=\"" + DataBinder.Eval(Container, "DataItem.CardID").ToString() + "\"	name=\"cid\">" %>							
                    </ItemTemplate>
			    </asp:TemplateField>
			    <asp:BoundField DataField="CardID" HeaderText="编号 ID" Visible="false"/>										    
				<asp:BoundField DataField="CardID" HeaderText="编号 ID"/>
				<asp:BoundField DataField="CardNo" HeaderText="充值卡卡号" />
				<asp:TemplateField HeaderText="使用状态">
						<ItemTemplate>
						    <%# DataBinder.Eval(Container, "DataItem.Nullity").ToString() == "False" ? "未使用" : "已经使用" %>						
                        </ItemTemplate>
				</asp:TemplateField>
				<asp:BoundField DataField="Accounts" HeaderText="充入用户" />
				<asp:BoundField DataField="CardType"  HeaderText="类别" />
				<asp:BoundField DataField="Score"  HeaderText="赠送金币" />
				
				<asp:TemplateField HeaderText="赠送会员">
					<ItemTemplate>
					    <%# DataBinder.Eval(Container, "DataItem.IsPresent").ToString() == "False" ? "无" : "赠送" %>						
                    </ItemTemplate>
				</asp:TemplateField>
				
				<asp:TemplateField HeaderText="会员级别">
					<ItemTemplate>
					    <%# SetMemberInfo(DataBinder.Eval(Container, "DataItem.MemberOrder")) %>						
                    </ItemTemplate>
				</asp:TemplateField>
				
				<asp:BoundField DataField="OverDate" HeaderText="赠送天数" />
				<asp:BoundField DataField="UseDate" HeaderText="充值日期"/>
				<asp:BoundField DataField="BatchNo" HeaderText="批号" />		
			 </Columns>
			 <HeaderStyle CssClass="title" />
			 <RowStyle CssClass="tdbg" Font-Names="宋体" HorizontalAlign="Center"/>		 
			 </asp:GridView>
			
		    <table width='100%' border='0' cellpadding='0' cellspacing='0' style="margin-top:4px;">
            <tr> 
            <td width='191' height='23'> 
		    <input title="选中/取消选中 本页所有Case" onClick="CheckByName(this.form,'cid','no')" type="checkbox" name="chkall" id="Checkbox1" />选中本页所有成员</td>
            <td width="574">
            <div align="left"><strong>操作</strong>
            <asp:Button ID="btnDelete" runat="server" Text=" 删除 " OnClick="btnDelete_Click" />
            </div>
         </td></tr></table>	
			<table width="100%"><tr>
            <td align="right">
			  <webdiyer:aspnetpager id="AspNetPager1" runat="server" Font-Names="宋体" CssClass="page"
			  horizontalalign="Right" onpagechanged="AspNetPager1_PageChanged" 
			  FirstPageText="首页" LastPageText="尾页" NextPageText="下一页" PrevPageText="上一页" NumericButtonTextFormatString="{0}"
            TextAfterPageIndexBox="页" TextBeforePageIndexBox="转到第"
            PageSize="25" ShowCustomInfoSection="Left" 
            CustomInfoHTML="总记录数：%RecordCount% 总页数：%PageCount% 每页记录数：%PageSize% 当前页数：&lt;span style='color:red;font-weight:bold;' &gt;%CurrentPageIndex%&lt;/span&gt;  记录：%StartRecordIndex%-%EndRecordIndex%">
        </webdiyer:aspnetpager>
        </td>
        </tr></table>
    
    </form>
</body>
</html>
