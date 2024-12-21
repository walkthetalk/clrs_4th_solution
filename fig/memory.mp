numeric nullptr;
nullptr := 0;

vardef __add_slot(suffix freelist)(expr slot_id) :=
	freelist[slot_id] := freelist[0];
	freelist[0] := slot_id;
enddef;

vardef __ext_slots(suffix tree)(expr cnt) :=
	save i;
	numeric i;
	i := 1;
	forever:
		exitif i > cnt;
		__add_slot(tree.free_list)(tree.maxnodes + i);
		i := i + 1;
	endfor;
	tree.maxnodes := tree.maxnodes + cnt;
enddef;

vardef free_slot(suffix tree)(expr idx) :=
	tree.free_list[idx] := tree.free_list[0];
	tree.free_list[0] := idx;
enddef;
vardef alloc_slot(suffix tree) :=
	save ret;
	numeric ret;
	if tree.free_list[0] = nullptr:
		__ext_slots(tree)(16);
	fi
	ret := tree.free_list[0];
	tree.free_list[0] := tree.free_list[ret];

	ret
enddef;

vardef declare_memorypool(suffix tree) :=
	numeric tree.maxnodes;
	numeric tree.cnt;
	numeric tree.free_list[];

	tree.maxnodes := 0;
	tree.cnt := 0;
	tree.free_list[0] := nullptr;

	__ext_slots(tree)(16);
enddef;

% freelist[0] store list head
vardef init_freelist(suffix freelist)(expr max_nodes) :=
	numeric i;
	i := 0;
	forever:
		exitif i >= max_nodes;
		freelist[i] := i + 1;
		i := i + 1;
	endfor;
	% 0 means tail
	freelist[max_nodes] := nullptr;
enddef;
vardef free_node(suffix freelist)(expr idx) :=
	freelist[idx] := freelist[0];
	freelist[0] := idx;
enddef;
vardef alloc_node(suffix freelist) :=
	save ret;
	numeric ret;
	ret := freelist[0];
	%message "alloc node " & decimal(ret);
	freelist[0] := freelist[freelist[0]];
	%message "next alloc node " & decimal(freelist[0]);

	ret
enddef;
