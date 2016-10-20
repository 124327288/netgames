<%@ page language="C#" autoeventwireup="true" inherits="GameCardCreator, App_Web_gamecardcreator.aspx.ddf127e1" enablesessionstate="True" %>
<%@ Register TagPrefix="cc5" TagName="Header" Src="Header.ascx" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>会员卡生成</title>
    <link href='../Admin_Style.css' rel='stylesheet' type='text/css' />
	<script type="text/javascript" src="js/common.js"></script>
	<script type="text/javascript">
	    function OnMemberOrderChange(memberOrder) {
	       // alert(memberOrder);
	        var mOrder=memberOrder.options[memberOrder.selectedIndex].value
	       // alert(mOrder);
	        var days=document.getElementById("txtOverDays");
	        switch (mOrder){
	            case "1":
	                days.value="30";
	                break;
                case "2":
                days.value="30";
                break;
                case "3":
                days.value="60";
                break;
                case "4":
                days.value="90";
                break;
                default:
                days.value="0";
                break;
	        }
	        
	        //alert(days.value);
	    }
	</script>
</head>
<body>
    
    <cc5:Header ID="header" runat="server" />
    

    <form id="form1" runat="server">
   <table width='100%'>
        <tr>
        <td align='left'>您现在的位置：会员卡管理&gt;&gt;&nbsp;<a href="GameCardGridInfo.aspx">批量添加新充值卡</a>
                     
        </td>
        <td align='right'></td>
        </tr></table>
    <table class="border" cellspacing="0" cellpadding="8" width="100%" align="center" >				
		<tr class="tdbg">
			<td width="20%" class="txtrem">充值卡类别：</td>
			<td>	
            <asp:DropDownList ID="ddlCardType" runat="server">
            <asp:ListItem Value="1">新手卡</asp:ListItem>
            <asp:ListItem Value="2">会员卡</asp:ListItem>
            <asp:ListItem Value="3">冲值卡</asp:ListItem>            
            </asp:DropDownList>
            </td>
        </tr>       
        <tr class="tdbg">
        <td class="txtrem"> 赠送金币：</td>
        <td><asp:TextBox ID="txtScore" runat="server">0</asp:TextBox></td>
        </tr>
          <tr class="tdbg">
        <td class="txtrem">是否赠送会员：</td>
        <td >
        <asp:RadioButton ID="rbPresent_2" runat="server" Text="无" Checked="true" GroupName="present" />&nbsp;&nbsp;&nbsp;&nbsp;
            <asp:RadioButton ID="rbPresent_1" runat="server" Text="赠送" GroupName="present" />
            
        </td>
        </tr>
        <tr class="tdbg">
        <td class="txtrem">          
            赠送会员：
           </td>
        <td>
            <asp:DropDownList ID="ddlMemberOrder" runat="server" onchange="OnMemberOrderChange(this);">          
            <asp:ListItem Value="0">普通会员</asp:ListItem>
            <asp:ListItem Value="1">红钻（30天）</asp:ListItem>
            <asp:ListItem Value="2">蓝钻（30天）</asp:ListItem>
            <asp:ListItem Value="3">黄钻（60天）</asp:ListItem>
            <asp:ListItem Value="4">紫钻（90天）</asp:ListItem>
            </asp:DropDownList>
			</td>
		</tr>
		<tr class="tdbg">
		<td  class="txtrem">赠送会员天数：</td>
		<td>
            <asp:TextBox ID="txtOverDays" runat="server">0</asp:TextBox>
		</td>
		</tr>
        <tr class="tdbg">
            <td class="txtrem">添加数量：
            </td>
            <td>
                <asp:TextBox ID="txtAddNum" MaxLength="14" runat="server" Width="228px"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvAddNum" runat="server" ControlToValidate="txtAddNum"
                    Display="Dynamic" ErrorMessage="请填写添加数量！"></asp:RequiredFieldValidator></td>
        </tr>
        <tr class="tdbg">
            <td class="txtrem">批号：
            </td>
            <td>
                <asp:TextBox ID="txtBatchNo" MaxLength="14" runat="server" Width="228px">0</asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvBatchNo" runat="server" ControlToValidate="txtBatchNo"
                    ErrorMessage="请填写生成批号!"></asp:RequiredFieldValidator></td>
        </tr>
        <tr class="tdbg">
            <td class="txtrem">操作：
            </td>
            <td >
                <asp:Button ID="btnAddCard" runat="server" Text="添加到数据库" OnClick="btnAddCard_Click" />&nbsp;&nbsp;&nbsp;&nbsp;
                <asp:Button ID="btnExcel" runat="server" Text="导出充值卡" CausesValidation="False" OnClick="btnExcel_Click" />&nbsp;&nbsp;&nbsp;&nbsp;
                </td>
        </tr>
        <tr class="tdbg">
            <td class="txtrem">
            </td>
            <td>
                <asp:Label ID="lblMsg" runat="server"></asp:Label></td>
        </tr>
		</table>
   
   
    </form>
</body>
</html>
