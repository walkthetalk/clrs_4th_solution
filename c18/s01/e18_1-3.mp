input clrs_btree;

beginfig(1);
	declare.btree(BTA);
	build.btree(BTA) "(2)(1)(3 4 5)";
	draw img.btree(BTA);
endfig;

beginfig(2);
	declare.btree(BTB);
	build.btree(BTB) "(3)(1 2)(4 5)";
	draw img.btree(BTB);
endfig;

beginfig(3);
	declare.btree(BTC);
	build.btree(BTC) "(4)(1 2 3)(5)";
	draw img.btree(BTC);
endfig;

beginfig(4);
	declare.btree(BTD);
	build.btree(BTD) "(2 4)(1)(3)(5)";
	draw img.btree(BTD);
endfig;

end;
