import std/[tables, times]

type
  ValueKind = enum
    VString, VDateTime, VFloat

  Value = object
    case kind*: ValueKind
    of VString:
      stringV*: string
    of VDateTime:
      dateTimeV*: DateTime
    of VFloat:
      floatV*: float

  DataFrame = OrderedTable[string, seq[Value]]

proc newVString(val = string.default): Value = 
  Value(kind: VString, stringV: val)

proc newVDateTime(val = DateTime.default): Value = 
  Value(kind: VDateTime, dateTimeV: val)

proc newVFloat(val: float): Value = 
  Value(kind: VFloat, floatV: val)

proc getString(val: Value): string = 
  assert val.kind == VString
  val.stringV

proc getDateTime(val: Value): DateTime  = 
  assert val.kind == VDateTime
  val.dateTimeV

proc  getFloat(val: Value): float =
  assert val.kind == VFloat
  val.floatV