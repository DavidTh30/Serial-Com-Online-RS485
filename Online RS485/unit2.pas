unit Unit2;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ComCtrls,
  ExtCtrls, ECTabCtrl, Types;

type

  { TForm2 }

  TForm2 = class(TForm)
    ECTabCtrl1: TECTabCtrl;
    Image1: TImage;
    Memo1: TMemo;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    procedure ECTabCtrl1Change(Sender: TObject);
    procedure ECTabCtrl1ChangeBounds(Sender: TObject);
    procedure ECTabCtrl1Changing(Sender: TObject; var AllowChange: Boolean);
    procedure ECTabCtrl1ControlBorderSpacingChange(Sender: TObject);
    procedure ECTabCtrl1Fold(Sender: TObject; AFolded, AOwner: Integer);
    procedure ECTabCtrl1GetSiteInfo(Sender: TObject; DockClient: TControl;
      var InfluenceRect: TRect; MousePos: TPoint; var CanDock: Boolean);
    procedure ECTabCtrl1SizeConstraintsChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  Form2: TForm2;
  Done:boolean;
implementation

{$R *.lfm}

{ TForm2 }

procedure TForm2.ECTabCtrl1Fold(Sender: TObject; AFolded, AOwner: Integer);
begin
  //PageControl1.TabIndex:=ECTabCtrl1.TabIndex;
  //showmessage(IntTostr(AFolded));
end;

procedure TForm2.ECTabCtrl1GetSiteInfo(Sender: TObject; DockClient: TControl;
  var InfluenceRect: TRect; MousePos: TPoint; var CanDock: Boolean);
begin
  //PageControl1.TabIndex:=ECTabCtrl1.TabIndex;
end;

procedure TForm2.ECTabCtrl1SizeConstraintsChange(Sender: TObject);
begin
  //PageControl1.TabIndex:=ECTabCtrl1.TabIndex;
end;

procedure TForm2.FormShow(Sender: TObject);
begin
  Done:=true;
end;

procedure TForm2.ECTabCtrl1Change(Sender: TObject);
begin
  if not Done then exit;
  PageControl1.TabIndex :=ECTabCtrl1.TabIndex;
end;

procedure TForm2.ECTabCtrl1ChangeBounds(Sender: TObject);
begin
  //PageControl1.TabIndex :=ECTabCtrl1.TabIndex;
end;

procedure TForm2.ECTabCtrl1Changing(Sender: TObject; var AllowChange: Boolean);
begin
  //PageControl1.TabIndex :=ECTabCtrl1.TabIndex;
end;

procedure TForm2.ECTabCtrl1ControlBorderSpacingChange(Sender: TObject);
begin
  //PageControl1.TabIndex:=ECTabCtrl1.TabIndex;
end;

end.

