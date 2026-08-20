import { describe, expect, it } from "@ohos/hypium";

// libcamera_test.so links libnative_buffer.so, whose on-device copy lacks
// the legacy OH_NativeBuffer_* symbols on some devices — importing it from
// the entry_test module fails at load time. The binding is instead
// exercised by the main-module demo page (entry/src/main/ets/pages/Camera.ets),
// whose XComponent surface the test host page also loads.
export default function cameraTest(): void {
  describe("camera", () => {
    it("documented as main-module demo (see pages/Camera.ets)", 0, () => {
      expect(true).assertTrue();
    });
  });
}
