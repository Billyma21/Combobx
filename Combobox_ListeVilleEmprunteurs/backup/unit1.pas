unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, mysql56conn, sqldb, db, FileUtil, Forms, Controls,
  Graphics, Dialogs, DBGrids, StdCtrls, DbCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    BT_Connect: TButton;
    BT_Insert: TButton;
    BT_Afficher: TButton;
    ComboBox1: TComboBox;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    MySQL56Connection1: TMySQL56Connection;
    SQLQuery1: TSQLQuery;
    SQLQuery2: TSQLQuery;

    SQLTransaction1: TSQLTransaction;
    procedure BT_ConnectClick(Sender: TObject);
    procedure BT_InsertClick(Sender: TObject);
    procedure BT_AfficherClick(Sender: TObject);
    procedure ComboBox1Select(Sender: TObject);


  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.BT_ConnectClick(Sender: TObject);
begin
  MySQL56Connection1.DatabaseName:='biblio';
  MySQL56Connection1.UserName:='root';
  // Tentative de connexion à la base de données biblio
  MySQL56Connection1.Open;
  if Not MySQL56Connection1.Connected then
    begin
     ShowMessage ('Connexion échouée !'); exit;
    end;
  Label1.Caption:='Connecté';
  // Affichage de la table emprunteurs dans le 1er DBGrid
   SQLQuery1.SQL.Text:= 'SELECT * FROM emprunteurs';
   SQLQuery1.Open;

   SQLQuery2.SQL.Text := 'SELECT DISTINCT ville FROM emprunteurs';
   SQLQuery2.Open;
   SQLQuery2.First;
   while(not SQLQuery2.EOF) do
     begin
      ComboBox1.Items.Add(SQLQuery2.Fields.Fields[0].AsString);
      SQLQuery2.Next;
     end;
   SQLQuery2.Close;


  Datasource1.Dataset:=SQLQuery1;
  DBGrid1.DataSource:=DataSource1;
 // SQLQuery1.Open;
end;

procedure TForm1.BT_InsertClick(Sender: TObject);

     var nom, prenom, adresse, codepostal, ville, tel : string;
       begin

         nom := quotedstr(Edit1.Text);
         prenom := QuotedStr(Edit2.Text);
         adresse := QuotedStr(Edit3.Text);
         codepostal := Edit4.Text;
         ville := QuotedStr(Edit6.Text);
         tel := Edit7.Text;
         //SQLTransaction1.commit;
        // SQlTransaction1.StartTransaction;
         MySQL56Connection1.ExecuteDirect('insert into emprunteurs(nom,prénom,adresse,cp,ville,tél) values ('+nom+','+prenom+','+adresse+','+codepostal+','+ville+','+tel+')');
         SQLTransaction1.Commit;

         SQLQuery1.Close;
         SQLQuery1.SQL.Text:= 'SELECT * FROM emprunteurs';
         SQLQuery1.Open;

         //initialisation des valeurs de la liste du combobox
         Combobox1.Items.Clear;
         SQLQuery2.SQL.Text := 'SELECT DISTINCT ville FROM emprunteurs';
         SQLQuery2.Open;
         SQLQuery2.First;
         while(not SQLQuery2.EOF) do
          begin
               ComboBox1.Items.Add(SQLQuery2.Fields.Fields[0].AsString);
               SQLQuery2.Next;
          end;
         SQLQuery2.Close;
       end;

procedure TForm1.BT_AfficherClick(Sender: TObject);


       begin
         // Remplissage des zones de texte par champs

           Edit5.Text := DBGrid1.Columns[0].Field.Text;
           Edit1.Text := DBGrid1.Columns[1].Field.Text;
           Edit2.Text := DBGrid1.Columns[2].Field.Text;
           Edit3.Text := DBGrid1.Columns[3].Field.Text;
           Edit4.Text := DBGrid1.Columns[4].Field.Text;
           Edit6.Text := DBGrid1.Columns[5].Field.Text;
           Edit7.Text := DBGrid1.Columns[6].Field.Text;


          end;

procedure TForm1.ComboBox1Select(Sender: TObject);
begin
  SQLQuery1.Close;
  SQLQuery1.SQL.Text:= 'SELECT * FROM emprunteurs WHERE ville="'+ComboBox1.Text+'"';
  SQLQuery1.Open;
end;

end.

