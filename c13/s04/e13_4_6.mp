input clrs_rbtree;

beginfig(1);
	declare.rbtree(RRR);
	build.rbtree(RRR) "(B,B)"
		& "((A,B;lft.$x$)(\alpha,B;bot.$2$)(\beta,B;bot.$2$))"
		& "((D,R;rt.$w$)((C,B)(\gamma,B;bot.$2$)(\delta,B;bot.$2$))((E,B)(\epsilon,B;bot.$2$)(\zeta,B;bot.$2$)))";

	RRR.isfull := false;
	RRR.drawnil := false;
	save imgRRR;
	picture imgRRR;
	imgRRR := img.rbtree(RRR);

	declare.rbtree(SSS);
	build.rbtree(SSS) "(D,B)"
		& "((B,R)"
			& "((A,B;lft.$x$)(\alpha,B;bot.$2$)(\beta,B;bot.$2$))"
			& "((C,B;toprt.$w$)(\gamma,B;bot.$2$)(\delta,B;bot.$2$)))"
		& "((E,B)(\epsilon,B;bot.$2$)(\zeta,B;bot.$2$))";

	SSS.isfull := false;
	SSS.drawnil := false;
	save imgSSS;
	picture imgSSS;
	imgSSS := img.rbtree(SSS);
	
	draw imgRRR shifted (-xpart(lrcorner imgRRR) - 0.5cm, 0);
	draw imgSSS shifted (-xpart(llcorner imgSSS) + 0.5cm, 0);

	drawarrow (-1cm,0)--(1cm,0) withcolor clrsClB;
	label.top(TEX("Case 1"), (0,0));
endfig;

beginfig(2);
	declare.rbtree(RRR);
	build.rbtree(RRR) "(B,U;rt.$c$)"
		& "((A,B;lft.$x$)(\alpha,B;bot.$1+c$)(\beta,B;bot.$1+c$))"
		& "((D,R;rt.$w$)"
			& "((C,B)(\gamma,B;bot.$2+c$)(\delta,B;bot.$2+c$))"
			& "((E,B)(\epsilon,B;bot.$2+c$)(\zeta,B;bot.$2+c$)))";

	RRR.isfull := false;
	RRR.drawnil := false;
	save imgRRR;
	picture imgRRR;
	imgRRR := img.rbtree(RRR);

	declare.rbtree(SSS);
	build.rbtree(SSS) "(B,U;lft.$x$,rt.$c$)"
		& "((A,B)(\alpha,B;bot.$1+c$)(\beta,B;bot.$1+c$))"
		& "((D,R)"
			& "((C,B)(\gamma,B;bot.$1+c$)(\delta,B;bot.$1+c$))"
			& "((E,B)(\epsilon,B;bot.$1+c$)(\zeta,B;bot.$1+c$)))";

	SSS.isfull := false;
	SSS.drawnil := false;
	save imgSSS;
	picture imgSSS;
	imgSSS := img.rbtree(SSS);

	draw imgRRR shifted (-xpart(lrcorner imgRRR) - 0.5cm, 0);
	draw imgSSS shifted (-xpart(llcorner imgSSS) + 0.5cm, 0);

	drawarrow (-1cm,0)--(1cm,0) withcolor clrsClB;
	label.top(TEX("Case 2"), (0,0));
endfig;

beginfig(3);
	declare.rbtree(RRR);
	build.rbtree(RRR) "(B,U;rt.$c$)"
		& "((A,B;lft.$x$)"
			& "(\alpha,B;bot.$1+c$)"
			& "(\beta,B;bot.$1+c$))"
		& "((D,R;rt.$w$)"
			& "((C,R)(\gamma,B;bot.$1+c$)(\delta,B;bot.$1+c$))"
			& "((E,B)(\epsilon,B;bot.$2+c$)(\zeta,B;bot.$2+c$)))";

	RRR.isfull := false;
	RRR.drawnil := false;
	save imgRRR;
	picture imgRRR;
	imgRRR := img.rbtree(RRR);

	declare.rbtree(SSS);
	build.rbtree(SSS) "(B,U;rt.$c$)"
		& "((A,B)(\alpha,B;bot.$1+c$)(\beta,B;bot.$1+c$))"
		& "((C,B;rt.$w$)"
			& "(\gamma,B;bot.$1+c$)"
			& "((D,R)"
				& "(\delta,B;bot.$1+c$)"
				& "((E,B)(\epsilon,B;bot.$2+c$)(\zeta,B;bot.$2+c$))))";

	SSS.isfull := false;
	SSS.drawnil := false;
	save imgSSS;
	picture imgSSS;
	imgSSS := img.rbtree(SSS);

	draw imgRRR shifted (-xpart(lrcorner imgRRR) - 0.5cm, 0);
	draw imgSSS shifted (-xpart(llcorner imgSSS) + 0.5cm, 0);

	drawarrow (-1cm,0)--(1cm,0) withcolor clrsClB;
	label.top(TEX("Case 3"), (0,0));
endfig;

beginfig(4);
	declare.rbtree(RRR);
	build.rbtree(RRR) "(B,U;rt.$c$)"
		& "((A,B;lft.$x$)"
			& "(\alpha,B;bot.$1+c$)"
			& "(\beta,B;bot.$1+c$))"
		& "((D,R;rt.$w$)"
			& "((C,U;rt.$c'$)(\gamma,B;bot.$1+c+c'$)(\delta,B;bot.$1+c+c'$))"
			& "((E,R)(\epsilon,B;bot.$1+c$)(\zeta,B;bot.$1+c$)))";

	RRR.isfull := false;
	RRR.drawnil := false;
	save imgRRR;
	picture imgRRR;
	imgRRR := img.rbtree(RRR);

	declare.rbtree(SSS);
	build.rbtree(SSS) "(D,U;rt.$c$)"
		& "((B,B)"
			& "((A,B)(\alpha,B;bot.$2+c$)(\beta,B;bot.$2+c$))"
			& "((C,U;rt.$c'$)(\gamma,B;bot.$1+c+c'$)(\delta,B;bot.$1+c+c'$)))"
		& "((E,B)"
			& "(\epsilon,B;bot.$1+c$)"
			& "(\zeta,B;bot.$1+c$))";

	SSS.isfull := false;
	SSS.drawnil := false;
	save imgSSS;
	picture imgSSS;
	imgSSS := img.rbtree(SSS);

	draw imgRRR shifted (-xpart(lrcorner imgRRR) - 0.5cm, 0);
	draw imgSSS shifted (-xpart(llcorner imgSSS) + 0.5cm, 0);

	drawarrow (-1cm,0)--(1cm,0) withcolor clrsClB;
	label.top(TEX("Case 4 "), (0,0));

	save ww,hh;
	numeric ww,hh;
	ww := xpart(lrcorner imgSSS - llcorner imgSSS);
	hh := ypart(urcorner imgSSS);
	label.llft(TEX("$x$ = $T_{root}$"), (ww + 0.5cm, hh));
endfig;

end;
