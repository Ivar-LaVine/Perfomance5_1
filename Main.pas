unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, DBGrids, DB, IBCustomDataSet, IBTable, IBDatabase, IniFiles,
  IBQuery, StdCtrls, ExtCtrls, jpeg;

type
  TForm1 = class(TForm)
    IBDatabase1: TIBDatabase;
    IBTransaction1: TIBTransaction;
    IBTable1: TIBTable;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    IBQuery1: TIBQuery;
    IBTransaction2: TIBTransaction;
    Edit1: TEdit;
    Button1: TButton;
    IBQuery2: TIBQuery;
    DBGrid2: TDBGrid;
    IBQuery3: TIBQuery;
    DataSource2: TDataSource;
    DBGrid3: TDBGrid;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    IBQuery4: TIBQuery;
    DataSource3: TDataSource;
    DBGrid4: TDBGrid;
    IBQuery5: TIBQuery;
    DataSource4: TDataSource;
    Image5: TImage;
    Image6: TImage;
    Button2: TButton;
    Button3: TButton;
    IBQuery6: TIBQuery;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses Password;

procedure TForm1.Button1Click(Sender: TObject);
var ticket : string;
begin
  ticket := '';
  with IBQuery2 do
  begin
    DataBase := IBDataBase1;
    SQL.Clear;
    SQL.Add('SELECT TICKET FROM TSTUDENT WHERE (NAME = :name) AND (SURNAME = :surname) AND (PATRONYMIC = :patronymic)');
    ParamByName('name').AsString := '????';
    ParamByName('surname').AsString := '??????';
    ParamByName('patronymic').AsString := '????????';
    Open;
    ticket := Fields[0].AsString;
  end;
  Edit1.Text := ticket;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  if IBTransaction2.Active = false then IBTransaction2.StartTransaction;
  try
    begin
      with IBQuery6 do
      begin
        DataBase := IBDataBase1;
        SQL.Clear;
        SQL.Add('INSERT INTO TSTUDENT(SURNAME, NAME, PATRONYMIC, DATEOFBIRTH, GRP_ID) VALUES (:surname, :name, :patronymic, :dateofbirth, 1)');
        ParamByName('name').AsString := '????';
        ParamByName('surname').AsString := '???????';
        ParamByName('patronymic').AsString := '????????';
        ParamByName('dateofbirth').AsDate := StrToDate('08.03.2002');
        Open;
      end;
      IBTransaction2.Commit;
    end;
  except
    begin
      IBTransaction2.RollBack;
    end;
  end;
  
end;

procedure TForm1.Button3Click(Sender: TObject);
var i : integer;
begin
  if IBTransaction2.Active = false then IBTransaction2.StartTransaction;
  try
    begin
      with IBQuery6 do
      begin
        DataBase := IBDataBase1;
        SQL.Clear;
        SQL.Add('SELECT MRK_ID FROM TMARK M ');
        SQL.Add('INNER JOIN TSTUDENT ST ON (ST.STU_ID = M.STU_ID) ');
        SQL.Add('INNER JOIN TSUBJECT SB ON (SB.SUB_ID = M.SUB_ID) ');
        SQL.Add('WHERE (NAME = :name) AND (SURNAME = :surname) AND (PATRONYMIC = :patronymic) and (SUBJECT = :subject) ');
        ParamByName('name').AsString := '????';
        ParamByName('surname').AsString := '??????';
        ParamByName('patronymic').AsString := '????????';
        ParamByName('subject').AsString := '??????????';
        Open;
        i := Fields[0].AsInteger;
        SQL.Clear;
        SQL.Add('UPDATE TMARK SET MARK = 4 WHERE MRK_ID = ' + inttostr(i));
        Open;
      end;
      IBTransaction2.Commit;
    end;
  except
    begin
      IBTransaction2.RollBack;
    end;
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
var F: TIniFile;
    Charset, UserName, Password: String;
begin
// ?????? ???????? ?????????? ?? ini-?????
   try
      F:=TIniFile.Create(ExtractFilePath(ParamStr(0))+'Perfomance.ini');
      IBDataBase1.DatabaseName:=F.ReadString('Settings', 'Database', '');
      IBDataBase1.SQLDialect:=F.ReadInteger('Settings', 'SQLDialect', 3);
      Charset:=F.ReadString('Settings', 'Charset', 'WIN1251');
      UserName:=F.ReadString('Settings', 'UserName', 'student');
      Password:=F.ReadString('Settings', 'Password', 'edu-759');
      IBDataBase1.Params.Clear;
      IBDataBase1.Params.Add('user_name='+UserName);
      IBDataBase1.Params.Add('password='+Password);
      IBDataBase1.Params.Add('lc_ctype='+Charset);
   finally
      F.Free;
   end;
// ??????? ???????? ???? ??????
   try                                         
      IBDataBase1.Open;
   except
// ???? ?????? ??????? Firebird
      if not(EnterPassword('?????? ??????? Firebird', UserName, Password)) then
      begin
         UserName:='';
         Password:='';
      end;
      try
         IBDataBase1.Params.Clear;
         IBDataBase1.Params.Add('user_name='+UserName);
         IBDataBase1.Params.Add('password='+Password);
         IBDataBase1.Params.Add('lc_ctype='+Charset);
// ???????? ????? ????? ?????? ?????????????         
         IBDataBase1.Open;
      except
         MessageDlg('?????? ???????? ?????? ??????? ???? ?????? ??? ??????????? '+
          '??????????? ????????? ? ini-?????.', mtWarning, [mbOK], 0);
      end;
   end;
   if not(IBDatabase1.Connected) then Form1.Close;   
end;

end.
