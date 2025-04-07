import 'package:quail_57/gameplay/domain/entity/emmy.dart';
import 'package:quail_57/gameplay/domain/entity/entity.dart';

class You extends Emmy {
  You({super.id, super.previousMove, EmmyType? emmyType})
    : super(type: EntityType.you, emmyType: emmyType ?? EmmyType.grub);

  @override
  You withEmmyType(EmmyType newEmmyType) {
    return You(id: id, previousMove: previousMove, emmyType: newEmmyType);
  }
}
