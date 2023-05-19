input clrs_bintree;

boolean R;
R := false;
boolean B;
B := true;

vardef declare.rbtree(suffix tree) :=
	declare.bintree(tree);
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

vardef rbtree_isleaf(suffix tree)(expr idx) :=
	if tree[idx]lft = nullptr and tree[idx]rt = nullptr:
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

vardef build@#(suffix tree) expr s :=
	save lvl, idx, pNode, lastCH;
	numeric lvl;
	numeric idx[];
	numeric pNode[];
	string lastCH;
	lvl := 0;
	idx[lvl] := 0;
	pNode[lvl] := nullptr;
	lastCH := "";

	save ch, newnodeBegin, newnodeContent, newnodeLvl;
	string ch;
	numeric newnodeBegin;
	string newnodeContent;
	numeric newnodeLvl;
	for i := 0 upto ((length s) - 1):
		ch := substring (i,i+1) of s;
		% todo: skip spaces
		if ch = "(":
			if lastCH = ")":
				idx[lvl] := idx[lvl] + 1;
			else:
				lvl := lvl + 1;
				idx[lvl] := 0;
			fi;
			% begin new node
			newnodeBegin := i+1;
		elseif ch = ")":
			if lastCH = ")":
				lvl := lvl - 1;
			else:
				newnodeContent := substring (newnodeBegin, i) of s;
				if newnodeContent <> "":
					if idx[lvl] <> 0:
						newnodeLvl := lvl+1;
					else:
						newnodeLvl := lvl;
					fi;
					pNode[newnodeLvl] := newnode@#(tree)(scantokens(newnodeContent));
					associate@#(tree)(pNode[newnodeLvl-1], pNode[newnodeLvl], idx[newnodeLvl-1]);
				fi;
			fi;
		fi;

		lastCH := ch;
	endfor;

	tree.root := pNode[1];
enddef;

vardef subimg.rbtree(suffix tree)(expr drawnil, i, xunit, yunit, gsize) :=
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
			subpic := subimg.rbtree(tree)(drawnil, tree[i]lft, xunit, yunit, gsize);

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
			subpic := subimg.rbtree(tree)(drawnil, tree[i]rt, xunit, yunit, gsize);

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

vardef img.rbtree(suffix tree)(expr hasnil, gsize, xunit, yunit) :=
image(
	draw subimg.rbtree(tree)(hasnil, tree.root, xunit, yunit, gsize);
)
enddef;
