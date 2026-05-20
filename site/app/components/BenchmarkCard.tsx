import type { Test } from "@/lib/benchmarks";
import { RunBarChart } from "./RunBarChart";

export function BenchmarkCard({ test }: { test: Test }) {
  return (
    <article className="bench-card">
      <header className="bench-card-head">
        <div className="bench-card-headline">
          <div className="bench-card-name">
            {test.title}
            {test.description && (
              <span className="bench-card-desc"> · {test.description}</span>
            )}
          </div>
          <code className="bench-card-ident">{test.identifier}</code>
        </div>
        {(test.appVersion || test.args) && (
          <dl className="bench-card-meta">
            {test.appVersion && (
              <div>
                <dt>App</dt>
                <dd>{test.appVersion}</dd>
              </div>
            )}
            {test.args && (
              <div>
                <dt>Args</dt>
                <dd>
                  <code>{test.args}</code>
                </dd>
              </div>
            )}
          </dl>
        )}
      </header>

      <div className="bench-card-stats">
        <Stat
          label="Mean"
          value={formatStat(test.mean)}
          unit={test.unit}
          emphasis
        />
        <Stat label="Median" value={formatStat(test.median)} unit={test.unit} />
        <Stat label="Std Dev" value={formatStat(test.stddev)} unit={test.unit} />
        <Stat label="Runs" value={String(test.runs.length)} unit="n" />
      </div>

      <RunBarChart runs={test.runs} unit={test.unit} mean={test.mean} />
    </article>
  );
}

function Stat({
  label,
  value,
  unit,
  emphasis = false,
}: {
  label: string;
  value: string;
  unit: string;
  emphasis?: boolean;
}) {
  return (
    <div className={`stat-cell${emphasis ? " stat-cell-emphasis" : ""}`}>
      <div className="stat-cell-label">{label}</div>
      <div className="stat-cell-value">
        {value}
        <small>{unit}</small>
      </div>
    </div>
  );
}

function formatStat(v: number): string {
  if (!Number.isFinite(v) || v === 0) return "—";
  if (v >= 1000) return v.toLocaleString(undefined, { maximumFractionDigits: 0 });
  if (v >= 100) return v.toFixed(1);
  if (v >= 10) return v.toFixed(2);
  return v.toFixed(3);
}
