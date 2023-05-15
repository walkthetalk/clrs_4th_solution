input memory;

boolean R;
R := false;
boolean B;
B := true;

vardef rbtree_declare(suffix tree) :=
	declare_tree(tree);

	numeric tree[]key;
	numeric tree[]lft;
	numeric tree[]rt;
	boolean tree[]isblack;
enddef;

vardef rbtree_alloc(suffix tree) :=
	save ret;
	numeric ret;
	ret := alloc_slot(tree);

	% init node
	tree[ret]key := -1;
	tree[ret]lft := nullptr;
	tree[ret]rt  := nullptr;
	tree[ret]isblack := false;

	ret
enddef;

vardef rbtree_free(suffix tree)(expr idx) :=
	free_slot(tree)(idx);
enddef;

vardef rbtree_isleaf(suffix tree)(expr idx) :=
	if tree[idx]lft = nullptr and tree[idx]rt = nullptr:
		true
	else:
		false
	fi
enddef;

vardef rbtree_newnode(suffix tree)(expr k, is_black) :=
	save idx;
	numeric idx;
	idx := rbtree_alloc(tree);

	tree[idx]key := k;
	tree[idx]isblack := is_black;
	tree[idx]lft := nullptr;
	tree[idx]rt  := nullptr;

	idx
enddef;

vardef isempty(text a) :=
	save i;
	numeric i;
	i := 0;
	for t=a:
		i := i + 1;
	endfor;

	if i > 0:
		false
	else:
		true
	fi
enddef;

vardef rbtree_recbuild(suffix tree)(text a)(text b)(text c) :=
	save idx, l, r;
	numeric idx;
	numeric l;
	numeric r;

	if isempty(b):
		message "b is numeric";
		l := nullptr;
	else:
		message "b is tree";
		l := rbtree_recbuild(tree) b;
	fi;
	if numeric c:
		message "r is numeric";
		r := nullptr;
	else:
		message "r is tree";
		r := rbtree_recbuild(tree) c;
	fi;
	idx := rbtree_newnode(tree)(a);

	tree[idx]lft := l;
	tree[idx]rt  := r;

	idx
enddef;

vardef rbtree_build(suffix tree)(text a)(text b)(text c) :=
	tree.root := rbtree_recbuild(tree)(a)(b)(c);
enddef;

vardef rbtree_subimg(suffix tree)(expr drawnil, i, xunit, yunit, gsize) :=
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
		save ccc;
		color ccc;
		if tree[i]isblack:
			ccc := black;
		else:
			ccc := 0.75red;
		fi;
		fill fr withcolor ccc;
		label(decimal(tree[i]key), (0,0)) withcolor white;

		if (tree[i]lft <> nullptr) or drawnil:
			save subpic;
			picture subpic;
			subpic := rbtree_subimg(tree)(drawnil, tree[i]lft, xunit, yunit, gsize);

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
			subpic := rbtree_subimg(tree)(drawnil, tree[i]rt, xunit, yunit, gsize);

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

vardef rbtree_img(suffix tree)(expr hasnil, gsize, xunit, yunit) :=
image(
	draw rbtree_subimg(tree)(hasnil, tree.root, xunit, yunit, gsize);
)
enddef;
