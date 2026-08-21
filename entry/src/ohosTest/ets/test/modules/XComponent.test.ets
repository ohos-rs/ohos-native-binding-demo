import { describe, expect, it } from "@ohos/hypium";
import { drawXcomponent, setFrameRate, surfaceEvents } from "libxcomponent_test.so";
import { eventsById } from "libxcomponent_multi_test.so";

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

  describe("xcomponent_multi", () => {
    // multi_mode dispatch keys callbacks by XComponent id. Without a host
    // surface the map stays empty — the deterministic baseline. The
    // per-id dispatch itself is verified on the main app's OhosTestHost
    // page, which mounts two XComponents (ids ohosTest_xc_multi_a/b) bound
    // to this same library; each id accumulates its own created counter.
    it("no-surface map is empty", 0, () => {
      expect(eventsById()).assertEqual("");
    });
  });
}
