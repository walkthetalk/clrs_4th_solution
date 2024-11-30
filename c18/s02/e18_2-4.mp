input clrs_btree;

beginfig(1);
	declare.btree(BTE);
	build.btree(BTE) "(1)";
	draw img.btree(BTE);
endfig;

beginfig(2);
	declare.btree(BTE);
	build.btree(BTE) "(1 2)";
	draw img.btree(BTE);
endfig;

beginfig(3);
	declare.btree(BTE);
	build.btree(BTE) "(1 2 3)";
	draw img.btree(BTE);
endfig;

beginfig(4);
	declare.btree(BTE);
	build.btree(BTE) "(2)(1)(3 4)";
	draw img.btree(BTE);
endfig;

beginfig(5);
	declare.btree(BTE);
	build.btree(BTE) "(2)(1)(3 4 5)";
	draw img.btree(BTE);
endfig;

beginfig(6);
	declare.btree(BTE);
	build.btree(BTE) "(2 4)(1)(3)(5 6)";
	draw img.btree(BTE);
endfig;

beginfig(7);
	declare.btree(BTE);
	build.btree(BTE) "(2 4)(1)(3)(5 6 7)";
	draw img.btree(BTE);
endfig;

beginfig(8);
	declare.btree(BTE);
	build.btree(BTE) "(2 4 6)(1)(3)(5)(7 8)";
	draw img.btree(BTE);
endfig;

beginfig(9);
	declare.btree(BTE);
	build.btree(BTE) "(4)((2)(1)(3))((6)(5)(7 8 9))";
	draw img.btree(BTE);
endfig;

beginfig(10);
	declare.btree(BTE);
	build.btree(BTE) "(4)((2)(1)(3))((6 8)(5)(7)(9 10))";
	draw img.btree(BTE);
endfig;

beginfig(11);
	declare.btree(BTE);
	build.btree(BTE) "(4)((2)(1)(3))((6 8)(5)(7)(9 10 11))";
	draw img.btree(BTE);
endfig;

end;
