input TEX;

input memory;
input clrs;
input clrs_base_list;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vardef declare.disjointSet(suffix tree) :=
	declare_list(tree);

	% draw
	numeric tree.gsize;
	numeric tree.xunit;
	numeric tree.yunit;
	numeric tree.commentdist;
	tree.gsize := 0.5cm;
	tree.xunit := 0.5cm;
	tree.yunit := 0.5cm;
	tree.commentdist := 0.05cm;

	numeric tree.xinterval;
	tree.xinterval := 1;
	numeric tree.cxinterval;
	tree.cxinterval := 10;
	% 中心點 y 方向的距離，不是節點間的間隔
	numeric tree.cyinterval;
	tree.cyinterval := 30;
	% 顏色
	color tree[]fillcolor;
	color tree[]framecolor;

	% prepare
	pair tree[]keysize[];
	pair tree[]nodesize;
	pair tree[]keyposition[];
	pair tree[]position;

	% properties
	string tree[]key;
	numeric tree[]next;
	numeric tree[]prev;

	% setobject
	string tree.setobject.key;
	color tree.setobject.fillcolor;
	color tree.setobject.framecolor;
enddef;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% for base tree %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vardef newnode.disjointSet(suffix tree)(expr k, comment) :=
	save idx;
	numeric idx;
	idx := alloc_slot(tree);

	% init
	tree[idx]key := "";
	tree[idx]prev := nullptr;
	tree[idx]next := nullptr;

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
	tree[idx]key := k;

	idx
enddef;

vardef associate.disjointSet(suffix tree)(expr prev_idx, self_idx) :=
	tree[prev_idx]next := self_idx;
	tree[self_idx]prev := prev_idx;
enddef;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% for set object %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vardef setroot.disjointSet(suffix tree)(expr k, comment) :=
	% 顏色
	if comment = "":
		tree.setobject.fillcolor := clrsCfA;
		tree.setobject.framecolor := clrsClA;
	elseif comment = "focus":
		tree.setobject.fillcolor := clrsCfB;
		tree.setobject.framecolor := clrsClB;
	else:
		tree.setobject.fillcolor := clrsCfA;
		tree.setobject.framecolor := clrsClA;
	fi;

	% add keys
	tree.setobject.key := k;
enddef;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% draw %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vardef calcSizes.btree(suffix tree)(expr idx) :=
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
			calcSizes.btree(tree)(tree[idx]children[j]);
		fi;
	endfor;
enddef;

vardef calcSubTree.btree(suffix tree)(expr idx) :=
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
			calcSubTree.btree(tree)(cidx);
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

vardef layoutAt.btree(suffix tree)(expr idx, pos) :=
	tree[idx]position := pos;

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
			layoutAt.btree(tree)(cidx, (x, y));

			x := x + tree[cidx]widthOfSubTree / 2 + tree.cxinterval;
		fi;
	endfor;
enddef;

vardef prepare.btree(suffix tree) :=
	calcSizes.btree(tree)(tree.root);
	calcSubTree.btree(tree)(tree.root);
	layoutAt.btree(tree)(tree.root, (0,0));
enddef;

vardef bottomOf.btree(suffix tree)(expr idx) :=
	((ypart tree[idx]position) - (ypart tree[idx]nodesize) / 2)
enddef;
vardef topOf.btree(suffix tree)(expr idx) :=
	save tmp;
	numeric tmp;
	tmp := ypart(tree[idx]nodesize);

	save pos;
	pair pos;
	pos := tree[idx]position;

	((xpart pos), (ypart pos) + tmp / 2)
enddef;

vardef drawnode.disjointSet(suffix tree)(expr idx, pos) :=
	% 畫外框
	save frame;
	path frame;
	frame := unitsquare shifted (-0.5, -0.5)
		xscaled tree.xunit
		yscaled (tree.yunit * 3)
		shifted pos;
	save inline;
	path inline;
	inline := (-0.5, 0)--(0.5, 0)
		xscaled tree.xunit
		yscaled (tree.yunit * 3);
	fill frame withcolor tree[idx]fillcolor;
	draw frame withcolor tree[idx]framecolor;
	draw inline shifted (0, 1.5 * tree.yunit)  withcolor tree[idx]framecolor;
	draw inline shifted (0, -1.5 * tree.yunit)  withcolor tree[idx]framecolor;

	label(tree[idx]key, pos);
enddef;

vardef __drawSetobject.disjointSet(suffix tree)(expr pos) :=
	% 畫外框
	save frame;
	path frame;
	frame := unitsquare shifted (-0.5, -0.5)
		xscaled tree.xunit
		yscaled (tree.yunit * 3)
		shifted pos;
	save inline;
	path inline;
	inline := (-0.5, 0)--(0.5, 0)
		xscaled tree.xunit
		yscaled (tree.yunit * 3);
	fill frame withcolor tree.setobject.fillcolor;
	draw frame withcolor tree.setobject.framecolor;
	draw inline shifted (0, 1.5 * tree.yunit)  withcolor tree.setobject.framecolor;
	draw inline shifted (0, -1.5 * tree.yunit)  withcolor tree.setobject.framecolor;

	label(tree.setobject.key, pos);
enddef;

vardef img.disjointSet(suffix tree) :=
image(
	%prepare.disjointSet(tree);

	% 畫集合對象
	pair setpos;
	setpos := (0,0);
	__drawSetobject.disjointSet(tree)(setpos);

	% 畫鏈表
	numeric idx;
	idx := tree.head;
	pair pos;
	pos := setpos;

	forever:
		exitif idx = nullptr;
		message("pos: " & decimal(xpart pos) & ", " & decimal(ypart pos));
		pos := (xpart pos + tree.xunit * 2, 0);
		drawnode.disjointSet(tree)(idx, pos);
		idx := tree[idx]next;
	endfor;
)
enddef;
