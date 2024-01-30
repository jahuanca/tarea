import 'package:flutter_tareo/domain/packing/repositories/personal_packing_repository.dart';

class DeleteUvaDetalleUseCase {
  final PersonalPackingRepository _uvaDetalle;

  DeleteUvaDetalleUseCase(this._uvaDetalle);

  Future<void> execute(String box) async {
    return await _uvaDetalle.deleteAll(box);
  }
}
