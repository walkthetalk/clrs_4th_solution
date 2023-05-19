input memory;

vardef declare.bintree(suffix tree) :=
	declare_tree(tree);

	numeric tree[]key;
	numeric tree[]lft;
	numeric tree[]rt;
enddef;

vardef alloc.bintree(suffix tree) :=
	save ret;
	numeric ret;
	ret := alloc_slot(tree);

	% init node
	tree[ret]key := -1;
	tree[ret]lft := nullptr;
	tree[ret]rt  := nullptr;

	ret
enddef;

vardef free.bintree(suffix tree)(expr idx) :=
	free_slot(tree)(idx);
enddef;

vardef newnode.bintree(suffix tree)(expr k) :=
	save idx;
	numeric idx;
	idx := alloc.bintree(tree);

	tree[idx]key := k;
	tree[idx]lft := nullptr;
	tree[idx]rt  := nullptr;

	idx
enddef;
vardef associate.bintree(suffix tree)(expr parent, child, idx) :=
	if idx = 1:
		tree[parent]lft := child;
	elseif idx = 2:
		tree[parent]rt := child;
	fi;
enddef;


vardef subimg.bintree(suffix tree)(expr i, xunit, yunit, gsize) :=
image(
	save fr;
	path fr;
	fr := fullcircle scaled gsize;

	fill fr withcolor .8white;
	label(decimal(tree[i]key), (0,0));

	if (tree[i]lft <> nullptr):
		save subpic;
		picture subpic;
		subpic := subimg.bintree(tree)(tree[i]lft, xunit, yunit, gsize);

		save subroot;
		pair subroot;
		subroot := (-xpart(urcorner subpic) - (xunit-gsize)/2, -yunit);

		drawarrow (fr intersectionpoint ((0,0) -- subroot))
			..((fr shifted subroot) intersectionpoint ((0,0) -- subroot)) withcolor black;
		draw subpic shifted subroot;
	fi;

	if (tree[i]rt <> nullptr):
		save subpic;
		picture subpic;
		subpic := subimg.bintree(tree)(tree[i]rt, xunit, yunit, gsize);

		save subroot;
		pair subroot;
		subroot := (-xpart(ulcorner subpic) + (xunit-gsize)/2, -yunit);

		drawarrow (fr intersectionpoint ((0,0) -- subroot))
			..((fr shifted subroot) intersectionpoint ((0,0) -- subroot)) withcolor black;
		draw subpic shifted subroot;
	fi;
)
enddef;

vardef img.bintree(suffix tree)(expr gsize, xunit, yunit) :=
image(
	% check if root is nullptr
	draw subimg.bintree(tree)(tree.root, xunit, yunit, gsize);
)
enddef;
