import { describe, expect, it } from "vitest";
import {
  distros,
  getDistroMarkdown,
  getDistroMeta,
  getDistroName,
  parseDistroMarkdown,
} from "./benchmarks";

const SAMPLE = `# Demo Benchmark Results

Intro paragraph describing the run.

## Table of Contents
1. [System Information](#system-information)

## System Information

### Hardware
- **Processor**: 2 x Intel Core i5
- **Memory**: \`4096MB\`

### Software
- **OS**: Ubuntu 24.04
- **Kernel**: 6.8.0-49-generic

---

## C-Ray Benchmark

### Test Identifier: \`pts/c-ray-2.0.0\`

#### Title: C-Ray
- **App Version**: 2.0
- **Arguments**: \`-s 1920x1080 -r 16\`
- **Description**: Resolution: 1080p - Rays Per Pixel: 16

### Detailed Run Times

| Run | Time (ms) |
|-----|-----------|
| 1   | 100.0     |
| 2   | 200.0     |
| 3   | 300.0     |

### Summary Statistics
- **Mean Time (ms)**: 200.0
- **Median Time (ms)**: 200.0
- **Standard Deviation (ms)**: 81.65
`;

describe("getDistroName / getDistroMeta", () => {
  it("renders the display name with version", () => {
    expect(getDistroName("ubuntu")).toBe("Ubuntu 24.04 LTS");
    expect(getDistroName("fedora")).toBe("Fedora 41");
    expect(getDistroName("debian")).toBe("Debian 12");
  });

  it("exposes the Phoronix suite version per distro", () => {
    expect(getDistroMeta("ubuntu").pts).toBe("v10.8.4");
    expect(getDistroMeta("debian").pts).toBe("v10.8.5");
  });
});

describe("parseDistroMarkdown", () => {
  const parsed = parseDistroMarkdown(SAMPLE);

  it("extracts the title and intro", () => {
    expect(parsed.title).toBe("Demo Benchmark Results");
    expect(parsed.intro).toContain("Intro paragraph describing the run.");
  });

  it("parses hardware + software spec pairs and strips backticks", () => {
    expect(parsed.hardware).toContainEqual({ key: "Processor", value: "2 x Intel Core i5" });
    expect(parsed.hardware).toContainEqual({ key: "Memory", value: "4096MB" });
    expect(parsed.software).toContainEqual({ key: "OS", value: "Ubuntu 24.04" });
  });

  it("keeps only the *Benchmark* H2 sections and slugifies their anchors", () => {
    // "Table of Contents" and "System Information" must be excluded.
    expect(parsed.sections).toHaveLength(1);
    expect(parsed.sections[0].name).toBe("C-Ray Benchmark");
    expect(parsed.sections[0].anchor).toBe("c-ray-benchmark");
  });

  it("parses a test's metadata, unit, run table, and summary stats", () => {
    const test = parsed.sections[0].tests[0];
    expect(test.identifier).toBe("pts/c-ray-2.0.0");
    expect(test.title).toBe("C-Ray");
    expect(test.appVersion).toBe("2.0");
    expect(test.args).toBe("-s 1920x1080 -r 16"); // backticks stripped
    expect(test.description).toContain("Resolution: 1080p");
    expect(test.unit).toBe("ms");
    expect(test.runs).toEqual([
      { run: 1, value: 100 },
      { run: 2, value: 200 },
      { run: 3, value: 300 },
    ]);
    expect(test.mean).toBe(200);
    expect(test.median).toBe(200);
    expect(test.stddev).toBeCloseTo(81.65);
  });

  it("returns empty collections for non-benchmark input", () => {
    const empty = parseDistroMarkdown("# Just A Title\n\nNo sections here.\n");
    expect(empty.sections).toEqual([]);
    expect(empty.hardware).toEqual([]);
  });
});

// Smoke test against the committed corpus: every distro's markdown must parse
// into at least one benchmark section with at least one test. Guards the parser
// against real-file regressions, not just the crafted fixture above.
describe("committed benchmark corpus parses", () => {
  it.each(distros)("%s.md yields parsable sections", (slug) => {
    const parsed = parseDistroMarkdown(getDistroMarkdown(slug));
    expect(parsed.title.length).toBeGreaterThan(0);
    expect(parsed.sections.length).toBeGreaterThan(0);
    expect(parsed.sections[0].tests.length).toBeGreaterThan(0);
  });
});
