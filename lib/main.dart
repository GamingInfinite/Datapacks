import 'package:objd/core.dart';

void main(List<String> args) {
  createProject(
      Project(
          name: "Creative Utilities",
          version: 16,
          target: "./Compiled Datapacks",
          generate: CUWidget()),
      args);
  createProject(
      Project(
          name: "Pendants",
          version: 16,
          target: "./Compiled Datapacks",
          generate: PendantWidget()),
      args);
}

TextComponent createTextComponent(String text, Color color) {
  return TextComponent(text, color: color);
}

List<Color> packColors = [
  Color.fromRGB(255, 204, 0),
  Color.fromRGB(252, 3, 244)
];
Color AuthorColor = Color.fromRGB(108, 0, 232);
Score butcher = Score(Entity.All(tags: ["isOp"]), "butcher");
List<Widget> mainCUFile = [
  Scoreboard.trigger("butcher", addIntoLoad: true),
  Do.Until(Tag("butcherDisabled", entity: Entity.All()), then: [
    Trigger.enable(butcher, addNew: false),
    If(Condition.score(Score(Entity.Player(), "butcher").matches(1)), then: [
      Kill(Entity(selector: "e", type: EntityType("!player"))),
      butcher.set(0)
    ])
  ])
];
List<Widget> mainPendantFile = [];

class CUWidget extends Widget {
  @override
  generate(Context context) {
    return Pack(
        name: "creativeutilities",
        main: File('main', child: For.of(mainCUFile)),
        load: File('load',
            child: For.of([
              Tellraw(Entity.All(), show: [
                createTextComponent("Loaded ", Color.Gold),
                createTextComponent("Creative Utilities ", packColors[0]),
                createTextComponent("by ", Color.Gold),
                createTextComponent("GInfinity (GamingInfinite)", AuthorColor)
              ])
            ])));
  }
}

class PendantWidget extends Widget {
  @override
  generate(Context context) {
    return Pack(
        name: "pendants",
        main: File('main', child: For.of(mainPendantFile)),
        load: File('load',
            child: For.of([
              Tellraw(Entity.All(), show: [
                createTextComponent("Loaded ", Color.Gold),
                createTextComponent("Pendants ", packColors[1]),
                createTextComponent("by ", Color.Gold),
                createTextComponent("GInfinity (GamingInfinite)", AuthorColor)
              ])
            ])));
  }
}
