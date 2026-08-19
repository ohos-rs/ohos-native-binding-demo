import { router } from "@kit.ArkUI";

interface DemoEntry {
  name: string;
  page: string;
  note: string;
}

@Entry
@Component
struct Index {
  private demos: DemoEntry[] = [
    { name: "ArkUI", page: "pages/ArkUI", note: "node tree / dialog / input / animation" },
    { name: "ArkWeb", page: "pages/ArkWeb", note: "web proxy postMessage" },
    { name: "DisplaySoloist", page: "pages/DisplaySoloist", note: "soloist frame callback" },
    { name: "Hilog", page: "pages/Hilog", note: "log / info redirect" },
    { name: "IME", page: "pages/Ime", note: "input method attach/show/hide" },
    { name: "JSVM", page: "pages/Jsvm", note: "napi value roundtrips in JSVM" },
    { name: "NetConnection", page: "pages/NetConnection", note: "default http proxy" },
    { name: "Pasteboard", page: "pages/Pasteboard", note: "clipboard read" },
    { name: "Raw", page: "pages/Raw", note: "rawfile dir listing" },
    { name: "Sensor", page: "pages/Sensor", note: "accelerometer subscribe" },
    { name: "Vibrator", page: "pages/Vibrator", note: "vibrate / custom effect" },
    { name: "Vsync", page: "pages/Vsync", note: "frame callbacks" },
    { name: "XComponent", page: "pages/XComp", note: "surface + GL + touch" },
  ];

  build() {
    Column() {
      Text("ohos-native-bindings demos")
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 48, bottom: 16 })
      List({ space: 4 }) {
        ForEach(
          this.demos,
          (demo: DemoEntry) => {
            ListItem() {
              Column() {
                Text(demo.name)
                  .fontSize(18)
                  .fontWeight(FontWeight.Medium)
                Text(demo.note)
                  .fontSize(12)
                  .fontColor("#666666")
              }
              .width("100%")
              .alignItems(HorizontalAlign.Start)
              .padding(10)
              .onClick(() => {
                router.pushUrl({ url: demo.page });
              })
            };
          },
          (demo: DemoEntry) => demo.page,
        )
      }
      .width("92%")
      .layoutWeight(1)
    }
    .width("100%")
    .height("100%")
    .alignItems(HorizontalAlign.Center);
  }
}
