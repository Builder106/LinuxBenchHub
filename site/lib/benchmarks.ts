import fs from "node:fs";
import path from "node:path";

export const distros = ["ubuntu", "fedora", "debian"] as const;
export type Distro = (typeof distros)[number];

const distroMeta: Record<
  Distro,
  { name: string; version: string; pts: string }
> = {
  ubuntu: { name: "Ubuntu", version: "24.04 LTS", pts: "v10.8.4" },
  fedora: { name: "Fedora", version: "41", pts: "v10.8.4" },
  debian: { name: "Debian", version: "12", pts: "v10.8.5" },
};

export function getDistroName(slug: Distro): string {
  return `${distroMeta[slug].name} ${distroMeta[slug].version}`;
}

export function getDistroMeta(slug: Distro) {
  return distroMeta[slug];
}

export function getDistroMarkdown(slug: Distro): string {
  const file = path.join(
    process.cwd(),
    "..",
    "benchmarks",
    slug,
    `${slug}.md`,
  );
  return fs.readFileSync(file, "utf8");
}

export type SpecPair = { key: string; value: string };
export type RunRow = { run: number; value: number };

export type Test = {
  identifier: string;
  title: string;
  description: string;
  appVersion: string;
  args: string;
  unit: string;
  runs: RunRow[];
  mean: number;
  median: number;
  stddev: number;
};

export type BenchmarkSection = {
  name: string;
  anchor: string;
  tests: Test[];
};

export type ParsedDistro = {
  title: string;
  intro: string;
  hardware: SpecPair[];
  software: SpecPair[];
  sections: BenchmarkSection[];
};

const KEY_VALUE_LINE = /^-\s+\*\*(.+?)\*\*:\s*(.*)$/;

function parseSpecList(text: string): SpecPair[] {
  return text
    .split("\n")
    .map((line) => line.match(KEY_VALUE_LINE))
    .filter((m): m is RegExpMatchArray => Boolean(m))
    .map((m) => ({ key: m[1].trim(), value: stripBackticks(m[2].trim()) }));
}

function stripBackticks(s: string): string {
  return s.replace(/^`(.*)`$/, "$1");
}

function parseTable(text: string): RunRow[] {
  const lines = text.split("\n").filter((l) => l.trim().startsWith("|"));
  if (lines.length < 3) return [];
  // skip header (lines[0]) and separator (lines[1])
  return lines
    .slice(2)
    .map((line) => {
      const cells = line
        .split("|")
        .map((c) => c.trim())
        .filter((c) => c.length > 0);
      const run = Number.parseInt(cells[0], 10);
      const value = Number.parseFloat(cells[1]);
      return { run, value };
    })
    .filter((r) => Number.isFinite(r.run) && Number.isFinite(r.value));
}

function findKeyValue(block: string, key: RegExp): string {
  const lines = block.split("\n");
  for (const line of lines) {
    const m = line.match(KEY_VALUE_LINE);
    if (!m) continue;
    if (key.test(m[1])) return stripBackticks(m[2].trim());
  }
  return "";
}

function findNumeric(block: string, key: RegExp): number {
  const v = findKeyValue(block, key);
  const n = Number.parseFloat(v);
  return Number.isFinite(n) ? n : 0;
}

function detectUnit(block: string): string {
  // The Summary Statistics lines look like "**Mean Time (ms)**: 1088.787"
  const m = block.match(/\*\*Mean (?:Time|Value) \(([^)]+)\)\*\*/);
  return m ? m[1] : "";
}

function slugify(s: string): string {
  return s
    .toLowerCase()
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/(^-|-$)/g, "");
}

function parseTest(block: string): Test {
  const identMatch = block.match(/### Test Identifier:\s*`?([^`\n]+)`?/);
  const titleMatch = block.match(/#### Title:\s*(.+)/);
  const tableMatch = block.match(
    /### Detailed Run (?:Times|Values)\s*\n+([\s\S]*?)(?=\n###|\n---|$)/,
  );
  return {
    identifier: identMatch ? identMatch[1].trim() : "",
    title: titleMatch ? titleMatch[1].trim() : "",
    description: findKeyValue(block, /^Description$/),
    appVersion: findKeyValue(block, /^App Version$/),
    args: findKeyValue(block, /^Arguments$/),
    unit: detectUnit(block),
    runs: tableMatch ? parseTable(tableMatch[1]) : [],
    mean: findNumeric(block, /^Mean/),
    median: findNumeric(block, /^Median/),
    stddev: findNumeric(block, /^Standard Deviation/),
  };
}

export function parseDistroMarkdown(md: string): ParsedDistro {
  const titleMatch = md.match(/^#\s+(.+)$/m);
  const introMatch = md.match(/^#\s+.+\n+([^\n#].+?)\n+##/s);

  const hwMatch = md.match(/### Hardware\s*\n+([\s\S]*?)\n+###/);
  const swMatch = md.match(/### Software\s*\n+([\s\S]*?)\n+---/);

  // Split the file at H2 boundaries; keep only Benchmark sections.
  const h2Sections = md.split(/(?=^##\s+)/m);
  const benchmarkSections: BenchmarkSection[] = h2Sections
    .filter((s) => /^##\s+.*Benchmark/.test(s))
    .map((section) => {
      const nameMatch = section.match(/^##\s+(.+)$/m);
      const name = nameMatch ? nameMatch[1].trim() : "Benchmark";
      const testBlocks = section
        .split(/(?=### Test Identifier:)/)
        .slice(1);
      return {
        name,
        anchor: slugify(name),
        tests: testBlocks.map(parseTest),
      };
    });

  return {
    title: titleMatch ? titleMatch[1].trim() : "",
    intro: introMatch ? introMatch[1].trim() : "",
    hardware: parseSpecList(hwMatch ? hwMatch[1] : ""),
    software: parseSpecList(swMatch ? swMatch[1] : ""),
    sections: benchmarkSections,
  };
}
