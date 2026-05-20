import type { RunRow } from "@/lib/benchmarks";

type Props = {
  runs: RunRow[];
  unit: string;
  mean: number;
};

export function RunBarChart({ runs, unit, mean }: Props) {
  if (runs.length === 0) {
    return (
      <div className="run-chart-empty">No per-run data parsed for this test.</div>
    );
  }

  const values = runs.map((r) => r.value);
  const max = Math.max(...values, mean);
  const min = Math.min(...values, 0);
  // Use a scale that starts at zero so the bars feel honest.
  const scaleMax = max * 1.08;

  const width = 640;
  const height = 220;
  const pad = { top: 16, right: 16, bottom: 28, left: 56 };
  const chartW = width - pad.left - pad.right;
  const chartH = height - pad.top - pad.bottom;

  const slot = chartW / runs.length;
  const barW = slot * 0.66;

  const yFor = (v: number) =>
    pad.top + chartH - (v / scaleMax) * chartH;

  const gridTicks = 4;
  const tickStep = scaleMax / gridTicks;

  return (
    <figure className="run-chart">
      <svg
        viewBox={`0 0 ${width} ${height}`}
        role="img"
        aria-label={`Per-run ${unit} values`}
      >
        {/* gridlines */}
        {Array.from({ length: gridTicks + 1 }, (_, i) => {
          const v = tickStep * i;
          const y = yFor(v);
          return (
            <g key={i}>
              <line
                x1={pad.left}
                x2={width - pad.right}
                y1={y}
                y2={y}
                stroke="var(--border-warm)"
                strokeWidth="0.6"
                opacity={i === 0 ? 0.9 : 0.45}
              />
              <text
                x={pad.left - 8}
                y={y + 3}
                textAnchor="end"
                fontFamily="var(--font-mono)"
                fontSize="10"
                fill="var(--fg-dim)"
              >
                {formatTick(v)}
              </text>
            </g>
          );
        })}

        {/* bars */}
        {runs.map((r, i) => {
          const x = pad.left + slot * i + (slot - barW) / 2;
          const y = yFor(r.value);
          const h = pad.top + chartH - y;
          return (
            <g key={i}>
              <rect
                x={x}
                y={y}
                width={barW}
                height={h}
                fill="var(--accent)"
                opacity={0.92}
              >
                <title>{`Run ${r.run}: ${r.value.toLocaleString()} ${unit}`}</title>
              </rect>
              <text
                x={x + barW / 2}
                y={pad.top + chartH + 16}
                textAnchor="middle"
                fontFamily="var(--font-mono)"
                fontSize="10"
                fill="var(--fg-dim)"
              >
                {r.run}
              </text>
            </g>
          );
        })}

        {/* mean reference line */}
        {mean > 0 && (
          <g>
            <line
              x1={pad.left}
              x2={width - pad.right}
              y1={yFor(mean)}
              y2={yFor(mean)}
              stroke="var(--accent-bright)"
              strokeWidth="1.2"
              strokeDasharray="4 4"
            />
            <text
              x={width - pad.right}
              y={yFor(mean) - 5}
              textAnchor="end"
              fontFamily="var(--font-mono)"
              fontSize="10"
              fill="var(--accent-bright)"
              fontWeight="600"
              letterSpacing="0.06em"
            >
              MEAN {formatTick(mean)}
            </text>
          </g>
        )}
      </svg>
      <figcaption>
        run {runs[0].run}–{runs[runs.length - 1].run} · bars in {unit} · dashed
        line is mean
      </figcaption>
    </figure>
  );
}

function formatTick(v: number): string {
  if (v >= 1000) return v.toLocaleString(undefined, { maximumFractionDigits: 0 });
  if (v >= 100) return v.toFixed(0);
  if (v >= 10) return v.toFixed(1);
  return v.toFixed(2);
}
