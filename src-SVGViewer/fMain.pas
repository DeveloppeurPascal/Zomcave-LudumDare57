﻿/// <summary>
/// ***************************************************************************
///
/// Zomcave
///
/// Copyright 2025 Patrick PREMARTIN under AGPL 3.0 license.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
/// THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
/// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
/// DEALINGS IN THE SOFTWARE.
///
/// ***************************************************************************
///
/// Author(s) :
/// Patrick PREMARTIN
///
/// Site :
/// https://zomcave.gamolf.fr
///
/// Project site :
/// https://github.com/DeveloppeurPascal/Zomcave-LudumDare57
///
/// ***************************************************************************
/// File last update : 2025-04-07T08:49:27.745+02:00
/// Signature : e2d257d2b3db3f8f7be2db3ebd8c7cb92902dfba
/// ***************************************************************************
/// </summary>

unit fMain;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.Objects,
  FMX.Layouts;

type
  TfrmMain = class(TForm)
    VertScrollBox1: TVertScrollBox;
    FlowLayout1: TFlowLayout;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
  protected
    procedure RefreshFlowLayoutImages;
    procedure CalcFlowLayoutHeight;
  public
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.fmx}

uses
  Olf.Skia.SVGToBitmap;

procedure TfrmMain.CalcFlowLayoutHeight;
var
  i: integer;
  h: single;
  c: tControl;
begin
  h := 10;
  for i := 0 to FlowLayout1.ChildrenCount - 1 do
    if (FlowLayout1.Children[i] is tControl) then
    begin
      c := FlowLayout1.Children[i] as tControl;
      if h < c.position.y + c.height + c.Margins.Bottom then
        h := c.position.y + c.height + c.Margins.Bottom;
    end;
  FlowLayout1.height := h;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  tthread.ForceQueue(nil,
    procedure
    begin
      RefreshFlowLayoutImages;
    end);
end;

procedure TfrmMain.FormResize(Sender: TObject);
begin
  CalcFlowLayoutHeight;
end;

procedure TfrmMain.RefreshFlowLayoutImages;
var
  img: TImage;
  i: integer;
begin
  while FlowLayout1.ChildrenCount > 0 do
    FlowLayout1.Children[0].Free;

  for i := 0 to TOlfSVGBitmapList.Count - 1 do
  begin
    img := TImage.Create(self);
    img.WrapMode := TImageWrapMode.Fit;
    img.Bitmap.Assign(TOlfSVGBitmapList.Bitmap(i, round(img.width),
      round(img.height), Image1.Bitmap.BitmapScale));
    img.Margins.Right := 5;
    img.Margins.Bottom := 5;
    img.Parent := FlowLayout1;
  end;

  CalcFlowLayoutHeight;
end;

end.
