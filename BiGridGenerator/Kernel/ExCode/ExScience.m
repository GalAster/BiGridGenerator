(* Mathematica Package *)
(* Created by Mathematica Plugin for IntelliJ IDEA *)

(* :Title: ExScience *)
(* :Context: ExScience` *)
(* :Author: GalAster *)
(* :Date: 2016-11-1 *)

(* :Package Version: 0.2 *)
(* :Mathematica Version: 11.0+ *)
(* :Copyright:该软件包遵从CC协议:BY+NA+NC(署名、非商业性使用、相同方式共享） *)
(* :Keywords: *)
(* :Discussion: *)

BeginPackage["ExScience`"]
(* Exported symbols added here with SymbolName::usage *)

Begin["`Private`"];
SingleElectronGrid[k_,way_:Re,ops___]:=GraphicsGrid[Table[SphericalPlot3D[
  Evaluate@way@SphericalHarmonicY[l,m,\[Theta],\[Phi]],{\[Theta],0,Pi},{\[Phi],0,2Pi},
  PlotRange->All,Mesh->None,Boxed->False,Axes->None,ColorFunction->"Rainbow",ops],
  {l,0,k-1},{m,0,l}],Frame->All];
SingleElectron[l_,m_,ops___]:=GraphicsRow[SphericalPlot3D[
  #[SphericalHarmonicY[l,m,\[Theta],\[CurlyPhi]]],{\[Theta],0,Pi},{\[CurlyPhi],0,2Pi},
  Boxed->False,Axes->None,ColorFunction->"TemperatureMap",ops]&/@{Re,Abs},Frame->All];

(*光学*)
ReflectCircle:=Module[{p,q,inref},inref[pt1_,pt2_,k_]:=
    ({Re[#1],Im[#1]}&)[(#2*(#2/#1)^k&)[pt1.{1,I},pt2.{1,I}]];
    Manipulate[Dynamic[p={-1,0};q={Cos[x],Sin[x]};
    With[{inrefs=(inref[p,q,#1]&)/@Range[-1,s]},
      Graphics[Flatten[{GrayLevel[0.3],Disk[],White,Line[inrefs]}]]]],
      {{x,0,"入射点"},-Pi,Pi},{{s,120,"反射次数"},0,120,1}]];
Epicycloid[n_]:=Manipulate[Show[Graphics[Style[
  Line[Partition[Riffle[Table[{-Cos[i],Sin[i]},{i,0,((n+1)*lin)*(Pi/32),Pi/32}],
    Table[{Cos[i/(n+1)],-Sin[i/(n+1)]},{i,0,((n+1)*lin)*(Pi/32),Pi/32}]],2]],Darker[Purple]]],
    ParametricPlot[{Sin[f],Cos[f]},{f,0,2*Pi},PlotStyle->{Hue[1/3,1,0.4,0.9],Thickness[0.006]}],
    PlotLabel->FullSimplify[{(n/(n+2)+1/(n+2))*Cos[t]-(1/(n+2))*Cos[(n+1)*t],(n/(n+2)+1/(n+2))*Sin[t]-(1/(n+2))*Sin[(n+1)*t]}],
    ImageSize->{400,400}],{{lin,64,"线段数"},0,64,1,Appearance->"Labeled"}];
ReflectLine:=Manipulate[Module[{pts,lines},
  pts=Table[{Sin[2*k*(Pi/n)],Cos[2*k*(Pi/n)]},{k,1,n}];
  lines=Table[{k,Mod[k*mult,n,1]},{k,1,n}];
  Graphics[{(Line[pts[[#1]]]&)/@lines,Point/@pts,
    MapIndexed[Style[Text[#2[[1]],1.05*#1],12]&,pts]},
    ImageSize->{550,420}]],{{n,32,"数值取模"},4,120,1,
  Appearance->"Labeled"},{{mult,2,"数字倍数"},2,120,1,Appearance->"Labeled"}];

ReflectFunction[f_, {left_: - 4, right_: 4, n_: 20}] :=
    Manipulate[ With[{df = D[f, x]},
      Plot[f, {x, left, right},
        Filling -> -100,
        PlotRange -> {{left, right}, Automatic},
        FillingStyle -> RGBColor[0.848, 0.848, 0.92],
        Prolog -> {Lighter[Orange],
          Table[{Line[{{xi, f /. x -> xi}, {xi, Max[10, f /. x -> xi]}}],
            Orange, Line[{{xi, f /. x -> xi},
              N[{xi - length*(2*(df/(1 + df^2))),f + length*(-1 + 2/(1 + df^2))}]} /. x -> xi]},
            {xi,left, right, (right - left)/n}]}]], {{length, 16, "反射线长度"}, 0,16}];


ReflectEllipse[aa_, bb_] :=Manipulate[ellipseMultiReflectionGraphics[\[CurlyPhi], \[Alpha],n, {aa, bb}],
  {{\[CurlyPhi], -Pi}, -Pi, Pi}, {{n, 1}, 1, 50,1}, {{\[Alpha], \[Pi]/4}, -Pi/2, Pi/2},
  Initialization :> {ellipseMultiReflectionGraphics[\[CurlyPhi]_, \[Alpha]_, n_, {a_, b_}] :=
      Module[{parameters, pathData, pathPoints},
        parameters = N[{\[CurlyPhi], \[Alpha], n, {a, b}}, 20 + 4*n];
        pathData = multiReflections @@ parameters;
        pathPoints = N[First /@ pathData];
        Graphics[{{GrayLevel[0.9], Disk[{0, 0}, {a, b}]}, {Black,PointSize[0.016],
          N[If[a >= b,Point[{{Sqrt[a^2 - b^2], 0}, {-Sqrt[a^2 - b^2], 0}}],
            Point[{{0,Sqrt[b^2 - a^2]}, {0, -Sqrt[b^2 - a^2]}}]]]}, {Black,Thickness[0.006], Point[pathPoints[[1]]]},
          {Black, PointSize[0.02], Circle[{0, 0}, {a, b}]}, {Thickness[0.001],
            MapIndexed[{Hue[0.3*(#2[[1]]/n) + 0.6], Line[#1]} & , Partition[pathPoints, 2, 1]]}}]],
    multiReflections[\[CurlyPhi]_, \[Alpha]_, n_, {a_, b_}] := NestList[ propagate[#1, {a, b}] & ,
      {{a*Cos[\[CurlyPhi]],b*Sin[\[CurlyPhi]]}, {a*Cos[\[Alpha]],b*Sin[\[Alpha]]}}, Round[n]],
    propagate[{p_, dir_}, {a_, b_}] := reflect[{nextReflectionPoint[{p, dir}, {a, b}], dir}, {a, b}],
    nextReflectionPoint[{p_, dir_}, {a_, b_}] := Module[{solxy, distances, pos, x, y},
      solxy = {x, y} /.Quiet[Solve[{x == p[[1]] + s*dir[[1]], y == p[[2]] + s*dir[[2]], x^2/a^2 + y^2/b^2 == 1}, {s, x, y}]];
      distances = (Norm[p - #1] & ) /@ solxy;
      pos = Position[distances, Max[distances]][[1]]; (solxy[[#1]] & ) @@ pos],
    reflect[{p_, dir_}, {a_, b_}] :=Module[{normalDir, parallelDir, normalComponent, paralleComponent},
      normalDir = (-(#1/Norm[#1]) & )[p/{a^2, b^2}];
      parallelDir = Reverse[normalDir]*{-1, 1};
      normalComponent = normalDir . dir;
      paralleComponent = parallelDir . dir;
      {p, (-normalComponent)*normalDir +paralleComponent*parallelDir}]}];

Catacaustic[f_, {left_, right_, down_, up_}, n_: 200] :=
    Module[{refl$y$, sol$, F},F[x_, y_, a_,g_] := (2*Derivative[1][g][a])*(y -g[a]) - (Derivative[1][g][a]^2 - 1)*(x - a);
    With[{},sol$ = Simplify[First[Solve[{F[x, y, t, f] == 0, D[F[x, y, t, f], t] == 0}, {x,y}]]];
    refl$y$ = y /. First[Solve[F[x, y, t, f] == 0, y]];
    Show[Graphics[{Opacity[0.2], White,Line[Table[{{a, up + 1}, {a,f[a]}, {(-Sign[Derivative[1][f][a]])*5,
      refl$y$ /. {x -> (-Sign[Derivative[1][f][a]])*5,t -> a}}}, {a, left + (right - left)/(2.*n),right, (right - left)/n}]]}],
      Sequence @@ (ParametricPlot[Tooltip[{x, y} /. sol$], {t, #1[[1]], #1[[2]]},
        PlotStyle -> {White, Thickness[Medium]}] &) /@ {{-10, 10}},
      Plot[Tooltip[f[x]], {x, left, right},PlotStyle -> {Thick, ColorData[1][2]}],
      PlotRange -> {{left, right}, {up, down}}, Axes -> False,Background -> Black]]];

Catacaustic2[f_, {left_, right_, n_: 100}, a_: 1] :=
    Module[{}, point = N@Range[left, right, (right - left)/n];
    line[x_] := {HalfLine[{{x, f[x]}, {x, f[x] + 1}}],
      HalfLine[{{x, f[x]}, {x - a Sin[2 ArcTan[Derivative[1][f][x]]],
        f[x] + a Cos[2 ArcTan[Derivative[1][f][x]]]}}]};
    p1 = Plot[f[x], {x, left, right}, AspectRatio -> 1,PlotTheme -> "Business"];
    curve = {t -Derivative[1][f][t]/Derivative[2][f][t], (1 - Derivative[1][f][t]^2)/(2*Derivative[2][f][t]) + f[t]};
    p2 = ParametricPlot[curve, {t, 0, 10},PlotStyle -> Directive[Red, Thick]];
    p3 = Graphics[{Thin, Flatten[line /@ point]}];
    Show[p1, p2, p3]];

TangentComplex[function_] := Module[{f0,f1,f2},
  f0 = FromPolarCoordinates[{function, \[Theta]}];
  f1 = FullSimplify[Last[f0] + D[Last[f0], \[Theta]]*(x - First[f0])/D[First[f0], \[Theta]]];
  f2 = Simplify[N[Table[f1, {\[Theta], 0, 10, 0.1}]]];
  Plot[f2, {x, -1, 4}, PlotRange -> 3,
    PlotStyle -> Directive[Black, Thin], AspectRatio -> 1,
    Axes -> False, PlotLabel -> y == f1]];




End[] (* `Private` *)

EndPackage[]