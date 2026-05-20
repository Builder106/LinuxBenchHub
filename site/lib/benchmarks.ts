import fs from "node:fs";
import path from "node:path";

export const distros = ["ubuntu", "fedora", "debian"] as const;
export type Distro = (typeof distros)[number];

const distroNames: Record<Distro, string> = {
  ubuntu: "Ubuntu 24.04 LTS",
  fedora: "Fedora Linux 41",
  debian: "Debian 12",
};

export function getDistroName(slug: Distro): string {
  return distroNames[slug];
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
