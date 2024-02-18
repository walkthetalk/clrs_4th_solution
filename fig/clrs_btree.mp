input TEX;

input memory;
input clrs;
input clrs_base_tree;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vardef declare.btree(suffix tree) :=
	declare_tree(tree);

	% draw
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
	numeric tree[]widthOfSubTree;

	% properties
	numeric tree.t;
	numeric tree.height;

	string tree[]keys[];
	numeric tree[]nkeys;
	numeric tree[]children[];
	numeric tree[]nchildren;
enddef;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% for base tree %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vardef newnode.btree(suffix tree)(expr ks, comment) :=
	save idx;
	numeric idx;
	idx := alloc_slot(tree);

	% init
	tree[idx]nkeys := 0;
	tree[idx]nchildren := 0;

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

vardef associate.btree(suffix tree)(expr parent, child, idx) :=
	tree[parent]children[idx - 1] := child;
	tree[parent]nchildren := tree[parent]nchildren + 1;
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

vardef subdraw.btree(suffix tree)(expr idx) :=
	% 畫外框
	save frame;
	path frame;
	frame := unitsquare shifted (-0.5, -0.5)
		xscaled (xpart tree[idx]nodesize)
		yscaled (ypart tree[idx]nodesize)
		shifted tree[idx]position;
	fill frame withcolor tree[idx]fillcolor;
	draw frame withcolor tree[idx]framecolor;

	% 畫關鍵字
	save j;
	numeric j;
	for j := 0 upto (tree[idx]nkeys - 1):
		label(tree[idx]keys[j], tree[idx]keyposition[j]);
	endfor;

	% 畫孩子節點
	for j := 0 upto tree[idx]nkeys:
		if known tree[idx]children[j]:
			subdraw.btree(tree)(tree[idx]children[j]);
		fi;
	endfor;

	% 畫鏈接
	save botSelf;
	numeric botSelf;
	botSelf := bottomOf.btree(tree)(idx);
	save x;
	numeric x;
	for j := 0 upto (tree[idx]nkeys - 1):
		if known tree[idx]children[j]:
			x := (xpart tree[idx]keyposition[j])
				- (xpart tree[idx]keysize[j]) / 2
				- tree.xinterval / 2;
			save m;
			numeric m;
			m := tree[idx]children[j];
			draw (x, botSelf) -- topOf.btree(tree)(m);
		fi;
	endfor;
	j := tree[idx]nkeys;
	if known tree[idx]children[j]:
		x := (xpart tree[idx]keyposition[j-1])
			+ (xpart tree[idx]keysize[j-1]) / 2
			+ tree.xinterval / 2;
		draw (x, botSelf) -- topOf.btree(tree)(tree[idx]children[j]);
	fi;
enddef;

vardef img.btree(suffix tree) :=
image(
	prepare.btree(tree);

	subdraw.btree(tree)(tree.root);
)
enddef;
