% specific tree type should provide:
% vardef newnode@#(suffix tree)(expr ...)
% vardef associate@#(suffix tree)(expr parent, child, idx)

vardef build@#(suffix tree) expr s :=
	save lvl, idx, pNode, lastCH;
	numeric lvl;
	numeric idx[];
	numeric pNode[];
	string lastCH;
	lvl := 0;
	idx[lvl] := 0;
	pNode[lvl] := nullptr;
	lastCH := "";

	save ch, newnodeBegin, nnc, newnodeLvl;
	string ch;
	numeric newnodeBegin;
	string nnc;
	string comment;
	numeric newnodeLvl;
	for i := 0 upto ((length s) - 1):
		ch := substring (i,i+1) of s;
		% todo: skip spaces
		if ch = "(":
			if lastCH = ")":
				idx[lvl] := idx[lvl] + 1;
			else:
				lvl := lvl + 1;
				idx[lvl] := 0;
			fi;
			% begin new node
			newnodeBegin := i+1;
		elseif ch = ")":
			if lastCH = ")":
				lvl := lvl - 1;
			else:
				nnc := substring (newnodeBegin, i) of s;
				if nnc <> "":
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
					if idx[lvl] <> 0:
						newnodeLvl := lvl+1;
					else:
						newnodeLvl := lvl;
					fi;

					pNode[newnodeLvl] := newnode@#(tree)(scantokens(nnc), comment);
					associate@#(tree)(pNode[newnodeLvl-1], pNode[newnodeLvl], idx[newnodeLvl-1]);
				fi;
			fi;
		fi;

		lastCH := ch;
	endfor;

	tree.root := pNode[1];
enddef;
