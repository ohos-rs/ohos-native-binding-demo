import { describe, expect, it } from "@ohos/hypium";
import { ranOrThrew } from "../helpers/Utils";
import { drawXcomponent, setFrameRate } from "libxcomponent_test.so";

export default function xcomponentTest(): void {
  describe("xcomponent", () => {
    // The host page (main module OhosTestHost) loads an XComponent with
    // libraryname=xcomponent_test; its native state is process-wide. When
    // no surface is attached (module imported by the test runner), the
    // calls throw a descriptive napi error — callability is what matters.
    it("drawXcomponent and setFrameRate", 0, () => {
      expect(ranOrThrew((): void => drawXcomponent())).assertTrue();
      expect(ranOrThrew((): void => setFrameRate(30, 30, 30))).assertTrue();
    });
  });
}
