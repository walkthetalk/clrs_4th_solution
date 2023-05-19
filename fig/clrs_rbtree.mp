input clrs_bintree;

boolean R;
R := false;
boolean B;
B := true;

vardef declare.rbtree(suffix tree) :=
	declare.bintree(tree);

	% draw options;
	boolean tree.drawnil;
	tree.drawnil := true;

	boolean tree[]isblack;
enddef;

vardef alloc.rbtree(suffix tree) :=
	save ret;
	numeric ret;
	ret := alloc.bintree(tree);
	tree[ret]isblack := false;

	ret
enddef;

vardef free.rbtree(suffix tree)(expr idx) :=
	bintree_free(tree)(idx);
enddef;

vardef isleaf.rbtree(suffix tree)(expr idx) :=
	if (tree[idx]lft = nullptr) and (tree[idx]rt = nullptr):
		true
	else:
		false
	fi
enddef;

vardef newnode.rbtree(suffix tree)(expr k, is_black) :=
	save idx;
	numeric idx;
	idx := newnode.bintree(tree)(k);
	tree[idx]isblack := is_black;

	idx
enddef;

vardef associate.rbtree(suffix tree)(expr parent, child, idx) :=
	if idx = 1:
		tree[parent]lft := child;
	elseif idx = 2:
		tree[parent]rt := child;
	fi;
enddef;

vardef subimg.rbtree(suffix tree)(expr isfull, drawnil, i, xunit, yunit, gsize) :=
image(
	save fr;
	path fr;
	fr := fullcircle scaled gsize;

	if i = nullptr:
		if drawnil:
			fill fr withcolor black;
			label("N", (0,0)) withcolor white;
		fi;
	else:
		save fillcolor, lblcolor;
		color fillcolor;
		color lblcolor;
		if tree[i]isblack:
			fillcolor := black;
		else:
			fillcolor := 0.75red;
		fi;
		if (not isfull) and (isleaf.rbtree(tree)(i)):
			lblcolor := black;
		else:
			lblcolor := white;
			fill fr withcolor fillcolor;
		fi;

		label(TEX("$" & tree[i]key & "$"), (0,0)) withcolor lblcolor;

		if (tree[i]lft <> nullptr) or drawnil:
			save subpic;
			picture subpic;
			subpic := subimg.rbtree(tree)(isfull, drawnil, tree[i]lft, xunit, yunit, gsize);

			save subroot;
			pair subroot;
			subroot := (-xpart(urcorner subpic) - (xunit-gsize)/2, -yunit);

			drawarrow (fr intersectionpoint ((0,0) -- subroot))
				..((fr shifted subroot) intersectionpoint ((0,0) -- subroot)) withcolor black;
			draw subpic shifted subroot;
		fi;

		if (tree[i]rt <> nullptr) or drawnil:
			save subpic;
			picture subpic;
			subpic := subimg.rbtree(tree)(isfull, drawnil, tree[i]rt, xunit, yunit, gsize);

			save subroot;
			pair subroot;
			subroot := (-xpart(ulcorner subpic) + (xunit-gsize)/2, -yunit);

			drawarrow (fr intersectionpoint ((0,0) -- subroot))
				..((fr shifted subroot) intersectionpoint ((0,0) -- subroot)) withcolor black;
			draw subpic shifted subroot;
		fi;
	fi;
)
enddef;

vardef img.rbtree(suffix tree) :=
image(
	if not tree.isfull:
		draw (0, tree.yunit)--(0, 0);
	fi;
	draw subimg.rbtree(tree)(tree.isfull, tree.drawnil, tree.root, tree.xunit, tree.yunit, tree.gsize);
)
enddef;
