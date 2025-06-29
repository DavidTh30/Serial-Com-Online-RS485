unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, SerialPort,
  ModBusSerial, PLCTagNumber, registry, typinfo, Tag, HMIEdit, commtypes, Unit2;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    CheckBox3: TCheckBox;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    ComboBox5: TComboBox;
    ComboBox6: TComboBox;
    ComboBox7: TComboBox;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    HMIEdit1: THMIEdit;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    ModBusRTUDriver1: TModBusRTUDriver;
    SerialPortDriver1: TSerialPortDriver;
    Tag1: TPLCTagNumber;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure CheckBox1EditingDone(Sender: TObject);
    procedure CheckBox2EditingDone(Sender: TObject);
    procedure CheckBox3EditingDone(Sender: TObject);
    procedure ComboBox1EditingDone(Sender: TObject);
    procedure ComboBox2EditingDone(Sender: TObject);
    procedure ComboBox3EditingDone(Sender: TObject);
    procedure ComboBox4EditingDone(Sender: TObject);
    procedure ComboBox5EditingDone(Sender: TObject);
    procedure ComboBox6EditingDone(Sender: TObject);
    procedure ComboBox7EditingDone(Sender: TObject);
    procedure Edit1EditingDone(Sender: TObject);
    procedure Edit2EditingDone(Sender: TObject);
    procedure Edit3EditingDone(Sender: TObject);
    procedure Edit4EditingDone(Sender: TObject);
    procedure Edit5EditingDone(Sender: TObject);
    procedure Edit6EditingDone(Sender: TObject);
    procedure Edit7EditingDone(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SerialPortDriver1CommErrorReading(Error: TIOResult);
    procedure SerialPortDriver1CommErrorWriting(Error: TIOResult);
    procedure SerialPortDriver1CommPortClosed(Sender: TObject);
    procedure SerialPortDriver1CommPortCloseError(Sender: TObject);
    procedure SerialPortDriver1CommPortOpened(Sender: TObject);
    procedure SerialPortDriver1CommPortOpenError(Sender: TObject);
    procedure Tag1AsyncValueChange(Sender: TObject; const Value: TArrayOfDouble
      );
    procedure Tag1Update(Sender: TObject);
    procedure Tag1ValueChange(Sender: TObject);
    procedure Tag1ValueChangeFirst(Sender: TObject);
  private

  public
    procedure GetSerialPortExt();
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.GetSerialPortExt();
var
  reg  : TRegistry;
  l,v  : TStringList;
  n    : integer;
  pn: string;
  //fn: string;
  //Result_:string;

  function findFriendlyName(key: string; port: string): string;
  var
    r : TRegistry;
    k : TStringList;
    i : Integer;
    ck: string;
    rs: string;
  begin
    r := TRegistry.Create;
    k := TStringList.Create;

    r.RootKey := HKEY_LOCAL_MACHINE;
    r.OpenKeyReadOnly(key);
    r.GetKeyNames(k);
    r.CloseKey;

    try
      for i := 0 to k.Count - 1 do
      begin
        ck := key + k[i] + '\'; // current key
        // looking for "PortName" stringvalue in "Device Parameters" subkey
        if r.OpenKeyReadOnly(ck + 'Device Parameters') then
        begin
          if r.ReadString('PortName') = port then
          begin
            //Memo1.Lines.Add('--> ' + ck);
            r.CloseKey;
            r.OpenKeyReadOnly(ck);
            rs := r.ReadString('FriendlyName');
            Break;
          end // if r.ReadString('PortName') = port ...
        end  // if r.OpenKeyReadOnly(ck + 'Device Parameters') ...
        // keep looking on subkeys for "PortName"
        else // if not r.OpenKeyReadOnly(ck + 'Device Parameters') ...
        begin
          if r.OpenKeyReadOnly(ck) and r.HasSubKeys then
          begin
            rs := findFriendlyName(ck, port);
            if rs <> '' then Break;
          end; // if not (r.OpenKeyReadOnly(ck) and r.HasSubKeys) ...
        end; // if not r.OpenKeyReadOnly(ck + 'Device Parameters') ...
      end; // for i := 0 to k.Count - 1 ...
      result := rs;
    finally
      r.Free;
      k.Free;
    end; // try ...
  end; // function findFriendlyName ...

begin
  v      := TStringList.Create;
  l      := TStringList.Create;
  reg    := TRegistry.Create;
  //Result_ := '';
  ComboBox1.Clear;

  try
    reg.RootKey := HKEY_LOCAL_MACHINE;
    if reg.OpenKeyReadOnly('HARDWARE\DEVICEMAP\SERIALCOMM') then
    begin
      reg.GetValueNames(l);

      for n := 0 to l.Count - 1 do
      begin
        pn := reg.ReadString(l[n]);
        //fn := findFriendlyName('\System\CurrentControlSet\Enum\', pn);
        ComboBox1.Items.Append(pn);
      end; // for n := 0 to l.Count - 1 ...

      //Result_ := v.CommaText;
    end; // if reg.OpenKeyReadOnly('HARDWARE\DEVICEMAP\SERIALCOMM') ...
  finally
    reg.Free;
    v.Free;
  end; // try ...
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Memo1.Clear;

  GetSerialPortExt();
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  SerialPortDriver1.Active:=True;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  if SerialPortDriver1.Active then
  SerialPortDriver1.Active:=false;
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  i:integer;
begin

  ComboBox6.Clear;

  CheckBox1.Checked:=Tag1.SwapBytes;
  CheckBox2.Checked:=Tag1.SwapDWords;
  CheckBox3.Checked:=Tag1.SwapWords;

  Edit1.Text:=Tag1.PLCRack.ToString;
  Edit2.Text:=Tag1.PLCSlot.ToString;
  Edit3.Text:=Tag1.PLCStation.ToString;

  Edit4.Text:=Tag1.MemAddress.ToString;
  Edit5.Text:=Tag1.MemReadFunction.ToString;
  Edit6.Text:=Tag1.MemSubElement.ToString;
  Edit7.Text:=Tag1.MemWriteFunction.ToString;

  for i := Ord(Low(TTagType)) to Ord(High(TTagType)) do
  begin
    ComboBox6.Items.Append(GetEnumName(typeInfo(TTagType), i));
  end;
  ComboBox6.ItemIndex:= Ord(Tag1.TagType);
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  Memo1.Clear;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  Memo2.Clear;
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  Form2.Show;
end;

procedure TForm1.CheckBox1EditingDone(Sender: TObject);
begin
  Tag1.SwapBytes:=CheckBox1.Checked;
end;

procedure TForm1.CheckBox2EditingDone(Sender: TObject);
begin
  Tag1.SwapDWords:=CheckBox2.Checked;
end;

procedure TForm1.CheckBox3EditingDone(Sender: TObject);
begin
  Tag1.SwapWords:=CheckBox3.Checked;
end;

procedure TForm1.ComboBox1EditingDone(Sender: TObject);
begin
  SerialPortDriver1.COMPort:=ComboBox1.Text;

end;

procedure TForm1.ComboBox2EditingDone(Sender: TObject);
var
  i: integer;
begin
  for i := Ord(Low(TSerialDataBits)) to Ord(High(TSerialDataBits)) do
  begin
    if GetEnumName(TypeInfo(TSerialDataBits), i) = ComboBox2.Text then begin
      SerialPortDriver1.DataBits:= TSerialDataBits(i);
      exit;
    end;
  end;
end;

procedure TForm1.ComboBox3EditingDone(Sender: TObject);
var
  i: integer;
begin
  for i := Ord(Low(TSerialParity)) to Ord(High(TSerialParity)) do
  begin
    if GetEnumName(TypeInfo(TSerialParity), i) = ComboBox3.Text then begin
      SerialPortDriver1.Paridade:= TSerialParity(i);
      exit;
    end;
  end;
end;

procedure TForm1.ComboBox4EditingDone(Sender: TObject);
var
  i: integer;
begin
  for i := Ord(Low(TSerialStopBits)) to Ord(High(TSerialStopBits)) do
  begin
    if GetEnumName(TypeInfo(TSerialStopBits), i) = ComboBox4.Text then begin
      SerialPortDriver1.StopBits:= TSerialStopBits(i);
      exit;
    end;
  end;
end;

procedure TForm1.ComboBox5EditingDone(Sender: TObject);
var
  i: integer;
begin
  for i := Ord(Low(TSerialBaudRate)) to Ord(High(TSerialBaudRate)) do
  begin
    if GetEnumName(TypeInfo(TSerialBaudRate), i) = ComboBox5.Text then begin
      SerialPortDriver1.BaudRate:= TSerialBaudRate(i);
      exit;
    end;
  end;
end;

procedure TForm1.ComboBox6EditingDone(Sender: TObject);
var
  i: integer;
begin
  for i := Ord(Low(TTagType)) to Ord(High(TTagType)) do
  begin
    if GetEnumName(TypeInfo(TTagType), i) = ComboBox6.Text then begin
      Tag1.TagType:= TTagType(i);
      exit;
    end;
  end;
end;

procedure TForm1.ComboBox7EditingDone(Sender: TObject);
begin
  HMIEdit1.NumberFormat:=ComboBox7.Items[ComboBox7.ItemIndex];
end;

procedure TForm1.Edit1EditingDone(Sender: TObject);
var
  i:longint;
begin
  if TryStrToInt(Edit1.Text,i) then
  begin
    if i < 0 then i:=0;
    if i > 255 then i:=255;
    Edit1.Text:=IntToStr(i);
  end
  else
  begin
    i:=0;
    Edit1.Text:=IntToStr(i);
  end;
  Tag1.PLCRack:=i;
end;

procedure TForm1.Edit2EditingDone(Sender: TObject);
var
  i:longint;
begin
  if TryStrToInt(Edit2.Text,i) then
  begin
    if i < 0 then i:=0;
    if i > 255 then i:=255;
    Edit2.Text:=IntToStr(i);
  end
  else
  begin
    i:=0;
    Edit2.Text:=IntToStr(i);
  end;
  Tag1.PLCSlot:=i;
end;

procedure TForm1.Edit3EditingDone(Sender: TObject);
var
  i:longint;
begin
  if TryStrToInt(Edit3.Text,i) then
  begin
    if i < 0 then i:=0;
    if i > 255 then i:=255;
    Edit3.Text:=IntToStr(i);
  end
  else
  begin
    i:=0;
    Edit3.Text:=IntToStr(i);
  end;
  Tag1.PLCStation:=i;
end;

procedure TForm1.Edit4EditingDone(Sender: TObject);
var
  i:longint;
begin
  if TryStrToInt(Edit4.Text,i) then
  begin
    if i < 0 then i:=0;
    if i > 10000 then i:=10000;
    Edit4.Text:=IntToStr(i);
  end
  else
  begin
    i:=0;
    Edit4.Text:=IntToStr(i);
  end;
  Tag1.MemAddress:=i;
end;

procedure TForm1.Edit5EditingDone(Sender: TObject);
var
  i:longint;
begin
  if TryStrToInt(Edit5.Text,i) then
  begin
    if i < 0 then i:=0;
    if i > 255 then i:=255;
    Edit5.Text:=IntToStr(i);
  end
  else
  begin
    i:=0;
    Edit5.Text:=IntToStr(i);
  end;
  Tag1.MemReadFunction:=i;
end;

procedure TForm1.Edit6EditingDone(Sender: TObject);
var
  i:longint;
begin
  if TryStrToInt(Edit6.Text,i) then
  begin
    if i < 0 then i:=0;
    if i > 255 then i:=255;
    Edit6.Text:=IntToStr(i);
  end
  else
  begin
    i:=0;
    Edit6.Text:=IntToStr(i);
  end;
  Tag1.MemSubElement:=i;
end;

procedure TForm1.Edit7EditingDone(Sender: TObject);
var
  i:longint;
begin
  if TryStrToInt(Edit7.Text,i) then
  begin
    if i < 0 then i:=0;
    if i > 255 then i:=255;
    Edit7.Text:=IntToStr(i);
  end
  else
  begin
    i:=0;
    Edit7.Text:=IntToStr(i);
  end;
  Tag1.MemWriteFunction:=i;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i:integer;
begin
  Memo1.Clear;
  Memo2.Clear;

  ComboBox2.Clear;
  ComboBox3.Clear;
  ComboBox4.Clear;
  ComboBox5.Clear;
  ComboBox6.Clear;
  GetSerialPortExt();

  CheckBox1.Checked:=Tag1.SwapBytes;
  CheckBox2.Checked:=Tag1.SwapDWords;
  CheckBox3.Checked:=Tag1.SwapWords;

  Edit1.Text:=Tag1.PLCRack.ToString;
  Edit2.Text:=Tag1.PLCSlot.ToString;
  Edit3.Text:=Tag1.PLCStation.ToString;

  Edit4.Text:=Tag1.MemAddress.ToString;
  Edit5.Text:=Tag1.MemReadFunction.ToString;
  Edit6.Text:=Tag1.MemSubElement.ToString;
  Edit7.Text:=Tag1.MemWriteFunction.ToString;

  for i := Ord(Low(TSerialDataBits)) to Ord(High(TSerialDataBits)) do
  begin
    ComboBox2.Items.Append(GetEnumName(typeInfo(TSerialDataBits), i));
  end;
  //GetEnumValue(typeInfo(TSerialDataBits),ComboBox5.Items[ComboBox5.ItemIndex]);
  ComboBox2.ItemIndex:= Ord(SerialPortDriver1.DataBits);

  for i := Ord(Low(TSerialParity)) to Ord(High(TSerialParity)) do
  begin
    ComboBox3.Items.Append(GetEnumName(typeInfo(TSerialParity), i));
  end;
  ComboBox3.ItemIndex:= Ord(SerialPortDriver1.Paridade);

  for i := Ord(Low(TSerialStopBits)) to Ord(High(TSerialStopBits)) do
  begin
    ComboBox4.Items.Append(GetEnumName(typeInfo(TSerialStopBits), i));
  end;
  ComboBox4.ItemIndex:= Ord(SerialPortDriver1.StopBits);

  for i := Ord(Low(TSerialBaudRate)) to Ord(High(TSerialBaudRate)) do
  begin
    ComboBox5.Items.Append(GetEnumName(typeInfo(TSerialBaudRate), i));
  end;
  ComboBox5.ItemIndex:= Ord(SerialPortDriver1.BaudRate);

  for i := Ord(Low(TTagType)) to Ord(High(TTagType)) do
  begin
    ComboBox6.Items.Append(GetEnumName(typeInfo(TTagType), i));
  end;
  ComboBox6.ItemIndex:= Ord(Tag1.TagType);
end;

procedure TForm1.SerialPortDriver1CommErrorReading(Error: TIOResult);
begin
  Memo1.Append('CommErrorReading');
end;

procedure TForm1.SerialPortDriver1CommErrorWriting(Error: TIOResult);
begin
  Memo1.Append('CommErrorWriting');
end;

procedure TForm1.SerialPortDriver1CommPortClosed(Sender: TObject);
begin
  Memo1.Append('CommPortClosed');
end;

procedure TForm1.SerialPortDriver1CommPortCloseError(Sender: TObject);
begin
  Memo1.Append('CommPortCloseError');
end;

procedure TForm1.SerialPortDriver1CommPortOpened(Sender: TObject);
begin
  Memo1.Append('CommPortOpened');
end;

procedure TForm1.SerialPortDriver1CommPortOpenError(Sender: TObject);
begin
  Memo1.Append('CommPortOpenError');
end;

procedure TForm1.Tag1AsyncValueChange(Sender: TObject;
  const Value: TArrayOfDouble);
begin
  Memo2.Append('AsyncValueChange');
end;

procedure TForm1.Tag1Update(Sender: TObject);
begin
  Memo2.Append('Update');
end;

procedure TForm1.Tag1ValueChange(Sender: TObject);
begin
  Memo2.Append('ValueChange');
end;

procedure TForm1.Tag1ValueChangeFirst(Sender: TObject);
begin
  Memo2.Append('ValueChangeFirst');
end;

end.

