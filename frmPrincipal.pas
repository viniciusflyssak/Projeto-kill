unit frmPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, TLHelp32, Vcl.ExtCtrls, Vcl.StdCtrls, PsAPI;

type
  TTaskKiller = class(TForm)
    pnlfundo: TPanel;
    BtnKill: TButton;
    lblTask: TLabel;
    edtTask: TEdit;
    procedure BtnKillClick(Sender: TObject);
    procedure edtTaskKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
  function KillTask(sFile: String): Boolean;

var
  TaskKiller: TTaskKiller;

implementation

{$R *.dfm}

function KillTask(sFile: String): Boolean;
var
  verSystem: TOSVersionInfo;
  hdlSnap,hdlProcess: THandle;
  bPath,bLoop: Bool;
  peEntry: TProcessEntry32;
  arrPid: Array [0..1023] of DWORD;
  iC: DWord;
  k,iCount: Integer;
  arrModul: Array [0..299] of Char;
  hdlModul: HMODULE;
begin
  Result := False;
  if ExtractFileName(sFile)=sFile then
    bPath:=false
  else
    bPath:=true;
  verSystem.dwOSVersionInfoSize:=SizeOf(TOSVersionInfo);
  GetVersionEx(verSystem);
  if verSystem.dwPlatformId=VER_PLATFORM_WIN32_WINDOWS then
  begin
    hdlSnap:=CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
    peEntry.dwSize:=Sizeof(peEntry);
    bLoop:=Process32First(hdlSnap,peEntry);
    while integer(bLoop)<>0 do
    begin
      if bPath then
      begin
        if CompareText(peEntry.szExeFile,sFile) = 0 then
        begin
          TerminateProcess(OpenProcess(PROCESS_TERMINATE,false,peEntry.th32ProcessID), 0);
          Result := True;
        end;
      end
      else
      begin
        if CompareText(ExtractFileName(peEntry.szExeFile),sFile) = 0 then
        begin
          TerminateProcess(OpenProcess(PROCESS_TERMINATE,false,peEntry.th32ProcessID), 0);
          Result := True;
        end;
      end;
      bLoop := Process32Next(hdlSnap,peEntry);
    end;
    CloseHandle(hdlSnap);
  end
  else
    if verSystem.dwPlatformId=VER_PLATFORM_WIN32_NT then
    begin
      EnumProcesses(@arrPid,SizeOf(arrPid),iC);
      iCount := iC div SizeOf(DWORD);
      for k := 0 to Pred(iCount) do
      begin
        hdlProcess:=OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ,false,arrPid [k]);
        if (hdlProcess<>0) then
        begin
          EnumProcessModules(hdlProcess,@hdlModul,SizeOf(hdlModul),iC);
          GetModuleFilenameEx(hdlProcess,hdlModul,arrModul,SizeOf(arrModul));
          if bPath then
          begin
            if CompareText(arrModul,sFile) = 0 then
            begin
              TerminateProcess(OpenProcess(PROCESS_TERMINATE or PROCESS_QUERY_INFORMATION,False,arrPid [k]), 0);
              Result := True;
            end;
          end
          else
          begin
            if CompareText(ExtractFileName(arrModul),sFile) = 0 then
            begin
              TerminateProcess(OpenProcess(PROCESS_TERMINATE or PROCESS_QUERY_INFORMATION,False,arrPid [k]), 0);
              Result := True;
            end;
          end;
          CloseHandle(hdlProcess);
        end;
      end;
    end;
end;

procedure TTaskKiller.BtnKillClick(Sender: TObject);
begin
  KillTask(edtTask.Text + '.exe');
end;

procedure TTaskKiller.edtTaskKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
    KillTask(edtTask.Text + '.exe');      
end;

end.
