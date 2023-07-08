input TEX;
input clrs;

numeric gsize;
gsize := .8cm;

path gfr;
gfr := fullcircle scaled gsize;

vardef mysubpath(expr mainP, fisrtCut, secondCut) :=
	subpath (ypart(fisrtCut intersectiontimes mainP),
			ypart(secondCut intersectiontimes mainP)) of mainP
enddef;

vardef drawNode(expr name, pos):=
	save sfr;
	path sfr;
	sfr := gfr shifted pos;

	fill sfr withcolor clrsCfA;
	draw sfr withcolor clrsClA;
	label(TEX(name), pos);
enddef;

vardef nlink(expr pos, dist, linkoffset):=
	save spos,npos;
	pair spos,npos;
	spos := pos;
	npos := pos + dist;

	save sfr, nfr;
	path sfr, nfr;
	sfr := gfr shifted spos;
	nfr := gfr shifted npos;

	save lline;
	path lline;
	lline := spos{-linkoffset} .. (spos + dist/3 - linkoffset*3/4){dist} .. npos;
	mysubpath(lline, sfr, nfr)
enddef;

vardef nnlink(expr pos, dist, linkoffset):=
	save spos,nnpos;
	pair spos,nnpos;
	spos := pos;
	nnpos := pos + 2 * dist;

	save sfr, nnfr;
	path sfr, nnfr;
	sfr := gfr shifted spos;
	nnfr := gfr shifted nnpos;

	save rline;
	path rline;
	rline := spos .. (spos + dist + linkoffset){dist} .. nnpos;
	mysubpath(rline, sfr, nnfr)
enddef;

vardef drawNodeLink(expr name, pos, dist, linkoffset):=
	drawNode(name, pos);
	drawarrow nlink(pos, dist, linkoffset);
	drawarrow nnlink(pos, dist, linkoffset);
enddef;

beginfig(1);

pair dist;
dist := (gsize * 1.5, 0);

pair linkoffset;
linkoffset := (0, gsize*1.5);

pair pos;
pos := (0,0);

drawNodeLink("$n$", pos, dist, linkoffset);
linkoffset := -linkoffset;
pos := pos + dist;

drawNodeLink("$n{-}1$", pos, dist, linkoffset);
linkoffset := -linkoffset;
pos := pos + dist;

drawNode("$n{-}2$", pos);
drawarrow nlink(pos, dist, linkoffset);
draw subpath(0,1.5) of nnlink(pos, dist, linkoffset);

linkoffset := -linkoffset;
pos := pos + dist;

drawarrow subpath(0.5,2) of nnlink(pos, dist, linkoffset);

label(TEX("$\vdots$"), (0,0)) scaled 3 shifted (pos + dist/2);
linkoffset := -linkoffset;
pos := pos + dist;
drawarrow nlink(pos, dist, linkoffset);
drawarrow nnlink(pos, dist, linkoffset);
linkoffset := -linkoffset;
pos := pos + dist;
drawNodeLink("$3$", pos, dist, linkoffset);
linkoffset := -linkoffset;
pos := pos + dist;
drawNodeLink("$2$", pos, dist, linkoffset);
pos := pos + dist;
drawNode("$1$", pos);
pos := pos + dist;
drawNode("$0$", pos);

endfig;

end
