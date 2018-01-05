(* ::Package:: *)

(************************************************************************)
(* This file was generated automatically by the Mathematica front end.  *)
(* It contains Initialization cells from a Notebook file, which         *)
(* typically will have the same name as this file except ending in      *)
(* ".nb" instead of ".m".                                               *)
(*                                                                      *)
(* This file is intended to be loaded into the Mathematica kernel using *)
(* the package loading commands Get or Needs.  Doing so is equivalent   *)
(* to using the Evaluate Initialization Cells menu command in the front *)
(* end.                                                                 *)
(*                                                                      *)
(* DO NOT EDIT THIS FILE.  This entire file is regenerated              *)
(* automatically each time the parent Notebook file is saved in the     *)
(* Mathematica front end.  Any changes you make to this file will be    *)
(* overwritten.                                                         *)
(************************************************************************)



(* ::Input::Initialization:: *)
BoxesToLinearSyntax[boxexpr_]:="\!"<>UnescapeLinearSyntax@ToString[boxexpr,InputForm]

$FromLinearSyntax={"\!"->"\\!","\("->"\\(","\)"->"\\)","\`"->"\\`","\*"->"\\*","\+"->"\\+","\@"->"\\@","\%"->"\\%","\^"->"\\^","\&"->"\\&","\_"->"\\_","\/"->"\\/"};

$ToLinearSyntax=Reverse/@$FromLinearSyntax;

EscapeLinearSyntax[str_String]:=StringReplace[str,$FromLinearSyntax]

UnescapeLinearSyntax[str_String]:=StringReplace[str,$ToLinearSyntax]


