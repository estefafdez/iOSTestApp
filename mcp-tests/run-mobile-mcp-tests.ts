// Drives mobile-mcp against a booted iOS Simulator running TestApp.
// Real assertions on the accessibility tree plus a screenshot per step.
// Usage: node run-mobile-mcp-tests.ts --app /path/to/TestApp.app --out ./screenshots
import { Client } from "@modelcontextprotocol/sdk/client/index.js";
import { StdioClientTransport } from "@modelcontextprotocol/sdk/client/stdio.js";
import { mkdirSync, writeFileSync } from "node:fs";
import { join } from "node:path";

interface ScreenElement {
  ref?: string;
  id?: string;
  label?: string;
  name?: string;
  identifier?: string;
  text?: string;
  value?: string;
  coordinates?: { x: number; y: number };
  x?: number;
  y?: number;
}

const args: string[] = process.argv.slice(2);
const opt = (name: string, fallback: string | null): string | null => {
  const i = args.indexOf(`--${name}`);
  return i >= 0 ? args[i + 1] : fallback;
};
const APP_PATH = opt("app", null);
const OUT_DIR = opt("out", "./screenshots") as string;
const BUNDLE_ID = "com.estefafdez.ios.test.app";
mkdirSync(OUT_DIR, { recursive: true });

const transcript: Array<{ step: string; detail: string; at: string }> = [];
const record = (step: string, detail: string): void => {
  transcript.push({ step, detail, at: new Date().toISOString() });
  console.log(`[step] ${step}: ${detail}`);
};

const transport = new StdioClientTransport({
  command: "npx",
  args: ["-y", "@mobilenext/mobile-mcp@1.0.13"],
});
const client = new Client({ name: "mobile-mcp-ci-client", version: "1.0.0" });
await client.connect(transport);
record("connect", "connected to mobile-mcp server");

const call = async (name: string, callArgs: Record<string, unknown> = {}): Promise<string> => {
  const res = await client.callTool({ name, arguments: callArgs });
  const text = (res.content as Array<{ text?: string }> | undefined)
    ?.map((c) => c.text ?? "")
    .join("\n") ?? "";
  if (res.isError) throw new Error(`${name} failed: ${text}`);
  return text;
};

// --- device selection ---
const devicesRaw = await call("mobile_list_available_devices");
const parsed = JSON.parse(devicesRaw);
const devices = Array.isArray(parsed) ? parsed : parsed.devices ?? [];
if (devices.length === 0) {
  record("devices", "NO DEVICES AVAILABLE - cannot run");
  writeFileSync(join(OUT_DIR, "transcript.json"), JSON.stringify(transcript, null, 2));
  process.exit(2);
}
const device = devices.find((d: any) => String(d.platform ?? d.type ?? "").toLowerCase().includes("ios")) ?? devices[0];
const deviceId: string = device.id ?? device.deviceId ?? device.uuid;
record("devices", `using ${JSON.stringify(device)}`);

const shot = async (name: string): Promise<void> => {
  await call("mobile_save_screenshot", { device: deviceId, saveTo: join(OUT_DIR, `${name}.png`) });
  record("screenshot", `${name}.png`);
};

const elements = async (): Promise<ScreenElement[]> => {
  const raw = await call("mobile_list_elements_on_screen", { device: deviceId });
  const parsedEls = JSON.parse(raw);
  return Array.isArray(parsedEls) ? parsedEls : parsedEls.elements ?? [];
};

const findElement = (els: ScreenElement[], needle: string): ScreenElement | undefined => {
  const lower = needle.toLowerCase();
  return els.find((e) =>
    [e.label, e.name, e.identifier, e.text, e.value]
      .filter(Boolean)
      .some((v) => String(v).toLowerCase().includes(lower)));
};

const tap = async (el: ScreenElement): Promise<void> => {
  await call("mobile_click_on_screen_at_coordinates", {
    device: deviceId,
    ref: el.ref ?? String(el.id ?? ""),
    x: el.coordinates?.x ?? el.x,
    y: el.coordinates?.y ?? el.y,
  });
};

const tapText = async (needle: string): Promise<void> => {
  const els = await elements();
  const el = findElement(els, needle);
  if (!el) throw new Error(`element not found: ${needle}. Screen: ${JSON.stringify(els).slice(0, 400)}`);
  await tap(el);
  record("tap", needle);
};

