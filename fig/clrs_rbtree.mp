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

vardef img_sub_bin_search_fine_tree(suffix A, B)(expr drawnil, i, xunit, yunit, gsize) :=
image(
	save fr, _drawnil;
	path fr;
	fr := fullcircle scaled gsize;

	boolean _drawnil;
	if known(A[i]):
		_drawnil := drawnil;
		fill fr withcolor B[i];
		label(decimal(A[i]), (0,0)) withcolor B[0];
	elseif drawnil:
		fill fr withcolor black;
		label("N", (0,0)) withcolor B[0];
		_drawnil := false;
	fi;

	if known(A[lchild(i)]) or _drawnil:
		save subpic;
		picture subpic;
		subpic := img_sub_bin_search_fine_tree(A, B)(_drawnil, lchild(i), xunit, yunit, gsize);

		save subroot;
		pair subroot;
		subroot := (-xpart(urcorner subpic) - (xunit-gsize)/2, -yunit);

		drawarrow (fr intersectionpoint ((0,0) -- subroot))
			..((fr shifted subroot) intersectionpoint ((0,0) -- subroot)) withcolor black;
		draw subpic shifted subroot;
	fi;

	if known(A[rchild(i)]) or _drawnil:
		save subpic;
		picture subpic;
		subpic := img_sub_bin_search_fine_tree(A, B)(_drawnil, rchild(i), xunit, yunit, gsize);

		save subroot;
		pair subroot;
		subroot := (-xpart(ulcorner subpic) + (xunit-gsize)/2, -yunit);

		drawarrow (fr intersectionpoint ((0,0) -- subroot))
			..((fr shifted subroot) intersectionpoint ((0,0) -- subroot)) withcolor black;
		draw subpic shifted subroot;
	fi;
)
enddef;

% A: numeric A[1..len];
%    numeric A.len;
% B: color B[1..len]
%    B[0] is label color
vardef img_bin_search_tree(suffix A, B)(expr hasnil, gsize, xunit, yunit) :=
image(
	draw img_sub_bin_search_fine_tree(A, B)(hasnil, 1, xunit, yunit, gsize);
)
enddef;

color rbcRed;
rbcRed := 0.75red;
color rbcBlack;
rbcBlack := black;
