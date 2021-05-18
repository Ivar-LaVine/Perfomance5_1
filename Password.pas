unit Password;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm2 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  function EnterPassword(DlgCaption: String; var UserName, Password: String): Boolean;

var
  Form2: TForm2;

implementation

{$R *.dfm}

function EnterPassword(DlgCaption: String; var UserName, Password: String): Boolean;
begin
   Application.CreateForm(TForm2, Form2);
   Form2.Caption:=DlgCaption;
   if (Form2.ShowModal=mrOK) then
   begin
      UserName:=Form2.Edit1.Text;
      Password:=Form2.Edit2.Text;
      Result:=True;
   end else
   begin
      UserName:=Form2.Edit1.Text;
      Password:=Form2.Edit2.Text;
      Result:=False;
   end;
   Form2.Release;
end;

procedure TForm2.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
   if (Key=#32) then
   begin
      MessageBeep(0);
      Key:=#0;
   end;   
end;

procedure TForm2.Button1Click(Sender: TObject);
begin
  if (Trim(Edit1.Text)='') then
   begin
      MessageDlg('Необходимо указать имя учетной записи пользователя.',
       mtInformation, [mbOK], 0);
      Edit1.SetFocus;
      Exit;
   end;
   ModalResult:=mrOK;
end;

end.

