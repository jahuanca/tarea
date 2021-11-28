
abstract class ExportDataRepository{

  Future<void> exportToExcel(dynamic data);
  Future<void> exportToExcelPacking(int key);
}