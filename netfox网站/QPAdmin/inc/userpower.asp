<% Dim hasPower
    hasPower=InStr(Session("AdminSet"), ",8,")<=0       
%>
<tr id="user_right" class='tdbg'>
  <td class="txtrem">用户权限：</td>
  <td>
  <input name="in_UserRight" type="checkbox" value="1"<% If SqlCheckNum(rs("UserRight")) And 1 Then %> checked='checked'<% End If %> <% IF hasPower Then%>disabled='disabled'<% End If %> />是否禁止游戏
  <input name="in_UserRight" type="checkbox" value="2"<% If SqlCheckNum(rs("UserRight")) And 2 Then %> checked='checked'<% End If %> <% IF hasPower Then%>disabled='disabled'<% End If %>/>是否禁止旁观
  <input name="in_UserRight" type="checkbox" value="4"<% If SqlCheckNum(rs("UserRight")) And 4 Then %> checked='checked'<% End If %> <% IF hasPower Then%>disabled='disabled'<% End If %>/>是否禁止私聊
  <br />
  <input name="in_UserRight" type="checkbox" value="8"<% If SqlCheckNum(rs("UserRight")) And 8 Then %> checked='checked'<% End If %> <% IF hasPower Then%>disabled='disabled'<% End If %>/>是否禁止大厅聊天
  <input name="in_UserRight" type="checkbox" value="16"<% If SqlCheckNum(rs("UserRight")) And 16 Then %> checked='checked'<% End If %> <% IF hasPower Then%>disabled='disabled'<% End If %>/>是否禁止房间聊天
  <input name="in_UserRight" type="checkbox" value="268435456"<% If SqlCheckNum(rs("UserRight")) And 268435456 Then %> checked='checked'<% End If %> <% IF hasPower Then%>disabled='disabled'<% End If %>/>是否比赛
  </td>
</tr>
<tr id="master_right" class='tdbg2'> 
  <td class="txtrem">管理权限：</td>
  <td>
  <input name="in_MasterRight" type="checkbox" value="1"<% If SqlCheckNum(rs("MasterRight")) And 1 Then %> checked='checked'<% End If %> <% IF hasPower Then%>disabled='disabled'<% End If %>/>是否可限制游戏
  <input name="in_MasterRight" type="checkbox" value="2"<% If SqlCheckNum(rs("MasterRight")) And 2 Then %> checked='checked'<% End If %> <% IF hasPower Then%>disabled='disabled'<% End If %>/>是否可限制旁观
  <input name="in_MasterRight" type="checkbox" value="4"<% If SqlCheckNum(rs("MasterRight")) And 4 Then %> checked='checked'<% End If %> <% IF hasPower Then%>disabled='disabled'<% End If %>/>是否可限制私聊
  <br />
  <input name="in_MasterRight" type="checkbox" value="8"<% If SqlCheckNum(rs("MasterRight")) And 8 Then %> checked='checked'<% End If %> <% IF hasPower Then%>disabled='disabled'<% End If %>/>是否可限制大厅聊天
  <input name="in_MasterRight" type="checkbox" value="16"<% If SqlCheckNum(rs("MasterRight")) And 16 Then %> checked='checked'<% End If %> <% IF hasPower Then%>disabled='disabled'<% End If %>/>是否可限制房间聊天
  <input name="in_MasterRight" type="checkbox" value="32"<% If SqlCheckNum(rs("MasterRight")) And 32 Then %> checked='checked'<% End If %> <% IF hasPower Then%>disabled='disabled'<% End If %>/>是否可踢用户
  <br />
  <input name="in_MasterRight" type="checkbox" value="64"<% If SqlCheckNum(rs("MasterRight")) And 64 Then %> checked='checked'<% End If %> <% IF hasPower Then%>disabled='disabled'<% End If %>/>是否可限制帐号
  <input name="in_MasterRight" type="checkbox" value="128"<% If SqlCheckNum(rs("MasterRight")) And 128 Then %> checked='checked'<% End If %> <% IF hasPower Then%>disabled='disabled'<% End If %>/>是否可限制IP
  <input name="in_MasterRight" type="checkbox" value="256"<% If SqlCheckNum(rs("MasterRight")) And 256 Then %> checked='checked'<% End If %> <% IF hasPower Then%>disabled='disabled'<% End If %>/>是否可查看IP
  <input name="in_MasterRight" type="checkbox" value="512"<% If SqlCheckNum(rs("MasterRight")) And 512 Then %> checked='checked'<% End If %> <% IF hasPower Then%>disabled='disabled'<% End If %>/>是否可发送警告 
  <br />  
  <input name="in_MasterRight" type="checkbox" value="1024"<% If SqlCheckNum(rs("MasterRight")) And 1024 Then %> checked='checked'<% End If %> <% IF hasPower Then%>disabled='disabled'<% End If %>/>是否可广播消息
  <input name="in_MasterRight" type="checkbox" value="2048"<% If SqlCheckNum(rs("MasterRight")) And 2048 Then %> checked='checked'<% End If %> <% IF hasPower Then%>disabled='disabled'<% End If %>/>是否可游戏绑定
  <input name="in_MasterRight" type="checkbox" value="4096"<% If SqlCheckNum(rs("MasterRight")) And 4096 Then %> checked='checked'<% End If %> <% IF hasPower Then%>disabled='disabled'<% End If %>/>是否可全局绑定
 <input name="in_MasterRight" type="checkbox" value="8192"<% If SqlCheckNum(rs("MasterRight")) And 4096 Then %> checked='checked'<% End If %> <% IF hasPower Then%>disabled='disabled'<% End If %>/>是否可配置房间 
  </td></tr>
 <tr class="tdbg">
    <td class="txtrem">管理级别：</td>
    <td>
    <input name="in_MasterOrder" type="radio"  value="0"<% If rs("MasterOrder")=0 Then %>checked='checked'<% End If %> <% IF hasPower Then%>disabled='disabled'<% End If %> />普通玩家
    <input name="in_MasterOrder" type="radio"  value="1"<% If rs("MasterOrder")=1 Then %> checked='checked'<% End If %> <% IF hasPower Then%>disabled='disabled'<% End If %> /><span style="color:#105399;font-weight:bold;">内部管理员</span>
    <input name="in_MasterOrder" type="radio"  value="2"<% If rs("MasterOrder")=2 Then %> checked='checked'<% End If %> <% IF hasPower Then%>disabled='disabled'<% End If %> /><span style="color:#cd6a00;font-weight:bold;">外部管理员</span>
    </td>
 </tr> 

