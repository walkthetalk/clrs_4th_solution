input clrs_btree;

beginfig(1);
	declare.btree(BBB);

	build.btree(BBB) "(M;focus)((D H)(B C)(F G)(J K L))((Q T X;focus)(N P)(R S;focus)(V W)(Y Z))";

	draw img.btree(BBB);
endfig;

end;
