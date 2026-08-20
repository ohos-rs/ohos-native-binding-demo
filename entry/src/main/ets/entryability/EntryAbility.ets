import { AbilityConstant, UIAbility, Want } from "@kit.AbilityKit";
import { hilog } from "@kit.PerformanceAnalysisKit";
import { window } from "@kit.ArkUI";

const DOMAIN = 0x0000;

export default class EntryAbility extends UIAbility {
  onCreate(_want: Want, _launchParam: AbilityConstant.LaunchParam): void {
    hilog.info(DOMAIN, "testTag", "%{public}s", "Ability onCreate");
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    hilog.info(DOMAIN, "testTag", "%{public}s", "Ability onWindowStageCreate");
    // OhosTestHost publishes the XComponent / NodeContent / Web surfaces the
    // ohosTest Hypium suite drives. TestAbility shares this process, so the
    // AppStorage-published surfaces are visible to it. Navigate to the demo
    // menu (pages/Index) after a short delay.
    windowStage.loadContent("pages/OhosTestHost", (err) => {
      if (err.code) {
        hilog.error(
          DOMAIN,
          "testTag",
          "Failed to load content. Cause: %{public}s",
          JSON.stringify(err),
        );
        return;
      }
      hilog.info(DOMAIN, "testTag", "Succeeded in loading the content.");
    });
  }

  onForeground(): void {
    hilog.info(DOMAIN, "testTag", "%{public}s", "Ability onForeground");
  }

  onBackground(): void {
    hilog.info(DOMAIN, "testTag", "%{public}s", "Ability onBackground");
  }
}
