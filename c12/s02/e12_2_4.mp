input clrs_bintree;

beginfig(1);
	declare.bintree(RRR);
	build.bintree(RRR) "(1)()((3)(2)(4))";

	draw img.bintree(RRR);
endfig;

end;
