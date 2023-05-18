input clrs_rbtree;

beginfig(1);
	rbtree_declare(RRR);
	rbtree_build(RRR) "(26,B)((17,R)((14,B)((10,R)((7,B)(3,R)())(12,B))((16,B)(15,R)()))((21,B)((19,B)()(20,R))(23,B)))((41,B)((30,R)(28,B)((38,B)(35,R)(39,R)))(47,B))";

	draw rbtree_img(RRR)(true, 0.5cm, 0.8cm,0.8cm);
endfig;

end;