(* ::Input::Initialization:: *)
EliminateRepetition[h_[elems___]]:=
Module[{heldElems, indexedElems, indexedRepresentatives, result, MyHoldComplete},
SetAttributes[MyHoldComplete, HoldAllComplete];
heldElems = MyHoldComplete /@ Unevaluated[{elems}];
indexedElems = Thread[heldElems -> Range @ Length[heldElems]];
indexedRepresentatives = First /@ Split[Sort[indexedElems], First[#1] === First[#2] &];
result = h @@ Join @@ (Last /@ Sort[Reverse /@ indexedRepresentatives]);
ClearAttributes[MyHoldComplete, HoldAllComplete];
result
]


(* ::Input::Initialization:: *)
$RomanDigitValues = {1, 5, 10, 50, 100, 500, 1000};


(* ::Input::Initialization:: *)
$RomanDigitSymbols = {"I", "V", "X", "L", "C", "D", "M"};


(* ::Input::Initialization:: *)
$RomanDigitDecompRules = Append[
{4 -> {1, 5}, 9 -> {1,10}}, digit_ :> Table[5, {Quotient[digit, 5]}] ~Join~ Table[1, {Mod[digit, 5]}]
];

romanDigitDecomp[n_Integer /; 0 <= n <= 9] := Replace[n, $RomanDigitDecompRules]

toRoman[n_Integer /; 0 <= n <= 999] :=
Module[{digits, romanValueLists, romanDigitLists},
digits = IntegerDigits[n, 10, 3];
romanValueLists = romanDigitDecomp /@ digits;
romanDigitLists = MapThread[Replace[#1, Thread[{1, 5, 10} -> #2], {1}]&,
{
romanValueLists,
Reverse @ Partition[$RomanDigitSymbols, 3, 2]
}
];
StringJoin[romanDigitLists]
]


(* ::Input::Initialization:: *)
Clear[ThousandFold]
ThousandFold[expr] := Grid[{{expr}}, RowSpacings->0, RowMinHeight->0.25]
ThousandFold[expr_, 0] := Grid[{{expr}}, RowSpacings->0, RowMinHeight->0.25]
ThousandFold[expr_, n_Integer] :=
Grid[Append[Table[{\[HorizontalLine]}, {n}], {expr}], RowSpacings->0, RowMinHeight->0.25]


(* ::Input::Initialization:: *)
Unprotect[$BoxForms];
AppendTo[$BoxForms, RomanNumeralForm];
Protect[$BoxForms];

RomanNumeralForm /: ParentForm[RomanNumeralForm] = StandardForm;

RomanNumeralForm /: MakeBoxes[n_Integer /; NumberQ @ Unevaluated[n] && Positive[n], RomanNumeralForm] := FormBox[InterpretationBox[#, n, Editable->False], StandardForm]& @
GridBox[
{Reverse @ MapIndexed[ToBoxes @ ThousandFold[toRoman[#1], First[#2] - 1]&, Reverse @ IntegerDigits[n, 10^3]]},
RowAlignments->Bottom, ColumnSpacings->0.1
]

RomanNumeralForm /: MakeBoxes[RomanNumeralForm[expr_], fmt_] :=
MakeBoxes[expr, RomanNumeralForm]


(* ::Input::Initialization:: *)
(* These go 1 through 9, not starting at 0 since they had no 0: *)

$GreekUnits = {"\[Alpha]","\[Beta]","\[Gamma]","\[Delta]","\[Epsilon]","\[Stigma]","\[Zeta]","\[Eta]","\[Theta]"};
$GreekTens = {"\[Iota]","\[Kappa]","\[Lambda]","\[Mu]","\[Nu]","\[Xi]","\[Omicron]","\[Pi]","\[Koppa]"};
$GreekHundreds = {"\[Rho]","\[Sigma]","\[Tau]","\[Upsilon]","\[Phi]","\[Chi]","\[Psi]","\[Omega]","\[Sampi]"};

$GreekThousands = BoxesToLinearSyntax @ RowBox[{SubscriptBox["\[InvisiblePrefixScriptBase]","\[Prime]"],#}] & /@ $GreekUnits;
$GreekMyriads = BoxesToLinearSyntax @ OverscriptBox["M",#] & /@ $GreekUnits;


(* ::Input::Initialization:: *)
toGreek[n_Integer /; 0 <= n <= 9999] :=
StringJoin @ MapThread[If[#2 != 0, Part[#1, #2], ""]&, {{$GreekThousands, $GreekHundreds, $GreekTens, $GreekUnits}, IntegerDigits[n, 10, 4]}]


(* ::Input::Initialization:: *)
Clear[MyriadFold]
MyriadFold[expr] := Grid[{{expr}}, RowSpacings->0, RowMinHeight->0.25]
MyriadFold[expr_, 0] := Grid[{{expr}}, RowSpacings->0, RowMinHeight->0.25]
MyriadFold[expr_, n_Integer] :=
Grid[Prepend[Table[{"M"}, {n}], {expr}], RowSpacings->0]


(* ::Input::Initialization:: *)
Unprotect[$BoxForms];
AppendTo[$BoxForms, GreekNumeralForm];
Protect[$BoxForms];

GreekNumeralForm /: ParentForm[GreekNumeralForm] = StandardForm;

GreekNumeralForm /: MakeBoxes[n_Integer /; NumberQ @ Unevaluated[n] && Positive[n], GreekNumeralForm] := FormBox[InterpretationBox[#, n, Editable->False], StandardForm]& @
GridBox[
{Reverse @ MapIndexed[ToBoxes @ MyriadFold[toGreek[#1], First[#2] - 1]&, Reverse @ IntegerDigits[n, 10^4]]},
RowAlignments->Bottom, ColumnSpacings->0.1
]

GreekNumeralForm /: MakeBoxes[GreekNumeralForm[expr_], fmt_] :=
MakeBoxes[expr, GreekNumeralForm]


(* ::Input::Initialization:: *)
Clear[diophPowerSymbol, internalDiophantineForm]

diophPowerSymbol[0] = 1;
diophPowerSymbol[1] = \[FinalSigma];

diophPowerSymbol[n_Integer /; 2 <= n] :=
SequenceForm @@
MapAt[
Superscript[#, \[CapitalUpsilon]]&,
Join[
Table[\[CapitalKappa], {Quotient[n, 3] - Mod[Mod[n, 3], 2]}],
Table[\[CapitalDelta], {Mod[-n, 3]}]
],
1
]


internalDiophantineForm[poly_, x_, fmt_:StandardForm] :=
Module[{coeffList = CoefficientList[poly, x], varCoeffs, posCoeffs, negCoeffs, posGreeks, negGreeks, posAndNegList},
(
varCoeffs = Reverse @ MapIndexed[{#1, First[#2] - 1}&, coeffList];
posCoeffs = Select[varCoeffs,  Composition[Positive, First]];
negCoeffs = Select[varCoeffs, Composition[Negative, First]];
{posGreeks, negGreeks} = Replace[{posCoeffs, negCoeffs}, {
{constant_, 0} :> SequenceForm[Overscript[M, \[Degree]], Overscript[toGreek @ Abs[constant], \[HorizontalLine]]],
{coeff_, power_} :> SequenceForm[diophPowerSymbol[power], Overscript[toGreek @ Abs[coeff], \[HorizontalLine]]]
}, {2}];
If[negGreeks =!= {},
negGreeks = Prepend[negGreeks, " \[UpArrow] "];
];
posAndNegList = Flatten[{posGreeks, negGreeks}, 1, List];
InterpretationBox @@ {ToBoxes[SequenceForm @@ posAndNegList, fmt], poly, Editable->False}
) /; VectorQ[coeffList, IntegerQ]
]


(* ::Input::Initialization:: *)
Clear[DiophantinePolynomialForm, DiophantinePolyQ]

Attributes[DiophantinePolyQ] = HoldAllComplete;

DiophantinePolyQ[expr_, var_] :=
PolynomialQ[Unevaluated[expr], Unevaluated[var]] && VectorQ[CoefficientList[expr, var], IntegerQ]

DiophantinePolyQ[expr_] := PolynomialQ @ Unevaluated[expr] && Length @ Variables @ Unevaluated[expr] == 1 &&
VectorQ[CoefficientList[expr, First @ Variables @ Unevaluated[expr]], IntegerQ]


DiophantinePolynomialForm /: MakeBoxes[DiophantinePolynomialForm[expr_, x_] /; DiophantinePolyQ[expr, x], fmt_] :=
internalDiophantineForm[expr, x, fmt]

DiophantinePolynomialForm /: MakeBoxes[DiophantinePolynomialForm[expr_?DiophantinePolyQ], fmt_] :=
internalDiophantineForm[expr, First @ Variables[expr], fmt]

(* If not of the correct form, then don't use Diophantine formatting *)

DiophantinePolynomialForm /: MakeBoxes[otherwise:DiophantinePolynomialForm[expr_, var_:Null], fmt_] :=
MakeBoxes[expr, fmt]


(* ::Input::Initialization:: *)
Clear[internalVieteForm, vietePowerSymbol]

vietePowerSymbol[0] = "1";
vietePowerSymbol[1] = "\[ScriptCapitalN]";

vietePowerSymbol[n_Integer /; 2 <= n] :=
Composition[ToExpression, StringJoin] @ Join[
Table["\[ScriptCapitalC]", {Quotient[n, 3] - Mod[Mod[n, 3], 2]}],
Table["\[ScriptCapitalQ]", {Mod[-n, 3]}]
]

internalVieteForm[poly_, x_, fmt_:StandardForm] :=
Module[{coeffList = CoefficientList[poly, x], n, varPowers, theSum},
(
n = Length[coeffList];
varPowers = Array[vietePowerSymbol, n, 0];
theSum = DeleteCases[Inner[Times, Reverse[varPowers], Reverse[coeffList], List], 0];
Switch[Length[theSum],
0,
	theSum = 0,
1,
	theSum = First[theSum],
_,
	theSum = Composition[HoldForm, Plus] @@ theSum
];
InterpretationBox @@ {ToBoxes[theSum, fmt], poly, Editable->False}
) /; VectorQ[coeffList, NumberQ]
]


(* ::Input::Initialization:: *)
Clear[VietePolynomialForm, VietePolyQ, VieteQuadraticForm]

Attributes[VietePolyQ] = HoldAllComplete;

VietePolyQ[expr_, var_] :=
PolynomialQ[Unevaluated[expr], Unevaluated[var]] &&
VectorQ[CoefficientList[expr, var], NumberQ]

VietePolyQ[expr_] := PolynomialQ @ Unevaluated[expr] && Length @ Variables @ Unevaluated[expr] == 1 &&
VectorQ[CoefficientList[expr, First @ Variables @ Unevaluated[expr]], NumberQ]


VietePolynomialForm /: MakeBoxes[VietePolynomialForm[expr_, x_] /; VietePolyQ[expr, x], fmt_] :=
internalVieteForm[expr, x, fmt]

VietePolynomialForm /: MakeBoxes[VietePolynomialForm[expr_?VietePolyQ], fmt_] :=
internalVieteForm[expr, First @ Variables[expr], fmt]

VietePolynomialForm /: MakeBoxes[VietePolynomialForm[lhs_ == rhs_, x_] /; VietePolyQ[lhs, x] && VietePolyQ[rhs, x], fmt_] :=
MakeBoxes[SequenceForm[VietePolynomialForm[lhs, x], " aequatis sit ", VietePolynomialForm[rhs, x]], fmt]

(* If not of required form, then ignore VietePolynomialForm wrapper *)

VietePolynomialForm /: MakeBoxes[otherwise:VietePolynomialForm[expr_, var_:Null], fmt_] :=
MakeBoxes[expr, fmt]



(*"
VieteQuadraticForm was the name used in the talk, therefore it
must be supported here.  But it should have been named
VietePolynomialForm all along.
"*)

VieteQuadraticForm /: MakeBoxes[VieteQuadraticForm[expr_, x_] /; VietePolyQ[expr, x], fmt_] :=
internalVieteForm[expr, x, fmt]

VieteQuadraticForm /: MakeBoxes[VieteQuadraticForm[expr_?VietePolyQ], fmt_] :=
internalVieteForm[expr, First @ Variables[expr], fmt]

VieteQuadraticForm /: MakeBoxes[VieteQuadraticForm[lhs_ == rhs_, x_] /; VietePolyQ[lhs, x] && VietePolyQ[rhs, x], fmt_] :=
MakeBoxes[SequenceForm[VieteQuadraticForm[lhs, x], " aequatis sit ", VieteQuadraticForm[rhs, x]], fmt]

(* If not of required form, then ignore VieteQuadraticForm wrapper *)

VieteQuadraticForm /: MakeBoxes[otherwise:VieteQuadraticForm[expr_, var_:Null], fmt_] :=
MakeBoxes[expr, fmt]


(* ::Input::Initialization:: *)
Clear[internalHarriotForm]

internalHarriotForm[poly_, x_, fmt_:StandardForm] :=
Module[{coeffList = CoefficientList[poly, x], theVars, theSum},
(
theVars = Table[
ToExpression @ StringJoin @ Table["a", {i}],
{i, Length[coeffList] - 1}
];
theVars = Prepend[theVars, 1];
theSum = Composition[HoldForm, Plus] @@ DeleteCases[Inner[Times, Reverse[theVars], Reverse[coeffList], List], 0];
InterpretationBox @@ {ToBoxes[theSum, fmt], poly, Editable->False}
) /; VectorQ[coeffList, NumberQ]
]


(* ::Input::Initialization:: *)
Clear[HarriotPolynomialForm, HarriotPolyQ]

Attributes[HarriotPolyQ] = HoldAllComplete;

HarriotPolyQ[expr_, var_] :=
PolynomialQ[Unevaluated[expr], Unevaluated[var]] && VectorQ[CoefficientList[expr, var], NumberQ]

HarriotPolyQ[expr_] := PolynomialQ @ Unevaluated[expr] && Length @ Variables @ Unevaluated[expr] == 1 && VectorQ[CoefficientList[expr, First @ Variables @ Unevaluated[expr]], NumberQ]


HarriotPolynomialForm /: MakeBoxes[HarriotPolynomialForm[expr_, x_] /; HarriotPolyQ[expr, x], fmt_] :=
internalHarriotForm[expr, x, fmt]

HarriotPolynomialForm /: MakeBoxes[HarriotPolynomialForm[expr_?HarriotPolyQ], fmt_] :=
internalHarriotForm[expr, First @ Variables[expr], fmt]

HarriotPolynomialForm /: MakeBoxes[HarriotPolynomialForm[lhs_ == rhs_, x_] /; HarriotPolyQ[lhs, x] && HarriotPolyQ[rhs, x], fmt_] :=
InterpretationBox @@ {
MakeBoxes[SameQ[HarriotPolynomialForm[lhs, x], HarriotPolynomialForm[rhs, x]], fmt],
lhs == rhs,
Editable->False
}

(* If not of required form, then ignore HarriotPolynomialForm wrapper *)

HarriotPolynomialForm /: MakeBoxes[otherwise:HarriotPolynomialForm[expr_, var_:Null], fmt_] :=
MakeBoxes[expr, fmt]


(* ::Input::Initialization:: *)
Clear[internalChuquetForm, MyCoeffientList]

MyCoefficientList[poly_, var_] :=
Map[{Coefficient[poly, var, #], #}&, Exponent[poly, var, List]]

internalChuquetForm[poly_, x_, fmt_:StandardForm] :=
Module[{coeffAndPowerList = MyCoefficientList[poly, x], justCoeffs, thePowers, revPowers, revSigns, infixForm},
justCoeffs = First /@ coeffAndPowerList;
(
thePowers = Apply[MyPower[Abs[#1], #2]&, coeffAndPowerList, {1}];
revPowers = Reverse[thePowers];
revSigns = Sign /@ Rest[Reverse[justCoeffs]];
revSigns = Replace[revSigns, {-1 ->OverTilde[m], 1 -> p}, {1}];
infixForm = Drop[#, -1]& @ 
Flatten[Transpose[{revPowers, Append[revSigns, Null]}], 1];
infixForm = DeleteCases[infixForm, 0 | _[0, _]];
infixForm = infixForm /. MyPower[coeff_, power_?Negative] :> MyPower[coeff, SequenceForm[Abs[power], OverTilde[m]]];
infixForm = Composition[HoldForm, SequenceForm] @@ infixForm/. MyPower -> Superscript;
InterpretationBox @@ {ToBoxes[infixForm, fmt], poly, Editable->False}
) /; VectorQ[justCoeffs, NumberQ]
]


(* ::Input::Initialization:: *)
Clear[ChuquetPolynomialForm, ChuquetPolyQ, PseudoPolynomialQ]

PseudoPolynomialQ[expr_] :=
Length @ Variables[expr] == 1 &&
PseudoPolynomialQ[expr, First @ Variables[expr]]

PseudoPolynomialQ[_. x^_Integer, x_] = True;

PseudoPolynomialQ[sum_Plus, x_] :=
Module[{nonNegTerms, nonPosTerms},
nonNegTerms = DeleteCases[sum, _. x^_?Negative];
nonPosTerms = DeleteCases[sum, _. x^_?Positive];
nonPosTerms = nonPosTerms /. x^neg_?Negative :> x^-neg;
PolynomialQ[nonNegTerms, x] && PolynomialQ[nonPosTerms, x]
]

Attributes[ChuquetPolyQ] = HoldAllComplete;

ChuquetPolyQ[expr_, var_] :=
PseudoPolynomialQ[Unevaluated[expr], Unevaluated[var]] && VectorQ[First /@ MyCoefficientList[expr, var], NumberQ]

ChuquetPolyQ[expr_] := PseudoPolynomialQ @ Unevaluated[expr] && Length @ Variables @ Unevaluated[expr] == 1 && VectorQ[First /@ MyCoefficientList[expr, First @ Variables @ Unevaluated[expr]], NumberQ]


ChuquetPolynomialForm /: MakeBoxes[ChuquetPolynomialForm[expr_, x_] /; ChuquetPolyQ[expr, x], fmt_] :=
internalChuquetForm[expr, x, fmt]

ChuquetPolynomialForm /: MakeBoxes[ChuquetPolynomialForm[expr_?ChuquetPolyQ], fmt_] :=
internalChuquetForm[expr, First @ Variables[expr], fmt]

ChuquetPolynomialForm /: MakeBoxes[ChuquetPolynomialForm[lhs_ == rhs_, x_] /; ChuquetPolyQ[lhs, x] && ChuquetPolyQ[rhs, x], fmt_] :=
InterpretationBox @@ {
MakeBoxes[SequenceForm[ChuquetPolynomialForm[lhs, x], " \[EAcute]gault ", ChuquetPolynomialForm[rhs, x]], fmt],
lhs == rhs,
Editable->False
}

(* If not of required form, then ignore ChuquetPolynomialForm wrapper *)

ChuquetPolynomialForm /: MakeBoxes[otherwise:ChuquetPolynomialForm[expr_, var_:Null], fmt_] :=
MakeBoxes[expr, fmt]


(* ::Input::Initialization:: *)
Clear[boxedFunction, LeibnizFunction]

boxedFunction[boxexpr1_, boxexpr2_] :=
GridBox[{{
GridBox[{{boxexpr1}}, GridFrame->{{0, 1}, {0, 1}}],
GridBox[{{boxexpr2}}, GridFrame->{{0, 1}, {1, 0}}, GridFrameMargins->{{0, 0.4}, {0, 1}}]
}}, RowAlignments->Bottom, ColumnSpacings->0.1
]

LeibnizFunction[n_][vars___] :=
boxedFunction[
RowBox @ BoxForm`Intercalate[Thread @ Unevaluated @ MakeBoxes[{vars}], ";"],
MakeBoxes[n]
]

LeibnizFunction[Rational, n_][vars___] :=
boxedFunction[
RowBox @ BoxForm`Intercalate[Thread @ Unevaluated @ MakeBoxes[{vars}], ";"],
MakeBoxes @ Dot[r, n]
]

LeibnizFunction[RationalIntegral, n_][vars___] :=
boxedFunction[
RowBox @ BoxForm`Intercalate[Thread @ Unevaluated @ MakeBoxes[{vars}], ";"],
MakeBoxes @ Dot[ri, n]
]


(* ::Input::Initialization:: *)
LeibnizFunctionQ[f_?SymbolQ /; Context[f] == "Global`"] = True;
LeibnizFunctionQ[_] = False;

Attributes[SymbolQ] = HoldAllComplete;
SymbolQ[s_Symbol] := AtomQ @ Unevaluated[s]


LeibnizForm /: MakeBoxes[LeibnizForm[expr_], fmt_] :=
Module[{distinctFuncs, c, leibnizFuncs},
distinctFuncs = EliminateRepetition[
Join @@ Cases[Unevaluated[expr], liebFunc:(head_ /; LeibnizFunctionQ @ Unevaluated[head])[__] :> HoldComplete[liebFunc], {0, -1}, Heads->True]
];
c[_] = 0;
leibnizFuncs = List @@ Replace[distinctFuncs, _[args__] :> RuleCondition[k = Length @ Unevaluated[{args}]; ++c[k]; DisplayForm[LeibnizFunction[c[k]][args]], True],
{1}];
distinctFuncs = List @@ (HoldPattern /@ HoldPattern /@ distinctFuncs);
Prepend[InterpretationBox[expr, Editable->False],
MakeBoxes @@ Append[
HoldComplete[expr] /. Thread[distinctFuncs -> leibnizFuncs],
fmt
]
]
]


