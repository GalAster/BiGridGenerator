(* ::Package:: *)
(* ::Title:: *)
(*Example(样板包)*)
(* ::Subchapter:: *)
(*程序包介绍*)
(* ::Text:: *)
(*Mathematica Package*)
(*Created by Mathematica Plugin for IntelliJ IDEA*)
(*Establish from GalAster's template*)
(**)
(*Author:GalAster*)
(*Creation Date:2016-11-08*)
(*Copyright:CC4.0 BY+NA+NC*)
(**)
(*该软件包遵从CC协议:署名、非商业性使用、相同方式共享*)
(**)
(*这里应该填这个函数的介绍*)
(* ::Section:: *)
(*函数说明*)
BeginPackage["GameModel`"];
CCPGraph::usage = "";
CCPMatrix::usage = "";
CCPMarkov::usage = "";
CCPDistribution::usage = "";
(* ::Section:: *)
(*程序包正体*)
(* ::Subsection::Closed:: *)
(*主设置*)
GameModel$Version="V0.1";
GameModel$Environment="V11.0+";
GameModel$LastUpdate="2016-11-12";
GameModel::usage = "程序包的说明,这里抄一遍";
Begin["`Private`"];
(* ::Subsection::Closed:: *)
(*主体代码*)



(* ::Subsubsection:: *)
(*氪皇集卡问题*)
step=Function[list,Ramp[list-#&/@IdentityMatrix@Length@list]];
fix=Function[list,Union@Flatten[FixedPointList[Union@Flatten[step/@#,1]&,{list}],1]];
add=Function[list,(list->#&/@step@list)~Join~{list->list}];
ass=Function[list,Reverse[Union@Flatten[add/@fix@list]]];
pos=Function[{a,b},If[a===b,(If[#[[1]]===0,1,0]&/@Transpose@{a,b})~Join~{1},(a-b)~Join~{0}]];
Wei[{x_,m_}]:=Chop[Total/@(Append[x,1-Total@x]*#&/@pos@@@ass@m)];
CCPGraph[x_?VectorQ,m_?VectorQ,"3D"]:=Graph3D[
  Delete[ass@m,Position[Wei[{x,m}],0]],PlotTheme->"Web",
  GraphLayout->"SpringEmbedding",
  EdgeWeight->Delete[Wei[{x,m}],Position[Wei[{x,m}],0]],
  EdgeLabels->Placed["EdgeWeight",Center],
  EdgeLabelStyle->Directive[Lighter@Blue,16,Bold],
  VertexLabelStyle->Directive[Black,16,Bold],
  VertexLabels->Placed["Name",Center]];
CCPGraph[x_?VectorQ,m_?VectorQ]:=Graph[
  Function[{a,b},Property[DirectedEdge@@a,EdgeStyle->{Thick,b,Dashed}]]@@@
      Transpose@{Delete[ass@m,Position[Wei[{x,m}],0]],
        ColorData["Rainbow"]/@Delete[Wei[{x,m}],Position[Wei[{x,m}],0]]},
  PlotTheme->"Minimal",GraphLayout->"LayeredDigraphEmbedding",
  VertexShapeFunction->"Diamond",VertexSize->Large,
  VertexLabelStyle->Directive[Black,16,Bold],
  VertexLabels->Placed["Name",Center]];
CCPMatrix[x_?VectorQ,m_?VectorQ]:=WeightedAdjacencyMatrix[Graph[ass@m,EdgeWeight->Wei[{x,m}]]];
CCPMarkov[x_?VectorQ,m_?VectorQ]:=DiscreteMarkovProcess[1,CCPMatrix[x,m]];





(* ::Subsubsection:: *)
(*氪皇集卡概率*)
CCPDistribution[x_?VectorQ,m_?VectorQ]:=FirstPassageTimeDistribution[CCPMarkov[x,m],Length@fix@m];
Unprotect[CDF,PDF,Mean];
(*http://math.stackexchange.com/questions/379525/probability-distribution-in-the-coupon-collectors-problem*)
PDF[CCPDistribution[n_?IntegerQ],x_]:=(n!*StirlingS2[x-1,n-1])/n^x;
CDF[CCPDistribution[n_?IntegerQ],x_]:=(n!*StirlingS2[x,n])/n^x;
Mean[CCPDistribution[n_?IntegerQ]]:=n*HarmonicNumber[n];
(*http://mathoverflow.net/questions/229060/batched-coupon-collector-problem*)
(*https://www.zhihu.com/question/33576455*)
(*http://math.stackexchange.com/questions/131664/coupon-collector-problem-with-batched-selections?rq=1*)
Mean[CCPDistribution[n_?IntegerQ,s_?IntegerQ]]:=Sum[1/(1-Binomial[i,s]/Binomial[n,s]),{i,0,n-1}];
Mean[CCPDistribution[n_?IntegerQ,d_?StringQ]]:=Block[{s=ToExpression@d},
  Sum[((-1)^(1+i)*Binomial[n,i])/(1-Binomial[-i+n,s]/Binomial[n,s]),{i,1,n}]];
(*http://cruy.xyz/201601/%E4%BB%8E%E6%8A%9B%E7%A1%AC%E5%B8%81%E8%AF%B4%E8%B5%B7/*)
Mean[CCPDistribution[n_?IntegerQ,{s_?IntegerQ}]]:=s*Integrate[1-(1-Gamma[n,t]/Gamma[n])^s,{t,0,Infinity}];
Mean[CCPDistribution[n_,s_,"Fast"]]:=s*NIntegrate[1-(1-Gamma[n,t]/Gamma[n])^s,{t,0,9527}];
Mean[CCPDistribution[p_?VectorQ]]:=NIntegrate[1-Times@@@{1-E^(-t*#)&/@p},{t,0,Infinity}];
Se[m_,t_]:=Sum[t^k/k!,{k,0,m-1}];
Mean[CCPDistribution[x_?VectorQ,n_?VectorQ]]:=Total@x*Integrate[
  1-Product[1-Se[n[[i]],x[[i]]t]E^(-x[[i]]t),{i,1,Length@x}],{t,0,Infinity}];
Mean[CCPDistribution[x_,n_,"Fast"]]:=Total@x*NIntegrate[
  1-Product[1-Se[n[[i]],x[[i]]t]E^(-x[[i]]t),{i,1,Length@x}],{t,0,9527}];
Protect[CDF,PDF,Mean];



(* ::Subsubsection:: *)
(*伪随机分布*)






(* ::Subsection::Closed:: *)
(*附加设置*)
End[] ;

EndPackage[];