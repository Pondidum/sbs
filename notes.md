Guild Notes
===========

Public: Elemental[Enhancement]
Officer: 123 progress

Public: No Spec
Officer: 123 bethlac

Public: Arms[Prot]
Officer: 7 zonoz



Addon Messages
=============

	Prefix	 	name 			data							example
	-------------------------------------------------------------------
	sbs_bs		bid start		itemID:itemName:itemLink		7073:Broken Fang:|cff9d9d9d|Hitem:7073:0:0:0:0:0:0:0:80:0|h[Broken Fang]|h|r
	sbs_bf		bid finish		itemID:itemName:itemLink		7073:Broken Fang:|cff9d9d9d|Hitem:7073:0:0:0:0:0:0:0:80:0|h[Broken Fang]|h|r
	sbs_bfw		bid winners		itemID:winner1:winner2:...		7073:Darkend:Somniac
	sbs_bfb		bid bidders		itemID:bidder1:bidder2:...		7073:Frenca:Snypee:Derchizul:Vashor




Whisper Commands
================

Command: 
	!bid cancel

Responses: 
	Bid cancelled.
	No bid to cancel.



Command:
	!bid arg:integer

Responses:
	Invalid bid "{arg}".
	Not enough points (you bid "{arg}", you have "{stored}" available.)
	Bid accepted, "{arg}" points, {Mainspec|Offspec|Unranked}.
	New bid accepted, "{arg}" points, {Mainspec|Offspec|Unranked}.



Command:
	!bid arg1:integer arg2:"mainspec","offspec"

Responses:
	Invalid Bid "{arg1}".
	Invalid Bid "{arg2}".
	Not enough points (you bid "{arg}", you have "{stored}" available.)
	Bid accepted, "{arg}" points, {Mainspec|Offspec|Unranked}.
	New bid accepted, "{arg}" points, {Mainspec|Offspec|Unranked}.
