import 'entity.dart';

class Category extends Entity {
  String description;

  Category(this.description);

  Category.withId(id, this.description);

  @override
  Map<String, Object?> toJson() => {
        'id': id,
        'description': description,
      };
}
