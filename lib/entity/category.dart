import 'entity.dart';

class Category extends Entity {
  String description;

  Category(this.description);

  Category.withId(int id, this.description) {
    super.id = id;
  }

  @override
  Map<String, Object?> toJson() => {
        'id': id,
        'description': description,
      };

  @override
  String toString() {
    return '{ id: ${id}, description: ${description} }';
  }
}
