import { describe, expect, it } from "@ohos/hypium";
import { lastEvent } from "libarkui_input_test.so";

export default function arkuiInputTest(): void {
  describe("arkui_input", () => {
    // The host page (main module OhosTestHost) loads an XComponent with
    // libraryname=arkui_input_test; lastEvent reports process-wide native
    // input state.
    it("lastEvent", 0, () => {
      expect(lastEvent().length > 0).assertTrue();
    });
  });
}
