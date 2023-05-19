input clrs_rbtree;

beginfig(1);
	declare.bintree(RRR);
	build.bintree(RRR) "(8)((4)((2)(1)(3))((6)(5)(7)))((12)((10)(9)(11))((14)(13)(15)))";

	draw img.bintree(RRR);
endfig;
beginfig(2);
	declare.rbtree(Htwo);
	build.rbtree(Htwo) "(8,B)((4,R)((2,B)(1,R)(3,R))((6,B)(5,R)(7,R)))((12,R)((10,B)(9,R)(11,R))((14,B)(13,R)(15,R)))";
	draw img.rbtree(Htwo);
endfig;
beginfig(3);
	declare.rbtree(Hthree);
	build.rbtree(Hthree) "(8,B)((4,R)((2,B)(1,B)(3,B))((6,B)(5,B)(7,B)))((12,R)((10,B)(9,B)(11,B))((14,B)(13,B)(15,B)))";
	draw img.rbtree(Hthree);
endfig;
beginfig(4);
	declare.rbtree(Hfour);
	build.rbtree(Hfour) "(8,B)((4,B)((2,B)(1,B)(3,B))((6,B)(5,B)(7,B)))((12,B)((10,B)(9,B)(11,B))((14,B)(13,B)(15,B)))";
	draw img.rbtree(Hfour);
endfig;

end;
