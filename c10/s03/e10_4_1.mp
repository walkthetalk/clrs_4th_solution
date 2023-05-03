input TEX;

vardef texlabel@#(expr strname, pos) text p =
	label@#(TEX(strname), pos) p
enddef;

vardef mathlabel@#(expr strname, pos) text p =
	label@#(TEX("$" & strname & "$"), pos) p
enddef;

vardef heap_interval primary $ =
	save n;
	numeric n;

	%message "heap_interval " & decimal($);
	% find highest bit
	n := 1;
	forever:
		exitif (n*2) > $;
		n := n * 2;
	endfor

	% n = 2^{\lfloor \log_2^$ \rfloor}

	if (n <= $) and ($ <= (n + 1)):
		n := n / 4;
	else:
		n := n / 2;
	fi;

	if n < 1:
		n := 1;
	fi;

	n
enddef;

vardef img_bintree(suffix A)(expr i, p, n, xunit, yunit, gsize) :=
image(
	save fr;
	path fr;
	fr := fullcircle scaled gsize;

	%message "img subheap " & decimal(n);

	save nn;
	numeric nn;
	nn := n / 2;
	if nn < 0.5:
		nn := 0.5;
	fi;

	fill fr shifted p withcolor .8white;
	label(decimal(A.key[i]), p) withcolor black;

	if known(A.left[i]) and (A.left[i] >= 0):
		save cp;
		pair cp;
		cp := (xpart p - nn * xunit, ypart p - yunit);

		drawarrow ((fr shifted p) intersectionpoint (p -- cp))
			..((fr shifted cp) intersectionpoint (p -- cp)) withcolor black;
		draw img_bintree(A)(A.left[i], cp, nn, xunit, yunit, gsize);
	fi;

	if known(A.right[i]) and (A.right[i] >= 0):
		save cp;
		pair cp;
		cp := (xpart p + nn * xunit, ypart p - yunit);
		drawarrow ((fr shifted p) intersectionpoint (p -- cp))
			..((fr shifted cp) intersectionpoint (p -- cp)) withcolor black;
		draw img_bintree(A)(A.right[i], cp, nn, xunit, yunit, gsize);
	fi;
)
enddef;

vardef imgTenFourOne :=
image(
	numeric A.key[], A.left[], A.right[];
	numeric A.len;
	A.len := 10;	% data length
	numeric NIL;
	NIL := -1;

	A.key[ 1] := 17; A.left[ 1] := 8; A.right[ 1] := 9;
	A.key[ 2] := 14; A.left[ 2] := NIL; A.right[ 2] := NIL;
	A.key[ 3] := 12; A.left[ 3] := NIL; A.right[ 3] := NIL;
	A.key[ 4] := 20; A.left[ 4] := 10; A.right[ 4] := NIL;
	A.key[ 5] := 33; A.left[ 5] := 2; A.right[ 5] := NIL;
	A.key[ 6] := 15; A.left[ 6] := 1; A.right[ 6] := 4;
	A.key[ 7] := 28; A.left[ 7] := NIL; A.right[ 7] := NIL;
	A.key[ 8] := 22; A.left[ 8] := NIL; A.right[ 8] := NIL;
	A.key[ 9] := 13; A.left[ 9] := 3; A.right[ 9] := 7;
	A.key[10] := 25; A.left[10] := NIL; A.right[10] := 5;

	draw img_bintree(A)(6, (0,0), heap_interval(A.len), .5cm, .7cm, .5cm);
)
enddef;

beginfig(1);
	draw imgTenFourOne;
endfig;

end;
