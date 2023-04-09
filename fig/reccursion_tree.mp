input TEX;

vardef rtlabel@#(expr strname, pos) text p =
	label@#(TEX(strname), pos) p
enddef;

vardef rlc(suffix A, C, D, lx, rx)(expr k, x_coord, lvl, y_offset) :=
	save nextlvl_dist,next_x_coord;
	save line_start,line_endy;

	if x_coord < lx:
		lx := x_coord;
	fi;
	if x_coord > rx:
		rx := x_coord;
	fi;

	% lvl 0 僅佔位，沒有標籤
	if lvl > 0:

	rtlabel(A[lvl], (x_coord, D[lvl])) withcolor black;

	numeric nextlvl_dist;
	numeric next_x_coord;
	pair line_start;
	numeric line_endy;

	nextlvl_dist := (xpart C[lvl-1]);
	next_x_coord := x_coord - nextlvl_dist * (k - 1) / 2;
	line_start := (x_coord, D[lvl] - (ypart C[lvl])/2 - y_offset);
	line_endy := D[lvl-1] + (ypart C[lvl-1])/2 + y_offset;
	for i := 0 upto (k - 1):
		save line_end;
		pair line_end;
		line_end := (next_x_coord, line_endy);
		if lvl > 1:
			draw line_start -- line_end;
		else:
			draw line_start -- (line_start/2 + line_end/2);
			draw (line_start/2 + line_end/2) -- line_end dashed evenly scaled 0.5;
		fi;
		rlc(A,C,D, lx, rx)(k, next_x_coord, lvl-1, y_offset);
		next_x_coord := next_x_coord + nextlvl_dist;
	endfor;
	fi;
enddef;

vardef rlc_vertical(suffix A, C, D)(expr k, y_coord, lvl, x_offset) :=
	save nextlvl_dist,next_y_coord;
	rtlabel(A[lvl], (D[lvl], y_coord)) withcolor black;

	if lvl > 1:
		nextlvl_dist := (ypart C[lvl-1]);

		next_y_coord := y_coord - nextlvl_dist * (k - 1) / 2;
		for i := 0 upto (k - 1):
			draw (D[lvl] + (xpart C[lvl])/2 + x_offset, y_coord)
				--(D[lvl-1] - (xpart C[lvl-1])/2 - x_offset, next_y_coord);
			rlc_vertical(A,C,D)(k, next_y_coord, lvl-1, x_offset);
			next_y_coord := next_y_coord + nextlvl_dist;
		endfor;
	else:
		next_y_coord := y_coord;

		draw (D[lvl] + (xpart C[lvl])/2 + x_offset, y_coord)
			--(D[lvl-1] - (xpart C[lvl-1])/2 - x_offset, next_y_coord) dashed evenly scaled 0.5;
		rtlabel(A[0], (D[0], next_y_coord)) withcolor black;
	fi;
enddef;

% A   : 標籤內容
% C[i]: 第 i 層每個元素所佔空間大小
% D[i]: 第 i 層 y 座標
% k   : k 叉樹
% lvl : 0~lvl 層
% cell_h: 層間連線的高度
% xgap: 空隙寬度
% yoffset: y 方向標籤與連線的距離
vardef rlc_sizes(suffix A, C, D)(expr k, lvl, cell_h, xgap, yoffset) :=
	for i := 1 upto lvl:
		C[i] := (urcorner thelabel.urt(TEX(A[i]), (0,0))) + (xgap,0);
	endfor;
	% C[0] 特殊處理
	C[0] := (xgap,0);

	save tmp;
	for i := 1 upto lvl:
		tmp := (xpart C[i-1]) * k;
		if tmp > (xpart C[i]):
			C[i] := (tmp, ypart C[i]);
		fi;
	endfor;
	save ycoord;
	numeric ycoord;
	ycoord := 0;
	for i := lvl downto 1:
		D[i] := ycoord;
		ycoord := ycoord - cell_h - yoffset * 2 - (ypart C[i])/2 - (ypart C[i-1])/2;
	endfor;
	D[0] := ycoord;
enddef;

vardef rlc_sizes_vertical(suffix A, C, D)(expr k, lvl, cell_w, ygap, xoffset) :=
	for i := 0 upto lvl:
		C[i] := (urcorner thelabel.urt(TEX(A[i]), (0,0))) + (0, ygap);
	endfor;
	save tmp;
	for i := 1 upto lvl:
		if i > 1:
			tmp := (ypart C[i-1]) * k;
		else:
			tmp := ypart C[i-1];
		fi;
		if tmp > (ypart C[i]):
			C[i] := (xpart C[i], tmp);
		fi;
	endfor;
	save xcoord;
	numeric xcoord;
	xcoord := 0;
	for i := lvl downto 1:
		D[i] := xcoord;
		xcoord := xcoord + cell_w + xoffset * 2 + (xpart C[i])/2 + (xpart C[i-1])/2;
	endfor;
	D[0] := xcoord;
enddef;

