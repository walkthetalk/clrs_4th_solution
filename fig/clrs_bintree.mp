input TEX;

input memory;
input clrs;
input clrs_base_tree;

vardef declare.bintree(suffix tree) :=
	declare_tree(tree);

	% draw options
	boolean tree.isfull;
	tree.isfull := true;

	numeric tree.gsize;
	numeric tree.xunit;
	numeric tree.yunit;
	numeric tree.commentdist;
	tree.gsize := 0.5cm;
	tree.xunit := 0.6cm;
	tree.yunit := 1.0cm;
	tree.commentdist := 0.05cm;

	string tree[]key;
	numeric tree[]lft;
	numeric tree[]rt;
	string tree[]comment;

	color   tree[]frcolor;
	color   tree[]fillcolor;
	color   tree[]lblcolor;

	path    tree.fr;
	numeric tree[]lvl;
	numeric tree[]x;
	numeric tree[]y;

	tree.fr = fullcircle scaled tree.gsize;
enddef;

vardef alloc.bintree(suffix tree) :=
	save ret;
	numeric ret;
	ret := alloc_slot(tree);

	% init node
	tree[ret]key := "";
	tree[ret]lft := nullptr;
	tree[ret]rt  := nullptr;

	ret
enddef;

vardef free.bintree(suffix tree)(expr idx) :=
	free_slot(tree)(idx);
enddef;

vardef newnode.bintree(suffix tree)(expr k, cmt) :=
	save idx;
	numeric idx;
	idx := alloc.bintree(tree);

	tree[idx]key := k;
	tree[idx]lft := nullptr;
	tree[idx]rt  := nullptr;
	tree[idx]comment := cmt;

	idx
enddef;
vardef associate.bintree(suffix tree)(expr parent, child, idx) :=
	if idx = 1:
		tree[parent]lft := child;
	elseif idx = 2:
		tree[parent]rt := child;
	fi;
enddef;

vardef isleaf.bintree(suffix tree)(expr idx) :=
	if (tree[idx]lft = nullptr) and (tree[idx]rt = nullptr):
		true
	else:
		false
	fi
enddef;

vardef drawcommentsOf(expr position, dist, cmt) :=
	save i;
	numeric i;
	save j;
	numeric j;

	save start;
	numeric start;
	start := 0;
	for i := 0 upto (length cmt):
		if (i = (length cmt)) or (substring(i,i+1) of cmt = ","):
			save scmt;
			string scmt;
			scmt := substring(start, i) of cmt;
			start := i+1;

			for j := 0 upto (length scmt - 1):
				if substring(j,j+1) of scmt = ".":
					save pos;
					string pos;
					pos := substring(0,j) of scmt;

					save poffset;
					pair poffset;
					if pos = "rt":
						poffset := (dist,0);
					elseif pos = "lft":
						poffset := (-dist,0);
					elseif pos = "top":
						poffset := (0,dist);
					elseif pos = "bot":
						poffset := (0,-dist);
					elseif pos = "toplft":
						poffset := (0,dist);
						pos := "ulft";
					elseif pos = "toprt":
						poffset := (0,dist);
						pos := "urt";
					elseif pos = "botlft":
						poffset := (0,-dist);
						pos := "llft";
					elseif pos = "botrt":
						poffset := (0,-dist);
						pos := "lrt";
					elseif pos = "urt":
						poffset := (dist/sqrt(2),dist/sqrt(2));
					elseif pos = "ulft":
						poffset := (-dist/sqrt(2),dist/sqrt(2));
					elseif pos = "lrt":
						poffset := (dist/sqrt(2),-dist/sqrt(2));
					elseif pos = "llft":
						poffset := (-dist/sqrt(2),-dist/sqrt(2));
					else:
						message "error: unkown position of comments: " & pos;
					fi;
					poffset := poffset + position;
					scantokens("label." & pos & "(TEX(" & char(34) & substring(j+1, length scmt) of scmt & char(34) & "), poffset)");

					exitif true;
				fi;
			endfor;
		fi;
	endfor;
enddef;

vardef lftNof(suffix tree)(expr n) :=
	save r;
	numeric r;

	if tree[n]lft <> nullptr:
		r := lftNof(tree)(tree[n]lft);
		r := r + rtNof(tree)(tree[n]lft);
	else:
		r := 1;
	fi;

	r
enddef;

vardef rtNof(suffix tree)(expr n) :=
	save r;
	numeric r;

	if tree[n]rt <> nullptr:
		r := lftNof(tree)(tree[n]rt);
		r := r + rtNof(tree)(tree[n]rt);
	else:
		r := 1;
	fi;

	r
enddef;

vardef prepare.bintree(suffix tree)(expr idx, xx, yy) :=
	if tree.isfull or (not (isleaf.bintree(tree)(idx))):
		if unknown tree[idx]frcolor:
			tree[idx]frcolor := clrsClA;
		fi;
		if unknown tree[idx]fillcolor:
			tree[idx]fillcolor := clrsCfA;
		fi;
	fi;
	if unknown tree[idx]lblcolor:
		tree[idx]lblcolor := black;
	fi;

	tree[idx]lvl := l;
	tree[idx]x   := xx;
	tree[idx]y   := yy;
	if tree[idx]lft <> nullptr:
		prepare.bintree(tree)(tree[idx]lft, xx - rtNof(tree)(tree[idx]lft), yy-1);
	fi;
	if tree[idx]rt <> nullptr:
		prepare.bintree(tree)(tree[idx]rt, xx + lftNof(tree)(tree[idx]rt), yy-1);
	fi;
enddef;

vardef positionOf(suffix tree)(expr i) :=
	(tree.xunit * tree[i]x, tree.yunit * tree[i]y)
enddef;

vardef linkof(expr fr, sp, ep) :=
	save lpath;
	path lpath;
	lpath := (sp--ep);
	((fr shifted (point 0 of lpath)) intersectionpoint lpath)
		-- ((fr shifted (point 1 of lpath)) intersectionpoint lpath)
enddef;

vardef linkOf.bintree(suffix tree)(expr i, j) :=
	linkof(tree.fr, positionOf(tree)(i), positionOf(tree)(j))
enddef;

vardef subdraw.bintree(suffix tree)(expr i) :=
	if known tree[i]fillcolor:
		fill tree.fr shifted positionOf(tree)(i) withcolor tree[i]fillcolor;
	fi;
	if known tree[i]frcolor:
		draw tree.fr shifted positionOf(tree)(i) withcolor tree[i]frcolor;
	fi;
	label(TEX("$" & tree[i]key & "$"), positionOf(tree)(i)) withcolor tree[i]lblcolor;

	if (tree[i]lft <> nullptr):
		subdraw.bintree(tree)(tree[i]lft);
		drawarrow linkOf.bintree(tree)(i, tree[i]lft) withcolor black;
	fi;

	if (tree[i]rt <> nullptr):
		subdraw.bintree(tree)(tree[i]rt);
		drawarrow linkOf.bintree(tree)(i, tree[i]rt) withcolor black;
	fi;
enddef;
vardef img.bintree(suffix tree) :=
image(
	prepare.bintree(tree)(tree.root, 0, 0);

	if not tree.isfull:
		draw (0, tree.yunit)--(0, 0);
	fi;
	% check if root is nullptr
	subdraw.bintree(tree)(tree.root);
)
enddef;
