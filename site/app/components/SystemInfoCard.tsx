import type { SpecPair } from "@/lib/benchmarks";

type Props = {
  hardware: SpecPair[];
  software: SpecPair[];
};

export function SystemInfoCard({ hardware, software }: Props) {
  return (
    <section className="system-card" id="system-information">
      <h2 className="system-card-heading">System</h2>
      <div className="system-card-cols">
        <SpecColumn label="Hardware" pairs={hardware} />
        <SpecColumn label="Software" pairs={software} />
      </div>
    </section>
  );
}

function SpecColumn({ label, pairs }: { label: string; pairs: SpecPair[] }) {
  return (
    <div className="system-card-col">
      <div className="system-card-col-label">{label}</div>
      <dl className="system-card-list">
        {pairs.map((p) => (
          <div className="system-card-row" key={p.key}>
            <dt>{p.key}</dt>
            <dd>{p.value}</dd>
          </div>
        ))}
      </dl>
    </div>
  );
}
