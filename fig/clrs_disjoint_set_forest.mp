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

	numeric tree.xinterval;
	tree.xinterval := 1;
	numeric tree.cxinterval;
	tree.cxinterval := 5;
	% 中心點 y 方向的距離，不是節點間的間隔
	numeric tree.cyinterval;
	tree.cyinterval := 30;
	% 顏色
	color tree[]fillcolor;
	color tree[]framecolor;

	% prepare
	numeric tree.xyunit;
	tree.xyunit := .5cm;
	path tree.baseframe;
	tree.baseframe = fullcircle scaled tree.xyunit;

	pair tree[]keysize[];
	pair tree[]nodesize;
	pair tree[]keyposition[];
	pair tree[]position;
	numeric tree[]widthOfSubTree;

	% properties
	numeric tree.t;
	numeric tree.height;

	string tree[]keys[];
	numeric tree[]nkeys;
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
	tree[idx]nkeys := 0;
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
	save j;
	numeric j;
	save k;
	numeric k;
	k := 0;
	save mkeys;
	string mkeys;
	mkeys := ks & " "; % 尾部添加一個空格
	for j := 0 upto ((length mkeys) - 1):
		if (substring(j,j+1) of mkeys) = " ":
			tree[idx]keys[tree[idx]nkeys] := substring(k, j) of mkeys;
			tree[idx]nkeys := tree[idx]nkeys + 1;
			k := j+1;
		fi;
	endfor;

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

	for j := 0 upto (tree[idx]nkeys - 1):
		tree[idx]keysize[j] := urcorner thelabel.urt(tree[idx]keys[j], (0,0));
	endfor;
	save w,h;
	numeric w;
	numeric h;
	w := 0;
	h := 0;
	for j := 0 upto (tree[idx]nkeys - 1):
		h := max(ypart tree[idx]keysize[j], h);
		w := w + xpart tree[idx]keysize[j];
	endfor;
	tree[idx]nodesize := (w + tree.xinterval * (tree[idx]nkeys+1),
		h + tree.xinterval*2);

	% 計算孩子節點
	for j := 0 upto (tree[idx]nkeys):
		if known tree[idx]children[j]:
			calcSizes.disjointSetForest(tree)(tree[idx]children[j]);
		fi;
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
	for j := 0 upto tree[idx]nkeys:
		if known tree[idx]children[j]:
			cidx := tree[idx]children[j];
			calcSubTree.disjointSetForest(tree)(cidx);
			childrenWidth := childrenWidth
				+ tree.cxinterval
				+ tree[cidx]widthOfSubTree;
		fi;
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

	% 確定關鍵字的位置
	x := (xpart pos) - (xpart tree[idx]nodesize)/2 + tree.xinterval;	% 有邊界
	for j := 0 upto (tree[idx]nkeys - 1):
		width := xpart(tree[idx]keysize[j]);
		x := x + width / 2;
		tree[idx]keyposition[j] := (x, ypart pos);
		x := x + width / 2 + tree.xinterval;
	endfor;

	% 確定孩子的位置
	x := (xpart pos) - tree[idx]widthOfSubTree/2;
	y := (ypart pos) - tree.cyinterval;
	for j := 0 upto tree[idx]nkeys:
		if known tree[idx]children[j]:
			cidx := tree[idx]children[j];
			x := x + tree[cidx]widthOfSubTree / 2;
			tmprank := layoutAt.disjointSetForest(tree)(cidx, (x, y), srank + 1);
			if tmprank > maxrank:
				maxrank := tmprank;
			fi;

			x := x + tree[cidx]widthOfSubTree / 2 + tree.cxinterval;
		fi;
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
	save j;
	numeric j;
	for j := 0 upto (tree[idx]nkeys - 1):
		label(TEX("$" & tree[idx]keys[j] & "$"), tree[idx]keyposition[j]);
	endfor;

	% 畫孩子節點
	for j := 0 upto tree[idx]nkeys:
		if known tree[idx]children[j]:
			subdraw.disjointSetForest(tree)(tree[idx]children[j]);
		fi;
	endfor;

	% 畫鏈接
	save x;
	numeric x;
	pair sss;
	pair eee;
	for j := 0 upto tree[idx]nkeys:
		if known tree[idx]children[j]:
			x := (xpart tree[idx]keyposition[j])
				- (xpart tree[idx]keysize[j]) / 2
				- tree.xinterval / 2;
			save m;
			numeric m;
			m := tree[idx]children[j];
			drawarrow __linkpath.disjointSetForest(tree)(m, idx);
		fi;
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
