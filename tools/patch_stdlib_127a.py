#!/usr/bin/env python3
"""Patch wurstStdlib2 for classic 1.27a (no BlzGroup* / BlzBit*)."""
from __future__ import annotations

import pathlib
import sys

ROOT = pathlib.Path(__file__).resolve().parents[1]
GROUP = ROOT / "_build/dependencies/wurstStdlib2/wurst/_handles/Group.wurst"
INTEGER = ROOT / "_build/dependencies/wurstStdlib2/wurst/_handles/primitives/Integer.wurst"

CLASSIC_GROUP_BLOCK = '''
int groupSizeResult = 0
int groupGetIndex = 0
int groupGetCursor = 0
unit groupGetResult = null
group groupMergeTarget = null
int groupMergeCount = 0

function groupCountCallback()
	groupSizeResult += 1

function groupGetCallback()
	if groupGetCursor == groupGetIndex
		groupGetResult = GetEnumUnit()
	groupGetCursor += 1

function groupAddCallback()
	if GroupAddUnit(groupMergeTarget, GetEnumUnit())
		groupMergeCount += 1

function groupRemoveCallback()
	if GroupRemoveUnit(groupMergeTarget, GetEnumUnit())
		groupMergeCount += 1

public function group.size() returns int
	groupSizeResult = 0
	ForGroup(this, function groupCountCallback)
	return groupSizeResult

public function group.isEmpty() returns bool
	return not this.hasNext()

/** Returns a random unit from this group without removing it
	or null if the group is empty */
public function group.getRandom() returns unit
	let size = this.size()
	if size > 0
		return this.get(GetRandomInt(0, size - 1))
	return null

public function group.immediateOrder(string order) returns bool
	return GroupImmediateOrder(this, order)

public function group.immediateOrderById(int order) returns bool
	return GroupImmediateOrderById(this, order)

public function group.pointOrder(string order, vec2 point) returns bool
	return GroupPointOrder(this, order, point.x, point.y)

public function group.pointOrderById(int order, vec2 point) returns bool
	return GroupPointOrderById(this, order, point.x, point.y)

public function group.targetOrder(string order, widget targetWidget) returns bool
	return GroupTargetOrder(this, order, targetWidget)

public function group.targetOrder(int order, widget targetWidget) returns bool
	return GroupTargetOrderById(this, order, targetWidget)

public function group.add(vararg group groups) returns int
	var i = 0
	for g in groups
		groupMergeTarget = this
		groupMergeCount = 0
		ForGroup(g, function groupAddCallback)
		i += groupMergeCount
	return i

public function group.remove(vararg group groups) returns int
	var i = 0
	for g in groups
		groupMergeTarget = this
		groupMergeCount = 0
		ForGroup(g, function groupRemoveCallback)
		i += groupMergeCount
	return i

public function group.get(int index) returns unit
	groupGetResult = null
	groupGetIndex = index
	groupGetCursor = 0
	ForGroup(this, function groupGetCallback)
	return groupGetResult
'''


def patch_group() -> None:
	if not GROUP.is_file():
		raise SystemExit(f"missing {GROUP}")
	text = GROUP.read_text(encoding="utf-8")
	if "BlzGroupGetSize" not in text:
		print("Group.wurst already classic-safe")
		return
	start = text.index("public function group.size() returns int")
	end = text.index("/* Group iterator */")
	GROUP.write_text(text[:start] + CLASSIC_GROUP_BLOCK.strip() + "\n\n" + text[end:], encoding="utf-8")
	print("patched Group.wurst (no BlzGroup*)")


def patch_integer() -> None:
	if not INTEGER.is_file():
		raise SystemExit(f"missing {INTEGER}")
	text = INTEGER.read_text(encoding="utf-8")
	if "BlzBitOr" not in text and "and32(other)" in text:
		print("Integer.wurst already classic-safe")
		return
	if "import initlater Bitwise" not in text and "import Bitwise" not in text:
		text = text.replace("import Real\n", "import Real\nimport initlater Bitwise\n", 1)
	elif "import Bitwise" in text and "import initlater Bitwise" not in text:
		text = text.replace("import Bitwise", "import initlater Bitwise")
	text = text.replace(
		"public function int.bitAnd(int other) returns int\n\treturn BlzBitAnd(this, other)",
		"public function int.bitAnd(int other) returns int\n\treturn this.and32(other)",
	)
	text = text.replace(
		"public function int.bitOr(int other) returns int\n\treturn BlzBitOr(this, other)",
		"public function int.bitOr(int other) returns int\n\treturn this.or32(other)",
	)
	text = text.replace(
		"public function int.bitXor(int other) returns int\n\treturn BlzBitXor(this, other)",
		"public function int.bitXor(int other) returns int\n\treturn this.xor32(other)",
	)
	text = text.replace(
		"public function int.isOdd() returns boolean\n\treturn BlzBitAnd(this, 1) == 1",
		"public function int.isOdd() returns boolean\n\treturn this.and32(1) == 1",
	)
	if "BlzBit" in text:
		raise SystemExit("Integer.wurst still references BlzBit* after patch")
	INTEGER.write_text(text, encoding="utf-8")
	print("patched Integer.wurst (no BlzBit*, initlater Bitwise)")


def main() -> int:
	patch_group()
	patch_integer()
	return 0


if __name__ == "__main__":
	raise SystemExit(main())