vardef rectree(suffix A, B)(expr k, lvl) :=
	save xgap, yoffset, line_height;
	xgap := width_of_label("m") / 2;
	yoffset := (ypart size_of_label("m")) / 2;
	line_height := (ypart size_of_label("m")) * 5;
	save C, D, Lx, Rx;
	pair C[];
	numeric D[];
	rlc_sizes(A, C, D)(k,lvl, line_height, xgap, yoffset);
	numeric Lx, Rx;
	Lx := 0;
	Rx := 0;
	rlc(A, C, D, Lx, Rx)(k, 0, lvl, yoffset);

	save s, lxdist, lcnt, ly;
	pair s;
	s := size_of_label(A[0]);
	s := s + (xgap, 0);
	numeric lcnt;
	lcnt := floor((Rx - Lx) / xpart s);
	numeric lxdist;
	if lcnt > 0:
		lxdist := (Rx-Lx) / lcnt;
	else:
		lxdist := 0;
	fi;
	numeric ly;
	ly := D[0] - line_height - 2 * yoffset - (ypart s)/2;
	pair lpBegin, lpEnd;
	for i := 0 upto lcnt:
		lpBegin := (Lx + i * lxdist, D[0] - yoffset);
		lpEnd := lpBegin - (0, line_height);
		draw lpBegin -- lpEnd dashed evenly scaled 0.5;
		rtlabel(A[0], (xpart lpBegin, ly));
	endfor

	bound_pos_x := max((xpart C[lvl])/2, Rx + (xpart s)/2) + xgap/2;
	bound_pos_x_r := bound_pos_x + (width_of_labels(B)(lvl));
	for i := lvl downto 1:
		rtlabel.lft(B[i], (bound_pos_x_r, D[i]));
	endfor;

	rtlabel.lft(B[0], (bound_pos_x_r, ly));
	show ",,,,,,,,,,,,,,,,,,,,,";
	show (xpart C[lvl])/2;
enddef;

vardef width_of_label(expr lbl) :=
	xpart size_of_label(lbl)
enddef;

vardef size_of_label(expr lbl) :=
	(urcorner thelabel.urt(TEX(lbl), (0,0)))
enddef;

vardef width_of_labels(suffix A)(expr n) :=
	save ret, tmp;
	ret := 0;
	for i := 0 upto n:
		tmp := width_of_label(A[i]);
		if ret < tmp:
			ret := tmp;
		fi;
	endfor;
	ret
enddef;

vardef rectree_vertical(suffix A, B)(expr k, lvl) :=
	save ygap, xoffset, line_height;
	ygap := (xpart size_of_label("m")) / 2;
	xoffset := (ypart size_of_label("m")) / 2;
	line_width := (ypart size_of_label("m")) * 10;
	save C, D;
	pair C[];
	numeric D[];
	rlc_sizes_vertical(A, C, D)(k,lvl, line_width, ygap, xoffset);
	rlc_vertical(A, C, D)(k, 0, lvl, xoffset);

	bound_pos_y := -(ypart C[lvl])/2 - ygap/2;
	for i := lvl downto 0:
		rtlabel.bot(B[i], (D[i], bound_pos_y));
	endfor;
enddef;



vardef rlc_single_side_binary(suffix A, S)(expr k, x_coord, y_coord, lvl, cell_h, cell_w, y_offset) :=
	save nextlvl_dist,next_y_coord,next_x_coord, next_lvl;
	rtlabel(A[lvl], (x_coord, y_coord)) withcolor black;
	if lvl >= 1:
		next_lvl := lvl - 1;
		nextlvl_dist := cell_w;

		next_y_coord := y_coord - cell_h;
		next_x_coord := x_coord - nextlvl_dist * (k - 1) / 2;
		for i := 0 upto (k - 1):
			if lvl > 1:
				draw (x_coord, y_coord - y_offset)--(next_x_coord, next_y_coord + y_offset);
			else:
				draw (x_coord, y_coord - y_offset)--(next_x_coord, next_y_coord + y_offset) dashed evenly scaled 0.5;
			fi;
			if i < (k - 1):
				rlc_single_side_binary(A,S)(k, next_x_coord, next_y_coord, next_lvl, cell_h, cell_w, y_offset);
			else:
				rtlabel(S, (next_x_coord, next_y_coord)) withcolor black;
			fi;
			next_x_coord := next_x_coord + nextlvl_dist;
		endfor;
	fi;
enddef;


vardef rectree_single_side_binary(suffix A, B, S)(expr k, lvl, cell_w, cell_h, y_offset) :=
	rlc_single_side_binary(A,S)(k, 0, 0, lvl, cell_h, cell_w, y_offset);

	string lbl;
	bound_pos_x := lvl * cell_w / 2 + cell_w;
	bound_pos_y := 0;
	for i := lvl downto 0:
		rtlabel(B[i], (bound_pos_x, bound_pos_y));
		bound_pos_y := bound_pos_y - cell_h;
	endfor;
enddef;


