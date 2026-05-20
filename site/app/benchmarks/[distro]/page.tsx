import { notFound } from "next/navigation";
import { FacetDivider } from "@/app/components/FacetDivider";
import { DistroHero } from "@/app/components/DistroHero";
import { SystemInfoCard } from "@/app/components/SystemInfoCard";
import { BenchmarkCard } from "@/app/components/BenchmarkCard";
import {
  distros,
  getDistroMarkdown,
  getDistroMeta,
  parseDistroMarkdown,
  type Distro,
} from "@/lib/benchmarks";

export const dynamicParams = false;

export function generateStaticParams() {
  return distros.map((distro) => ({ distro }));
}

export async function generateMetadata({
  params,
}: {
  params: Promise<{ distro: string }>;
}) {
  const { distro } = await params;
  if (!isDistro(distro)) return {};
  const meta = getDistroMeta(distro);
  return {
    title: `${meta.name} ${meta.version} benchmarks — LinuxBenchHub`,
    description: `Phoronix Test Suite ${meta.pts} results for ${meta.name} ${meta.version} captured on VMware Fusion Pro 13.6.1.`,
  };
}

function isDistro(slug: string): slug is Distro {
  return (distros as readonly string[]).includes(slug);
}

export default async function BenchmarkPage({
  params,
}: {
  params: Promise<{ distro: string }>;
}) {
  const { distro } = await params;
  if (!isDistro(distro)) notFound();

  const meta = getDistroMeta(distro);
  const parsed = parseDistroMarkdown(getDistroMarkdown(distro));

  return (
    <main>
      <a href="/" className="back-link">
        ← OVERVIEW
      </a>

      <DistroHero
        distro={distro}
        name={meta.name}
        version={meta.version}
        pts={meta.pts}
        intro={parsed.intro}
      />

      <nav className="section-nav" aria-label="Benchmarks">
        <a href="#system-information">System</a>
        {parsed.sections.map((s) => (
          <a href={`#${s.anchor}`} key={s.anchor}>
            {s.name.replace(/\s+Benchmark$/i, "")}
          </a>
        ))}
      </nav>

      <FacetDivider />

      <SystemInfoCard
        hardware={parsed.hardware}
        software={parsed.software}
      />

      {parsed.sections.map((section) => (
        <section
          className="bench-section"
          id={section.anchor}
          key={section.anchor}
        >
          <FacetDivider />
          <h2 className="bench-section-heading">{section.name}</h2>
          {section.tests.map((test, i) => (
            <BenchmarkCard test={test} key={`${test.identifier}-${i}`} />
          ))}
        </section>
      ))}
    </main>
  );
}
