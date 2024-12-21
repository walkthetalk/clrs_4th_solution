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
	tree.commentdist := 0.2cm;

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
	color tree[]keycolor;

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
	numeric tree.setobject.lpos;
	numeric tree.setobject.rpos;
	tree.setobject.lpos := -0.5;
	tree.setobject.rpos := 0.75;
	boolean tree.hasHead;
	boolean tree.hasTail;
	tree.hasHead := true;
	tree.hasTail := true;
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
	tree[idx]fillcolor := clrsCfA;
	tree[idx]framecolor := black;
	if comment = "":
		tree[idx]keycolor := clrsCfA;
	elseif comment = "emph":
		tree[idx]keycolor := clrsCfF;
	else:
		tree[idx]keycolor := clrsCfA;
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
	tree.setobject.fillcolor := clrsCfF;
	tree.setobject.framecolor := clrsClA;

	% add keys
	tree.setobject.key := k;
enddef;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% draw %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vardef drawnode.disjointSet(suffix tree)(expr idx, pos) :=
	% 畫外框
	save frame;
	path frame;
	frame := unitsquare shifted (-0.5, -0.5)
		xscaled tree.xunit
		yscaled (tree.yunit * 3)
		shifted pos;
	fill frame withcolor tree[idx]fillcolor;
	draw frame withcolor tree[idx]framecolor;

	save keyframe;
	path keyframe;
	keyframe := unitsquare shifted (-0.5, -0.5)
		xscaled tree.xunit
		yscaled tree.yunit
		shifted pos;
	fill keyframe withcolor tree[idx]keycolor;
	draw keyframe withcolor tree[idx]framecolor;

	label(TEX("$" & tree[idx]key & "$"), pos);
enddef;

vardef __drawSetobject.disjointSet(suffix tree)(expr pos) :=
	save htcnt;
	numeric htcnt;
	htcnt := 0;
	if tree.hasHead:
		htcnt := 1;
	fi;
	if tree.hasTail:
		htcnt := htcnt + 1;
	fi;

	% 畫外框
	save frame;
	path frame;
	frame := unitsquare shifted (-0.5, -0.5)
		xscaled (tree.xunit * 2.5)
		yscaled (tree.yunit * htcnt)
		shifted pos;
	fill frame withcolor tree.setobject.fillcolor;
	draw frame withcolor tree.setobject.framecolor;

	save posshift;
	pair posshift;
	if tree.hasHead:
		if tree.hasTail:
			posshift := (0, tree.yunit * 0.5);
		else:
			posshift := (0,0);
		fi;
		label(TEX("\it " & "head"), pos shifted (tree.xunit * tree.setobject.lpos, 0)) shifted posshift;
		draw unitsquare shifted (-0.5,-0.5)
			xscaled (tree.xunit/2)
			yscaled (tree.yunit/2)
			shifted pos shifted (tree.xunit * tree.setobject.rpos, 0) shifted posshift;
	fi;
	if tree.hasTail:
		if tree.hasHead:
			posshift := (0, tree.yunit * -0.5);
		else:
			posshift := (0, 0);
		fi;
		label(TEX("\it " & "tail"), pos shifted (tree.xunit * tree.setobject.lpos, 0)) shifted posshift;
		draw unitsquare shifted (-0.5,-0.5)
			xscaled (tree.xunit/2)
			yscaled (tree.yunit/2)
			shifted pos shifted (tree.xunit * tree.setobject.rpos, 0) shifted posshift;
	fi;

	label.ulft(TEX("$" & tree.setobject.key & "$"), pos shifted (-tree.xunit * 0.5, tree.yunit * (htcnt-0.5)));
enddef;

vardef connectH(expr ps, pe, dist) :=
	save pc;
	pair pc;
	pc := (xpart pe, ypart ps);

	save pa, pb;

	pair pa;
	if xpart ps < xpart pe:
		pa := ((xpart pc) - dist, ypart pc);
	else:
		pa := ((xpart pc) + dist, ypart pc);
	fi;
	pair pb;
	if (ypart ps) < (ypart pe):
		pb := (xpart pc, (ypart pc) + dist);
	else:
		pb := (xpart pc, (ypart pc) - dist);
	fi;

	pa .. controls pc .. pb

