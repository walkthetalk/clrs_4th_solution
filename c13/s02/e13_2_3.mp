input clrs_bst;

beginfig(1);
	numeric gsize;
	numeric xunit;
	numeric yunit;
	boolean fill_leaf;
	gsize := 0.5cm;
	xunit := 0.8cm;
	yunit := 0.8cm;
	fill_leaf := false;

	string A[];
	A[1] := "$y$";
	A[2] := "$x$";
	A[3] := "$\gamma$";
	A[4] := "$\alpha$";
	A[5] := "$\beta$";

	picture a;
	a := image(
		draw (0, gsize/2)--(0,gsize/2+yunit/2);
		draw img_sub_bin_search_fine_tree(A)(fill_leaf, 1, xunit, yunit, gsize);
	);

	string B[];
	B[1] := "$x$";
	B[2] := "$\alpha$";
	B[3] := "$y$";
	B[6] := "$\beta$";
	B[7] := "$\gamma$";

	picture b;
	b := image(
		draw (0, gsize/2)--(0,gsize/2+yunit/2);
		draw img_sub_bin_search_fine_tree(B)(fill_leaf, 1, xunit, yunit, gsize);
	);

	picture uuu;
	uuu := image(label(TEX("LEFT-ROTATE($T,x$)"),(0,0)););
	picture ddd;
	ddd := image(label(TEX("RIGHT-ROTATE($T,y$)"),(0,0)););

	numeric mmm;
	mmm := max(xpart urcorner uuu, xpart urcorner ddd);

	drawarrow (mmm,0)--(-mmm,0) withcolor clrsClB;
	drawarrow ((-mmm,0)--(mmm,0)) shifted (0, -gsize) withcolor clrsClB;
	draw uuu shifted (0, ypart urcorner uuu + 0.1cm);
	draw ddd shifted (0, ypart lrcorner ddd - 0.1cm -gsize);
	draw a shifted (-(xpart urcorner a) - mmm - gsize, 0);
	draw b shifted (-(xpart ulcorner b) + mmm + gsize, 0);
endfig;

end;
