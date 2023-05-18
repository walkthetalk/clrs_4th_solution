input clrs_bintree;

boolean R;
R := false;
boolean B;
B := true;

vardef rbtree_declare(suffix tree) :=
	bintree_declare(tree);
	boolean tree[]isblack;
enddef;

vardef rbtree_alloc(suffix tree) :=
	save ret;
	numeric ret;
	ret := bintree_alloc(tree);
	tree[ret]isblack := false;

	ret
enddef;

vardef rbtree_free(suffix tree)(expr idx) :=
	bintree_free(tree)(idx);
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
	idx := bintree_newnode(tree)(k);
	tree[idx]isblack := is_black;

	idx
enddef;

vardef rbtree_ass(suffix tree)(expr parent, child, idx) :=
	if idx = 1:
		tree[parent]lft := child;
	elseif idx = 2:
		tree[parent]rt := child;
	fi;
enddef;

vardef rbtree_build(suffix tree) expr s :=
	save len;
	numeric len;
	len := length s;
	numeric lvl;
	numeric idx[];
	numeric pNode[];
	string lastCH;
	lvl := 0;
	idx[lvl] := 0;
	pNode[lvl] := nullptr;
	lastCH := "";

	string ch;
	numeric newnodeBegin;
	string nodecontent;
	for i := 0 upto (len - 1):
		ch := substring (i,i+1) of s;
		% todo: skip spaces
		if ch = "(":
			if lastCH = ")":
				idx[lvl] := idx[lvl] + 1;
				%message decimal(lvl) & " " & "idx -> " & decimal(idx[lvl]);
			else:
				lvl := lvl + 1;
				idx[lvl] := 0;
				%message decimal(lvl) & " " & decimal(idx[lvl]);
			fi;
			% begin new node
			newnodeBegin := i+1;
		elseif ch = ")":
			if lastCH = ")":
				lvl := lvl - 1;
				%message decimal(lvl) & " ^ " & decimal(idx[lvl]);
			else:
				nodecontent := substring (newnodeBegin, i) of s;
				%message "##### " & decimal(lvl) & " " & decimal(idx[lvl]) & " " & nodecontent & " " & decimal(idx[lvl-1]);
				if nodecontent <> "":
					if idx[lvl] <> 0:
						pNode[lvl+1] := rbtree_newnode(tree)(scantokens(nodecontent));
						rbtree_ass(tree)(pNode[lvl], pNode[lvl+1], idx[lvl]);
					else:
						pNode[lvl] := rbtree_newnode(tree)(scantokens(nodecontent));
						rbtree_ass(tree)(pNode[lvl-1], pNode[lvl], idx[lvl-1]);
					fi;
				fi;
			fi;
		fi;

		lastCH := ch;
	endfor;

	tree.root := pNode[1];
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