enddef;

vardef connectV(expr ps, pe, dist) :=
	save pc;
	pair pc;
	pc := (xpart ps, ypart pe);

	save pa, pb;

	pair pa;
	if ypart ps < ypart pe:
		pa := ((xpart pc), (ypart pc) - dist);
	else:
		pa := ((xpart pc), (ypart pc) + dist);
	fi;
	pair pb;
	if (xpart ps) < (xpart pe):
		pb := ((xpart pc) + dist, (ypart pc));
	else:
		pb := ((xpart pc) - dist, (ypart pc));
	fi;

	pa .. controls pc .. pb

enddef;

vardef imgTail.disjointSet(suffix tree) :=
image(
	% 畫集合對象
	pair setpos;
	setpos := (0,-tree.yunit * 2.5);
	__drawSetobject.disjointSet(tree)(setpos);
 
	% 畫鏈表
	numeric idx;
	idx := tree.head;
	pair pos;
	pos := setpos;

	numeric posinc;
	posinc := tree.xunit * 2;

	forever:
		exitif idx = nullptr;
		pos := (xpart pos + posinc, 0);
		drawnode.disjointSet(tree)(idx, pos);
		idx := tree[idx]next;
	endfor;

	% pos 是尾部節點的位置
	pair tailpos;
	tailpos := pos;
	pair sss;
	sss := (xpart setpos + tree.xunit * tree.setobject.rpos, ypart setpos);
	pair eee;
	eee := (xpart tailpos, ypart tailpos - tree.yunit * 1.5);
	drawarrow (sss
		 --connectH(sss, eee, tree.commentdist)
		-- eee)
		withcolor red;

	% 畫 鏈表對象連線
	idx := tree.head;
	pos := setpos;
	pair ccc;
	forever:
		exitif idx = nullptr;
		% 跳過 尾節點
		exitif tree[idx]next = nullptr;
		pos := (xpart pos + posinc, 0);
		sss := (xpart pos, (ypart pos) + tree.yunit * 1);
		eee := (xpart tailpos, (ypart tailpos) + tree.yunit * 1.5);
		ccc := ((xpart sss + xpart eee)/2, tree.yunit * 2);
		drawarrow (sss
			-- connectV(sss, ccc, tree.commentdist)
			-- connectH(ccc, eee, tree.commentdist)
			-- eee);

		sss := (xpart pos, (ypart pos) - tree.yunit * 1);
		eee := (xpart pos + posinc - tree.xunit * 0.5, (ypart pos) - tree.yunit * 1);
		drawarrow (sss -- eee) withcolor .5white;

		idx := tree[idx]next;
	endfor;

	% 單獨處理尾部節點
	sss := (xpart tailpos, (ypart tailpos) + tree.yunit * 1);
	eee := (xpart setpos, (ypart setpos) + tree.yunit * 0.5);
	pair ca, cb;
	ca := ((xpart sss + xpart eee)/2, (ypart tailpos) + tree.yunit * 2.5);
	cb := ((xpart tailpos) + tree.xunit * 1, (ypart sss + ypart ca) / 2);
	drawarrow (sss
		-- connectH(sss, cb, tree.commentdist)
		-- connectV(cb, ca, tree.commentdist)
		-- connectH(ca, eee, tree.commentdist)
		-- eee);
	sss := (xpart tailpos, (ypart tailpos) - tree.yunit * 1);
	eee := (xpart setpos + posinc, (ypart tailpos) - tree.yunit * 1.5);
	ca  := ((xpart sss + xpart eee)/2, (ypart tailpos) - tree.yunit * 3);
	cb  := ((xpart tailpos) + tree.xunit * 1, (ypart sss + ypart ca) / 2);
	drawarrow (sss
		-- connectH(sss, cb, tree.commentdist)
		-- connectV(cb, ca, tree.commentdist)
		-- connectH(ca, eee, tree.commentdist)
		-- eee) withcolor .5white;

)
enddef;

