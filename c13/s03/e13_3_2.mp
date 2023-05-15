input clrs_rbtree;

beginfig(1);
	numeric data[];
	color ncolor[];
	ncolor[0] := white;
	data[1] := 38;	ncolor[1] := rbcBlack;
	data[2] := 19;	ncolor[2] := rbcRed;
	data[3] := 41;	ncolor[3] := rbcBlack;
	data[4] := 12;	ncolor[4] := rbcBlack;
	data[5] := 31;	ncolor[5] := rbcBlack;
	data[8] := 8;	ncolor[8] := rbcRed;

	draw img_bin_search_tree(data, ncolor)(false, 0.5cm, 0.8cm,0.8cm);
endfig;

end;
