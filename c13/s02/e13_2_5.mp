input clrs_bintree;

beginfig(1);
	declare.bintree(RRR);
	build.bintree(RRR) "(2)(1)(3)";

	draw img.bintree(RRR);
endfig;

beginfig(2);
	declare.bintree(TTT);
	build.bintree(TTT) "(3)((2)(1)())()";

	draw img.bintree(TTT);
endfig;

end;
