### 随机二叉树


$$E(Y_n)=\frac{2}{n}\sum_{i=1}^nE(\max(Y_{i-1},Y_{n-i}))$$


```mma
f[0,k_]:=1;
f[1,k_]:=If[k>0,1,0];
f[n_,k_]:=f[n,k]=Sum[Binomial[n-1,r-1]*f[r-1,k-1]*f[n-r,k-1],{r,n}];
h[n_]:=Sum[k(f[n,k]-If[k>0,f[n,k-1],0]),{k,0,n}]/n!;Table[h[n],{n,0,10}]
Table[h[n],{n,0,30}]//ListLinePlot
```




```mma

Clear[ps,CT]
ps=Prime[Range@PrimePi[m=1*^6]];
CT[n_]:=CT[n]=Count[ps-n,_?PrimeQ]
CloseKernels[];
LaunchKernels[24]
AbortableMap[CT,Range[2,10000,2]];
pt=Table[{i,CT[i]},{i,2,10000,2}];
ListPlot[pt,PlotRange->{7000,30000},PlotTheme->"Classic",AspectRatio->1/2]


```