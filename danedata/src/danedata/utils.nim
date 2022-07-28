import std/[tables, times]

type
  ValueKind* = enum
    VString, VDateTime, VFloat

  Value* = object
    case kind*: ValueKind
    of VString:
      stringV*: string
    of VDateTime:
      dateTimeV*: DateTime
    of VFloat:
      floatV*: float

  DataFrame* = OrderedTable[string, seq[Value]]

proc newVString*(val = string.default): Value = 
  Value(kind: VString, stringV: val)

proc newVDateTime*(val = DateTime.default): Value = 
  Value(kind: VDateTime, dateTimeV: val)

proc newVFloat*(val: float): Value = 
  Value(kind: VFloat, floatV: val)

proc getString*(val: Value): string = 
  assert val.kind == VString
  val.stringV

proc getDateTime*(val: Value): DateTime  = 
  assert val.kind == VDateTime
  val.dateTimeV

proc  getFloat*(val: Value): float =
  assert val.kind == VFloat
  val.floatV

proc `$`*(val: Value): string = 
  case val.kind
  of VString:
    result.addQuoted(val.stringV)
  of VFloat:
    result.add($val.floatV)
  of VDateTime:
    result.add($val.dateTimeV)

proc `==`*(val1, val2: Value): bool = 
  if val1.kind != val2.kind: return false

  case val1.kind
  of VString:
    result = val1.stringV == val2.stringV
  of VFloat:
    result = val1.floatV == val2.floatV
  of VDateTime:
    result = val1.dateTimeV == val2.dateTimeV



  