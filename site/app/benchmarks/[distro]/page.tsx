import { notFound } from "next/navigation";
import ReactMarkdown from "react-markdown";
import remarkGfm from "remark-gfm";
import {
  distros,
  getDistroMarkdown,
  getDistroName,
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
  const name = getDistroName(distro);
  return {
    title: `${name} benchmarks — LinuxBenchHub`,
    description: `Phoronix Test Suite results for ${name} captured on VMware Fusion Pro 13.6.1.`,
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
  const markdown = getDistroMarkdown(distro);

  return (
    <main>
      <a href="/" className="back-link">← OVERVIEW</a>
      <article>
        <ReactMarkdown remarkPlugins={[remarkGfm]}>{markdown}</ReactMarkdown>
      </article>
    </main>
  );
}