vardef imgHead.disjointSet(suffix tree) :=
image(
	%prepare.disjointSet(tree);

	% 畫集合對象
	pair setpos;
	setpos := (0,tree.yunit * -1);
	__drawSetobject.disjointSet(tree)(setpos);
 
	% 畫鏈表
	numeric idx;
	idx := tree.head;
	pair pos;
	pos := setpos;

	numeric posinc;
	posinc := tree.xunit * 2;

	pair nextstart;
	nextstart := (xpart setpos + tree.xunit * tree.setobject.rpos, ypart setpos);
	pair nextend;
	pair sss;
	pair eee;
	pair ccc;
	pos := pos + (tree.xunit * 1, 0);
	forever:
		exitif idx = nullptr;
		pos := (xpart pos + posinc, 0);
		drawnode.disjointSet(tree)(idx, pos);

		sss := (xpart pos, (ypart pos) + tree.yunit * 1);
		eee := (xpart setpos, (ypart setpos) + tree.yunit * 0.5);
		ccc := ((xpart sss + xpart eee)/2, tree.yunit * 2);
		drawarrow (sss
			-- connectV(sss, ccc, tree.commentdist)
			-- connectH(ccc, eee, tree.commentdist)
			-- eee);

		nextend := (xpart pos - tree.xunit * 0.5, ypart pos - tree.yunit * 1);
		drawarrow (nextstart -- nextend);
		nextstart := (xpart pos, ypart nextend);

		idx := tree[idx]next;
	endfor;

	label(TEX("$/$"), pos + (0, tree.yunit * -1.0));
)
enddef;

vardef imgHeadAndTail.disjointSet(suffix tree) :=
image(
	%prepare.disjointSet(tree);

	% 畫集合對象
	pair setpos;
	setpos := (0,tree.yunit * -1.5);
	__drawSetobject.disjointSet(tree)(setpos);
 
	% 畫鏈表
	numeric idx;
	idx := tree.head;
	pair pos;
	pos := setpos;

	numeric posinc;
	posinc := tree.xunit * 2;

	pair nextstart;
	nextstart := (xpart setpos + tree.xunit * tree.setobject.rpos, tree.yunit * -1);
	pair nextend;
	pair sss;
	pair eee;
	pair ccc;
	pos := (xpart setpos + tree.xunit * 1, 0);
	forever:
		exitif idx = nullptr;
		pos := (xpart pos + posinc, 0);
		drawnode.disjointSet(tree)(idx, pos);

		sss := (xpart pos, (ypart pos) + tree.yunit * 1);
		eee := (xpart setpos, (ypart setpos) + tree.yunit * 1);
		ccc := ((xpart sss + xpart eee)/2, tree.yunit * 2);
		drawarrow (sss
			-- connectV(sss, ccc, tree.commentdist)
			-- connectH(ccc, eee, tree.commentdist)
			-- eee);

		nextend := (xpart pos - tree.xunit * 0.5, ypart pos - tree.yunit * 1);
		drawarrow (nextstart -- nextend);
		nextstart := (xpart pos, ypart nextend);

		idx := tree[idx]next;
	endfor;

	label(TEX("$/$"), pos + (0, tree.yunit * -1.0));

	% 紅線
	pair tailpos;
	tailpos := pos;
	pair sss;
	sss := (xpart setpos + tree.xunit * tree.setobject.rpos, ypart setpos - tree.yunit * 0.5);
	pair eee;
	eee := (xpart tailpos, ypart tailpos - tree.yunit * 1.5);
	drawarrow (sss
		 --connectH(sss, eee, tree.commentdist)
		-- eee)
		withcolor red;
)
enddef;

vardef img.disjointSet(suffix tree) :=
	if tree.hasHead:
		if tree.hasTail:
			imgHeadAndTail.disjointSet(tree)
		else:
			imgHead.disjointSet(tree)
		fi
	else:
		if tree.hasTail:
			imgTail.disjointSet(tree)
		else:
			image()
		fi
	fi
enddef;
