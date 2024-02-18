input clrs_btree;

beginfig(1);
	% 插入 Q 後，插入 K 之前
	declare.btree(BTQ);
	build.btree(BTQ) "(F Q S)";
	draw img.btree(BTQ);
endfig;

beginfig(2);
	% 插入 C 後，插入 L 之前
	declare.btree(BTC);
	build.btree(BTC) "(Q)(C F K)(S)";
	draw img.btree(BTC);
endfig;

beginfig(3);
	% 插入 V 後，插入 W 之前
	declare.btree(BTV);
	build.btree(BTV) "(F Q)(C)(H K L)(S T V)";
	draw img.btree(BTV);
endfig;

beginfig(4);
	% 插入 W 後，插入 M 之前
	declare.btree(BTW);
	build.btree(BTW) "(F Q T)(C)(H K L)(S)(V W)";
	draw img.btree(BTW);
endfig;

beginfig(5);
	% 插入 N 後，插入 P 之前
	declare.btree(BTN);
	build.btree(BTN) "(Q)((F K)(C)(H)(L M N))((T)(R S)(V W))";
	draw img.btree(BTN);
endfig;

beginfig(6);
	% 插入 P 後，插入 A 之前
	declare.btree(BTP);
	build.btree(BTP) "(Q)((F K M)(C)(H)(L)(N P))((T)(R S)(V W))";
	draw img.btree(BTP);
endfig;

beginfig(7);
	% 插入 X 後，插入 Y 之前
	declare.btree(BTX);
	build.btree(BTX) "(K Q)((F)(A B C)(H))((M)(L)(N P))((T)(R S)(V W X))";
	draw img.btree(BTX);
endfig;

beginfig(8);
	% 插入 Y 後，插入 D 之前
	declare.btree(BTY);
	build.btree(BTY) "(K Q)((F)(A B C)(H))((M)(L)(N P))((T W)(R S)(V)(X Y))";
	draw img.btree(BTY);
endfig;

beginfig(9);
	% 插入 E 後
	declare.btree(BTE);
	build.btree(BTE) "(K Q)((B F)(A)(C D E)(H))((M)(L)(N P))((T W)(R S)(V)(X Y Z))";
	draw img.btree(BTE);
endfig;

end;
