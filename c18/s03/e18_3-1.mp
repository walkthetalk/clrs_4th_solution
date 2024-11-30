input clrs_btree;

beginfig(1);
	declare.btree(BBB);

	build.btree(BBB) "(L P T X;focus)((A E J K;focus))((N O))((Q R S))((U V))((Y Z))";

	draw img.btree(BBB);
endfig;

beginfig(2);
	declare.btree(BBB);

	build.btree(BBB) "(L Q T X;focus)((A E J K))((N O))((R S;focus))((U V))((Y Z))";

	draw img.btree(BBB);
endfig;

beginfig(3);
	declare.btree(BBB);

	build.btree(BBB) "(L Q T;focus)((A E J K))((N O))((R S))((U V Y Z))";

	draw img.btree(BBB);
endfig;

end;
