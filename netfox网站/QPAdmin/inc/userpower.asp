<% Dim hasPower
    hasPower=InStr(Session("AdminSet"), ",8,")<=0       
%>
<tr id="user_right" class='tdbg'>
  <td class="txtrem">�û�Ȩ�ޣ�</td>
  <td>
  <input name="in_UserRight" type="checkbox" value="1"<% If SqlCheckNum(rs("UserRight")) And 1 Then %> checked='checked'<% End If %> <% IF hasPower Then%>disabled='disabled'<% End If %> />�Ƿ��ֹ��Ϸ
  <input name="in_UserRight" type="checkbox" value="2"<% If SqlCheckNum(rs("UserRight")) And 2 Then %> checked='checked'<% End If %> <% IF hasPower Then%>disabled='disabled'<% End If %>/>�Ƿ��ֹ�Թ�
  <input name="in_UserRight" type="checkbox" value="4"<% If SqlCheckNum(rs("UserRight")) And 4 Then %> checked='checked'<% End If %> <% IF hasPower Then%>disabled='disabled'<% End If %>/>�Ƿ��ֹ˽��
  <br />
  <input name="in_UserRight" type="checkbox" value="8"<% If SqlCheckNum(rs("UserRight")) And 8 Then %> checked='checked'<% End If %> <% IF hasPower Then%>disabled='disabled'<% End If %>/>�Ƿ��ֹ��������
  <input name="in_UserRight" type="checkbox" value="16"<% If SqlCheckNum(rs("UserRight")) And 16 Then %> checked='checked'<% End If %> <% IF hasPower Then%>disabled='disabled'<% End If %>/>�Ƿ��ֹ��������
  <input name="in_UserRight" type="checkbox" value="268435456"<% If SqlCheckNum(rs("UserRight")) And 268435456 Then %> checked='checked'<% End If %> <% IF hasPower Then%>disabled='disabled'<% End If %>/>�Ƿ����
  </td>
</tr>
<tr id="master_right" class='tdbg2'> 
  <td class="txtrem">����Ȩ�ޣ�</td>
  <td>
  <input name="in_MasterRight" type="checkbox" value="1"<% If SqlCheckNum(rs("MasterRight")) And 1 Then %> checked='checked'<% End If %> <% IF hasPower Then%>disabled='disabled'<% End If %>/>�Ƿ��������Ϸ
  <input name="in_MasterRight" type="checkbox" value="2"<% If SqlCheckNum(rs("MasterRight")) And 2 Then %> checked='checked'<% End If %> <% IF hasPower Then%>disabled='disabled'<% End If %>/>�Ƿ�������Թ�
  <input name="in_MasterRight" type="checkbox" value="4"<% If SqlCheckNum(rs("MasterRight")) And 4 Then %> checked='checked'<% End If %> <% IF hasPower Then%>disabled='disabled'<% End If %>/>�Ƿ������˽��
  <br />
  <input name="in_MasterRight" type="checkbox" value="8"<% If SqlCheckNum(rs("MasterRight")) And 8 Then %> checked='checked'<% End If %> <% IF hasPower Then%>disabled='disabled'<% End If %>/>�Ƿ�����ƴ�������
  <input name="in_MasterRight" type="checkbox" value="16"<% If SqlCheckNum(rs("MasterRight")) And 16 Then %> checked='checked'<% End If %> <% IF hasPower Then%>disabled='disabled'<% End If %>/>�Ƿ�����Ʒ�������
  <input name="in_MasterRight" type="checkbox" value="32"<% If SqlCheckNum(rs("MasterRight")) And 32 Then %> checked='checked'<% End If %> <% IF hasPower Then%>disabled='disabled'<% End If %>/>�Ƿ�����û�
  <br />
  <input name="in_MasterRight" type="checkbox" value="64"<% If SqlCheckNum(rs("MasterRight")) And 64 Then %> checked='checked'<% End If %> <% IF hasPower Then%>disabled='disabled'<% End If %>/>�Ƿ�������ʺ�
  <input name="in_MasterRight" type="checkbox" value="128"<% If SqlCheckNum(rs("MasterRight")) And 128 Then %> checked='checked'<% End If %> <% IF hasPower Then%>disabled='disabled'<% End If %>/>�Ƿ������IP
  <input name="in_MasterRight" type="checkbox" value="256"<% If SqlCheckNum(rs("MasterRight")) And 256 Then %> checked='checked'<% End If %> <% IF hasPower Then%>disabled='disabled'<% End If %>/>�Ƿ�ɲ鿴IP
  <input name="in_MasterRight" type="checkbox" value="512"<% If SqlCheckNum(rs("MasterRight")) And 512 Then %> checked='checked'<% End If %> <% IF hasPower Then%>disabled='disabled'<% End If %>/>�Ƿ�ɷ��;��� 
  <br />  
  <input name="in_MasterRight" type="checkbox" value="1024"<% If SqlCheckNum(rs("MasterRight")) And 1024 Then %> checked='checked'<% End If %> <% IF hasPower Then%>disabled='disabled'<% End If %>/>�Ƿ�ɹ㲥��Ϣ
  <input name="in_MasterRight" type="checkbox" value="2048"<% If SqlCheckNum(rs("MasterRight")) And 2048 Then %> checked='checked'<% End If %> <% IF hasPower Then%>disabled='disabled'<% End If %>/>�Ƿ����Ϸ��
  <input name="in_MasterRight" type="checkbox" value="4096"<% If SqlCheckNum(rs("MasterRight")) And 4096 Then %> checked='checked'<% End If %> <% IF hasPower Then%>disabled='disabled'<% End If %>/>�Ƿ��ȫ�ְ�
 <input name="in_MasterRight" type="checkbox" value="8192"<% If SqlCheckNum(rs("MasterRight")) And 4096 Then %> checked='checked'<% End If %> <% IF hasPower Then%>disabled='disabled'<% End If %>/>�Ƿ�����÷��� 
  </td></tr>
 <tr class="tdbg">
    <td class="txtrem">������</td>
    <td>
    <input name="in_MasterOrder" type="radio"  value="0"<% If rs("MasterOrder")=0 Then %>checked='checked'<% End If %> <% IF hasPower Then%>disabled='disabled'<% End If %> />��ͨ���
    <input name="in_MasterOrder" type="radio"  value="1"<% If rs("MasterOrder")=1 Then %> checked='checked'<% End If %> <% IF hasPower Then%>disabled='disabled'<% End If %> /><span style="color:#105399;font-weight:bold;">�ڲ�����Ա</span>
    <input name="in_MasterOrder" type="radio"  value="2"<% If rs("MasterOrder")=2 Then %> checked='checked'<% End If %> <% IF hasPower Then%>disabled='disabled'<% End If %> /><span style="color:#cd6a00;font-weight:bold;">�ⲿ����Ա</span>
    </td>
 </tr> 

