input TEX;

numeric ratio;
ratio := 20;

vardef posOf(expr row, column) :=
	(column * ratio, -row * ratio)
enddef;

vardef posAt(expr rc) :=
	((ypart rc) * ratio, -(xpart rc) * ratio)
enddef;

vardef secondCircle :=
	save p;
	path p;
	p := fullcircle scaled (ratio * 0.8);
	p
enddef;

vardef thirdCircle :=
	save p;
	path p;
	p := fullcircle scaled (ratio * 1.2);
	p
enddef;

beginfig(1);
	pair second[];
	second[1] := (1,4);
	second[2] := (2,5);
	pair third[];
	third[1] := (1,4);
	third[2] := (2,5);
	third[3] := (1,3);
	third[4] := (2,4);
	third[5] := (3,5);
	for i = 1 upto 5:
		fill thirdCircle shifted posAt(third[i]) withcolor blue;
	endfor;
	for i = 1 upto 2:
		fill secondCircle shifted posAt(second[i]) withcolor red;
	endfor;

	string lr[];
	lr[1] := "a";
	lr[2] := "b";
	lr[3] := "c";
	lr[4] := "d";
	lr[5] := "e";
	string lbl;
	for r = 1 upto 5:
		for c = 1 upto 5:
			lbl := "$" & lr[c] & "_{" & decimal r & "}$";
			label(TEX(lbl), posOf(r, c));
		endfor;
	endfor;
endfig;

end;
