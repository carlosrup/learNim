import std/[parsecsv, tables]
import datamancer, strutils, times

const 
  carnes: string = "CARNES"
  lacteos: string = "LACTEOS Y HUEVOS"
  procesados: string = "PROCESADOS"
  pescados: string = "PESCADOS"
  granos: string = "GRANOS Y CEREALES"

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

let 
  csvTable = createTableFromCsv("base_Mdiciembre.csv")
  fuenteSeq = csvTable["Fuente"]
  fechaSeq = csvTable["FechaEncuesta"]
  grupoSeq = csvTable["Grupo"]
  aliSeq = csvTable["Ali"]
  cantKgSeq = csvTable["Cant Kg"]

let df = seqsToDf({
  "Fuente": fuenteSeq,
  "FechaEncuesta": fechaSeq,
  "Grupo": grupoSeq,
  "Ali": aliSeq, 
  "Cant Kg": cantKgSeq
}).mutate(f{string -> float: "Cant Kg" ~ (idx("Cant Kg").replace(",",".")).parseFloat})

let timeFormat = initTimeFormat("d/M/yyyy")

let df1 = df.mutate(f{string -> TimeFormat: "Fecha" ~ (idx("FechaEncuesta")).parse(timeFormat).format(timeFormat)})

let dfFuente = df.group_by("Fuente").mutate(f{float: "CantXfuente" << sum(col("Cant Kg"))})

let dfGrupo =  df.group_by("Grupo").mutate(f{float: "CantXgrupo" << sum(col("Cant Kg"))})

let dfOtrosGrupos =  df.mutate(
  f{string: "Otros Grupos" ~ (
    idx("Grupo").multiReplace(
      (carnes, "OTROS GRUPOS"), 
      (lacteos, "OTROS GRUPOS"),
      (procesados, "OTROS GRUPOS"), 
      (pescados, "OTROS GRUPOS"),
      (granos, "OTROS GRUPOS"),

    )
  )}
)
let dfTotalPorGrupos = dfOtrosGrupos.group_by(
  "Otros Grupos").mutate(
    f{float: "TotalXGrupo" << sum(col("Cant Kg"))})


let totalXfuente =  dfFuente.unique("CantXfuente").pretty(precision= 10)

