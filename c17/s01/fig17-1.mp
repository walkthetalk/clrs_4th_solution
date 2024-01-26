input clrs_rbtree;

beginfig(1);
	declare.rbtree(RRR);
	RRR.hasSize := true;
	RRR.drawnil := false;
	build.rbtree(RRR) "(26,B)((17,R)((14,B)((10,R)((7,B)(3,R)())(12,B))((16,B)(15,R)()))((21,B)((19,B)()(20,R;urt.key,lrt.size))(23,B)))((41,B)((30,R)(28,B)((38,B)(35,R)(39,R)))(47,B))";

	draw img.rbtree(RRR);
endfig;

end;
