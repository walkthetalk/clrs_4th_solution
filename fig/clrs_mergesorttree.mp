input clrs_bintree;

vardef declare.mergesorttree(suffix tree) :=
	declare.bintree(tree);

	% draw options;
	tree.xunit := 0.4cm;
enddef;

vardef alloc.mergesorttree(suffix tree) :=
	save ret;
	numeric ret;
	ret := alloc.bintree(tree);

	ret
enddef;

vardef free.mergesorttree(suffix tree)(expr idx) :=
	bintree_free(tree)(idx);
enddef;

vardef isleaf.mergesorttree(suffix tree)(expr idx) :=
	if (tree[idx]lft = nullptr) and (tree[idx]rt = nullptr):
		true
	else:
		false
	fi
enddef;

vardef newnode.mergesorttree(suffix tree)(expr k, comment) :=
	save idx;
	numeric idx;
	idx := newnode.bintree(tree)(k, comment);

	idx
enddef;

vardef associate.mergesorttree(suffix tree)(expr parent, child, idx) :=
	if idx = 1:
		tree[parent]lft := child;
	elseif idx = 2:
		tree[parent]rt := child;
	fi;
enddef;

vardef prepare.mergesorttree(suffix tree)(expr idx, xx, yy) :=
	% generate colors
	tree[idx]lblcolor := black;
	tree[idx]fillcolor := clrsCfB;
	tree[idx]frcolor := clrsClB;

	tree[idx]lvl := l;
	tree[idx]x   := xx;
	tree[idx]y   := yy;
	if tree[idx]lft <> nullptr:
		prepare.mergesorttree(tree)(tree[idx]lft, xx - rtNof(tree)(tree[idx]lft), yy-1);
	fi;
	if tree[idx]rt <> nullptr:
		prepare.mergesorttree(tree)(tree[idx]rt, xx + lftNof(tree)(tree[idx]rt), yy-1);
	fi;
enddef;

vardef drawcomments.mergesorttree(suffix tree)(expr idx):=
	drawcommentsOf(positionOf(tree)(idx), tree.gsize/2 + tree.commentdist, tree[idx]comment);
	if (tree[idx]lft <> nullptr):
		drawcomments.mergesorttree(tree)(tree[idx]lft);
	fi;
	if (tree[idx]rt <> nullptr):
		drawcomments.mergesorttree(tree)(tree[idx]rt);
	fi;
enddef;

vardef subdraw.mergesorttree(suffix tree)(expr i) :=
	% first draw children, place link under the nodes
	if (tree[i]lft <> nullptr):
		draw linkOf.bintree(tree)(i, tree[i]lft) withcolor black;
		subdraw.mergesorttree(tree)(tree[i]lft);
	fi;

	if (tree[i]rt <> nullptr):
		draw linkOf.bintree(tree)(i, tree[i]rt) withcolor black;
		subdraw.mergesorttree(tree)(tree[i]rt);
	fi;

	save pic;
	picture lbl;
	lbl := thelabel(TEX("$" & tree[i]key & "$"),(0,0));

	save x,y;
	numeric x,y;
	x := xpart urcorner lbl + .1cm;
	y := ypart urcorner lbl + .1cm;

	save c;
	numeric c;
	c := .1cm;

	save fr;
	path fr;
	fr := (x,y-c){up} .. {left}(x-c,y)
		-- (-x+c,y){left} .. {down}(-x,y-c)
		-- (-x,-y+c){down} .. {right}(-x+c,-y)
		-- (x-c,-y){right} .. {up}(x,-y+c) -- cycle;

	if known tree[i]fillcolor:
		fill (fr shifted positionOf(tree)(i)) withcolor tree[i]fillcolor;
	fi;
	if known tree[i]frcolor:
		draw (fr shifted positionOf(tree)(i)) withcolor tree[i]frcolor;
	fi;
	draw lbl shifted positionOf(tree)(i) withcolor tree[i]lblcolor;
enddef;

vardef img.mergesorttree(suffix tree) :=
image(
	picture rpics[];
	save ridx;
	numeric ridx;

	for ridx := 0 upto (tree.nroot - 1):
		rpics[ridx] := image(
				prepare.mergesorttree(tree)(tree.root[ridx], 0,0);

				if not tree.isfull:
					draw (0, tree.yunit)--(0, 0);
				fi;
				% check if root is nullptr
				subdraw.mergesorttree(tree)(tree.root[ridx]);
				drawcomments.mergesorttree(tree)(tree.root[ridx]);
		);
	endfor;

	save pos;
	pair pos;
	pos := (0,0);
	for ridx := 0 upto (tree.nroot - 1):
		pos := pos - (xpart ulcorner rpics[ridx], 0);
		draw rpics[ridx] shifted pos;
		pos := pos + (xpart urcorner rpics[ridx], 0);
		pos := pos + (tree.xunit, 0);
	endfor;
)
enddef;
