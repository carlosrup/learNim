import std/parsecsv
import std/tables


#[ type Entry = object
    fuente*: string
    fechaEncuesta*: string
    grupo*: string
    ali*: string
    cantKg*: string ]#

proc createTableFromCsv(csvPath: string): Table[string, seq[string]] =
  result = {"Fuente": newSeq[string](), "FechaEncuesta": newSeq[string](),
   "Grupo": newSeq[string](), "Ali": newSeq[string](), "Cant Kg": newSeq[string]()}.toTable
  
  var parser: CsvParser

  parser.open(csvPath, separator = ';')
  defer: parser.close()

  #[ var table: seq[tuple[title, value: string]] ]#

  parser.readHeaderRow()
  while parser.readRow():
    
    result["Fuente"].add(parser.rowEntry("Fuente"))
    result["FechaEncuesta"].add(parser.rowEntry("FechaEncuesta"))
    result["Grupo"].add(parser.rowEntry("Grupo"))
    result["Ali"].add(parser.rowEntry("Ali"))
    result["Cant Kg"].add(parser.rowEntry("Cant Kg"))
    

#[ var df = readCsv("base_Mdiciembre.csv", sep=';') ]#

#[ let data= "Armenia, Mercar;1/12/2021;10:25;PICK UP;ARK791;null;'63;QUIND�O;'63470;MONTENEGRO;null;null;;TUBERCULOS, RAICES Y PLATANOS;Pl�tano hart�n verde;150;RACIMO;12;1800;EMTABARESP" ]#


echo createTableFromCsv("base_Mdiciembre.csv")