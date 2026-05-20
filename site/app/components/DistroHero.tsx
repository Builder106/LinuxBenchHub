import { DistroMark } from "./DistroMark";
import type { Distro } from "@/lib/benchmarks";

type Props = {
  distro: Distro;
  name: string;
  version: string;
  pts: string;
  intro: string;
};

export function DistroHero({ distro, name, version, pts, intro }: Props) {
  return (
    <header className="distro-hero">
      <div className="distro-hero-mark">
        <DistroMark distro={distro} size={84} />
      </div>
      <div className="distro-hero-body">
        <div className="distro-hero-eyebrow">PHORONIX TEST SUITE {pts}</div>
        <h1 className="distro-hero-name">
          {name}
          <span className="distro-hero-version">{version}</span>
        </h1>
        <p className="distro-hero-intro">{intro}</p>
      </div>
    </header>
  );
}
