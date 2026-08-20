import { describe, expect, it } from "@ohos/hypium";
import { NodeContent } from "@kit.ArkUI";
import { MyApp } from "libarkui_test.so";

export default function arkuiTest(): void {
  describe("arkui", () => {
    // The host page (main module OhosTestHost) hosts a NodeContent slot with
    // a live MyApp instance driving native ArkUI nodes. Constructing an
    // instance here verifies the binding surface; individual node methods
    // may throw when no ArkUI UIContext is attached to this runner.
    it("MyApp is constructible", 0, () => {
      expect(typeof MyApp === "function").assertTrue();
      let constructed: boolean = false;
      try {
        const app: MyApp = new MyApp(new NodeContent());
        constructed = true;
        app.destroyNativeNode();
      } catch (e) {
        console.info(`arkuiTest: ${e}`);
      }
      expect(constructed).assertTrue();
    });
  });
}
