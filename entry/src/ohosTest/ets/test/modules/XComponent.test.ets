import { describe, expect, it } from "@ohos/hypium";
import { ranOrThrew } from "../helpers/Utils";
import { drawXcomponent, setFrameRate, surfaceEvents } from "libxcomponent_test.so";

export default function xcomponentTest(): void {
  describe("xcomponent", () => {
    // In the aa-test process no XComponent host page is loaded (arkdown
    // cannot register entry_test router pages and startAbility of the main
    // EntryAbility does not create a window in test mode), so the library's
    // process state is the "no surface" baseline. These tests pin that
    // baseline: the surface counters stay at zero and the locked setters
    // report deterministic errors instead of crashing.
    it("no-surface baseline is deterministic", 0, () => {
      expect(surfaceEvents()).assertEqual("created=0 destroyed=0 last=0x0");
    });

    it("drawXcomponent without surface is a no-op", 0, () => {
      // GL_CTX lock is held with None; the call returns without drawing.
      drawXcomponent();
      expect(true).assertTrue();
    });

    it("setFrameRate without surface reports not initialized", 0, () => {
      let message: string = "";
      try {
        setFrameRate(30, 30, 30);
      } catch (e) {
        message = `${e}`;
      }
      expect(message).assertContain("not initialized");
    });
  });
}
