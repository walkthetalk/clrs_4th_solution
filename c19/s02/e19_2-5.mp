
input clrs_disjoint_set;

beginfig(1);
	declare.disjointSet(AAA);
	AAA.hasHead := false;

	setroot.disjointSet(AAA) ("S_1", "");
	build.disjointSet(AAA) "(f)(g)(d)";

	draw img.disjointSet(AAA);
endfig;

beginfig(2);
	declare.disjointSet(BBB);
	BBB.hasHead := false;

	setroot.disjointSet(BBB) ("S_2", "");
	build.disjointSet(BBB) "(c;emph)(h;emph)(e;emph)(b;emph)";

	draw img.disjointSet(BBB);
endfig;

beginfig(3);
	declare.disjointSet(CCC);
	CCC.hasHead := false;

	setroot.disjointSet(CCC) ("S_2", "");
	build.disjointSet(CCC) "(f)(g)(d)(c;emph)(h;emph)(e;emph)(b;emph)";

	draw img.disjointSet(CCC);
endfig;

end;
