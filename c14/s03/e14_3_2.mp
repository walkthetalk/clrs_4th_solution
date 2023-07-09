input clrs_mergesorttree;

beginfig(1);
	declare.mergesorttree(A);
	build.mergesorttree(A) "(1:16)"
		& "((1:8)"
			& "((1:4)((1:2)(1)(2))((3:4)(3)(4)))"
			& "((5:8)((5:6)(5)(6))((7:8)(7)(8))))"
		& "((9:16)"
			& "((9:12)((9:10)(9)(10))((11:12)(11)(12)))"
			& "((13:16)((13:14)(13)(14))((15:16)(15)(16))))";

	draw img.mergesorttree(A);
endfig;

end;
