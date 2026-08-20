import { AbilityConstant, UIAbility, Want } from "@kit.AbilityKit";
import { window } from "@kit.ArkUI";
import { hilog } from "@kit.PerformanceAnalysisKit";
import { abilityDelegatorRegistry } from "@kit.TestKit";
import { Hypium } from "@ohos/hypium";
import testsuite from "../test/List.test";

const TAG: string = "bindingsOhosTest";

export default class TestAbility extends UIAbility {
  private abilityDelegator: abilityDelegatorRegistry.AbilityDelegator =
    abilityDelegatorRegistry.getAbilityDelegator();

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(0x0000, TAG, "TestAbility onCreate %{public}s", JSON.stringify(want));
    hilog.info(0x0000, TAG, "launchParam %{public}s", JSON.stringify(launchParam));
  }

  onDestroy(): void {
    hilog.info(0x0000, TAG, "TestAbility onDestroy");
  }

  onWindowStageCreate(_windowStage: window.WindowStage): void {
    // The ohosTest ArkTS pipeline (arkdown) cannot register router pages for
    // the entry_test module — loadContent of any page fails with "page not
    // found". Host-surface-dependent bindings (XComponent / ArkUI / Web) are
    // instead hosted by the main module's OhosTestHost page: the main
    // EntryAbility and TestAbility share the bundle process by default, so
    // the surfaces published via AppStorage are visible here. Run
    // `pnpm start` (or otherwise launch the app) before `pnpm test`.
    hilog.info(0x0000, TAG, "TestAbility onWindowStageCreate");
    const args = abilityDelegatorRegistry.getArguments();
    Hypium.hypiumTest(this.abilityDelegator, args, testsuite);
  }
}