const typeInto = async (needle: string, text: string): Promise<void> => {
  const els = await elements();
  const el = findElement(els, needle);
  if (!el) throw new Error(`field not found: ${needle}`);
  await tap(el);
  await call("mobile_type_keys", { device: deviceId, text, submit: false });
  record("type", `${needle} <- "${text}"`);
};

const assertVisible = async (needle: string, shotName?: string): Promise<void> => {
  const els = await elements();
  const el = findElement(els, needle);
  if (!el) throw new Error(`ASSERT FAILED: "${needle}" not visible. Screen: ${JSON.stringify(els).slice(0, 600)}`);
  record("assert", `"${needle}" visible OK`);
  if (shotName) await shot(shotName);
};

const sleep = (ms: number): Promise<void> => new Promise((r) => setTimeout(r, ms));

try {
  if (APP_PATH) {
    await call("mobile_install_app", { device: deviceId, path: APP_PATH });
    record("install", APP_PATH);
  }
  // Retry the launch: simctl can fail transiently right after install (exit 4).
  let launched = false;
  let lastLaunchError = "";
  for (let attempt = 1; attempt <= 3 && !launched; attempt++) {
    try {
      await call("mobile_launch_app", { device: deviceId, packageName: BUNDLE_ID });
      launched = true;
    } catch (err) {
      lastLaunchError = err instanceof Error ? err.message : String(err);
      record("launch-retry", `attempt ${attempt} failed: ${lastLaunchError.slice(0, 200)}`);
      await sleep(5000);
    }
  }
  if (!launched) {
    // Collect crash reports so the CI artifact explains the failure.
    try {
      const crashesRaw = await call("mobile_list_crashes", { device: deviceId });
      record("crashes", crashesRaw.slice(0, 2000));
      const crashes = JSON.parse(crashesRaw);
      const list = Array.isArray(crashes) ? crashes : crashes.crashes ?? [];
      if (list.length > 0) {
        const first = list[0];
        const id = first.id ?? first.name ?? first;
        const crash = await call("mobile_get_crash", { device: deviceId, id });
        record("crash-detail", crash.slice(0, 4000));
      }
    } catch (diagErr) {
      record("crash-diag-failed", String(diagErr).slice(0, 300));
    }
    throw new Error(`launch failed after retries: ${lastLaunchError.slice(0, 300)}`);
  }
  await sleep(3000);
  record("launch", BUNDLE_ID);
  await shot("01-home");

  // Scenario 1: form validation
  await tapText("open_form_button");
  await sleep(1000);
  await tapText("form_submit_button"); // empty submit
  await assertVisible("Completa todos los campos", "02-form-error-empty");
  await typeInto("form_email_textbox", "not-an-email");
  await typeInto("form_password_textbox", "supersecret");
  await tapText("form_submit_button");
  await assertVisible("El email no tiene un formato válido", "03-form-error-email");
  await typeInto("form_email_textbox", "qa@example.com");
  await typeInto("form_password_textbox", "supersecret");
  await tapText("form_submit_button");
  await assertVisible("form_success_label", "04-form-success");
  await shot("05-form-done");

  // Scenario 2: list states
  await call("mobile_press_button", { device: deviceId, button: "HOME" });
  await sleep(1500);
  await call("mobile_launch_app", { device: deviceId, packageName: BUNDLE_ID });
  await sleep(2000);
  await tapText("open_list_button");
  await sleep(1500);
  await assertVisible("Caso de prueba: login", "06-list-success");
  await tapText("Error");
  await sleep(1500);
  await assertVisible("No se pudo cargar la lista", "07-list-error");

  record("done", "all scenarios passed");
  writeFileSync(join(OUT_DIR, "transcript.json"), JSON.stringify(transcript, null, 2));
  await client.close();
  process.exit(0);
} catch (err) {
  record("FAILED", err instanceof Error ? err.message : String(err));
  writeFileSync(join(OUT_DIR, "transcript.json"), JSON.stringify(transcript, null, 2));
  await shot("99-failure").catch(() => {});
  await client.close();
  process.exit(1);
}
