input TEX;
input clrs;

warningcheck := 0;	% for large number bigger than 4096

bboxmargin := 0;

vardef mOfMatrixChain(suffix mc)(expr gsize) :=
image(
	save i, j, x, y;
	numeric i, j;
	numeric x, y;
	save fr;
	path fr;
	fr := ((0,1)--(-1,0)--(0,-1)--(1,0)--cycle) scaled gsize;

	save len;
	numeric len;
	len := mc.len;

	for i := 1 upto len:
		for j := i upto len:
			x := j + i - len - 1;
			y := j - i - len + 1;

			save pos;
			pair pos;
			pos := (x,y) scaled gsize;

			save f;
			path f;
			f := fr shifted pos;

			draw f withcolor black;
			fill f withcolor clrsCfA;

			label(decimal(mc.m[i][j]v), pos);
		endfor;
	endfor;

	for i := 1 upto len:
		x := i;
		y := 2-i;
		label(decimal(i), (x,y) scaled gsize) shifted (-.25gsize, -.25gsize);
	endfor;

	label(TEX("$i$"), (.5 len + 1, -.5 len + 2) scaled gsize);

	for j := 1 upto len:
		x := j - len - 1;
		y := j - len + 1;
		label(decimal(j), (x,y) scaled gsize) shifted(.25gsize, -.25gsize);
	endfor;

	label(TEX("$j$"), (-.5 len - 1, -.5 len + 2) scaled gsize);

	label(TEX("$m$"), (0, 2) scaled gsize);

	for i:= 1 upto len:
		label(TEX("$A_" & decimal(i) & "$"), (i * 2 - len - 1, -len - 1) scaled gsize)
			shifted(0, .5gsize);
	endfor;
)
enddef;

vardef sOfMatrixChain(suffix mc)(expr gsize) :=
image(
	save i, j, x, y;
	numeric i, j;
	numeric x, y;
	save fr;
	path fr;
	fr := ((0,1)--(-1,0)--(0,-1)--(1,0)--cycle) scaled gsize;

	save len;
	numeric len;
	len := mc.len;

	for i := 1 upto (len - 1):
		for j := (i + 1) upto len:
			x := j + i - len - 1;
			y := j - i - len + 1;

			save pos;
			pair pos;
			pos := (x,y) scaled gsize;

			save f;
			path f;
			f := fr shifted pos;

			draw f withcolor black;
			fill f withcolor clrsCfA;

			label(decimal(mc.s[i][j]v), (x,y) scaled gsize);
		endfor;
	endfor;

	for i := 1 upto (len - 1):
		x := i;
		y := 2-i;
		label(decimal(i), (x,y) scaled gsize) shifted (-.25gsize, -.25gsize);
	endfor;

	label(TEX("$i$"), (.5 len + 1, -.5 len + 2) scaled gsize);

	for j := 2 upto len:
		x := j - len - 1;
		y := j - len + 1;
		label(decimal(j), (x,y) scaled gsize) shifted(.25gsize, -.25gsize);
	endfor;

	label(TEX("$j$"), (-.5 len - 1, -.5 len + 2) scaled gsize);

	label(TEX("$s$"), (0, 2) scaled gsize);
)
enddef;

vardef declareMatrixChain(suffix mc) :=
	numeric mc.len;
	numeric mc.key[];
	numeric mc.m[][]v;
	color mc.m[][]c;
	numeric mc.s[][]v;
	color mc.s[][]c;
enddef;

vardef initMatrixChain(suffix mc)(expr keys) :=
	save tmp, c;
	string tmp,c;
	tmp := "";

	mc.len := 0;
	for i = 0 upto (length(keys) - 1):
		c := substring (i,i+1) of keys;
		if c = ",":
			mc.key[mc.len] := scantokens(tmp);
			tmp := "";
			mc.len := mc.len + 1;
		else:
			tmp := tmp & c;
		fi;
	endfor;
	mc.key[mc.len] := scantokens(tmp);
enddef;

vardef calcMatrixChain(suffix mc) :=
	save n;
	numeric n;
	n := mc.len;
	save i,j,l,k;
	numeric i,j,l,k;

	for i := 1 upto n:
		mc.m[i][i]v := 0;
	endfor;
	for l := 2 upto n:
		for i := 1 upto (n - l + 1):
			j := i + l - 1;
			%message "i,j is " & decimal(i) & "," & decimal(j);
			for k := i upto (j - 1):
				q := mc.m[i][k]v + mc.m[k+1][j]v + mc.key[i-1] * mc.key[k] * mc.key[j];
				%message "   k is " & decimal(k);
				%message "   q is " & decimal(q);
				if unknown(mc.m[i][j]v):
					mc.m[i][j]v := q;
					mc.s[i][j]v := k;
				elseif q < mc.m[i][j]v:
					mc.m[i][j]v := q;
					mc.s[i][j]v := k;
				fi;
			endfor;
		endfor;
	endfor;
enddef;

beginfig(1);
	declareMatrixChain(MC);
	initMatrixChain(MC)("5,10,3,12,5,50,6");
	calcMatrixChain(MC);

	draw mOfMatrixChain(MC)(0.5cm);
	draw sOfMatrixChain(MC)(0.5cm) shifted (MC.len * 0.5cm * 2, 0);
endfig;

end;
