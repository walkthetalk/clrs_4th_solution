input clrs_rbtree;

beginfig(1);
	declare.rbtree(RRR);
	build.rbtree(RRR) "(38,B)((19,R)((12,B)(8,R)())(31,B))((41,B))";

	RRR.drawnil := false;
	draw img.rbtree(RRR);
endfig;

beginfig(2);
	declare.rbtree(RRR);
	build.rbtree(RRR) "(38,B)((19,R)(12,B)(31,B))((41,B))";

	RRR.drawnil := false;
	draw img.rbtree(RRR);
endfig;

beginfig(3);
	declare.rbtree(RRR);
	build.rbtree(RRR) "(38,B)((19,B)()(31,R))((41,B))";

	RRR.drawnil := false;
	draw img.rbtree(RRR);
endfig;

beginfig(4);
	declare.rbtree(RRR);
	build.rbtree(RRR) "(38,B)(31,B)(41,B)";

	RRR.drawnil := false;
	draw img.rbtree(RRR);
endfig;

beginfig(5);
	declare.rbtree(RRR);
	build.rbtree(RRR) "(38,B)()(41,R)";

	RRR.drawnil := false;
	draw img.rbtree(RRR);
endfig;

beginfig(6);
	declare.rbtree(RRR);
	build.rbtree(RRR) "(41,B)";

	RRR.drawnil := false;
	draw img.rbtree(RRR);
endfig;

end;
