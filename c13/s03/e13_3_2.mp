input clrs_rbtree;

beginfig(1);
	declare.rbtree(RRR);
	build.rbtree(RRR) "(38,B)((19,R)((12,B)(8,R)())(31,B))((41,B))";

	RRR.drawnil := false;
	draw img.rbtree(RRR);
endfig;

end;
