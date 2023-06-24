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
	tree.xunit := 0.8cm;
	tree.yunit := 0.8cm;
	tree.commentdist := 0.05cm;

	string tree[]key;
	numeric tree[]lft;
	numeric tree[]rt;
	string tree[]comment;
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

vardef drawcomments.bintree(suffix tree)(expr gsize, cmt) :=
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
					save cmtpic;
					picture cmtpic;
					cmtpic := scantokens("thelabel(TEX(" & char(34) & substring(j+1, length scmt) of scmt & char(34) & "), (0,0))");

					save pos;
					string pos;
					pos := substring(0,j) of scmt;

					save halfw,halfh,dist;
					numeric halfw,halfh,dist;
					halfw := xpart(lrcorner cmtpic);
					halfh := ypart(urcorner cmtpic);
					dist  := gsize/2 + tree.commentdist;
					if pos = "rt":
						draw cmtpic shifted (dist + halfw,0);
					elseif pos = "lft":
						draw cmtpic shifted (-dist - halfw,0);
					elseif pos = "top":
						draw cmtpic shifted (0,dist + halfh);
					elseif pos = "toplft":
						draw cmtpic shifted (-halfw,dist + halfh);
					elseif pos = "toprt":
						draw cmtpic shifted (halfw,dist + halfh);
					elseif pos = "bot":
						draw cmtpic shifted (0,-dist - halfh);
					elseif pos = "botlft":
						draw cmtpic shifted (-halfw,-dist - halfh);
					elseif pos = "botrt":
						draw cmtpic shifted (halfw,-dist - halfh);
					elseif pos = "urt":
						draw cmtpic shifted (halfw + dist/sqrt(2),dist/sqrt(2) + halfh);
					elseif pos = "ulft":
						draw cmtpic shifted (-halfw - dist/sqrt(2),dist/sqrt(2) + halfh);
					elseif pos = "lrt":
						draw cmtpic shifted (halfw + dist/sqrt(2),-dist/sqrt(2) - halfh);
					elseif pos = "llft":
						draw cmtpic shifted (-halfw - dist/sqrt(2),-dist/sqrt(2) - halfh);
					fi;

					exitif true;
				fi;
			endfor;
		fi;
	endfor;
enddef;

vardef subimg.bintree(suffix tree)(expr isfull, i, xunit, yunit, gsize) :=
image(
	save fr;
	path fr;
	fr := fullcircle scaled gsize;

	if isfull or (not (isleaf.bintree(tree)(i))):
		fill fr withcolor clrsCfA;
		draw fr withcolor clrsClA;
	fi;
	label(TEX("$" & tree[i]key & "$"), (0,0));

	if (tree[i]lft <> nullptr):
		save subpic;
		picture subpic;
		subpic := subimg.bintree(tree)(isfull, tree[i]lft, xunit, yunit, gsize);

		save subroot;
		pair subroot;
		subroot := (-max(xpart(urcorner subpic),gsize) - (xunit-gsize)/2, -yunit);

		drawarrow (fr intersectionpoint ((0,0) -- subroot))
			..((fr shifted subroot) intersectionpoint ((0,0) -- subroot)) withcolor black;
		draw subpic shifted subroot;
	fi;

	if (tree[i]rt <> nullptr):
		save subpic;
		picture subpic;
		subpic := subimg.bintree(tree)(isfull, tree[i]rt, xunit, yunit, gsize);

		save subroot;
		pair subroot;
		subroot := (-min(xpart(ulcorner subpic),-gsize) + (xunit-gsize)/2, -yunit);

		drawarrow (fr intersectionpoint ((0,0) -- subroot))
			..((fr shifted subroot) intersectionpoint ((0,0) -- subroot)) withcolor black;
		draw subpic shifted subroot;
	fi;
)
enddef;

vardef img.bintree(suffix tree) :=
image(
	if not tree.isfull:
		draw (0, tree.yunit)--(0, 0);
	fi;
	% check if root is nullptr
	draw subimg.bintree(tree)(tree.isfull, tree.root, tree.xunit, tree.yunit, tree.gsize);
)
enddef;
