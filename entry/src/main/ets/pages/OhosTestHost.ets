import { NodeContent, router } from "@kit.ArkUI";
import { webview } from "@kit.ArkWeb";

interface XComponentAttrs {
  id: string;
  type: number;
  libraryname: string;
}

/**
 * Host surfaces for the ohosTest Hypium suite. Lives in the main module
 * because the ohosTest HAP's ArkTS pipeline (arkdown) does not register
 * router pages — loadContent from TestAbility ends in "page not found".
 * Instead the app is started (`pnpm start`) before `pnpm test`; both
 * abilities share the bundle process, so the napi .so modules loaded by
 * this page expose the same process-wide native state to the test code.
 *
 * XComponent libraries must be loaded via libraryname (not import "lib*.so"),
 * otherwise module_exports calls XComponent::init without
 * __NATIVE_XCOMPONENT_OBJ__ and the process aborts.
 */
@Entry
@Component
struct OhosTestHost {
  private xcomponentAttrs: XComponentAttrs = {
    id: "ohosTest_xcomponent",
    type: XComponentType.SURFACE,
    libraryname: "xcomponent_test",
  };
  private arkuiInputAttrs: XComponentAttrs = {
    id: "ohosTest_arkui_input",
    type: XComponentType.SURFACE,
    libraryname: "arkui_input_test",
  };
  private nativeWindowAttrs: XComponentAttrs = {
    id: "ohosTest_native_window",
    type: XComponentType.SURFACE,
    libraryname: "native_window_test",
  };
  private cameraAttrs: XComponentAttrs = {
    id: "ohosTest_camera",
    type: XComponentType.SURFACE,
    libraryname: "camera_test",
  };
  private webController: webview.WebviewController = new webview.WebviewController();
  private arkuiSlot: NodeContent = new NodeContent();

  build() {
    Column({ space: 4 }) {
      Text("ohos-native-bindings ohosTest host")
        .fontSize(14)
        .margin({ top: 12 })
      Button("demo menu")
        .fontSize(12)
        .height(28)
        .onClick((): void => {
          router.pushUrl({ url: "pages/Index" });
        })
      Row({ space: 4 }) {
        XComponent(this.xcomponentAttrs)
          .width("50%")
          .height(72)
        XComponent(this.arkuiInputAttrs)
          .width("50%")
          .height(72)
          .focusable(true)
      }
      .width("100%")
      .height(72)
      Row({ space: 4 }) {
        XComponent(this.nativeWindowAttrs)
          .width("50%")
          .height(72)
        XComponent(this.cameraAttrs)
          .width("50%")
          .height(72)
      }
      .width("100%")
      .height(72)
      Column() {
        ContentSlot(this.arkuiSlot)
      }
      .width("100%")
      .height(72)
      Web({ controller: this.webController, src: "about:blank" })
        .id("ohosTest_web")
        .width("100%")
        .height(96)
        .javaScriptAccess(true)
        .domStorageAccess(true)
    }
    .width("100%")
    .height("100%");
  }
}
