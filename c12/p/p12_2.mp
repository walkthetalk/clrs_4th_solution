input clrs;

bboxmargin := 0;

% for any def, use expr/primary, don't use suffix
vardef lchild primary $ =
	($ * 2)
enddef;

vardef rchild primary $ =
	($ * 2 + 1)
enddef;

vardef parent primary $ =
	(floor($ / 2))
enddef;

vardef validate(suffix A)(expr i) :=
	if known(A[i]):
		i
	else:
		0
	fi;
enddef;

vardef img_sub_bin_search_tree(suffix A)(expr i, xunit, yunit, gsize) :=
image(
	save fr;
	path fr;
	fr := fullcircle xscaled (2 * gsize) yscaled gsize;

	if A[i] = "":
		fill fr withcolor clrsCfB;
	else:
		fill fr withcolor clrsCfA;
		label(A[i], (0,0)) withcolor black;
	fi;

	if known(A[lchild(i)]):
		save subpic, arrowpath;
		picture subpic;
		subpic := img_sub_bin_search_tree(A)(lchild(i), xunit, yunit, gsize);

		save subroot;
		pair subroot;
		subroot := (-xpart(urcorner subpic) - (xunit-gsize)/2, -yunit);

		path arrowpath;
		arrowpath := (fr intersectionpoint ((0,0) -- subroot))
			..((fr shifted subroot) intersectionpoint ((0,0) -- subroot));
		drawarrow  arrowpath withcolor black;
		label("0", (center arrowpath) + (-.2gsize, .3gsize));
		draw subpic shifted subroot;
	fi;

	if known(A[rchild(i)]):
		save subpic, arrowpath;
		picture subpic;
		subpic := img_sub_bin_search_tree(A)(rchild(i), xunit, yunit, gsize);

		save subroot;
		pair subroot;
		subroot := (-xpart(ulcorner subpic) + (xunit-gsize)/2, -yunit);

		path arrowpath;
		arrowpath := (fr intersectionpoint ((0,0) -- subroot))
			..((fr shifted subroot) intersectionpoint ((0,0) -- subroot));
		drawarrow arrowpath withcolor black;
		label("1", (center arrowpath) + (.2gsize, .3gsize));
		draw subpic shifted subroot;
	fi;
)
enddef;

vardef img_bin_search_tree(suffix A)(expr gsize, xunit, yunit) :=
image(
	draw img_sub_bin_search_tree(A)(1, xunit, yunit, gsize);
)
enddef;

beginfig(1);
	string data[];
	data[1] := "";
	data[2] := "0";
	data[3] := "";
	data[5] := "";
	data[6] := "10";
	data[11] := "011";
	data[12] := "100";
	data[13] := "";
	data[27] := "1011";

	draw img_bin_search_tree(data)(0.5cm, 0.8cm,1.0cm);
endfig;

end;
