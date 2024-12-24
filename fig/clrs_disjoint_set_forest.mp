input TEX;

input memory;
input clrs;
input clrs_base_tree;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vardef declare.disjointSetForest(suffix tree) :=
	declare_tree(tree);

	% draw
	numeric tree.rootinterval;
	tree.rootinterval := 5;

	numeric tree.cxinterval;
	tree.cxinterval := .3cm;
	% 中心點 y 方向的距離，不是節點間的間隔
	numeric tree.cyinterval;
	tree.cyinterval := 1cm;
	% 顏色
	color tree[]fillcolor;
	color tree[]framecolor;

	% prepare
	numeric tree.xyunit;
	tree.xyunit := .6cm;
	path tree.baseframe;
	tree.baseframe = fullcircle scaled tree.xyunit;

	pair tree[]nodesize;
	pair tree[]position;
	numeric tree[]widthOfSubTree;

	% properties
	numeric tree.t;
	numeric tree.height;

	string tree[]key;
	numeric tree[]children[];
	numeric tree[]nchildren;

	numeric tree[]rank;
enddef;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% for base tree %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vardef newnode.disjointSetForest(suffix tree)(expr ks, comment) :=
	save idx;
	numeric idx;
	idx := alloc_slot(tree);

	% init
	tree[idx]nchildren := 0;
	tree[idx]rank := 0;

	% 顏色
	if comment = "":
		tree[idx]fillcolor := clrsCfA;
		tree[idx]framecolor := clrsClA;
	elseif comment = "focus":
		tree[idx]fillcolor := clrsCfB;
		tree[idx]framecolor := clrsClB;
	else:
		tree[idx]fillcolor := clrsCfA;
		tree[idx]framecolor := clrsClA;
	fi;

	% add keys
	tree[idx]key := ks;

	idx
enddef;

vardef associate.disjointSetForest(suffix tree)(expr parent, child, idx) :=
	tree[parent]children[idx - 1] := child;
	tree[parent]nchildren := tree[parent]nchildren + 1;
enddef;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% draw %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vardef calcSizes.disjointSetForest(suffix tree)(expr idx) :=
	save j;
	numeric j;

	tree[idx]nodesize := (urcorner tree.baseframe) - (llcorner tree.baseframe);

	% 計算孩子節點
	for j := 0 upto (tree[idx]nchildren - 1):
		calcSizes.disjointSetForest(tree)(tree[idx]children[j]);
	endfor;
enddef;

vardef calcSubTree.disjointSetForest(suffix tree)(expr idx) :=
	save childrenWidth;
	numeric childrenWidth;
	childrenWidth := -tree.cxinterval;

	save j;
	numeric j;
	save cidx;
	numeric cidx;
	for j := 0 upto (tree[idx]nchildren - 1):
		cidx := tree[idx]children[j];
		calcSubTree.disjointSetForest(tree)(cidx);
		childrenWidth := childrenWidth
			+ tree.cxinterval
			+ tree[cidx]widthOfSubTree;
	endfor;

	save tmp;
	numeric tmp;
	tmp := xpart tree[idx]nodesize;
	if childrenWidth > tmp:
		tmp := childrenWidth;
	fi;

	tree[idx]widthOfSubTree := tmp;
enddef;

vardef layoutAt.disjointSetForest(suffix tree)(expr idx, pos, srank) :=
	tree[idx]position := pos;
	tree[idx]rank := srank;

	save j;
	numeric j;
	save width;
	numeric width;
	save cidx;
	numeric cidx;
	save x;
	numeric x;
	save y;
	numeric y;

	save maxrank;
	numeric maxrank;
	maxrank := srank;
	save tmprank;
	numeric tmprank;

	% 確定孩子的位置
	x := (xpart pos) - tree[idx]widthOfSubTree/2;
	y := (ypart pos) - tree.cyinterval;
	for j := 0 upto (tree[idx]nchildren - 1):
		cidx := tree[idx]children[j];
		x := x + tree[cidx]widthOfSubTree / 2;
		tmprank := layoutAt.disjointSetForest(tree)(cidx, (x, y), srank + 1);
		if tmprank > maxrank:
			maxrank := tmprank;
		fi;

		x := x + tree[cidx]widthOfSubTree / 2 + tree.cxinterval;
	endfor;

	maxrank
enddef;

vardef prepare.disjointSetForest(suffix tree)(expr idx) :=
	calcSizes.disjointSetForest(tree)(idx);
	calcSubTree.disjointSetForest(tree)(idx);
	save maxrank;
	numeric maxrank;
	maxrank := layoutAt.disjointSetForest(tree)(idx, (0,0), 0);
	maxrank
enddef;

vardef __linkpath.disjointSetForest(suffix tree)(expr sidx, eidx) :=
	save spath;
	save epath;
	path spath;
	path epath;
	spath := tree.baseframe shifted tree[sidx]position;
	epath := tree.baseframe shifted tree[eidx]position;
	save lpath;
	path lpath;
	lpath := tree[sidx]position -- tree[eidx]position;
	(lpath cutbefore spath cutafter epath)
enddef;

vardef __frameof(suffix tree)(expr idx) :=
	(tree.baseframe
		shifted tree[idx]position)
enddef;

vardef subdraw.disjointSetForest(suffix tree)(expr idx) :=
	% 畫外框
	save frame;
	path frame;
	frame := __frameof(tree)(idx);
	fill frame withcolor tree[idx]fillcolor;
	draw frame withcolor tree[idx]framecolor;

	% 畫關鍵字
	label(TEX("$" & tree[idx]key & "$"), tree[idx]position);

	% 畫孩子節點
	save j;
	numeric j;
	for j := 0 upto (tree[idx]nchildren - 1):
		subdraw.disjointSetForest(tree)(tree[idx]children[j]);
	endfor;

	% 畫鏈接
	pair sss;
	pair eee;
	for j := 0 upto (tree[idx]nchildren - 1):
		save m;
		numeric m;
		m := tree[idx]children[j];
		drawarrow __linkpath.disjointSetForest(tree)(m, idx);
	endfor;
enddef;

vardef img.disjointSetForest(suffix tree) :=
image(
	picture rpics[];
	save ridx;
	numeric ridx;

	for ridx := 0 upto (tree.nroot - 1):
		rpics[ridx] := image(
			save frame;
			path frame;
			save lframe;
			path lframe;
			save maxrank;
			numeric maxrank;

			maxrank := prepare.disjointSetForest(tree)(tree.root[ridx]);
			frame := __frameof(tree)(tree.root[ridx]);
			lframe := frame rotated -90 shifted (0, tree.xyunit * 0.75);
			subdraw.disjointSetForest(tree)(tree.root[ridx]);
			drawarrow (lframe cutbefore frame cutafter frame);
			label.top(TEX("$rank=" & decimal(maxrank) & "$"), (0,0)) scaled 0.8 shifted (0, tree.xyunit * 1.25);
		);
	endfor;

	save pos;
	pair pos;
	pos := (0,0);
	for ridx := 0 upto (tree.nroot - 1):
		pos := pos - (xpart ulcorner rpics[ridx], 0);
		draw rpics[ridx] shifted pos;
		pos := pos + (xpart urcorner rpics[ridx], 0);
		pos := pos + (tree.rootinterval, 0);
	endfor;
)
enddef;
