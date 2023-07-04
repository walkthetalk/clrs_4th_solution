input clrs_rbtree;

vardef link(expr a, b, lbl) :=
	save l,r;
	pair l;
	pair r;
	l := (urcorner a + lrcorner a) / 2;
	r := (ulcorner b + llcorner b) / 2;
	if (ypart l) < (ypart r):
		l := (xpart l, ypart r);
	else:
		r := (xpart r, ypart l);
	fi;

	drawarrow l--r withcolor clrsClB;
	label.top(TEX(lbl), (l+r)/2);
enddef;

beginfig(1);
	declare.rbtree(A);
	build.rbtree(A) "(3,B)(2,R)()";
	A.drawnil := false;

	declare.rbtree(B);
	build.rbtree(B) "(2,B)(1,R)(3,R)";
	B.drawnil := false;

	declare.rbtree(C);
	build.rbtree(C) "(2,B)()(3,R)";
	C.drawnil := false;

	picture a;
	picture b;
	picture c;
	a := img.rbtree(A);
	b := img.rbtree(B);
	c := img.rbtree(C);

	b := b shifted (urcorner a - ulcorner b + (1cm,0));
	c := c shifted (urcorner b - ulcorner c + (1cm,0));

	draw a;
	draw b;
	draw c;

	link(a,b,"insert");
	link(b,c,"delete");
endfig;

beginfig(2);
	declare.rbtree(A);
	build.rbtree(A) "(3,B)(2,R)(4,R)";
	A.drawnil := false;

	declare.rbtree(B);
	build.rbtree(B) "(3,B)((2,B)(1,R)())(4,B)";
	B.drawnil := false;

	declare.rbtree(C);
	build.rbtree(C) "(3,B)(2,B)(4,B)";
	C.drawnil := false;

	picture a;
	picture b;
	picture c;
	a := img.rbtree(A);
	b := img.rbtree(B);
	c := img.rbtree(C);

	b := b shifted (urcorner a - ulcorner b + (1cm,0));
	c := c shifted (urcorner b - ulcorner c + (1cm,0));

	draw a;
	draw b;
	draw c;

	link(a,b,"insert");
	link(b,c,"delete");
endfig;

end;
