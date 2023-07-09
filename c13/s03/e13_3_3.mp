input clrs_rbtree;

beginfig(1);
	declare.rbtree(RRR);
	build.rbtree(RRR) "(C,B;ulft.$k+1$)"
		& "((A,R;ulft.$k+1$)(\alpha,B)((B,R;rt.$z$,toprt.$k+1$)(\beta,B)(\gamma,B)))"
		& "((D,R;rt.$y$,lft.$k+1$)(\delta,B)(\epsilon,B))";

	RRR.isfull := false;
	RRR.drawnil := false;
	save imgRRR;
	picture imgRRR;
	imgRRR := img.rbtree(RRR);

	declare.rbtree(SSS);
	build.rbtree(SSS) "(C,R;lft.new $z$,rt.$k+2$)"
		& "((A,B;lft.$k+1$)"
			& "(\alpha,B)"
			& "((B,R;toprt.$k+1$)(\beta,B)(\gamma,B)))"
		& "((D,B;rt.$k+1$)(\delta,B)(\epsilon,B))";

	SSS.isfull := false;
	SSS.drawnil := false;
	save imgSSS;
	picture imgSSS;
	imgSSS := img.rbtree(SSS);
	
	draw imgRRR shifted (-xpart(lrcorner imgRRR) - 0.5cm, 0);
	draw imgSSS shifted (-xpart(llcorner imgSSS) + 0.5cm, 0);

	drawarrow (-1cm,0)--(1cm,0) withcolor clrsClB;
endfig;

beginfig(2);
	declare.rbtree(RRR);
	build.rbtree(RRR) "(C,B;ulft.$k+1$)"
		& "((B,R;ulft.$k+1$)"
			& "((A,R;rt.$z$,lft.$k+1$)(\alpha,B)(\beta,B))"
			& "(\gamma,B))"
		& "((D,R;rt.$y$,lft.$k+1$)(\delta,B)(\epsilon,B))";

	RRR.isfull := false;
	RRR.drawnil := false;
	save imgRRR;
	picture imgRRR;
	imgRRR := img.rbtree(RRR);

	declare.rbtree(SSS);
	build.rbtree(SSS) "(C,R;lft.new $z$,rt.$k+2$)"
		& "((B,B;ulft.$k+1$)"
			& "((A,R;rt.$z$,lft.$k+1$)(\alpha,B)(\beta,B))"
			& "(\gamma,B))"
		& "((D,B;rt.$y$,lft.$k+1$)(\delta,B)(\epsilon,B))";

	SSS.isfull := false;
	SSS.drawnil := false;
	save imgSSS;
	picture imgSSS;
	imgSSS := img.rbtree(SSS);
	
	draw imgRRR shifted (-xpart(lrcorner imgRRR) - 0.5cm, 0);
	draw imgSSS shifted (-xpart(llcorner imgSSS) + 0.5cm, 0);

	drawarrow (-1cm,0)--(1cm,0) withcolor clrsClB;
endfig;

beginfig(3);
	declare.rbtree(RRR);
	build.rbtree(RRR) "(C,B;ulft.$k+1$)"
		& "((A,R;ulft.$k+1$)"
			& "(\alpha,B)"
			& "((B,R;toprt.$z$,rt.$k+1$)(\beta,B)(\gamma,B)))"
		& "(\delta,B;rt.$y$)";

	RRR.isfull := false;
	RRR.drawnil := false;
	save imgRRR;
	picture imgRRR;
	imgRRR := img.rbtree(RRR);

	declare.rbtree(SSS);
	build.rbtree(SSS) "(C,B;ulft.$k+1$)"
		& "((B,R;ulft.$k+1$)"
			& "((A,R;rt.$z$,lft.$k+1$)(\alpha,B)(\beta,B))"
			& "(\gamma,B))"
		& "(\delta,B;rt.$y$)";

	SSS.isfull := false;
	SSS.drawnil := false;
	save imgSSS;
	picture imgSSS;
	imgSSS := img.rbtree(SSS);

	declare.rbtree(TTT);
	build.rbtree(TTT) "(B,B;rt.$k+1$)"
		& "((A,R;lft.$z$,rt.$k+1$)(\alpha,B)(\beta,B))"
		& "((C,R;lft.$z$,rt.$k+1$)(\gamma,B)(\delta,B))";
	TTT.isfull := false;
	TTT.drawnil := false;
	save imgTTT;
	picture imgTTT;
	imgTTT := img.rbtree(TTT);

	numeric lftshift, rtshift;
	lftshift := -xpart(lrcorner imgRRR - llcorner imgSSS) - 0.5cm;
	rtshift := xpart(lrcorner imgSSS - llcorner imgTTT) + 0.5cm;
	draw imgRRR shifted (lftshift, 0);
	draw imgSSS;
	draw imgTTT shifted (rtshift, 0);

	numeric dist;
	dist := 1cm;
	drawarrow (lftshift + dist,0) -- (-dist,0) withcolor clrsClB;
	drawarrow (dist,0) -- (rtshift - dist,0) withcolor clrsClB;
endfig;

end;
