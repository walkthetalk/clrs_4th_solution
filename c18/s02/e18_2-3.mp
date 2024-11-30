input clrs_btree;

beginfig(1);
	declare.btree(BTE);
	build.btree(BTE) "(4 8 12)((1 2 3))((5 6 7))((9 10 11))((13 14 15))";
	draw img.btree(BTE);
endfig;

beginfig(2);
	declare.btree(BTE);
	build.btree(BTE) "(4 8 12)((1 2 3))((5 6 7))((9 10 11))((13 14))";
	draw img.btree(BTE);
endfig;

beginfig(3);
	declare.btree(BTE);
	build.btree(BTE) "(8)((4)(1 2 3)(5 6 7))((12)(9 10 11)(13 14 15))";
	draw img.btree(BTE);
endfig;

end;
