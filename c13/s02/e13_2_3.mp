input clrs_bintree;

beginfig(1);
	declare.bintree(RRR);
	build.bintree(RRR) "(y)((x)(\alpha)(\beta))(\gamma)";
	RRR.isfull := false;

	picture a;
	a := img.bintree(RRR);

	declare.bintree(TTT);
	build.bintree(TTT) "(x)(\alpha)((y)(\beta)(\gamma))";
	TTT.isfull := false;

	picture b;
	b := img.bintree(TTT);

	picture uuu;
	uuu := image(label(TEX("LEFT-ROTATE($T,x$)"),(0,0)););
	picture ddd;
	ddd := image(label(TEX("RIGHT-ROTATE($T,y$)"),(0,0)););

	numeric mmm;
	mmm := max(xpart urcorner uuu, xpart urcorner ddd);

	drawarrow (mmm,0)--(-mmm,0) withcolor clrsClB;
	drawarrow ((-mmm,0)--(mmm,0)) shifted (0, -RRR.gsize) withcolor clrsClB;
	draw uuu shifted (0, ypart urcorner uuu + 0.1cm);
	draw ddd shifted (0, ypart lrcorner ddd - 0.1cm -RRR.gsize);
	draw a shifted (-(xpart urcorner a) - mmm - RRR.gsize, 0);
	draw b shifted (-(xpart ulcorner b) + mmm + RRR.gsize, 0);
endfig;

end;
