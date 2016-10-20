<%
Dim oUpFileStream
'----------------------------------------------------------------------
'�ļ��ϴ���
Class UpFile_Class

Dim Form,File,Version,Err 

Private Sub Class_Initialize
 Version = "�޾��ϴ��� Version V1.2"
 Err = -1
End Sub

Private Sub Class_Terminate  
  '�������������
  If Err < 0 Then
    Form.RemoveAll
    Set Form = Nothing
    File.RemoveAll
    Set File = Nothing
    oUpFileStream.Close
    Set oUpFileStream = Nothing
  End If
End Sub
   
Public Sub GetData (MaxSize)
   '�������
  Dim RequestBinData,sSpace,bCrLf,sInfo,iInfoStart,iInfoEnd,tStream,iStart,oFileInfo
  Dim iFileSize,sFilePath,sFileType,sFormValue,sFileName
  Dim iFindStart,iFindEnd
  Dim iFormStart,iFormEnd,sFormName
   '���뿪ʼ
  If Request.TotalBytes < 1 Then  '���û�������ϴ�
    Err = 1
    Exit Sub
  End If
  If MaxSize > 0 Then '������ƴ�С
    If Request.TotalBytes > MaxSize Then
    Err = 2	'����ϴ������ݳ�������
    Exit Sub
    End If
  End If
  Set Form = Server.CreateObject ("Scripting.Dictionary")
  Form.CompareMode = 1
  Set File = Server.CreateObject ("Scripting.Dictionary")
  File.CompareMode = 1
  Set tStream = Server.CreateObject ("ADODB.Stream")
  Set oUpFileStream = Server.CreateObject ("ADODB.Stream")
  oUpFileStream.Type = 1
  oUpFileStream.Mode = 3
  oUpFileStream.Open 
  oUpFileStream.Write Request.BinaryRead (Request.TotalBytes)
  oUpFileStream.Position = 0
  RequestBinData = oUpFileStream.Read 
  iFormEnd = oUpFileStream.Size
  bCrLf = ChrB (13) & ChrB (10)
  'ȡ��ÿ����Ŀ֮��ķָ���
  sSpace = MidB (RequestBinData,1, InStrB (1,RequestBinData,bCrLf)-1)
  iStart = LenB  (sSpace)
  iFormStart = iStart+2
  '�ֽ���Ŀ
  Do
    iInfoEnd = InStrB (iFormStart,RequestBinData,bCrLf & bCrLf)+3
    tStream.Type = 1
    tStream.Mode = 3
    tStream.Open
    oUpFileStream.Position = iFormStart
    oUpFileStream.CopyTo tStream,iInfoEnd-iFormStart
    tStream.Position = 0
    tStream.Type = 2
    tStream.CharSet = "gb2312"
    sInfo = tStream.ReadText      
    'ȡ�ñ���Ŀ����
    iFormStart = InStrB (iInfoEnd,RequestBinData,sSpace)-1
    iFindStart = InStr (22,sInfo,"name=""",1)+6
    iFindEnd = InStr (iFindStart,sInfo,"""",1)
    sFormName = Mid  (sinfo,iFindStart,iFindEnd-iFindStart)
    '������ļ�
    If InStr  (45,sInfo,"filename=""",1) > 0 Then
      Set oFileInfo = new FileInfo_Class
      'ȡ���ļ�����
      iFindStart = InStr (iFindEnd,sInfo,"filename=""",1)+10
      iFindEnd = InStr (iFindStart,sInfo,"""",1)
      sFileName = Mid  (sinfo,iFindStart,iFindEnd-iFindStart)
      oFileInfo.FileName = Mid (sFileName,InStrRev (sFileName, "\")+1)
      oFileInfo.FilePath = Left (sFileName,InStrRev (sFileName, "\"))
      oFileInfo.FileExt = Mid (sFileName,InStrRev (sFileName, ".")+1)
      iFindStart = InStr (iFindEnd,sInfo,"Content-Type: ",1)+14
      iFindEnd = InStr (iFindStart,sInfo,vbCr)
      oFileInfo.FileType = Mid  (sinfo,iFindStart,iFindEnd-iFindStart)
      oFileInfo.FileStart = iInfoEnd
      oFileInfo.FileSize = iFormStart -iInfoEnd -2
      oFileInfo.FormName = sFormName
      file.add sFormName,oFileInfo
    else
    '����Ǳ���Ŀ
      tStream.Close
      tStream.Type = 1
      tStream.Mode = 3
      tStream.Open
      oUpFileStream.Position = iInfoEnd 
      oUpFileStream.CopyTo tStream,iFormStart-iInfoEnd-2
      tStream.Position = 0
      tStream.Type = 2
      tStream.CharSet = "gb2312"
      sFormValue = tStream.ReadText
      If Form.Exists (sFormName) Then
        Form (sFormName) = Form (sFormName) & ", " & sFormValue
        else
        form.Add sFormName,sFormValue
      End If
    End If
    tStream.Close
    iFormStart = iFormStart+iStart+2
    '������ļ�β�˾��˳�
  Loop Until  (iFormStart+2) >= iFormEnd 
  RequestBinData = ""
  Set tStream = Nothing
End Sub
End Class

'----------------------------------------------------------------------------------------------------
'�ļ�������
Class FileInfo_Class
Dim FormName,FileName,FilePath,FileSize,FileType,FileStart,FileExt
'�����ļ�����
Public Function SaveToFile (Path)
  On Error Resume Next
  Dim oFileStream
  Set oFileStream = CreateObject ("ADODB.Stream")
  oFileStream.Type = 1
  oFileStream.Mode = 3
  oFileStream.Open
  oUpFileStream.Position = FileStart
  oUpFileStream.CopyTo oFileStream,FileSize
  oFileStream.SaveToFile Path,2
  oFileStream.Close
  Set oFileStream = Nothing 
End Function
 
'ȡ���ļ�����
Public Function FileData
  oUpFileStream.Position = FileStart
  FileData = oUpFileStream.Read (FileSize)
End Function

End Class
%>
