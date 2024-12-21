
input clrs_disjoint_set;

beginfig(1);
	declare.disjointSet(BBB);

	setroot.disjointSet(BBB) ("S_1", "");
	build.disjointSet(BBB) "(f)(g)(d)";

	draw img.disjointSet(BBB);
endfig;

end;
