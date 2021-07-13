import 'package:objd/core.dart';
import 'package:objd_crafting/objd_crafting.dart';

void main(List<String> args) {
  createProject(
      Project(
          name: "Creative Utilities",
          version: 16,
          target: "./Compiled Datapacks/",
          generate: CUWidget()),
      args);
  createProject(
      Project(
          name: "Pendants",
          version: 16,
          target: "./Compiled Datapacks/",
          generate: PendantWidget()),
      args);
  createProject(
      Project(
          name: "Pendants Crafting",
          version: 16,
          target: "./Compiled Datapacks/",
          generate: CraftingTable(
              name: "pcraft",
              main: [
                Execute.asat(Entity(tags: ["pTablePlacer"]),
                    children: [File.execute("set", create: false)]),
                Kill(Entity(tags: ["pTablePlacer"]))
              ],
              displayName: createTextComponent("Pendant Table", packColors[0]),
              placeholder:
                  Item(Items.gray_stained_glass_pane, name: TextComponent("")),
              blockModel: Item(Items.sheep_spawn_egg, model: 1, count: 1),
              onDestroy: Summon(EntityType("item"),
                  location: Location.rel(y: 0.7),
                  nbt: {
                    "Item": Item(Items.sheep_spawn_egg,
                        name: createTextComponent("Pendant Table", Color.Gold,
                            italic: false),
                        count: 1,
                        model: 1,
                        nbt: {
                          "EntityTag": Summon(EntityType("armor_stand"),
                              tags: ["pTablePlacer"],
                              nbt: {"Invisible": 1, "small": 1}).getMap()
                        }).getMap()
                  }),
              recipes: [
                Recipe(
                    {
                      2: Item(Items.prismarine_crystals),
                      4: Item(Items.prismarine_shard),
                      5: Item(Items.nautilus_shell),
                      6: Item(Items.scute),
                      8: Item(Items.heart_of_the_sea)
                    },
                    Item(Items.nautilus_shell,
                        count: 1,
                        name: createTextComponent("Dolphin Pendant", Color.Gold,
                            italic: false),
                        nbt: {
                          "swiftswim": 1,
                          "Enchantments": [
                            {"id": "protection", "lvl": 0}
                          ]
                        },
                        hideFlags: 1),
                    name: "dolphin_pendant")
              ])),
      args);
}

TextComponent createTextComponent(String text, Color color, {bool italic}) {
  return TextComponent(text, color: color, italic: italic);
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

List<Slot> PendantCheck = [Slot.MainHand, Slot.OffHand];
List<Widget> mainPendantFile = [
  Command(
      "execute if entity @p[nbt={SelectedItem:{id:'minecraft:nautilus_shell', tag:{swiftswim:1}}}] run effect give @a[nbt={SelectedItem:{id:'minecraft:nautilus_shell', tag:{swiftswim:1}}}] dolphins_grace 1 0"),
  Command(
      "execute if entity @p[nbt={SelectedItem:{id:'minecraft:nautilus_shell', tag:{swiftswim:1}}}] run effect give @a[nbt={SelectedItem:{id:'minecraft:nautilus_shell', tag:{swiftswim:1}}}] water_breathing 1 0")
];

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
