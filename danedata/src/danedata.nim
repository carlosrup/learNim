import std/[parsecsv, tables, times, parseutils, strutils, sequtils, sugar, math]
import danedata/utils
import print

const 
  fuente = "Fuente"
  fecha = "FechaEncuesta"
  grupo = "Grupo"
  ali = "Ali"
  cantidad = "Cant Kg"


#[ var df11 = {"Fuente": @[newVString("perro"), newVDateTime(parse("01/07/1977", "d/M/yyyy")), newVFloat(15.6)]}.toOrderedTable
echo getDateTime(df11["Fuente"][1])
echo df11["Fuente"][1].dateTimeV
df11["Fuente"].add(newVFloat(2.6))
df11["Fuente"].add(Value(kind:VFloat, floatV:18.9)) ]#


let data = "InfoAbaste221072022.csv"

var parserCvs: CsvParser
parserCvs.open(data, separator = ';')
parserCvs.readHeaderRow()
var count = 0

var df: DataFrame

while parserCvs.readRow() #[ and count < 65000 ]#:
  for header in items(parserCvs.headers):
    if header notin df:
      df[header] = newSeq[Value]()
    
    case header 
    of fuente: 
      df[header].add(
        newVString(parserCvs.rowEntry(header))
      )
    of fecha: 
      df[header].add(
        newVDateTime(parse(parserCvs.rowEntry(header), "d/M/yyyy"))
      )
    of grupo: 
      df[header].add(
        newVString(parserCvs.rowEntry(header))
      )
    of ali: 
      df[header].add(
        newVString(parserCvs.rowEntry(header))
      )
    of cantidad: 
      df[header].add(
        newVFloat(
          parseFloat((parserCvs.rowEntry(header)).replace(',','.'))
        )
      )
    else: discard
        
  #[  count.inc  ]#
  #echo parserCvs.processedRows()
  #echo parserCvs.headers 
parserCvs.close()

proc sumMarketCant(df: DataFrame, column: string, market: string): float =
  for index, element in df[column]:
    if getString(element) == market:
      result += getFloat(df["Cant Kg"][index])
     


let markets = deduplicate(df["Fuente"])
var selection: Table[string, float]

for market in markets:
  selection[getString(market)] = sumMarketCant(df, "Fuente", getString(market))
        
echo selection