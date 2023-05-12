input clrs_bst;

beginfig(1);
	string data[];
	data[1] := "2";
	data[2] := "1";
	data[3] := "3";

	draw img_bin_search_tree(data)(0.5cm, 0.8cm,0.8cm);
endfig;

beginfig(2);
	string data[];
	data[1] := "3";
	data[2] := "2";
	data[4] := "1";

	draw img_bin_search_tree(data)(0.5cm, 0.8cm,0.8cm);
endfig;

end;
