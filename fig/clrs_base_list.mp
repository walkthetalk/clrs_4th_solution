% specific list type should provide:
% vardef newnode@#(suffix tree)(expr ...)
% vardef associate@#(suffix tree)(expr parent, child, idx)

vardef declare_list(suffix tree) :=
	declare_memorypool(tree);

	numeric tree.head;
	numeric tree.tail;
	tree.head := nullptr;
	tree.tail := nullptr;
enddef;

vardef build@#(suffix tree) expr s :=
	save lvl, idx, pNode, lastCH;
	numeric lvl;
	numeric idx;
	numeric pNode[];
	string lastCH;
	lvl := 0;
	idx := 0;
	pNode[lvl] := nullptr;
	lastCH := "";

	save ch, newnodeBegin, nnc;
	string ch;
	numeric newnodeBegin;
	string nnc;
	string comment;

	for i := 0 upto ((length s) - 1):
		ch := substring (i,i+1) of s;
		% todo: skip spaces
		if ch = "(":
			idx := idx + 1;
			% begin new node
			newnodeBegin := i+1;
		elseif ch = ")":
			nnc := substring (newnodeBegin, i) of s;

			comment := "";
			for k := 0 upto ((length nnc) - 1):
				if (substring(k,k+1) of nnc) = ";":
					comment := (substring(k+1, length nnc) of nnc);
					nnc := substring(0,k) of nnc;
					exitif true;
				fi;
			endfor;

			nnc := char(34) & nnc & char(34);
			for j := ((length nnc)-1) downto 0:
				if (substring(j,j+1)of nnc) = ",":
					nnc := (substring(0,j) of nnc) & char(34) & "," & char(34)
						& (substring(j+1, (length nnc))of nnc);
				fi;
			endfor;

			pNode[idx] := newnode@#(tree)(scantokens(nnc), comment);
			associate@#(tree)(pNode[idx-1], pNode[idx]);
		fi;

		lastCH := ch;
	endfor;

	tree.head := pNode[1];
	tree.tail := pNode[idx];
enddef;
