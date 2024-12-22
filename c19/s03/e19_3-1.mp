
input clrs_disjoint_set_forest;

beginfig(1);
	declare.disjointSetForest(AAA);

	build.disjointSetForest(AAA) "(x_4)((x_2)(x_1))(x_3)";

	draw img.disjointSetForest(AAA);
endfig;

end;
