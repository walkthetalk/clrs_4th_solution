input clrs_rbtree;

beginfig(1);
	rbtree_declare(RRR);
	rbtree_build(RRR)(26,B)((17,R)()())();
	numeric data[];
	color ncolor[];
	ncolor[0] := white;	% color of label

	data[ 1] := 26; ncolor[ 1] := rbcBlack;
	data[ 2] := 17; ncolor[ 2] := rbcRed;
	data[ 3] := 41; ncolor[ 3] := rbcBlack;
	data[ 4] := 14; ncolor[ 4] := rbcBlack;
	data[ 5] := 21; ncolor[ 5] := rbcBlack;
	data[ 6] := 30; ncolor[ 6] := rbcRed;
	data[ 7] := 47; ncolor[ 7] := rbcBlack;
	data[ 8] := 10; ncolor[ 8] := rbcRed;
	data[ 9] := 16; ncolor[ 9] := rbcBlack;
	data[10] := 19; ncolor[10] := rbcBlack;
	data[11] := 23; ncolor[11] := rbcBlack;
	data[12] := 28; ncolor[12] := rbcBlack;
	data[13] := 38; ncolor[13] := rbcBlack;
	data[16] :=  7; ncolor[16] := rbcBlack;
	data[17] := 12; ncolor[17] := rbcBlack;
	data[18] := 15; ncolor[18] := rbcRed;
	data[21] := 20; ncolor[21] := rbcRed;
	data[26] := 35; ncolor[26] := rbcRed;
	data[27] := 39; ncolor[27] := rbcRed;
	data[32] :=  3; ncolor[32] := rbcRed;

	draw img_bin_search_tree(data, ncolor)(true, 0.5cm, 0.8cm,0.8cm);
endfig;

end;
