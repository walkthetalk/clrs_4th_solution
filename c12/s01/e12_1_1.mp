input clrs_bintree;

% @order: 0 preorder; 1 inorder; 2 postorder;
vardef preorder.bintree(suffix tree)(expr idx) :=
	save ret;
	string ret;
	ret := tree[idx]key;

	if tree[idx]lft <> nullptr:
		ret := ret & "," & preorder.bintree(tree)(tree[idx]lft);
	fi;
	if tree[idx]rt <> nullptr:
		ret := ret & "," & preorder.bintree(tree)(tree[idx]rt);
	fi;
	ret
enddef;
vardef inorder.bintree(suffix tree)(expr idx) :=
	save ret;
	string ret;
	ret := tree[idx]key;

	if tree[idx]lft <> nullptr:
		ret := inorder.bintree(tree)(tree[idx]lft) & "," & ret;
	fi;
	if tree[idx]rt <> nullptr:
		ret := ret & "," & inorder.bintree(tree)(tree[idx]rt);
	fi;
	ret
enddef;
vardef postorder.bintree(suffix tree)(expr idx) :=
	save ret;
	string ret;
	ret := tree[idx]key;
	if tree[idx]rt <> nullptr:
		ret := postorder.bintree(tree)(tree[idx]rt) & "," & ret;
	fi;
	if tree[idx]lft <> nullptr:
		ret := postorder.bintree(tree)(tree[idx]lft) & "," & ret;
	fi;
	ret
enddef;

vardef customdrawbintree(suffix tree) :=
	save ppp, pos, aux;

	picture ppp;
	ppp := img.bintree(tree);
	draw ppp;

	pair pos;
	pos := urcorner ppp;

	picture aux;
	aux := thelabel.urt("post:", (0,0));
	picture pre;

	pos := pos + (xpart lrcorner aux, -ypart urcorner aux);
	label.llft("pre:", pos);
	pre := thelabel.lrt(TEX("$" & preorder.bintree(tree)(tree.root) & "$"), pos);
	draw pre;

	pos := pos - (0, ypart urcorner aux);
	label.llft("in:", pos);
	pre := thelabel.lrt(TEX("$" & inorder.bintree(tree)(tree.root) & "$"), pos);
	draw pre;

	pos := pos - (0, ypart urcorner aux);
	label.llft("post:", pos);
	pre := thelabel.lrt(TEX("$" & postorder.bintree(tree)(tree.root) & "$"), pos);
	draw pre;
enddef;

beginfig(1);
	declare.bintree(RRR);
	build.bintree(RRR) "(10)((4)(1)(5))((17)(16)(21))";

	customdrawbintree(RRR);
endfig;

beginfig(2);
	declare.bintree(RRR);
	build.bintree(RRR) "(10)((4)(1)(5))((16)()((17)()(21)))";
	customdrawbintree(RRR);
endfig;

beginfig(3);
	declare.bintree(RRR);
	build.bintree(RRR) "(5)((4)(1)())((10)()((16)()((17)()(21))))";
	customdrawbintree(RRR);
endfig;

beginfig(4);
	declare.bintree(RRR);
	build.bintree(RRR) "(4)(1)((5)()((10)()((16)()((17)()(21)))))";
	customdrawbintree(RRR);
endfig;

beginfig(5);
	declare.bintree(RRR);
	build.bintree(RRR) "(1)()((4)()((5)()((10)()((16)()((17)()(21))))))";

	customdrawbintree(RRR);
endfig;

end;
