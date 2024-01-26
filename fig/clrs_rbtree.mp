input clrs_bintree;

vardef declare.rbtree(suffix tree) :=
	declare.bintree(tree);

	% draw options;
	boolean tree.drawnil;
	tree.drawnil := true;

	string tree[]ncolor;
enddef;

vardef alloc.rbtree(suffix tree) :=
	save ret;
	numeric ret;
	ret := alloc.bintree(tree);
	tree[ret]ncolor := "black";

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

vardef newnode.rbtree(suffix tree)(expr k, nodecolor, comment) :=
	save idx;
	numeric idx;
	idx := newnode.bintree(tree)(k, comment);
	tree[idx]ncolor := nodecolor;

	idx
enddef;

vardef associate.rbtree(suffix tree)(expr parent, child, idx) :=
	if idx = 1:
		tree[parent]lft := child;
	elseif idx = 2:
		tree[parent]rt := child;
	fi;
enddef;

vardef prepare.rbtree(suffix tree)(expr idx, xx, yy) :=
	% generate colors
	if (not tree.isfull) and (isleaf.rbtree(tree)(idx)):
		tree[idx]lblcolor := black;
	else:
		tree[idx]lblcolor := white;
		if tree[idx]ncolor = "B":
			tree[idx]fillcolor := black;
			tree[idx]frcolor := black;
		elseif tree[idx]ncolor = "R":
			tree[idx]fillcolor := 0.75red;
			tree[idx]frcolor := (148/255.0,31/255.0,40/255.0);
		elseif tree[idx]ncolor = "U":
			tree[idx]fillcolor := (192/255.0,139/255.0,117/255.0);
			tree[idx]frcolor := (144/255.0,75/255.0,78/255.0);
		else:
			tree[idx]fillcolor := scantokens(tree[i]ncolor);
			tree[idx]frcolor := tree[idx]fillcolor;
		fi;
	fi;

	tree[idx]lvl := l;
	tree[idx]x   := xx;
	tree[idx]y   := yy;
	if tree[idx]lft <> nullptr:
		prepare.rbtree(tree)(tree[idx]lft, xx - rtNof(tree)(tree[idx]lft), yy-1);
	fi;
	if tree[idx]rt <> nullptr:
		prepare.rbtree(tree)(tree[idx]rt, xx + lftNof(tree)(tree[idx]rt), yy-1);
	fi;
enddef;

vardef drawcomments.rbtree(suffix tree)(expr idx):=
	drawcommentsOf(positionOf(tree)(idx), tree.gsize/2 + tree.commentdist, tree[idx]comment);
	if (tree[idx]lft <> nullptr):
		drawcomments.rbtree(tree)(tree[idx]lft);
	fi;
	if (tree[idx]rt <> nullptr):
		drawcomments.rbtree(tree)(tree[idx]rt);
	fi;
enddef;

vardef subdraw.rbtree(suffix tree)(expr i) :=
	if known tree[i]fillcolor:
		fill (tree.fr shifted positionOf(tree)(i)) withcolor tree[i]fillcolor;
	fi;
	if known tree[i]frcolor:
		draw (tree.fr shifted positionOf(tree)(i)) withcolor tree[i]frcolor;
	fi;
	save lbl;
	string lbl;
	if (tree.hasSize):
		lbl := "${" & tree[i]key & " \over " & decimal(sizeNof(tree)(i)) & "}$";
	else:
		lbl := "$" & tree[i]key & "$";
	fi;
	label(TEX(lbl), positionOf(tree)(i)) withcolor tree[i]lblcolor;

	if isleaf.rbtree(tree)(i) and tree.drawnil:
		save nilposition;
		pair nilposition;
		nilposition := positionOf(tree)(i) + (0, -tree.xunit * 2);
		fill (tree.fr shifted nilposition) withcolor black;
		label(TEX"$N$", nilposition) withcolor white;

		drawarrow linkof(tree.fr, positionOf(tree)(i), nilposition) withcolor black;
	fi;

	if (tree[i]lft <> nullptr):
		subdraw.rbtree(tree)(tree[i]lft);
		drawarrow linkOf.bintree(tree)(i, tree[i]lft) withcolor black;
	fi;

	if (tree[i]rt <> nullptr):
		subdraw.rbtree(tree)(tree[i]rt);
		drawarrow linkOf.bintree(tree)(i, tree[i]rt) withcolor black;
	fi;
enddef;

vardef img.rbtree(suffix tree) :=
image(
	prepare.rbtree(tree)(tree.root, 0,0);

	if not tree.isfull:
		draw (0, tree.yunit)--(0, 0);
	fi;
	% check if root is nullptr
	subdraw.rbtree(tree)(tree.root);
	drawcomments.rbtree(tree)(tree.root);
)
enddef;
