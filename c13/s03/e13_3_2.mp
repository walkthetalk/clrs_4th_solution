input clrs_rbtree;

beginfig(1);
	declare.rbtree(RRR);
	build.rbtree(RRR) "(38,B)((19,R)((12,B)(8,R)())(31,B))((41,B))";
	draw img.rbtree(RRR)(false, 0.5cm,0.8cm,0.8cm);
endfig;

end;
