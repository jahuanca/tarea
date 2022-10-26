
abstract class ExportDataRepository{

  Future<void> exportToExcel(dynamic data);
  Future<void> exportToExcelPacking(int key);
  Future<void> exportToExcelSeleccion(int key);
  Future<void> exportToExcelPesado(int key);
  Future<void> exportToExcelTarea(int key);
  Future<void> exportToExcelPersonalPreTareEsparrago(int idDBPreTarea);
}