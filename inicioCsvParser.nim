import std/[parsecsv, tables, times, parseutils, strutils]



const 
  fuente = "Fuente"
  fecha = "FechaEncuesta"
  grupo = "Grupo"
  ali = "Ali"
  cantidad = "Cant Kg"


#[ ar df11 = {"Fuente": @[newVString("perro"), newVDateTime(parse("01/07/1977", "d/M/yyyy")), newVFloat(15.6)]}.toOrderedTable
echo getDateTime(df11["Fuente"][1])
echo df11["Fuente"][1].dateTimeV
df11["Fuente"].add(newVFloat(2.6))
df11["Fuente"].add(Value(kind:VFloat, floatV:18.9))
echo df11 ]#

let data = "InfoAbaste221072022.csv"

var parserCvs: CsvParser
parserCvs.open(data, separator = ';')
parserCvs.readHeaderRow()
var count = 0

var df: DataFrame

while parserCvs.readRow() and count < 5000:
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
      
    #[ df[header].add(parserCvs.rowEntry(header)) ]#
    #[ echo "##", header, ":", parserCvs.rowEntry(header), "##" ]#
    count.inc 
    
#[ echo parserCvs.processedRows()
echo parserCvs.headers ]#
parserCvs.close()
echo df

