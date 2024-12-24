
input clrs_disjoint_set_forest;

beginfig(1);
	declare.disjointSetForest(AAA);

	build.disjointSetForest(AAA) "(x_1),(x_2),(x_3),(x_4),(x_5),(x_6),(x_7),(x_8),(x_9),(x_{10}),(x_{11}),(x_{12}),(x_{13}),(x_{14}),(x_{15}),(x_{16})";

	draw img.disjointSetForest(AAA);
endfig;

beginfig(2);
	declare.disjointSetForest(BBB);

	build.disjointSetForest(BBB) "(x_2)(x_1),(x_4)(x_3),(x_6)(x_5),(x_8)(x_7),(x_{10})(x_9),(x_{12})(x_{11}),(x_{14})(x_{13}),(x_{16})(x_{15})";

	draw img.disjointSetForest(BBB);
endfig;

beginfig(3);
	declare.disjointSetForest(CCC);

	build.disjointSetForest(CCC) "(x_4)((x_2)(x_1))(x_3),(x_8)((x_6)(x_5))(x_7),(x_{12})((x_{10})(x_9))(x_{11}),(x_{16})((x_{14})(x_{13}))(x_{15})";

	draw img.disjointSetForest(CCC);
endfig;

beginfig(4);
	declare.disjointSetForest(DDD);

	build.disjointSetForest(DDD) "(x_8)((x_4)(x_1)(x_2)(x_3))(x_5)(x_6)(x_7),(x_{12})((x_{10})(x_9))(x_{11}),(x_{16})((x_{14})(x_{13}))(x_{15})";

	draw img.disjointSetForest(DDD);
endfig;

beginfig(4);
	declare.disjointSetForest(EEE);

	build.disjointSetForest(EEE) "(x_8)((x_4)(x_1)(x_2)(x_3))(x_5)(x_6)(x_7),(x_{16})((x_{12})(x_{10})(x_{11}))(x_{13})(x_{14})(x_{15})";

	draw img.disjointSetForest(EEE);
endfig;


end;
