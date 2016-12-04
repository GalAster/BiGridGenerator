Module[{}, def = "1,2,0.2,2,5,10,3,64Pi,140";

list = {1, 1, 2, 3, 5, 8};
TraditionalForm[
  an = Factor@InterpolatingPolynomial[Join[list, {9527}], n]]
  Table[an, {n, 1, 20}]
  eqn = {y'[x] == y[x] (1 - y[x]/27)};
  Flatten@Trace[DSolve[eqn, y[x], x], Solve[_, y[x]],
    TraceInternal -> True];
  ans = Extract[%[[1]], {1, 1}];
TraditionalForm[Column@eqn -> "   "  ans]


  f[t_] := {RandomInteger[{-9, 9}, 2], 1}
  g[{{a_, b_}, c_}] :=
   ImplicitRegion[(x + a)^2 + (y + b)^2 <= c^2, {x, y}]
  data[t_] := g /@ f /@ Range[t];
  area[t_] := RegionUnion[data[t]] // DiscretizeRegion // RegionMeasure

-----------------------------------------------------------------------------------------------------------------------------------
Clear["`*"]
DumpSave[FileNameJoin[{NotebookDirectory[], "plot.mx"}], "Global`"];
Quit[];
FileNameJoin[{NotebookDirectory[], "plot.mx"}]
------------------------------------------------------------------------------------------------------------------------------------
VoronoiMesh[AnglePath[Table[{Sqrt[k], GoldenAngle}, {k, 800}]],
  PlotTheme -> "Lines"]

param[x_, m_, t_] :=
    Module[{f, n = Length[x], nf},
      f = Chop[Fourier[x]][[;; Ceiling[Length[x]/2]]];
      nf = Length[f];
      Total[Rationalize[
        2 Abs[f]/Sqrt[n] Sin[
          Pi/2 - Arg[f] + 2. Pi Range[0, nf - 1] t], .01][[;;
          Min[m, nf]]]]]

tocurve[Line[data_], m_, t_] := param[#, m, t] & /@ Transpose[data]

img = Import["http://i.stack.imgur.com/wtJoA.png"];

img = Binarize[img~ColorConvert~"Grayscale"~ImageResize~500~Blur~3]~
    Blur~3;
lines = Cases[
  Normal@ListContourPlot[Reverse@ImageData[img],
    Contours -> {0.5}], _Line, -1];

ParametricPlot[Evaluate[tocurve[#, 500, t] & /@ lines], {t, 0, 1},
  Frame -> True, Axes -> False]
------------------------------------------------------------------------------------------------------------------------------------

(*定义决策树*)
决策[救赎者] := 1;
决策[背叛者] := 0;
(*初始化People矩阵*)
Peo = Transpose@Join[{Range[10],
  Join[ConstantArray[救赎者, 8], ConstantArray[背叛者, 2]]},
  Transpose@ArrayFlatten@ConstantArray[{{0, 10000.0}}, {10, 1}]];
开始 = Join[{{编号, 阵营, 回合数, 资产}}, Peo] // MatrixForm
匹配[list_] := Module[{q}, q = Length@list; If[Mod[q, 2] == 0,
  Partition[RandomSample[list, q], 2],
  Partition[RandomSample[list[[1 ;; -2]], q - 1], 2]]]
(*初始化匹配池*)
匹配池 = Range@10;
判定[{x_, y_}] := {决策[Peo[[x, 2]]], 决策[Peo[[y, 2]]]}
效果[{x_, y_}] := Module[{all},
  Peo[[x, 3]] += 1; Peo[[y, 3]] += 1;
  all = (0.2 Peo[[x, 4]] + 0.2 Peo[[y, 4]]);
  Peo[[x, 4]] *= 0.8; Peo[[y, 4]] *= 0.8;
  Switch[判定[{x, y}],
    {1, 1}, Peo[[x, 4]] += 0.65 all; Peo[[y, 4]] += 0.65 all,
    {1, 0}, Peo[[y, 4]] += all,
    {0, 1}, Peo[[x, 4]] += all]]
(*模拟开始*)
ans = ConstantArray[0, 432];
Do[效果 /@ 匹配@匹配池; ans[[t]] = {t, Peo[[1 ;; 10, 4]]}, {t, 1, 432}]
结束 = Join[{{编号, 阵营, 回合数, 资产}}, Peo] // MatrixForm
record = Transpose@((Transpose@ans)[[2]]);
Column[{ListLinePlot[record[[1 ;; 8]], AspectRatio -> 0.25,
  MaxPlotPoints -> Infinity, ImageSize -> Full],
  ListLinePlot[record[[9 ;; 10]], AspectRatio -> 0.25,
    MaxPlotPoints -> Infinity, ImageSize -> Full],
  ListLinePlot[Function[{x, y}, {x, Total@y}] @@@ ans,
    AspectRatio -> 0.25, MaxPlotPoints -> Infinity,
    ImageSize -> Full]}]












(*定义决策树*)
决策[无知者] = 决策[救赎者] = 1;
决策[堕落者] = 决策[背叛者] = 0;
(*初始化People矩阵*)
Peo = Transpose@Join[{Range[100],
  Join[ConstantArray[无知者, 36], ConstantArray[堕落者, 12],
    ConstantArray[救赎者, 28], ConstantArray[背叛者, 24]]},
  Transpose@ArrayFlatten@ConstantArray[{{0, 100.0, 0}}, {100, 1}]];
匹配[list_] := Module[{q}, q = Length@list; If[Mod[q, 2] == 0,
  Partition[RandomSample[list, q], 2],
  Partition[RandomSample[list[[1 ;; -2]], q - 1], 2]]]

(*初始化匹配池*)
匹配池 = Range@100;
判定[{x_, y_}] := {决策[Peo[[x, 2]]], 决策[Peo[[y, 2]]]};
效果[{x_, y_}] := Module[{all},
  Peo[[x, 3]] += 1; Peo[[y, 3]] += 1;
  all = (0.2 Peo[[x, 4]] + 0.2 Peo[[y, 4]]);
  Peo[[x, 4]] *= 0.8; Peo[[y, 4]] *= 0.8;
  Switch[判定[{x, y}],
    {1, 1}, Peo[[x, 5]] += 1; Peo[[y, 5]] += 1;
  Peo[[x, 4]] += 0.65 all; Peo[[y, 4]] += 0.65 all,
    {1, 0}, Peo[[x, 5]] -= 1; Peo[[y, 5]] += 1; Peo[[y, 4]] += all,
    {0, 1}, Peo[[x, 5]] += 1; Peo[[y, 5]] -= 1; Peo[[x, 4]] += all,
    {0, 0}, Peo[[x, 5]] -= 1; Peo[[y, 5]] -= 1]]
(*转化树*)
转化[n_] := Switch[Peo[[n, 2]],
  无知者, If[Peo[[n, 5]] < -1, Peo[[n, 2]] = 堕落者, Peo[[n, 2]] = 无知者],
  堕落者, If[Peo[[n, 5]] > 2, Peo[[n, 2]] = 无知者, Peo[[n, 2]] = 堕落者],
  救赎者, Peo[[n, 2]] = 救赎者,
  背叛者, Peo[[n, 2]] = 背叛者];
(*模拟开始*)
zc = rsd = ConstantArray[0, 432];
Do[效果 /@ 匹配@匹配池;
zc[[t]] = Peo[[1 ;; 100, 4]]; rsd[[t]] = Peo[[1 ;; 100, 5]];
转化 /@ Range@100, {t, 1, 432}]
TwoAxisListLinePlot[{f_, g_}] :=
    Module[{fgraph, ggraph, frange, grange, fticks,
      gticks}, {fgraph, ggraph} =
        MapIndexed[
          ListLinePlot[#, Axes -> True, PlotStyle -> ColorData[1][#2[[1]]],
            ImageSize -> Full,
            PlotLegends -> Placed[{"资产总和", "忍受度总和"}, Above]] &, {f,
          g}]; {frange, grange} =
        Last[PlotRange /. AbsoluteOptions[#, PlotRange]] & /@ {fgraph,
          ggraph};
    fticks =
        Last[Ticks /.
            AbsoluteOptions[fgraph,
              Ticks]] /. _RGBColor | _GrayLevel | _Hue :> ColorData[1][1];
    gticks = (MapAt[Function[r, Rescale[r, grange, frange]], #, {1}] & /@
        Last[Ticks /.
            AbsoluteOptions[ggraph,
              Ticks]]) /. _RGBColor | _GrayLevel | _Hue -> ColorData[1][2];
    Show[fgraph,
      ggraph /.
          Graphics[graph_, s___] :>
              Graphics[
                GeometricTransformation[graph,
                  RescalingTransform[{{0, 1}, grange}, {{0, 1}, frange}]], s],
      Axes -> False, Frame -> True,
      FrameStyle -> {ColorData[1] /@ {1, 2}, {Automatic, Transparent}},
      FrameTicks -> {{fticks, gticks}, {Automatic, Automatic}}]]
TwoAxisListLinePlot[{Total /@ zc, Total /@ rsd}]

(*定义决策树*)
决策[救赎者] := 1;
决策[背叛者] := 0;
(*初始化People矩阵*)
Peo = Transpose@Join[{Range[10],
  Join[ConstantArray[救赎者, 5], ConstantArray[背叛者, 5]]},
  Transpose@ArrayFlatten@ConstantArray[{{0, 10000.0}}, {10, 1}]];
开始 = Join[{{编号, 阵营, 回合数, 资产}}, Peo] // MatrixForm;
匹配[list_] := Module[{q}, q = Length@list; If[Mod[q, 2] == 0,
  Partition[RandomSample[list, q], 2],
  Partition[RandomSample[list[[1 ;; -2]], q - 1], 2]]]
(*初始化匹配池*)
匹配池 = Range@10;
判定[{x_, y_}] := {决策[Peo[[x, 2]]], 决策[Peo[[y, 2]]]}
效果[{x_, y_}] := Module[{all},
  Peo[[x, 3]] += 1; Peo[[y, 3]] += 1;
  all = (0.2 Peo[[x, 4]] + 0.2 Peo[[y, 4]]); Switch[判定[{x, y}],
    {1, 1}, Peo[[x, 4]] += 0.6 all; Peo[[y, 4]] += 0.6 all,
    {1, 0}, Peo[[x, 4]] *= 0.8; Peo[[y, 4]] += all,
    {0, 1}, Peo[[x, 4]] += all; Peo[[y, 4]] *= 0.8,
    {0, 0}, Peo[[x, 4]] *= 0.8; Peo[[y, 4]] *= 0.8]]

(*模拟开始*)
ans = ConstantArray[0, 100];
Do[效果 /@ 匹配@匹配池; ans[[t]] = {t, Peo[[1 ;; 10, 4]]}, {t, 1, 100}]
结束 = Join[{{编号, 阵营, 回合数, 资产}}, Peo] // MatrixForm;
{开始 -> 结束}
record = Transpose@((Transpose@ans)[[2]]);
ListLinePlot[record[[1 ;; 5]], Joined -> True]
ListLinePlot[record[[6 ;; 10]], Joined -> True]
ListLinePlot[Function[{x, y}, {x, Total@y}] @@@ ans,
  AspectRatio -> 0.25, MaxPlotPoints -> Infinity]

da1[{a_, d_}] := If[a >= d, a - d, 0]
da2[{a_, d_}] := If[a <= 0, 0, If[d > 0, 100*a/(100 + d), a*(2*d - 50)/(d - 50)]]
da3[{a_, d_}] := If[a <= 0, 0, If[d > 0, a^2/(a + d), (2 a/Pi)*(Pi + ArcTan[a/d])]]
Manipulate[
  Plot[{da1[{a, d}], da2[{a, d}], da3[{a, d}]}, {d, -100, 150},
    PlotRange -> {0, 360}, PlotLegends -> {"加法公式", "乘法公式", "除法公式"},
    PlotLabels -> Placed["攻击力" <> ToString@a, {0.25}],
    AspectRatio -> 1/2, ImageSize -> Medium,
    AxesLabel -> {"防御力", "伤害值"}], {a, -10, 200, 10}]

da1[{a_, d_}] := If[a >= d, a - d, 0]
da2[{a_, d_}] :=
    If[a <= 0, 0, If[d > 0, 100*a/(100 + d), a*(2*d - 50)/(d - 50)]]
da3[{a_, d_}] :=
    If[a <= 0, 0, If[d > 0, a^2/(a + d), (2 a/Pi)*(Pi + ArcTan[a/d])]]
dda1[{a_, d_}] := Abs@D[da1[{a, d}], d]
dda2[{a_, d_}] := Abs@D[da2[{a, d}], d]
dda3[{a_, d_}] := Abs@D[da3[{a, d}], d]
a = 500;
Plot[{da1[{a, d}], da2[{a, d}], da3[{a, d}]}, {d, -100, 250},
  PlotRange -> {0, 800}, PlotLegends -> {"加法公式", "乘法公式", "除法公式"},
  PlotLabels -> Placed["攻击力" <> ToString@a, {0.25}],
  AspectRatio -> 1/2, ImageSize -> Large, AxesLabel -> {"防御力", "伤害值"}];
Plot[Evaluate@{dda1[{a, d}], dda2[{a, d}], dda3[{a, d}]}, {d, -250,
  500}, PlotLegends -> {"加法公式", "乘法公式", "除法公式"}, AspectRatio -> 1/2,
  ImageSize -> Large, AxesLabel -> {"防御力", "防御边际效益(攻击力500)"},
  Axes -> { True,  True, True}, PlotRange -> {Automatic, 10},
  ScalingFunctions -> "Log"];
Column[{%%, %}]
Export["s.png", %]


Clear["`*"]
    ------------------------------------------------------------------------------------------------------------------------------------
好像是求随机游走遍历的?

G = Graph[{1 <-> 2, 1 <-> 3, 2 <-> 3, 2 <-> 4, 3 <-> 4}]
A = MatrixForm@AdjacencyMatrix[G];
M = Flatten[Quiet@Inner[Divide, Total /@ A, A, List], 1] /.
    ComplexInfinity -> Infinity;
WeightedAdjacencyGraph[M]


CoverTime[GridGraph[{3,3}],5]


f[1]=1;f[2]:=1;f[n_]:=f/@{n-1,n-2};TreeForm[f[6]]
Sum[Sum[Fibonacci[i]*Fibonacci[1-i+n],{i,1,n-2}],{n,4,32,2}]
Sum[Sum[Fibonacci[i],{i,1,n-2}],{n,4,32,2}]



------------------------------------------------------------------------------------------------------------------------------------
僵尸大逃杀!
nc = 15; nr = 3;
cx = Table[ToExpression[StringJoin["cx", ToString[i]]], {i, 1, nc}];
cy = Table[ToExpression[StringJoin["cy", ToString[i]]], {i, 1, nc}];
rx = Table[ToExpression[StringJoin["rx", ToString[i]]], {i, 1, nr}];
ry = Table[ToExpression[StringJoin["ry", ToString[i]]], {i, 1, nr}];
coordList = Flatten[{Transpose[{cx, cy}], Transpose[{rx, ry}]}];
cspeed = 1;
rspeed = 1.1;

eqns = Flatten[
  {Table[
    {{Derivative[1][cx[[i]]][t], Derivative[1][cy[[i]]][t]} ==
        cspeed*Normalize[Sum[{rx[[j]][t] - cx[[i]][t], ry[[j]][t] - cy[[i]][t]}/((cx[[i]][t] - rx[[j]][t])^2 +
            (cy[[i]][t] - ry[[j]][t])^2), {j, 1, nr}]],
      cx[[i]][0] == RandomReal[{-30, 30}],
      cy[[i]][0] == RandomReal[{-30, 30}]
    },
    {i, 1, nc}
  ],
    Table[
      {{Derivative[1][rx[[i]]][t], Derivative[1][ry[[i]]][t]} ==
          rspeed*Normalize[Sum[{rx[[i]][t] - cx[[j]][t], ry[[i]][t] - cy[[j]][t]}/((cx[[j]][t] - rx[[i]][t])^2 +
              (cy[[j]][t] - ry[[i]][t])^2), {j, 1, nc}]],
        rx[[i]][0] == RandomReal[{-5, 5}],
        ry[[i]][0] == RandomReal[{-5, 5}]
      },
      {i, 1, nr}
    ]
  }
];

soln = NDSolve[eqns, coordList, {t, 0, 200}, MaxSteps -> 200000, PrecisionGoal -> 2][[1]];

coordListFn[t_] := Flatten[Table[{coordList[[i]][t], coordList[[i + 1]][t]}, {i, 1, 2*(nc + nr), 2}]]
cops[t_] := Evaluate[coordListFn[t][[1 ;; 2*nc]] /. soln[[1 ;; 2*nc]]]
robbers[t_] := Evaluate[coordListFn[t][[2*nc + 1 ;; 2*(nc + nr)]] /. soln[[2*nc + 1 ;; 2*(nc + nr)]]]

Manipulate[
  Show[
    ParametricPlot[
      {cops[t], robbers[t]}, {t, 0, tmax},
      PlotRange -> All, PlotStyle -> {Darker[Red], {Darker[Green]}}
    ],
    ListPlot[
      {Partition[cops[0], 2], Partition[robbers[0], 2], Partition[cops[tmax], 2], Partition[robbers[tmax], 2]},
      PlotStyle -> {Directive[PointSize[Medium], Black], Directive[PointSize[Medium], Black], Darker[Red], Darker[Green]}
    ],
    Axes -> False
  ],
  {tmax, 0.001, 200, 1.5}
]
-----------------------------------------------------------------------------------------------------------------------------------
这干嘛的?
Graphics@Table[BlockMap[{RandomColor[],Rectangle[{#[[1]],y},{#[[2]],y+1}]}&,Accumulate@Prepend[0]@RandomPartition[100,16],2,1],{y,100}]



LU分解?忘记干嘛的了
n = 3; G = GridGraph[{n, n}];
M = AdjacencyMatrix@G + SparseArray[{Band[{1, 1}] -> 1}, {n^2, n^2}];
U = Normal@
    SparseArray[{Band[{1, 1}] -> 1, Band[{1, 2}] -> 1,
      Band[{2, 1}] -> 1}, {n, n}];
I1 = IdentityMatrix[n];
mu = Normal@
    SparseArray[{Band[{1, 1}] -> u, Band[{1, 2}] -> 1,
      Band[{2, 1}] -> 1}, {n, n}];
mc = ConstantArray[c, n];
LinearSolve[mu, mc]
MatrixForm /@ LUDecomposition[M, Modulus -> 2]
------------------------------------------------------------------------------------------------------------------------------------
一堆心形曲面
ops = {PlotRange -> All, Boxed -> False, Axes -> False,
  ContourStyle -> Directive[Red, Specularity[White, 10]],
  PlotRange -> All, ViewPoint -> {1, 1, 0.2}}
Nordstrand[x_, y_, z_] :=
    (2*((4/3)*x)^2 + 2*y^2 + z^2 - 1)^3 - ((4/3)*x)^2*(z^3/10) -
        y^2*z^3
Kuska[x_, y_,
  z_] := (2*x^2 + y^2 + z^2 - 1)^3 - ((1/10)*x^2)*z^3 - y^2*z^3

Taubin[x_, y_, z_] := (x^2 + (3/2)^2*y^2 + z^2 - 1)^3 - x^2*z^3 -
    (((3/2)^2/20)*y^2)*z^3

Trott[x_, y_, z_] :=
    320*((x^2 + (3/2)^2*y^2 + z^2 - 1)^3 -
        x^2*z^3 - (((3/2)^2/20)*y^2)*z^3)
ContourPlot3D[Kuska[x, y, z] == 0,
  {x, -0.9, 0.9}, {y, -1.2, 1.2}, {z, -1.2, 1.4}]
ContourPlot3D[Taubin[x, y, z] == 0,
  {x, -2, 2}, {y, -2, 2}, {z, -2, 2}]
ContourPlot3D[
  Trott[x, y, z] == 0, {x, -3/2, 3/2}, {y, -1, 1}, {z, -3/2,
  3/2}, #] & @@ ops
ContourPlot3D[Nordstrand[x, y, z] == 0,
  {x, -2, 2}, {y, -2, 2}, {z, -2, 2}, #] & @@ ops





记得似乎是个红包模拟器
Function[{total, num},
  Differences@
      Sort[1 + (RandomInteger[{0, 100 total - num}, num - 1]~
          Join~{0, 100 total - num})]/100.0]





Clear["`*"];
谢宾斯基三角上的随机游走
n = 5;
steps = 1000;
dir = {{0, 0}, {1, 0}, {0, 1}};

start = FromDigits[#, 2] & /@
    Transpose@Append[RandomChoice[dir, n - 1], RandomInteger[1, 2]];

move[pt_] :=
    With[{c = RandomChoice@Pick[-dir, BitAnd @@ (# + pt) & /@ -dir, 0]},
      pt + c + RandomChoice@DeleteCases[dir, -c]];
move[{2^n, 0}] := {2^n - 1, RandomInteger@1};
move[{0, 2^n}] := {RandomInteger@1, 2^n - 1};
move[{0, 0}] := RandomChoice@Rest@dir;

ListLinePlot[{#1 + #2/2, #2*Sqrt@3/2} & @@@
    NestList[move, start, steps],
  PlotRange -> {{0, 2^n}, {0, 2^n*Sqrt[3]/2}},
  AspectRatio -> Sqrt[3]/2]



------------------------------------------------------------------------------------------------------------------------------------
CCP蒙特卡洛
Manipulate[SeedRandom[sr];
With[{jj$ = Table[RandomInteger[{1, coupons}], {20*coupons}]},
  With[{store$ =
      Table[Length[Union[Take[jj$, k]]], {k, 1, Length[jj$]}]},
    With[{list$ =
        Flatten[Table[First[Position[store$, n]], {n, 1, coupons}]]},

      ListPlot[list$, PlotRange -> All, Frame -> True, Axes -> False,

        FrameLabel -> {Style["distinct coupons bought", "Label"],
          Style["total coupons bought", "Label"]},
        PlotLabel -> Style[StringJoin[ToString[Last[list$]],

          " coupons had to be bought for the complete set of ",
          ToString[coupons],
          ".
        The expected number was ",
          ToString[Round[coupons*HarmonicNumber[coupons]]], "."],
          "Label"],
        ImagePadding -> {{35, 25}, {35, 35}},
        ImageSize -> {475, 375}]]]],
  {{coupons, 50, "number of distinct coupons"}, 6, 100, 1,
    Appearance -> "Labeled"},
  {{sr, 1, "seed random"}, 1, 400, 1, Appearance -> "Labeled"},
  ControllerLinking -> True]











一堆砖块?
    Block[{hmax = 34, vmax = 21, d},
  Graphics[{EdgeForm[{Thin, Black}],
    Table[d = Min[i, j, hmax - i - 1, vmax - j - 1]/Max[hmax, vmax];
    {ColorData["FallColors", 2.2 d^0.7],
      Translate[
        Rotate[Rectangle[{i, j}], 2 d*RandomReal[{0, 1}]*\[Pi]/2],
        400 E^(-6 (1 - d)) RandomReal[{-0.1, 0.1}, 2]]}, {i, 0,
      hmax - 1}, {j, 0, vmax - 1}]}, Background -> Black]]



参数曲线动画
circle[t_] := {Sin[Pi t], Cos[Pi t]};
dMax = 1.5;
Animate[ParametricPlot[circle[t], {t, Max[0, u - .2], u},
  PlotRange -> {{-dMax, dMax}, {-dMax, dMax}},
  ColorFunction -> Function[{x, y, w}, Opacity[w, Blue]],
  Frame -> True, Axes -> True, AxesOrigin -> {0, 0},
  PlotPoints -> 100,
  Epilog -> {Black, PointSize -> 0.015, Point[circle[u]]}], {u,
  0. + $MachineEpsilon, 6}, AnimationRate -> 1,
  AnimationRunning -> False]


????????????????
start = ExampleData[{"TestImage", "Girl3"}]
step1 = MeanShiftFilter[start, 2, 0.05, MaxIterations -> 10]


定态薛定谔
Table[SphericalPlot3D[{Re[
  SphericalHarmonicY[l, m, \[Theta], \[Phi]]]^2}, {\[Theta], 0,
  2 \[Pi]}, {\[Phi], 0, 2 \[Pi]}, PlotRange -> All, PlotPoints -> 25,
  PlotTheme -> "Detailed",
  ColorFunction -> (ColorData["Rainbow"][#6] &),
  Mesh -> None], {m, -l, l}]






text1 = ExampleData[{"Text", "ToBeOrNotToBe"}];
text2 = StringReplace[text1, {"s" -> "th"}];
sa = SequenceAlignment[text1, text2];
Flatten[Map[
  If[Length[#] ==
      2, {Framed[
    Style[#[[1]], FontVariations -> {"StrikeThrough" -> True}],
    FrameStyle -> None, FrameMargins -> 2,
    Background -> Lighter@Red],
    Framed[#[[2]], FrameStyle -> None, FrameMargins -> 2,
      Background -> Lighter@Green]},
    Framed[#, FrameStyle -> None, FrameMargins -> 2]] &, sa]];
Apply[StringJoin, ToString[#, StandardForm] & /@ %]





wikiTranslation[word_, language_: "Chinese"] :=
    language /. WikipediaData[word, "TitleTranslationRules"]
namelist = {"Takaaki Kajita", "Arthur B. McDonald", "Isamu Akasaki",
  "Hiroshi Amano", "Shuji Nakamura"}
wikiTranslation /@ namelist
webAppURL =
    "https://script.google.com/macros/s/alphaNumericSequence/exec"
onlineTran[textList_, languageCode_] :=
    URLExecute[
      webAppURL, {"textlist" -> textList, "language" -> languageCode}]
onlineTran[{"Takaaki Kajita", "Arthur B. McDonald", "Isamu Akasaki",
  "Hiroshi Amano", "Shuji Nakamura"}, "zh-CN"]



quan = Flatten[ConstantArray @@@ Transpose[{{15, 100}, {10, 90}}]];
BinCounts[RandomInteger[Total@quan, 1000], {{0}~Join~Accumulate@quan}]






LSSB[list_] := Module[{base}, ClearAll[n];
base = Function[t, Table[E^(2 m n Pi I/t), {m, 1, t}, {n, 1, t}]]@
    Length[list];
Inner[Times, LinearSolve[base, list], base[[1]]^n, Plus]]
FullSimplify@LSSB[{1, 4, 9}]
InterpolatingPolynomial[{1, 4, 9, 16}, x]



T[list_] := Total@Boole@OddQ[list]
add[list_] := list~Join~Switch[Mod[T[list], 4],
  0, {(Total[list^2] - 1)/2, (Total[list^2] + 1)/2},
  1, {(Total[list^2] - 1)/2, (Total[list^2] + 1)/2},
  2, {},
  3, {Total[list^2]/4 - 1, Total[list^2]/4 + 1}]



\begin{aligned}
a_n^2 - a_{n - 1}^2 & = ({a_n} + {a_{n - 1}})({a_n} - {a_{n - 1}}) \hfill \
& = 2(2\sum\limits_{i = 1}^{n - 2} {a_i^2} )/4 = \sum\limits_{i = 1}^{n - 2} {a_i^2}  \hfill \\
\end{aligned}


\[
\begin{aligned}
\frac{{{\text{d}}y\left( x \right)}}{{{\text{d}}x}} & = \sin \left( {y\left( x \right)} \right) \hfill \
\csc \left( {y\left( x \right)} \right)\frac{{{\text{d}}y\left( x \right)}}{{{\text{d}}x}} & = 1 \hfill \
\int {\csc \left( {y\left( x \right)} \right){\text{d}}y\left( x \right)}  & = \int {1{\text{d}}x}  \hfill \
- \log \left( {\cos \left( {\frac{{y\left( x \right)}}{2}} \right)} \right) + \log \left( {\sin \left( {\frac{{y\left( x \right)}}{2}} \right)} \right) & = x + {c_1} \hfill \
y\left( x \right) & = 2{\cot ^{ - 1}}\left( {{{\text{e}}^{ - x - {c_1}}}} \right) \hfill \
y(x) & = 2ArcCot\left[ {{{\text{e}}^{ - x}}\cot \frac{1}{2}} \right] \hfill \\
\end{aligned}
\]